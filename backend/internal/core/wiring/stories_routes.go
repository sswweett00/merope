package wiring

import (
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgxpool"
	"local/merope/internal/core/config"
	coreMiddleware "local/merope/internal/core/middleware"
	"local/merope/internal/core/security"
	"local/merope/internal/database/db"
	"local/merope/internal/platform/redis"
	storiesInfra "local/merope/internal/modules/stories/infra"
	storiesService "local/merope/internal/modules/stories/service"
	storiesTransport "local/merope/internal/modules/stories/transport"
)

// RegisterStoriesRoutes attaches the server-authoritative stories API with the
// same authentication, authorization and idempotency controls used by BuildApp.
func RegisterStoriesRoutes(app *fiber.App, cfg *config.Config, pool *pgxpool.Pool, rdb *redis.Client) error {
	queries := db.New(pool)
	repo := storiesInfra.NewPostgresStoriesRepository(queries)
	service := storiesService.NewStoriesService(repo)
	handler := storiesTransport.NewStoriesHandler(service)

	enforcer, err := security.NewDefaultEnforcer()
	if err != nil {
		return err
	}

	stories := app.Group("/api/v10/stories")
	stories.Use(security.AuthMiddleware(cfg.JWTSecret, rdb.Conn))
	stories.Use(security.RBACMiddleware(enforcer))
	stories.Use(coreMiddleware.Idempotency(rdb.Conn, 24*time.Hour))
	stories.Get("/feed", handler.GetFeed)
	stories.Get("/user/:user_id", handler.GetUserStory)
	stories.Post("/:id/view", handler.View)
	stories.Post("/:id/react", handler.React)
	stories.Get("/:id/viewers", handler.Viewers)
	stories.Post("", handler.PostStory)
	return nil
}
