package wiring

import (
	"context"
	"errors"
	"log"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"

	"local/merope/internal/core/config"
	coreErrors "local/merope/internal/core/errors"
	coreMiddleware "local/merope/internal/core/middleware"
	"local/merope/internal/core/security"
	"local/merope/internal/core/worker"
	"local/merope/internal/database"
	"local/merope/internal/database/db"
	"local/merope/internal/platform/nats"
	"local/merope/internal/platform/redis"
	"local/merope/internal/platform/scylla"

	communityInfra "local/merope/internal/modules/community/infra"
	communityService "local/merope/internal/modules/community/service"
	communityTransport "local/merope/internal/modules/community/transport"
	contentDomain "local/merope/internal/modules/content/domain"
	contentInfra "local/merope/internal/modules/content/infra"
	contentService "local/merope/internal/modules/content/service"
	contentTransport "local/merope/internal/modules/content/transport"
	developerInfra "local/merope/internal/modules/developer/infra"
	developerService "local/merope/internal/modules/developer/service"
	developerTransport "local/merope/internal/modules/developer/transport"
	identityInfra "local/merope/internal/modules/identity/infra"
	identityService "local/merope/internal/modules/identity/service"
	identityTransport "local/merope/internal/modules/identity/transport"
	lumiaInfra "local/merope/internal/modules/lumia/infra"
	lumiaService "local/merope/internal/modules/lumia/service"
	lumiaTransport "local/merope/internal/modules/lumia/transport"
	messagingDomain "local/merope/internal/modules/messaging/domain"
	messagingInfra "local/merope/internal/modules/messaging/infra"
	messagingService "local/merope/internal/modules/messaging/service"
	messagingTransport "local/merope/internal/modules/messaging/transport"
	socialInfra "local/merope/internal/modules/social/infra"
	socialService "local/merope/internal/modules/social/service"
	socialTransport "local/merope/internal/modules/social/transport"
)

type Resources struct {
	PostgresPool *pgxpool.Pool
	Redis        *redis.Client
	NATS         *nats.Client
	Orchestrator *worker.Orchestrator
	Scylla       *scylla.Client
}

type Handlers struct {
	Identity     *identityTransport.IdentityHandler
	Content      *contentTransport.ContentHandler
	Messaging    *messagingTransport.MessagingHandler
	Social       *socialTransport.SocialHandler
	Lumia        *lumiaTransport.LumiaHandler
	Developer    *developerTransport.DeveloperHandler
	Community    *communityTransport.CommunityHandler
	VeritasGuard socialService.VeritasContentGuard
}

func BuildApp(ctx context.Context, cfg *config.Config) (*fiber.App, *Resources, *Handlers, func()) {
	zapLogger, err := zap.NewProduction()
	if err != nil { log.Fatalf("failed to initialize logger: %v", err) }
	pgPool, err := database.NewPostgresPool(ctx)
	if err != nil { log.Fatalf("failed to connect to PostgreSQL: %v", err) }
	rdb := redis.New(cfg.Redis.Addr, cfg.Redis.Password)
	queries := db.New(pgPool)
	var scyllaClient *scylla.Client
	if len(cfg.Scylla.Hosts) > 0 {
		scyllaClient, err = scylla.New(scylla.Config{Hosts: cfg.Scylla.Hosts, Keyspace: cfg.Scylla.Keyspace, Username: cfg.Scylla.Username, Password: cfg.Scylla.Password, Consistency: cfg.Scylla.Consistency})
		if err != nil { zapLogger.Warn("ScyllaDB unavailable; using PostgreSQL path", zap.Error(err)) } else { zapLogger.Info("ScyllaDB connected", zap.Strings("hosts", cfg.Scylla.Hosts)) }
	}
	var bus *nats.Client
	bus, err = nats.New(cfg.NATS.URL)
	if err != nil { zapLogger.Error("NATS connection failed; realtime writes are unavailable", zap.Error(err)); bus = nil } else if err := bus.EnsureStreams(); err != nil { zapLogger.Error("NATS stream initialization failed", zap.Error(err)); bus.Conn.Close(); bus = nil } else { zapLogger.Info("NATS connected", zap.String("url", cfg.NATS.URL)) }
	if bus == nil && strings.EqualFold(cfg.Env, "production") { log.Fatal("NATS is mandatory in production") }

	orchestrator := worker.NewOrchestrator(queries, 10, 20)
	orchestrator.Start(ctx)
	resources := &Resources{PostgresPool: pgPool, Redis: rdb, NATS: bus, Orchestrator: orchestrator, Scylla: scyllaClient}

	identityRepo := identityInfra.NewPostgresIdentityRepository(queries, rdb, nil)
	identitySentinel := identityService.NewIdentitySentinel(identityRepo, rdb.Conn)
	idService := identityService.NewIdentityService(identityRepo, cfg.JWTSecret, identitySentinel)
	idHandler := identityTransport.NewIdentityHandler(idService, cfg.JWTSecret, rdb.Conn)
	preAuthHandler := identityTransport.NewPreAuthMFAHandler(idService, cfg.JWTSecret, rdb.Conn)

	anomalyDetector := security.NewAnomalyDetector()
	securityFabric := security.NewMeropeSecurityFabric(bus, anomalyDetector)
	_ = securityFabric
	veritasGuard := socialService.NewVeritasContentGuard(bus)

	contentRepo := contentInfra.NewPostgresContentRepository(queries)
	var contService contentDomain.ContentService
	if scyllaClient != nil { contService = contentService.NewHighPerformanceContentService(contentRepo, contentInfra.NewScyllaContentRepository(scyllaClient), bus) } else { contService = contentService.NewContentService(contentRepo, bus, veritasGuard, idService) }
	contHandler := contentTransport.NewContentHandler(contService)

	msgRepo := messagingInfra.NewPostgresMessagingRepository(queries, pgPool)
	e2eeService := messagingService.NewE2EEService(msgRepo, bus)
	e2eeKeyRepo := messagingInfra.NewPostgresE2EEPublicKeyRepository(pgPool)
	e2eeKeyHandler := messagingTransport.NewE2EEKeyHandler(e2eeKeyRepo)
	unreadHandler := messagingTransport.NewUnreadHandler(pgPool)
	var msgService messagingDomain.MessagingService
	if scyllaClient != nil { msgService = messagingService.NewHighPerformanceService(msgRepo, messagingInfra.NewScyllaMessagingRepository(scyllaClient), bus, orchestrator, msgRepo, e2eeService) } else { msgService = messagingService.NewMessagingService(msgRepo, idService, msgRepo, e2eeService, bus, bus, nil) }
	msgHandler := messagingTransport.NewMessagingHandler(msgService)
	msgContractHandler := messagingTransport.NewMessagingContractHandler(msgService)

	socialRepo := socialInfra.NewPostgresSocialRepository(queries)
	socService := socialService.NewSocialService(socialRepo, idService, veritasGuard)
	socHandler := socialTransport.NewSocialHandler(socService)
	lumiaRepo := lumiaInfra.NewPostgresLumiaRepository(queries)
	lumSvc := lumiaService.NewLumiaService(lumiaRepo, idService, bus)
	lumHandler := lumiaTransport.NewLumiaHandler(lumSvc)

	developerRepo := developerInfra.NewPostgresDeveloperRepository(queries, pgPool)
	developerSvc := developerService.NewDeveloperService(developerRepo)
	developerHandler := developerTransport.NewDeveloperHandler(developerSvc)

	communityRepo := communityInfra.NewPostgresCommunityRepository(queries)
	communitySvc := communityService.NewCommunityService(communityRepo)
	communityHandler := communityTransport.NewCommunityHandler(communitySvc, communityRepo)

	handlers := &Handlers{Identity: idHandler, Content: contHandler, Messaging: msgHandler, Social: socHandler, Lumia: lumHandler, Developer: developerHandler, Community: communityHandler, VeritasGuard: veritasGuard}
	rbacEnforcer, err := security.NewDefaultEnforcer()
	if err != nil { log.Fatalf("failed to initialize RBAC: %v", err) }

	app := fiber.New(fiber.Config{DisableStartupMessage: true, BodyLimit: 4 * 1024 * 1024, ReadTimeout: 15 * time.Second, WriteTimeout: 30 * time.Second, IdleTimeout: 60 * time.Second, ErrorHandler: func(c *fiber.Ctx, err error) error {
		status := coreErrors.ToHTTPStatus(err); if status < 400 { status = fiber.StatusInternalServerError }
		code := coreErrors.GetCode(err); message := "request failed"; if status < 500 { if domainErr, ok := err.(*coreErrors.DomainError); ok { message = domainErr.Message } }
		return c.Status(status).JSON(fiber.Map{"code": code, "message": message, "request_id": coreMiddleware.GetRequestID(c)})
	}})
	app.Use(recover.New())
	app.Use(coreMiddleware.RequestID())
	app.Use(security.HTTPHardeningMiddleware())
	app.Use(logger.New())
	app.Use(security.SecurityHeadersMiddleware())
	app.Use(security.AnomalyDetectorMiddleware(anomalyDetector))
	app.Use(cors.New(cors.Config{AllowOrigins: cfg.CORSAllowedOrigins, AllowHeaders: "Origin, Content-Type, Accept, Authorization, X-Request-ID, Idempotency-Key", AllowMethods: "GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS", AllowCredentials: false}))
	app.Use(security.GlobalLimit(rdb.Conn))

	api := app.Group("/api/v10")
	auth := api.Group("/auth"); auth.Use(security.AuthLimit(rdb.Conn))
	auth.Post("/register", idHandler.Register); auth.Post("/login", preAuthHandler.Login); auth.Post("/refresh", idHandler.RefreshToken); auth.Post("/mfa/verify", preAuthHandler.Verify); auth.Get("/me", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer), idHandler.Me); auth.Post("/logout", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer), idHandler.Logout)
	protected := api.Group("/", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer)); protected.Use(coreMiddleware.Idempotency(rdb.Conn, 24*time.Hour))

	messaging := protected.Group("/messaging"); messaging.Get("/rooms", msgContractHandler.GetRooms); messaging.Post("/rooms", msgHandler.CreateDirectChat); messaging.Post("/rooms/group", msgHandler.CreateGroupChat); messaging.Get("/rooms/:id/history", msgContractHandler.GetHistory); messaging.Get("/rooms/:id/unread", unreadHandler.Get); messaging.Post("/rooms/:id/messages", msgContractHandler.SendMessage); messaging.Put("/messages/:msg_id", msgHandler.EditMessage); messaging.Delete("/messages/:msg_id", msgHandler.DeleteMessage); messaging.Post("/messages/:msg_id/react", msgHandler.React); messaging.Post("/rooms/:id/mute", msgHandler.MuteRoom); messaging.Post("/rooms/:id/read", msgHandler.MarkAsRead); messaging.Get("/e2ee/keys/:user_id", e2eeKeyHandler.Get); messaging.Post("/e2ee/keys", e2eeKeyHandler.Upload)
	content := protected.Group("/content"); content.Get("/feed", contHandler.Feed); content.Get("/posts/:id", contHandler.GetPost); content.Post("/posts", contHandler.CreatePost); content.Put("/posts/:id", contHandler.UpdatePost); content.Delete("/posts/:id", contHandler.DeletePost); content.Get("/posts/:id/comments", contHandler.GetComments); content.Post("/posts/:id/react", contHandler.React); content.Post("/posts/:id/like", contHandler.Like); content.Delete("/posts/:id/like", contHandler.Unlike); content.Post("/posts/:id/repost", contHandler.Repost); content.Delete("/posts/:id/comments/:comment_id", contHandler.DeleteComment)
	social := protected.Group("/social"); social.Get("/timeline", contHandler.Feed); social.Get("/profile/:id", socHandler.Profile); social.Get("/search/users", socHandler.Search); social.Get("/followers/:id", socHandler.Followers); social.Get("/following/:id", socHandler.Following); social.Post("/follow/:id", socHandler.Follow); social.Post("/unfollow/:id", socHandler.Unfollow)
	lumia := protected.Group("/lumia"); lumia.Post("/tip", lumHandler.Tip); lumia.Get("/live", lumHandler.GetLive)

	community := protected.Group("/community")
	community.Get("/communities", communityHandler.ListCommunities)
	community.Get("/communities/:id", communityHandler.GetCommunity)
	community.Post("/communities", communityHandler.CreateCommunity)
	community.Post("/communities/:id/join", communityHandler.Join)
	community.Post("/communities/:id/leave", communityHandler.Leave)
	community.Patch("/communities/:id/settings", communityHandler.UpdateSettings)
	community.Get("/communities/:id/guidelines", communityHandler.GetGuidelines)
	community.Put("/communities/:id/guidelines", communityHandler.UpdateGuidelines)
	community.Get("/communities/:id/members", communityHandler.Members)
	community.Patch("/communities/:id/members/:member_id", communityHandler.UpdateMemberRole)
	community.Post("/communities/:id/members/:member_id/ban", communityHandler.BanMember)
	community.Post("/communities/:id/members/:member_id/unban", communityHandler.UnbanMember)
	community.Get("/communities/:id/analytics", communityHandler.Analytics)
	community.Get("/events", communityHandler.ListEvents)
	community.Get("/events/upcoming", communityHandler.UpcomingEvents)
	community.Post("/events", communityHandler.CreateEvent)
	community.Post("/events/:id/rsvp", communityHandler.RSVP)
	community.Delete("/events/:id", communityHandler.CancelEvent)
	community.Get("/collectives", communityHandler.ListCollectives)
	community.Post("/collectives", communityHandler.CreateCollective)
	community.Post("/collectives/:id/join", communityHandler.JoinCollective)
	community.Get("/collectives/:id/threads", communityHandler.ListThreads)
	community.Post("/collectives/:id/threads", communityHandler.CreateThread)
	community.Post("/threads/:id/resonate", communityHandler.ResonateThread)
	community.Get("/threads/:id/replies", communityHandler.ThreadReplies)
	community.Post("/threads/:id/replies", communityHandler.CreateThreadReply)
	community.Post("/threads/:id/pin", communityHandler.PinThread)
	community.Post("/threads/:id/lock", communityHandler.LockThread)
	community.Get("/subscriptions", communityHandler.Subscriptions)
	community.Post("/subscriptions", communityHandler.CreateSubscription)
	community.Delete("/subscriptions/:id", communityHandler.CancelSubscription)
	community.Patch("/subscriptions/:id", communityHandler.UpdateSubscription)

	developer := protected.Group("/developer")
	developer.Get("/apps", developerHandler.ListApps)
	developer.Get("/apps/:app_id", developerHandler.GetApp)
	developer.Post("/apps", developerHandler.CreateApp)
	developer.Put("/apps/:app_id", developerHandler.UpdateApp)
	developer.Delete("/apps/:app_id", developerHandler.DeleteApp)
	developer.Post("/apps/:app_id/verify", developerHandler.VerifyApp)
	developer.Get("/apps/:app_id/api-keys", developerHandler.ListKeys)
	developer.Get("/api-keys/:key_id", developerHandler.GetKey)
	developer.Post("/apps/:app_id/api-keys", developerHandler.CreateKey)
	developer.Put("/api-keys/:key_id", developerHandler.UpdateKey)
	developer.Delete("/api-keys/:key_id", developerHandler.RevokeKey)
	developer.Get("/apps/:app_id/webhooks", developerHandler.ListWebhooks)
	developer.Get("/webhooks/:webhook_id", developerHandler.GetWebhook)
	developer.Post("/apps/:app_id/webhooks", developerHandler.CreateWebhook)
	developer.Put("/webhooks/:webhook_id", developerHandler.UpdateWebhook)
	developer.Delete("/webhooks/:webhook_id", developerHandler.DeleteWebhook)
	developer.Post("/webhooks/:webhook_id/test", developerHandler.TestWebhook)
	developer.Get("/apps/:app_id/bots", developerHandler.ListBots)
	developer.Get("/bots/:bot_id", developerHandler.GetBot)
	developer.Post("/apps/:app_id/bots", developerHandler.CreateBot)
	developer.Put("/bots/:bot_id", developerHandler.UpdateBot)
	developer.Delete("/bots/:bot_id", developerHandler.DeleteBot)
	developer.Get("/apps/:app_id/metrics", developerHandler.GetMetrics)
	developer.Post("/apps/:app_id/test-suite", developerHandler.TestSuite)

	app.Get("/health", func(c *fiber.Ctx) error { return c.Status(fiber.StatusOK).JSON(fiber.Map{"status": "ok", "request_id": coreMiddleware.GetRequestID(c)}) })
	cleanup := func(){ zapLogger.Info("shutting down API"); if orchestrator!=nil{orchestrator.Stop()}; if bus!=nil{bus.Conn.Drain();bus.Conn.Close()};if rdb!=nil{_=rdb.Close()};if pgPool!=nil{pgPool.Close()};if scyllaClient!=nil{scyllaClient.Close()};_=zapLogger.Sync() }
	return app, resources, handlers, cleanup
}

var _ = errors.New
