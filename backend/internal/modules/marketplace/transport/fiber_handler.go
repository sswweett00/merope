package transport

import (
	"local/merope/internal/modules/marketplace/domain"

	"github.com/gofiber/fiber/v2"
)

type MarketplaceHandler struct {
	service domain.RuntimeMarketplaceService
}

func NewMarketplaceHandler(service domain.RuntimeMarketplaceService) *MarketplaceHandler {
	return &MarketplaceHandler{service: service}
}

func (h *MarketplaceHandler) ListProduct(c *fiber.Ctx) error {
	var req domain.Product
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	if req.Price < 0 || req.StockQuantity < 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid product values"})
	}

	if err := h.service.PostProduct(c.Context(), &req); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"message": "Product listed successfully", "product_id": req.ID})
}

func (h *MarketplaceHandler) Purchase(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	var req struct {
		ProductIDs []string `json:"product_ids"`
		Quantities []int32  `json:"quantities"`
		Address    string   `json:"address"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	order, err := h.service.Purchase(c.Context(), userID, req.ProductIDs, req.Quantities, req.Address)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"order": order,
		"order_id": order.ID,
		"total_amount": order.TotalAmount,
	})
}
