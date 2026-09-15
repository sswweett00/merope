package transport

import (
	"local/merope/internal/modules/developer/domain"

	"github.com/gofiber/fiber/v2"
)

type DeveloperHandler struct {
	service domain.DeveloperService
}

func NewDeveloperHandler(service domain.DeveloperService) *DeveloperHandler {
	return &DeveloperHandler{service: service}
}

func (h *DeveloperHandler) RegisterApp(c *fiber.Ctx) error {
	type request struct {
		Name string `json:"name"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	app, err := h.service.RegisterApp(c.Context(), c.Locals("user_id").(string), req.Name)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	app.ClientSecret = "masked"
	return c.Status(fiber.StatusCreated).JSON(app)
}

func (h *DeveloperHandler) SetupWebhook(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	type request struct {
		URL    string   `json:"url"`
		Events []string `json:"events"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	webhook, err := h.service.SetupWebhook(c.Context(), appID, req.URL, req.Events)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(webhook)
}

func (h *DeveloperHandler) GetMetrics(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	metrics, err := h.service.GetAppHealth(c.Context(), appID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(metrics)
}

func (h *DeveloperHandler) ListWebhooks(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	webhooks, err := h.service.ListWebhooks(c.Context(), appID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"webhooks": webhooks})
}

func (h *DeveloperHandler) GenerateAPIKey(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	type request struct {
		Name      string   `json:"name"`
		Scopes    []string `json:"scopes"`
		TTLDays   int      `json:"ttl_days"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	key, err := h.service.GenerateAPIKey(c.Context(), appID, req.Name, req.Scopes, req.TTLDays)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"api_key":    key.RawKey,
		"key_prefix": key.KeyPrefix,
		"scopes":     key.Scopes,
		"expires_at": key.ExpiresAt,
	})
}

func (h *DeveloperHandler) ListAPIKeys(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	keys, err := h.service.ListAPIKeys(c.Context(), appID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"keys": keys})
}

func (h *DeveloperHandler) RevokeAPIKey(c *fiber.Ctx) error {
	appID := c.Params("app_id")
	keyID := c.Params("key_id")
	_ = appID

	if err := h.service.RevokeAPIKey(c.Context(), keyID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.SendStatus(fiber.StatusOK)
}
