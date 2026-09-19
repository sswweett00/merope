package transport

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	"local/merope/internal/modules/marketplace/domain"
)

type MarketplaceHandler struct {
	service domain.RuntimeMarketplaceService
}

func NewMarketplaceHandler(service domain.RuntimeMarketplaceService) *MarketplaceHandler {
	return &MarketplaceHandler{service: service}
}

func (h *MarketplaceHandler) ListProducts(c *fiber.Ctx) error {
	query := strings.TrimSpace(c.Query("q"))
	products, err := h.service.SearchProducts(c.Context(), query)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load products"})
	}
	return c.JSON(fiber.Map{"products": products})
}

func (h *MarketplaceHandler) ListProduct(c *fiber.Ctx) error {
	var req domain.Product
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
	}
	if req.Price < 0 || req.StockQuantity < 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid product values"})
	}
	userID, ok := c.Locals("user_id").(string)
	if !ok || strings.TrimSpace(userID) == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	// Seller ownership is derived from the authenticated principal; never trust
	// a client-provided seller_id for product creation.
	req.SellerID = strings.TrimSpace(userID)
	if err := h.service.PostProduct(c.Context(), &req); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to list product"})
	}
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"message": "product listed successfully", "product_id": req.ID})
}

func (h *MarketplaceHandler) Purchase(c *fiber.Ctx) error {
	userID, ok := c.Locals("user_id").(string)
	if !ok || userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "authentication required"})
	}
	var req struct {
		ProductIDs []string `json:"product_ids"`
		Quantities []int32  `json:"quantities"`
		Address    string   `json:"address"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
	}
	order, err := h.service.Purchase(c.Context(), userID, req.ProductIDs, req.Quantities, req.Address)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"order": order, "order_id": order.ID, "total_amount": order.TotalAmount})
}
