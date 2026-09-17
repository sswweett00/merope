package transport

import (
	"local/merope/internal/modules/developer/domain"

	"github.com/gofiber/fiber/v2"
)

type DeveloperHandler struct { service domain.RuntimeDeveloperService }

func NewDeveloperHandler(service domain.RuntimeDeveloperService) *DeveloperHandler { return &DeveloperHandler{service: service} }

func (h *DeveloperHandler) RegisterApp(c *fiber.Ctx) error {
	var req struct { Name string `json:"name"` }
	if err := c.BodyParser(&req); err != nil || req.Name == "" { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"}) }
	app, err := h.service.RegisterApp(c.Context(), c.Locals("user_id").(string), req.Name)
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	app.ClientSecret = "masked"
	return c.Status(fiber.StatusCreated).JSON(app)
}

func (h *DeveloperHandler) SetupWebhook(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	var req struct { URL string `json:"url"`; Events []string `json:"events"` }
	if err := c.BodyParser(&req); err != nil || req.URL == "" { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"}) }
	webhook, err := h.service.SetupWebhook(c.Context(), appID, req.URL, req.Events)
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.Status(fiber.StatusCreated).JSON(webhook)
}

func (h *DeveloperHandler) GetMetrics(c *fiber.Ctx) error {
	metrics, err := h.service.GetAppHealth(c.Context(), c.Params("app_id"))
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.JSON(metrics)
}

func (h *DeveloperHandler) ListWebhooks(c *fiber.Ctx) error {
	webhooks, err := h.service.ListWebhooks(c.Context(), c.Params("app_id"))
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.JSON(fiber.Map{"webhooks": webhooks})
}

func (h *DeveloperHandler) GenerateAPIKey(c *fiber.Ctx) error {
	var req struct { Name string `json:"name"`; Scopes []string `json:"scopes"`; TTLDays int `json:"ttl_days"` }
	if err := c.BodyParser(&req); err != nil || req.Name == "" { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"}) }
	key, err := h.service.GenerateAPIKey(c.Context(), c.Params("app_id"), req.Name, req.Scopes, req.TTLDays)
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"api_key": key.RawKey, "key_prefix": key.KeyPrefix, "scopes": key.Scopes, "expires_at": key.ExpiresAt})
}

func (h *DeveloperHandler) ListAPIKeys(c *fiber.Ctx) error {
	keys, err := h.service.ListAPIKeys(c.Context(), c.Params("app_id"))
	if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.JSON(fiber.Map{"keys": keys})
}

func (h *DeveloperHandler) RevokeAPIKey(c *fiber.Ctx) error {
	if err := h.service.RevokeAPIKey(c.Context(), c.Params("key_id")); err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()}) }
	return c.SendStatus(fiber.StatusOK)
}
