package transport

import (
	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/growth/domain"
)

type GrowthHandler struct {
	service domain.GrowthService
}

func NewGrowthHandler(service domain.GrowthService) *GrowthHandler {
	return &GrowthHandler{service: service}
}

func (h *GrowthHandler) TrackSignup(c *fiber.Ctx) error {
	var req struct {
		ReferrerID string `json:"referrer_id"`
		ReferredID string `json:"referred_id"`
		Code       string `json:"code"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if err := h.service.TrackSignup(c.Context(), req.ReferrerID, req.ReferredID, req.Code); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"message": "Referral tracked successfully"})
}
