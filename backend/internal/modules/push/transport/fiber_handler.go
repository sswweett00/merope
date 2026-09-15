package transport

import (
	"fmt"

	"local/merope/internal/modules/push/domain"

	"github.com/gofiber/fiber/v2"
)

type PushHandler struct {
	service domain.PushService
}

func NewPushHandler(service domain.PushService) *PushHandler {
	return &PushHandler{service: service}
}

func (h *PushHandler) RegisterDevice(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		Token      string `json:"token"`
		Platform   string `json:"platform"`
		DeviceID   string `json:"device_id"`
		AppVersion string `json:"app_version"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.RegisterDevice(c.Context(), userID, req.Token, req.Platform, req.DeviceID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"status": "registered"})
}

func (h *PushHandler) UnregisterDevice(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		Token    string `json:"token"`
		DeviceID string `json:"device_id"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.UnregisterDevice(c.Context(), userID+"_"+req.DeviceID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *PushHandler) GetDevices(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	devices, err := h.service.ListDevices(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	safeDevices := make([]map[string]string, 0, len(devices))
	for _, d := range devices {
		safeDevices = append(safeDevices, map[string]string{
			"id":         d.ID,
			"platform":   d.Platform,
			"device_id":  d.DeviceID,
			"app_version": d.AppVersion,
			"is_active":  fmt.Sprintf("%t", d.IsActive),
			"created_at": d.CreatedAt,
		})
	}
	return c.JSON(fiber.Map{"devices": safeDevices})
}

func (h *PushHandler) GetDeliveryReport(c *fiber.Ctx) error {
	notifID := c.Params("id")
	report, err := h.service.GetDeliveryReport(c.Context(), notifID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	if report == nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "report not found"})
	}
	return c.JSON(report)
}

func (h *PushHandler) TestPush(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	_ = userID

	if err := h.service.Dispatch(c.Context(), userID, "Test Push", "This is a test notification", nil); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"status": "dispatched"})
}
