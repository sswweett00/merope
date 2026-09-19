package transport

import (
	"strings"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/stories/domain"
)

type StoriesHandler struct {
	service domain.StoriesService
}

func NewStoriesHandler(service domain.StoriesService) *StoriesHandler {
	return &StoriesHandler{service: service}
}

func (h *StoriesHandler) PostStory(c *fiber.Ctx) error {
	authorID, ok := c.Locals("user_id").(string)
	if !ok || authorID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	type request struct {
		MediaURL  string `json:"media_url"`
		MediaType string `json:"media_type"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	if strings.TrimSpace(req.MediaURL) == "" || strings.TrimSpace(req.MediaType) == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "media_url and media_type are required"})
	}
	story, err := h.service.PostStory(c.Context(), authorID, req.MediaURL, req.MediaType, 24)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to create story"})
	}
	return c.Status(fiber.StatusCreated).JSON(story)
}

func (h *StoriesHandler) GetFeed(c *fiber.Ctx) error {
	userID, ok := c.Locals("user_id").(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	stories, err := h.service.GetFeed(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load stories"})
	}
	return c.JSON(fiber.Map{"stories": stories})
}

func (h *StoriesHandler) GetUserStory(c *fiber.Ctx) error {
	viewerID, ok := c.Locals("user_id").(string)
	if !ok || strings.TrimSpace(viewerID) == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	userID := strings.TrimSpace(c.Params("user_id"))
	if userID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "user_id is required"})
	}
	story, err := h.service.GetLatestStoryForUser(c.Context(), userID, viewerID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "story not found"})
	}
	return c.JSON(story)
}

func (h *StoriesHandler) View(c *fiber.Ctx) error {
	userID, ok := c.Locals("user_id").(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	if err := h.service.ViewStory(c.Context(), c.Params("id"), userID); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "failed to record view"})
	}
	return c.SendStatus(fiber.StatusNoContent)
}

func (h *StoriesHandler) React(c *fiber.Ctx) error {
	userID, ok := c.Locals("user_id").(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	var req struct {
		Emoji string `json:"emoji"`
	}
	if err := c.BodyParser(&req); err != nil || strings.TrimSpace(req.Emoji) == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "emoji is required"})
	}
	if err := h.service.ReactToStory(c.Context(), c.Params("id"), userID, req.Emoji); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "failed to react to story"})
	}
	return c.SendStatus(fiber.StatusNoContent)
}

func (h *StoriesHandler) Viewers(c *fiber.Ctx) error {
	requesterID, ok := c.Locals("user_id").(string)
	if !ok || strings.TrimSpace(requesterID) == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	viewers, err := h.service.GetStoryViewers(c.Context(), c.Params("id"), requesterID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load story viewers"})
	}
	return c.JSON(fiber.Map{"viewers": viewers})
}
