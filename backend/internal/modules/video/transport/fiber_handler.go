package transport

import (
	"local/merope/internal/modules/video/domain"

	"github.com/gofiber/fiber/v2"
)

type VideoHandler struct {
	service domain.VideoService
}

func NewVideoHandler(service domain.VideoService) *VideoHandler {
	return &VideoHandler{service: service}
}

func (h *VideoHandler) Sync(c *fiber.Ctx) error {
	type request struct {
		HubID     string  `json:"hub_id"`
		State     string  `json:"state"`
		Timestamp float64 `json:"timestamp"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.SyncWatchHub(c.Context(), req.HubID, req.State, req.Timestamp); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"status": "synced"})
}

func (h *VideoHandler) AddHotspot(c *fiber.Ctx) error {
	postID := c.Params("id")
	type request struct {
		TS      float64                `json:"ts"`
		X       float64                `json:"x"`
		Y       float64                `json:"y"`
		Action  string                 `json:"action"`
		Payload map[string]interface{} `json:"payload"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.AddInteractiveHotspot(c.Context(), postID, req.TS, req.X, req.Y, req.Action, req.Payload); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"status": "hotspot_added"})
}
