package transport

import (
	"strconv"

	"local/merope/internal/modules/notifications/domain"
	"github.com/gofiber/fiber/v2"
)

type NotificationsHandler struct {
	service domain.RuntimeNotificationsService
}

func NewNotificationsHandler(service domain.RuntimeNotificationsService) *NotificationsHandler {
	return &NotificationsHandler{service: service}
}

func (h *NotificationsHandler) GetActivity(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	pageStr := c.Query("page", "0")
	page, err := strconv.Atoi(pageStr)
	if err != nil || page < 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid page"})
	}

	notifications, err := h.service.GetActivity(c.Context(), userID, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"notifications": notifications})
}
