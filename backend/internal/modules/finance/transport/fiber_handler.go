package transport

import (
	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/finance/domain"
)

type FinanceHandler struct {
	service domain.RuntimeFinanceService
}

func NewFinanceHandler(service domain.RuntimeFinanceService) *FinanceHandler {
	return &FinanceHandler{service: service}
}

func (h *FinanceHandler) GetBalance(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	balance, err := h.service.GetBalance(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"balance": balance})
}

func (h *FinanceHandler) Tip(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)
	type request struct {
		ReceiverID string `json:"receiver_id"`
		Amount     int64  `json:"amount"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.TipUser(c.Context(), senderID, req.ReceiverID, req.Amount); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"message": "Tip sent successfully"})
}

func (h *FinanceHandler) CreateEscrow(c *fiber.Ctx) error {
	buyerID := c.Locals("user_id").(string)
	var req struct {
		SellerID    string `json:"seller_id"`
		Amount      int64  `json:"amount"`
		Description string `json:"description"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	escrow, err := h.service.InitiateEscrow(c.Context(), buyerID, req.SellerID, req.Amount, req.Description)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(escrow)
}

func (h *FinanceHandler) ReleaseEscrow(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	escrowID := c.Params("id")

	if err := h.service.ReleaseEscrow(c.Context(), escrowID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"message": "Escrow released"})
}
