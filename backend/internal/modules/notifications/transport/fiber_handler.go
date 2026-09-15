package transport

import (
	"local/merope/internal/modules/notifications/domain"
	"strconv"

	"github.com/gofiber/fiber/v2"
)

type NotificationsHandler struct {
	service domain.NotificationsService
}

func NewNotificationsHandler(service domain.NotificationsService) *NotificationsHandler {
	return &NotificationsHandler{service: service}
}

func (h *NotificationsHandler) GetActivity(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	pageStr := c.Query("page", "0")
	page, _ := strconv.Atoi(pageStr)

	notifications, err := h.service.GetActivity(c.Context(), userID, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"notifications": notifications})
}
