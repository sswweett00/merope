package transport

import (
	"strconv"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/notifications/domain"
)

type NotificationsHandler struct {
	service domain.RuntimeNotificationsService
}

func NewNotificationsHandler(service domain.RuntimeNotificationsService) *NotificationsHandler {
	return &NotificationsHandler{service: service}
}

func (h *NotificationsHandler) GetActivity(c *fiber.Ctx) error {
	userIDValue := c.Locals("user_id")
	userID, ok := userIDValue.(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}

	pageStr := c.Query("page", "0")
	page, err := strconv.Atoi(pageStr)
	if err != nil || page < 0 || page > 100000 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid page"})
	}

	notifications, err := h.service.GetActivity(c.Context(), userID, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load notifications"})
	}
	return c.JSON(fiber.Map{"notifications": notifications, "page": page, "pageSize": 20})
}

func (h *NotificationsHandler) ClearAll(c *fiber.Ctx) error {
	userIDValue := c.Locals("user_id")
	userID, ok := userIDValue.(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	if err := h.service.ClearForUser(c.Context(), userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to clear notifications"})
	}
	return c.SendStatus(fiber.StatusNoContent)
}
