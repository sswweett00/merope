package wiring

import (
	"context"
	"errors"
	"log"
	"path/filepath"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/contrib/websocket"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"

	"local/merope/internal/core/config"
	coreErrors "local/merope/internal/core/errors"
	coreMiddleware "local/merope/internal/core/middleware"
	"local/merope/internal/core/realtime"
	"local/merope/internal/core/security"
	"local/merope/internal/core/worker"
	"local/merope/internal/database"
	"local/merope/internal/database/db"
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
	financeInfra "local/merope/internal/modules/finance/infra"
	financeService "local/merope/internal/modules/finance/service"
	financeTransport "local/merope/internal/modules/finance/transport"
	identityInfra "local/merope/internal/modules/identity/infra"
	identityService "local/merope/internal/modules/identity/service"
	identityTransport "local/merope/internal/modules/identity/transport"
	lumiaInfra "local/merope/internal/modules/lumia/infra"
	lumiaService "local/merope/internal/modules/lumia/service"
	lumiaTransport "local/merope/internal/modules/lumia/transport"
	marketplaceInfra "local/merope/internal/modules/marketplace/infra"
	marketplaceService "local/merope/internal/modules/marketplace/service"
	marketplaceTransport "local/merope/internal/modules/marketplace/transport"
	messagingDomain "local/merope/internal/modules/messaging/domain"
	messagingInfra "local/merope/internal/modules/messaging/infra"
	messagingService "local/merope/internal/modules/messaging/service"
	messagingTransport "local/merope/internal/modules/messaging/transport"
	moderationInfra "local/merope/internal/modules/moderation/infra"
	moderationService "local/merope/internal/modules/moderation/service"
	moderationTransport "local/merope/internal/modules/moderation/transport"
	notificationsInfra "local/merope/internal/modules/notifications/infra"
	notificationsService "local/merope/internal/modules/notifications/service"
	notificationsTransport "local/merope/internal/modules/notifications/transport"
	searchInfra "local/merope/internal/modules/search/infra"
	searchService "local/merope/internal/modules/search/service"
	searchTransport "local/merope/internal/modules/search/transport"
	socialInfra "local/merope/internal/modules/social/infra"
	socialService "local/merope/internal/modules/social/service"
	socialTransport "local/merope/internal/modules/social/transport"
	vaultInfra "local/merope/internal/modules/vault/infra"
	vaultService "local/merope/internal/modules/vault/service"
	vaultTransport "local/merope/internal/modules/vault/transport"
	"local/merope/internal/platform/nats"
	"local/merope/internal/platform/redis"
	"local/merope/internal/platform/s3"
	"local/merope/internal/platform/scylla"
)

type Resources struct {
	PostgresPool *pgxpool.Pool
	Redis        *redis.Client
	NATS         *nats.Client
	Orchestrator *worker.Orchestrator
	Storage      *s3.Client
	WSHub        *realtime.Hub
	Scylla       *scylla.Client
}

type Handlers struct {
	Identity      *identityTransport.IdentityHandler
	Content       *contentTransport.ContentHandler
	Messaging     *messagingTransport.MessagingHandler
	Social        *socialTransport.SocialHandler
	Lumia         *lumiaTransport.LumiaHandler
	Developer     *developerTransport.DeveloperHandler
	Community     *communityTransport.CommunityHandler
	Marketplace   *marketplaceTransport.MarketplaceHandler
	Notifications *notificationsTransport.NotificationsHandler
	VeritasGuard  socialService.VeritasContentGuard
}

func BuildApp(ctx context.Context, cfg *config.Config) (*fiber.App, *Resources, *Handlers, func()) {
	zapLogger, err := zap.NewProduction()
	if err != nil {
		log.Fatalf("failed to initialize logger: %v", err)
	}
	pgPool, err := database.NewPostgresPool(ctx)
	if err != nil {
		log.Fatalf("failed to connect to PostgreSQL: %v", err)
	}
	rdb := redis.New(cfg.Redis.Addr, cfg.Redis.Password)
	queries := db.New(pgPool)

	var scyllaClient *scylla.Client
	if len(cfg.Scylla.Hosts) > 0 {
		scyllaClient, err = scylla.New(scylla.Config{Hosts: cfg.Scylla.Hosts, Keyspace: cfg.Scylla.Keyspace, Username: cfg.Scylla.Username, Password: cfg.Scylla.Password, Consistency: cfg.Scylla.Consistency})
		if err != nil {
			zapLogger.Warn("ScyllaDB unavailable; using PostgreSQL path", zap.Error(err))
		} else {
			zapLogger.Info("ScyllaDB connected", zap.Strings("hosts", cfg.Scylla.Hosts))
		}
	}

	var bus *nats.Client
	bus, err = nats.New(cfg.NATS.URL)
	if err != nil {
		zapLogger.Error("NATS connection failed; realtime writes are unavailable", zap.Error(err))
		bus = nil
	} else if err := bus.EnsureStreams(); err != nil {
		zapLogger.Error("NATS stream initialization failed", zap.Error(err))
		bus.Conn.Close()
		bus = nil
	} else {
		zapLogger.Info("NATS connected", zap.String("url", cfg.NATS.URL))
	}
	if bus == nil && strings.EqualFold(cfg.Env, "production") {
		log.Fatal("NATS is mandatory in production")
	}

	orchestrator := worker.NewOrchestrator(queries, 10, 20)
	orchestrator.Start(ctx)
	storageClient, err := s3.New(ctx, s3.Options{Endpoint: cfg.Storage.Endpoint, Region: cfg.Storage.Region, AccessKey: cfg.Storage.AccessKey, SecretKey: cfg.Storage.SecretKey, Bucket: cfg.Storage.Bucket})
	if err != nil {
		log.Fatalf("failed to initialize storage client: %v", err)
	}
	wsHub := realtime.NewHub(bus)
	go wsHub.Run(ctx)
	resources := &Resources{PostgresPool: pgPool, Redis: rdb, NATS: bus, Orchestrator: orchestrator, Storage: storageClient, WSHub: wsHub, Scylla: scyllaClient}

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
	if scyllaClient != nil {
		contService = contentService.NewHighPerformanceContentService(contentRepo, contentInfra.NewScyllaContentRepository(scyllaClient), bus, veritasGuard)
	} else {
		contService = contentService.NewContentService(contentRepo, bus, veritasGuard, idService)
	}
	contHandler := contentTransport.NewContentHandler(contService)

	msgRepo := messagingInfra.NewPostgresMessagingRepository(queries, pgPool)
	e2eeService := messagingService.NewE2EEService(msgRepo, bus)
	e2eeKeyRepo := messagingInfra.NewPostgresE2EEPublicKeyRepository(pgPool)
	e2eeKeyHandler := messagingTransport.NewE2EEKeyHandler(e2eeKeyRepo)
	unreadHandler := messagingTransport.NewUnreadHandler(pgPool)
	var msgService messagingDomain.MessagingService
	if scyllaClient != nil {
		msgService = messagingService.NewHighPerformanceService(msgRepo, messagingInfra.NewScyllaMessagingRepository(scyllaClient), bus, orchestrator, msgRepo, e2eeService)
	} else {
		msgService = messagingService.NewMessagingService(msgRepo, idService, msgRepo, e2eeService, bus, bus, nil)
	}
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

	marketplaceRepo := marketplaceInfra.NewPostgresMarketplaceRepository(queries, pgPool)
	marketplaceSvc := marketplaceService.NewMarketplaceService(marketplaceRepo)
	marketplaceHandler := marketplaceTransport.NewMarketplaceHandler(marketplaceSvc)

	notificationRepo := notificationsInfra.NewPostgresNotificationsRepository(queries)
	notificationSvc := notificationsService.NewNotificationsService(notificationRepo, nil)
	notificationHandler := notificationsTransport.NewNotificationsHandler(notificationSvc)
	searchRepo := searchInfra.NewPostgresSearchRepository(queries)
	searchSvc := searchService.NewSearchService(searchRepo, nil)
	searchHandler := searchTransport.NewSearchHandler(searchSvc)
	vaultRepo := vaultInfra.NewPostgresVaultRepository(queries)
	vaultSvc := vaultService.NewVaultService(vaultRepo, vaultService.NewVaultSentinelEngine(bus))
	vaultHandler := vaultTransport.NewVaultHandler(vaultSvc)
	financeRepo := financeInfra.NewPostgresFinanceRepository(queries, pgPool)
	financeSvc := financeService.NewFinanceService(financeRepo, contentRepo)
	financeHandler := financeTransport.NewFinanceHandler(financeSvc)
	moderationRepo := moderationInfra.NewPostgresModerationRepository(queries, pgPool)
	moderationSvc := moderationService.NewModerationService(moderationRepo)
	moderationHandler := moderationTransport.NewModerationHandler(moderationSvc)

	handlers := &Handlers{
		Identity:      idHandler,
		Content:       contHandler,
		Messaging:     msgHandler,
		Social:        socHandler,
		Lumia:         lumHandler,
		Developer:     developerHandler,
		Community:     communityHandler,
		Marketplace:   marketplaceHandler,
		Notifications: notificationHandler,
		VeritasGuard:  veritasGuard,
	}

	rbacEnforcer, err := security.NewDefaultEnforcer()
	if err != nil {
		log.Fatalf("failed to initialize RBAC: %v", err)
	}

	app := fiber.New(fiber.Config{
		DisableStartupMessage: true,
		BodyLimit:             4 * 1024 * 1024,
		ReadTimeout:           15 * time.Second,
		WriteTimeout:          30 * time.Second,
		IdleTimeout:           60 * time.Second,
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			status := coreErrors.ToHTTPStatus(err)
			if status < 400 {
				status = fiber.StatusInternalServerError
			}
			code := coreErrors.GetCode(err)
			message := "request failed"
			if status < 500 {
				if domainErr, ok := err.(*coreErrors.DomainError); ok {
					message = domainErr.Message
				}
			}
			return c.Status(status).JSON(fiber.Map{"code": code, "message": message, "request_id": coreMiddleware.GetRequestID(c)})
		},
	})
	app.Use(recover.New())
	app.Use(coreMiddleware.RequestID())
	app.Use(security.HTTPHardeningMiddleware())
	app.Use(logger.New())
	app.Use(security.SecurityHeadersMiddleware())
	app.Use(security.AnomalyDetectorMiddleware(anomalyDetector))
	app.Use(cors.New(cors.Config{AllowOrigins: cfg.CORSAllowedOrigins, AllowHeaders: "Origin, Content-Type, Accept, Authorization, X-Request-ID, Idempotency-Key", AllowMethods: "GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS", AllowCredentials: false}))
	app.Use(security.GlobalLimit(rdb.Conn))

	app.Get("/ws", func(c *fiber.Ctx) error {
		token := strings.TrimSpace(c.Query("token"))
		if token == "" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		claims, err := security.ValidateToken(token, cfg.JWTSecret)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		blacklisted, err := security.CheckTokenBlacklist(c.Context(), rdb.Conn, claims.ID)
		if err != nil || blacklisted {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		if claims.Fingerprint != "" && security.GenerateFingerprint(c.IP(), c.Get("User-Agent")) != claims.Fingerprint {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		if !websocket.IsWebSocketUpgrade(c) {
			return fiber.ErrUpgradeRequired
		}
		return websocket.New(func(conn *websocket.Conn) {
			wsHub.Serve(&realtime.Client{UserID: claims.UserID, Conn: conn})
		})(c)
	})

	api := app.Group("/api/v10")
	auth := api.Group("/auth")
	auth.Use(security.AuthLimit(rdb.Conn))
	auth.Post("/register", idHandler.Register)
	auth.Post("/login", preAuthHandler.Login)
	auth.Post("/refresh", idHandler.RefreshToken)
	auth.Post("/mfa/verify", preAuthHandler.Verify)
	auth.Get("/mfa/setup", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer), idHandler.SetupMFA)
	auth.Get("/me", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer), idHandler.Me)
	auth.Post("/logout", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer), idHandler.Logout)
	protected := api.Group("/", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), security.RBACMiddleware(rbacEnforcer))
	protected.Use(coreMiddleware.Idempotency(rdb.Conn, 24*time.Hour))

	messaging := protected.Group("/messaging")
	messaging.Get("/rooms", msgContractHandler.GetRooms)
	messaging.Post("/rooms", msgHandler.CreateDirectChat)
	messaging.Post("/rooms/group", msgHandler.CreateGroupChat)
	messaging.Get("/rooms/:id/history", msgContractHandler.GetHistory)
	messaging.Get("/rooms/:id/unread", unreadHandler.Get)
	messaging.Post("/rooms/:id/messages", msgContractHandler.SendMessage)
	messaging.Put("/messages/:msg_id", msgHandler.EditMessage)
	messaging.Delete("/messages/:msg_id", msgHandler.DeleteMessage)
	messaging.Post("/messages/:msg_id/react", msgHandler.React)
	messaging.Post("/rooms/:id/mute", msgHandler.MuteRoom)
	messaging.Post("/rooms/:id/read", msgHandler.MarkAsRead)
	messaging.Get("/e2ee/keys/:user_id", e2eeKeyHandler.Get)
	messaging.Post("/e2ee/keys", e2eeKeyHandler.Upload)

	content := protected.Group("/content")
	content.Get("/feed", contHandler.Feed)
	content.Get("/posts/:id", contHandler.GetPost)
	content.Post("/posts", contHandler.CreatePost)
	content.Put("/posts/:id", contHandler.UpdatePost)
	content.Delete("/posts/:id", contHandler.DeletePost)
	content.Get("/posts/:id/comments", contHandler.GetComments)
	content.Post("/posts/:id/comments", contHandler.AddComment)
	content.Get("/posts/:id/analytics", contHandler.GetPostAnalytics)
	content.Post("/posts/:id/react", contHandler.React)
	content.Post("/posts/:id/like", contHandler.Like)
	content.Delete("/posts/:id/like", contHandler.Unlike)
	content.Post("/posts/:id/repost", contHandler.Repost)
	content.Delete("/posts/:id/comments/:comment_id", contHandler.DeleteComment)

	social := protected.Group("/social")
	social.Get("/timeline", contHandler.Feed)
	social.Get("/profile/:id", socHandler.Profile)
	social.Get("/search/users", socHandler.Search)
	social.Get("/followers/:id", socHandler.Followers)
	social.Get("/following/:id", socHandler.Following)
	social.Post("/follow/:id", socHandler.Follow)
	social.Post("/unfollow/:id", socHandler.Unfollow)
	social.Post("/follow-requests/:id", socHandler.RequestFollow)
	social.Get("/follow-requests", socHandler.ListFollowRequests)
	social.Post("/follow-requests/:id/respond", socHandler.RespondFollowRequest)

	lumia := protected.Group("/lumia")
	lumia.Post("/tip", lumHandler.Tip)
	lumia.Get("/live", lumHandler.GetLive)

	marketplace := protected.Group("/marketplace")
	marketplace.Get("/products", marketplaceHandler.ListProducts)
	marketplace.Post("/products", marketplaceHandler.ListProduct)
	marketplace.Post("/orders", marketplaceHandler.Purchase)

	notifications := protected.Group("/notifications")
	notifications.Get("/activity", notificationHandler.GetActivity)
	notifications.Get("/unread-count", notificationHandler.UnreadCount)
	notifications.Post("/:id/read", notificationHandler.MarkRead)
	notifications.Post("/read-all", notificationHandler.MarkAllRead)
	notifications.Delete("", notificationHandler.ClearAll)

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

	search := protected.Group("/search")
	search.Get("", searchHandler.Search)
	search.Get("/autocomplete", searchHandler.Autocomplete)
	search.Get("/trending", searchHandler.GetTrending)
	search.Get("/history", searchHandler.GetHistory)
	search.Get("/interests", searchHandler.GetInterests)
	search.Post("/interests", searchHandler.UpdateInterests)
	search.Post("/location", searchHandler.UpdateLocation)
	search.Get("/nearby", searchHandler.GetNearby)

	vault := protected.Group("/vault")
	vault.Post("/items", vaultHandler.StoreItem)
	vault.Get("/items", vaultHandler.ListItems)

	finance := protected.Group("/finance")
	finance.Get("/balance", financeHandler.GetBalance)
	finance.Get("/transactions", financeHandler.GetTransactions)
	finance.Post("/tip", financeHandler.Tip)
	finance.Post("/transfer", financeHandler.Transfer)
	finance.Post("/unlock", financeHandler.UnlockContent)
	finance.Post("/escrow", financeHandler.CreateEscrow)
	finance.Get("/escrow/:id", financeHandler.GetEscrow)
	finance.Post("/escrow/:id/release", financeHandler.ReleaseEscrow)
	finance.Post("/escrow/:id/refund", financeHandler.RefundEscrow)

	moderation := protected.Group("/moderation")
	moderation.Get("/queue", moderationHandler.GetQueue)
	moderation.Post("/queue/:user_id/ban", moderationHandler.BanAccount)
	moderation.Post("/queue/:user_id/safe", moderationHandler.MarkSafe)
	moderation.Post("/reviews/:id/assign", moderationHandler.AssignReview)
	moderation.Post("/reviews/:id/resolve", moderationHandler.ResolveReview)
	moderation.Post("/classify", moderationHandler.ClassifyContent)

	if err := RegisterStoriesRoutes(app, cfg, pgPool, rdb); err != nil {
		log.Fatalf("failed to register stories routes: %v", err)
	}

	content.Post("/media/upload", func(c *fiber.Ctx) error {
		file, err := c.FormFile("file")
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "file is required"})
		}
		reader, err := file.Open()
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid file"})
		}
		defer reader.Close()
		ext := filepath.Ext(file.Filename)
		key := "media/" + uuid.NewString() + ext
		if _, err := storageClient.Upload(c.Context(), key, reader, file.Header.Get("Content-Type")); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "media upload failed"})
		}
		url := strings.TrimRight(cfg.Storage.PublicURLPrefix, "/") + "/" + key
		return c.Status(fiber.StatusCreated).JSON(fiber.Map{"url": url, "media_url": url, "media_id": strings.TrimSuffix(uuid.NewString(), "")})
	})

	liveHandler := func(c *fiber.Ctx) error {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"status": "ok",
			"request_id": coreMiddleware.GetRequestID(c),
		})
	}
	app.Get("/health/live", liveHandler)
	app.Get("/health", liveHandler)
	app.Get("/health/ready", func(c *fiber.Ctx) error {
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()

		ready := true
		if err := pgPool.Ping(ctx); err != nil {
			ready = false
		}
		if rdb == nil || rdb.Conn == nil || rdb.Conn.Ping(ctx).Err() != nil {
			ready = false
		}
		if bus == nil || bus.Conn == nil || !bus.Conn.IsConnected() {
			ready = false
		}

		status := fiber.StatusOK
		state := "ready"
		if !ready {
			status = fiber.StatusServiceUnavailable
			state = "not_ready"
		}
		return c.Status(status).JSON(fiber.Map{
			"status": state,
			"request_id": coreMiddleware.GetRequestID(c),
		})
	})
	cleanup := func() {
		zapLogger.Info("shutting down API")
		if wsHub != nil {
			wsHub.Stop()
		}
		if orchestrator != nil {
			orchestrator.Stop()
		}
		if bus != nil {
			drainDone := make(chan error, 1)
			go func() { drainDone <- bus.Conn.Drain() }()
			select {
			case err := <-drainDone:
				if err != nil {
					zapLogger.Warn("NATS drain failed", zap.Error(err))
				}
			case <-time.After(3 * time.Second):
				zapLogger.Warn("NATS drain timed out; closing connection")
			}
			bus.Conn.Close()
		}
		if rdb != nil {
			_ = rdb.Close()
		}
		if pgPool != nil {
			pgPool.Close()
		}
		if scyllaClient != nil {
			scyllaClient.Close()
		}
		_ = zapLogger.Sync()
	}
	return app, resources, handlers, cleanup
}

var _ = errors.New
