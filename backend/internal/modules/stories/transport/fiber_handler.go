package transport

import (
	"local/merope/internal/modules/stories/domain"

	"github.com/gofiber/fiber/v2"
)

type StoriesHandler struct {
	service domain.StoriesService
}

func NewStoriesHandler(service domain.StoriesService) *StoriesHandler {
	return &StoriesHandler{service: service}
}

func (h *StoriesHandler) PostStory(c *fiber.Ctx) error {
	authorID := c.Locals("user_id").(string)
	type request struct {
		MediaURL  string `json:"media_url"`
		MediaType string `json:"media_type"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	story, err := h.service.PostStory(c.Context(), authorID, req.MediaURL, req.MediaType, 24)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(story)
}

func (h *StoriesHandler) GetFeed(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	stories, err := h.service.GetFeed(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"stories": stories})
}

func (h *StoriesHandler) View(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	storyID := c.Params("id")

	if err := h.service.ViewStory(c.Context(), storyID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"message": "View recorded"})
}
