package transport

import (
	"local/merope/internal/modules/privacy/domain"

	"github.com/gofiber/fiber/v2"
)

type PrivacyHandler struct {
	service domain.RuntimePrivacyService
}

func NewPrivacyHandler(service domain.RuntimePrivacyService) *PrivacyHandler {
	return &PrivacyHandler{service: service}
}

func (h *PrivacyHandler) SetGhostMode(c *fiber.Ctx) error {
	sessionID := c.Locals("session_id").(string)
	var req struct { Active bool `json:"active"` }
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	if err := h.service.SetGhostMode(c.Context(), sessionID, req.Active); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"message": "Ghost mode updated", "active": req.Active})
}

func (h *PrivacyHandler) CheckVisibility(c *fiber.Ctx) error {
	userID := c.Params("user_id")
	viewerID := c.Locals("user_id").(string)
	visible, err := h.service.CheckVisibility(c.Context(), userID, viewerID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"visible": visible})
}

func (h *PrivacyHandler) UpdateIdentityKeys(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	var req struct { DeviceID string `json:"device_id"`; PublicKey []byte `json:"public_key"` }
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	if req.DeviceID == "" || len(req.PublicKey) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "device_id and public_key are required"})
	}
	if err := h.service.UpdateIdentityKeys(c.Context(), userID, req.DeviceID, req.PublicKey); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"message": "Identity keys updated"})
}

func (h *PrivacyHandler) UploadPreKeys(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	var req struct {
		DeviceID string `json:"device_id"`
		SignedKey *domain.SignedPreKey `json:"signed_pre_key"`
		OneTimeKeys []domain.OneTimePreKey `json:"one_time_pre_keys"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	if req.DeviceID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "device_id is required"})
	}
	if err := h.service.UploadPreKeys(c.Context(), userID, req.DeviceID, req.SignedKey, req.OneTimeKeys); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"message": "Pre-keys uploaded"})
}

func (h *PrivacyHandler) GetPreKeyBundle(c *fiber.Ctx) error {
	targetUserID := c.Params("user_id")
	deviceID := c.Query("device_id")
	if deviceID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "device_id is required"})
	}
	bundle, err := h.service.GetPreKeyBundle(c.Context(), targetUserID, deviceID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(bundle)
}
