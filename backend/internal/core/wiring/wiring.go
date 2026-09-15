package wiring

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"go.uber.org/zap"

	"local/merope/internal/core/config"
	"local/merope/internal/core/errors"
	"local/merope/internal/core/security"
	"local/merope/internal/core/worker"
	"local/merope/internal/database"
	"github.com/jackc/pgx/v5/pgxpool"
	"local/merope/internal/database/db"
	"local/merope/internal/platform/nats"
	"local/merope/internal/platform/redis"
	"local/merope/internal/platform/scylla"

	identityInfra "local/merope/internal/modules/identity/infra"
	identityService "local/merope/internal/modules/identity/service"
	identityTransport "local/merope/internal/modules/identity/transport"

	contentDomain "local/merope/internal/modules/content/domain"
	contentInfra "local/merope/internal/modules/content/infra"
	contentService "local/merope/internal/modules/content/service"
	contentTransport "local/merope/internal/modules/content/transport"

	messagingDomain "local/merope/internal/modules/messaging/domain"
	messagingInfra "local/merope/internal/modules/messaging/infra"
	messagingService "local/merope/internal/modules/messaging/service"
	messagingTransport "local/merope/internal/modules/messaging/transport"

	socialInfra "local/merope/internal/modules/social/infra"
	socialService "local/merope/internal/modules/social/service"
	socialTransport "local/merope/internal/modules/social/transport"

	lumiaService "local/merope/internal/modules/lumia/service"
	lumiaInfra "local/merope/internal/modules/lumia/infra"
	lumiaTransport "local/merope/internal/modules/lumia/transport"
)

type Resources struct {
	PostgresPool *pgxpool.Pool
	Redis        *redis.Client
	NATS         *nats.Client
	Orchestrator *worker.Orchestrator
	Scylla       *scylla.Client
}

type Handlers struct {
	Identity    *identityTransport.IdentityHandler
	Content     *contentTransport.ContentHandler
	Messaging   *messagingTransport.MessagingHandler
	Social      *socialTransport.SocialHandler
	Lumia       *lumiaTransport.LumiaHandler
	VeritasGuard *socialService.VeritasContentGuard
}

func BuildApp(ctx context.Context, cfg *config.Config) (*fiber.App, *Resources, *Handlers, func()) {
	zapLogger, _ := zap.NewProduction()
	defer func() { _ = zapLogger.Sync() }()

	// 1. Platform Infrastructure
	pgPool, err := database.NewPostgresPool(ctx)
	if err != nil {
		log.Fatalf("Failed to connect to PG: %v", err)
	}

	rdb := redis.New(cfg.Redis.Addr, cfg.Redis.Password)

	queries := db.New(pgPool)

	// ScyllaDB Initialization
	var scyllaClient *scylla.Client
	if len(cfg.Scylla.Hosts) > 0 {
		scyllaClient, err = scylla.New(scylla.Config{
			Hosts:       cfg.Scylla.Hosts,
			Keyspace:    cfg.Scylla.Keyspace,
			Username:    cfg.Scylla.Username,
			Password:    cfg.Scylla.Password,
			Consistency: cfg.Scylla.Consistency,
		})
		if err != nil {
			zapLogger.Warn("ScyllaDB connection failed, falling back to PostgreSQL-only mode", zap.Error(err))
		} else {
			zapLogger.Info("ScyllaDB connected", zap.Strings("hosts", cfg.Scylla.Hosts))
		}
	}

	// NATS JetStream
	var bus *nats.Client
	bus, err = nats.New(cfg.NATS.URL)
	if err != nil {
		zapLogger.Warn("NATS connection failed, real-time features will be limited", zap.Error(err))
	} else {
		_ = bus.EnsureStreams()
		zapLogger.Info("NATS connected", zap.String("url", cfg.NATS.URL))
	}

	// Worker Orchestrator
	orchestrator := worker.NewOrchestrator(queries, 10, 20)
	orchestrator.Start(ctx)

	resources := &Resources{
		PostgresPool: pgPool,
		Redis:        rdb,
		NATS:         bus,
		Orchestrator: orchestrator,
		Scylla:       scyllaClient,
	}

	// 2. Identity Module
	identityRepo := identityInfra.NewPostgresIdentityRepository(queries, rdb.Conn, nil)
	identitySentinel := identityService.NewIdentitySentinel(identityRepo)
	idService := identityService.NewIdentityService(identityRepo, cfg.JWTSecret, identitySentinel)
	idHandler := identityTransport.NewIdentityHandler(idService, cfg.JWTSecret, rdb.Conn)

	// Zenith: Security Fabric Initialization
	anomalyDetector := security.NewAnomalyDetector()
	securityFabric := security.NewMeropeSecurityFabric(bus, anomalyDetector)

	// Veritas Integrity Guard
	veritasGuard := socialService.NewVeritasContentGuard(bus)

	// 3. Content Module
	contentRepo := contentInfra.NewPostgresContentRepository(queries)
	var contService contentDomain.ContentService
	if scyllaClient != nil {
		scyllaContentRepo := contentInfra.NewScyllaContentRepository(scyllaClient)
		contService = contentService.NewHighPerformanceContentService(contentRepo, scyllaContentRepo, bus)
	} else {
		contService = contentService.NewContentService(contentRepo, bus, veritasGuard, idService)
	}
	contHandler := contentTransport.NewContentHandler(contService)

	// 4. Messaging Module
	msgRepo := messagingInfra.NewPostgresMessagingRepository(queries, pgPool)
	var msgService messagingDomain.MessagingService
	if scyllaClient != nil {
		scyllaMsgRepo := messagingInfra.NewScyllaMessagingRepository(scyllaClient)
		msgService = messagingService.NewHighPerformanceService(msgRepo, scyllaMsgRepo, bus, orchestrator, nil, nil)
	} else {
		msgService = messagingService.NewMessagingService(msgRepo, idService, nil, nil, bus, nil, nil)
	}
	msgHandler := messagingTransport.NewMessagingHandler(msgService)

	// 5. Social Module
	socialRepo := socialInfra.NewPostgresSocialRepository(queries)
	socService := socialService.NewSocialService(socialRepo, idService, veritasGuard)
	socHandler := socialTransport.NewSocialHandler(socService)

	// 6. Lumia Module
	lumiaRepo := lumiaInfra.NewPostgresLumiaRepository(queries)
	lumSvc := lumiaService.NewLumiaService(lumiaRepo, idService, bus)
	lumHandler := lumiaTransport.NewLumiaHandler(lumSvc)

	handlers := &Handlers{
		Identity:     idHandler,
		Content:      contHandler,
		Messaging:    msgHandler,
		Social:       socHandler,
		Lumia:        lumHandler,
		VeritasGuard: veritasGuard,
	}

	// 7. Fiber App Setup
	app := fiber.New(fiber.Config{
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{
				"code":    errors.GetCode(err),
				"message": err.Error(),
			})
		},
	})

	app.Use(recover.New())
	app.Use(logger.New())
	app.Use(security.SecurityHeadersMiddleware())
	app.Use(security.AnomalyDetectorMiddleware(security.NewAnomalyDetector()))
	app.Use(cors.New(cors.Config{
		AllowOrigins: cfg.CORSAllowedOrigins,
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
	}))

	app.Use(security.GlobalLimit(rdb.Conn))

	// API Groups
	api := app.Group("/api/v10")

	// Auth Routes
	auth := api.Group("/auth")
	auth.Use(security.AuthLimit(rdb.Conn))
	auth.Post("/register", idHandler.Register)
	auth.Post("/login", idHandler.Login)
	auth.Post("/refresh", idHandler.RefreshToken)
	auth.Get("/me", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), idHandler.Me)
	auth.Post("/logout", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn), idHandler.Logout)

	// Protected Groups
	protected := api.Group("/", security.AuthMiddleware(cfg.JWTSecret, rdb.Conn))

	// Messaging
	messaging := protected.Group("/messaging")
	messaging.Get("/rooms", msgHandler.GetRooms)
	messaging.Post("/rooms", msgHandler.CreateDirectChat)
	messaging.Post("/rooms/group", msgHandler.CreateGroupChat)
	messaging.Get("/rooms/:id/history", msgHandler.GetHistory)
	messaging.Post("/rooms/:id/messages", msgHandler.SendMessage)
	messaging.Put("/messages/:msg_id", msgHandler.EditMessage)
	messaging.Delete("/messages/:msg_id", msgHandler.DeleteMessage)
	messaging.Post("/messages/:msg_id/react", msgHandler.React)
	messaging.Post("/rooms/:id/mute", msgHandler.MuteRoom)
	messaging.Post("/rooms/:id/read", msgHandler.MarkAsRead)
	messaging.Get("/e2ee/keys/:user_id", msgHandler.GetE2EEPublicKey)
	messaging.Post("/e2ee/keys", msgHandler.UploadE2EEPublicKey)

	// Content & Social
	content := protected.Group("/content")
	content.Get("/feed", contHandler.Feed)
	content.Get("/posts/:id", contHandler.GetPost)
	content.Post("/posts", contHandler.CreatePost)
	content.Put("/posts/:id", contHandler.UpdatePost)
	content.Delete("/posts/:id", contHandler.DeletePost)
	content.Get("/posts/:id/comments", contHandler.GetComments)
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

	// Lumia
	lumia := protected.Group("/lumia")
	lumia.Post("/tip", lumHandler.Tip)
	lumia.Get("/live", lumHandler.GetLive)

	// Health Check
	app.Get("/health", func(c *fiber.Ctx) error {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{"status": "nirvana"})
	})

	cleanup := func() {
		zapLogger.Info("Shutting down API...")
		_ = app.Shutdown()
		if orchestrator != nil {
			orchestrator.Stop()
		}
		if bus != nil {
			_ = bus.Conn.Close()
		}
		if rdb != nil {
			_ = rdb.Close()
		}
		if pgPool != nil {
			pgPool.Close()
		}
		if scyllaClient != nil {
			_ = scyllaClient.Close()
		}
	}

	return app, resources, handlers, cleanup
}
