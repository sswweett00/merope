package transport

import (
	"strconv"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/moderation/domain"
)

type ModerationHandler struct {
	service domain.ModerationService
}

func NewModerationHandler(service domain.ModerationService) *ModerationHandler {
	return &ModerationHandler{service: service}
}

func (h *ModerationHandler) Report(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		TargetType string `json:"target_type"`
		TargetID   string `json:"target_id"`
		Reason     string `json:"reason"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.ReportContent(c.Context(), userID, req.TargetType, req.TargetID, req.Reason); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"status": "reported"})
}

func (h *ModerationHandler) GetBots(c *fiber.Ctx) error {
	bots, err := h.service.IdentifyBots(c.Context())
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"bots": bots})
}

func (h *ModerationHandler) BanAccount(c *fiber.Ctx) error {
	userID := c.Params("user_id")
	if err := h.service.BanAccount(c.Context(), userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ModerationHandler) MarkSafe(c *fiber.Ctx) error {
	userID := c.Params("user_id")
	if err := h.service.MarkAccountSafe(c.Context(), userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ModerationHandler) GetQueue(c *fiber.Ctx) error {
	status := c.Query("status", "pending")
	pageStr := c.Query("page", "0")
	page, _ := strconv.Atoi(pageStr)

	items, err := h.service.GetReviewQueue(c.Context(), status, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"queue": items})
}

func (h *ModerationHandler) AssignReview(c *fiber.Ctx) error {
	queueID := c.Params("id")
	reviewerID := c.Locals("user_id").(string)

	if err := h.service.AssignReview(c.Context(), queueID, reviewerID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ModerationHandler) ResolveReview(c *fiber.Ctx) error {
	queueID := c.Params("id")
	type request struct {
		Decision string `json:"decision"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.ResolveReview(c.Context(), queueID, req.Decision); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ModerationHandler) ClassifyContent(c *fiber.Ctx) error {
	type request struct {
		ContentType string `json:"content_type"`
		ContentID   string `json:"content_id"`
		AuthorID    string `json:"author_id"`
		Text        string `json:"text"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	classification, err := h.service.ClassifyContent(c.Context(), req.ContentType, req.ContentID, req.Text)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	if classification != nil && classification.Score > 0.4 {
		_ = h.service.AutoFlagContent(c.Context(), req.ContentType, req.ContentID, req.AuthorID)
	}

	return c.JSON(classification)
}
