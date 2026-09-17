package wiring

import (
	"github.com/gofiber/fiber/v2"
	"local/merope/internal/database/db"
	storiesInfra "local/merope/internal/modules/stories/infra"
	storiesService "local/merope/internal/modules/stories/service"
	storiesTransport "local/merope/internal/modules/stories/transport"
)

func registerStoriesRoutes(protected fiber.Router, queries *db.Queries) {
	repo := storiesInfra.NewPostgresStoriesRepository(queries)
	service := storiesService.NewStoriesService(repo)
	handler := storiesTransport.NewStoriesHandler(service)

	stories := protected.Group("/stories")
	stories.Get("/feed", handler.GetFeed)
	stories.Get("/user/:user_id", handler.GetUserStory)
	stories.Post("/:id/view", handler.View)
	stories.Post("/:id/react", handler.React)
	stories.Get("/:id/viewers", handler.Viewers)
	stories.Post("", handler.PostStory)
}
