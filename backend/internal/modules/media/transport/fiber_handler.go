package transport

import (
	"local/merope/internal/modules/media/domain"

	"github.com/gofiber/fiber/v2"
)

type MediaHandler struct {
	service domain.MediaService
}

func NewMediaHandler(service domain.MediaService) *MediaHandler {
	return &MediaHandler{service: service}
}

func (h *MediaHandler) UploadImage(c *fiber.Ctx) error {
	file, err := c.FormFile("file")
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "No file uploaded"})
	}

	reader, err := file.Open()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Could not open file"})
	}
	defer reader.Close()

	userID, _ := c.Locals("user_id").(string)
	if userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Authentication required"})
	}

	res, err := h.service.UploadImage(c.Context(), file.Filename, reader, userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(res)
}
