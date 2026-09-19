package transport

import (
	"github.com/gofiber/fiber/v2"

	"local/merope/internal/core/errors"
	"local/merope/internal/modules/lumia/domain"
)

type LumiaHandler struct {
	service domain.LumiaService
}

func NewLumiaHandler(service domain.LumiaService) *LumiaHandler {
	return &LumiaHandler{service: service}
}

func (h *LumiaHandler) Tip(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)

	type request struct {
		SignalID string `json:"signal_id"`
		Amount   int    `json:"amount"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	if err := h.service.TipSignal(c.Context(), senderID, req.SignalID, req.Amount); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}

	return c.JSON(fiber.Map{"message": "Energy wave sent successfully", "amount": req.Amount})
}

func (h *LumiaHandler) GetLive(c *fiber.Ctx) error {
	broadcasts, err := h.service.GetLiveBroadcasts(c.Context())
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}
	return c.JSON(broadcasts)
}
