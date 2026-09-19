package transport

import (
	"time"

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
	return c.JSON(fiber.Map{"balance": balance, "currency": "TRY"})
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


func (h *FinanceHandler) GetTransactions(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	page := c.QueryInt("page", 0)
	limit := c.QueryInt("limit", 25)
	if page < 0 || limit < 1 || limit > 100 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid pagination"})
	}
	transactions, err := h.service.GetTransactions(c.Context(), userID, int32(limit), int32(page*limit))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	items := make([]fiber.Map, 0, len(transactions))
	for _, tx := range transactions {
		txType := "credit"
		if tx.SenderID == userID {
			txType = "debit"
		}
		if tx.Type == "refund" || tx.Type == "escrow_refund" {
			txType = "refund"
		}
		if tx.Type == "fee" {
			txType = "fee"
		}
		items = append(items, fiber.Map{
			"id":                 tx.ID,
			"amount":             float64(tx.Amount),
			"transaction_type":  txType,
			"created_at":         tx.CreatedAt.UTC().Format(time.RFC3339),
			"description":       tx.Type,
			"transaction_status": tx.Status,
			"currency":           tx.Currency,
			"fee":                float64(tx.Fee),
			"from_account_id":    tx.SenderID,
			"to_account_id":      tx.ReceiverID,
			"metadata":           tx.Metadata,
		})
	}
	return c.JSON(fiber.Map{"transactions": items, "page": page, "limit": limit})
}

func (h *FinanceHandler) GetEscrow(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	escrowID := c.Params("id")
	escrow, err := h.service.GetEscrow(c.Context(), escrowID)
	if err != nil || (escrow.BuyerID != userID && escrow.SellerID != userID) {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "escrow not found"})
	}
	return c.JSON(escrow)
}

func (h *FinanceHandler) RefundEscrow(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	escrowID := c.Params("id")
	if err := h.service.RefundEscrow(c.Context(), escrowID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"message": "Escrow refunded"})
}

func (h *FinanceHandler) UnlockContent(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	var req map[string]interface{}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	postID, _ := req["post_id"].(string)
	amountFloat, _ := req["amount"].(float64)
	amount := int64(amountFloat)
	if postID == "" || amount <= 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	if err := h.service.UnlockContent(c.Context(), userID, postID, amount); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"message": "Content unlocked"})
}


func (h *FinanceHandler) Transfer(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)
	var req struct {
		ReceiverID string `json:\"receiver_id\"`
		Amount     int64  `json:\"amount\"`
	}
	if err := c.BodyParser(&req); err != nil || req.ReceiverID == "" || req.Amount <= 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid transfer"})
	}
	if err := h.service.TransferFunds(c.Context(), senderID, req.ReceiverID, req.Amount); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "operation failed"})
	}
	return c.JSON(fiber.Map{"message": "Transfer completed"})
}
