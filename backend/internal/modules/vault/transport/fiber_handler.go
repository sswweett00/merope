package transport

import (
	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/vault/domain"
)

type VaultHandler struct {
	service domain.VaultService
}

func NewVaultHandler(service domain.VaultService) *VaultHandler {
	return &VaultHandler{service: service}
}

func (h *VaultHandler) StoreItem(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)

	var req struct {
		Title         string `json:"title"`
		EncryptedData string `json:"encrypted_data"`
		ItemType      string `json:"item_type"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	item, err := h.service.SecureStore(c.Context(), userID, req.Title, req.EncryptedData, req.ItemType)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"item":      item,
		"item_id":   item.ID,
		"item_type": item.ItemType,
	})
}

func (h *VaultHandler) ListItems(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)

	items, err := h.service.ListItems(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}

	return c.JSON(fiber.Map{"items": items})
}
