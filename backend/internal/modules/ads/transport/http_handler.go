package transport

import (
	"strings"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/ads/domain"
)

type AdsHandler struct {
	service domain.AdsService
}

func NewAdsHandler(service domain.AdsService) *AdsHandler {
	return &AdsHandler{service: service}
}

func (h *AdsHandler) ServeAds(c *fiber.Ctx) error {
	interestsStr := c.Query("interests")
	var interests []string
	if interestsStr != "" {
		interests = strings.Split(interestsStr, ",")
	}

	ads, err := h.service.ServeAds(c.Context(), interests)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(ads)
}

func (h *AdsHandler) CreateCampaign(c *fiber.Ctx) error {
	var req struct {
		AdvertiserID string `json:"advertiser_id"`
		Name         string `json:"name"`
		Budget       int32  `json:"budget"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	campaign, err := h.service.CreateCampaign(c.Context(), req.AdvertiserID, req.Name, req.Budget)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(campaign)
}
