package transport

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	"local/merope/internal/core/errors"
	"local/merope/internal/modules/messaging/domain"
)

type E2EEKeyHandler struct {
	repo domain.E2EEPublicKeyRepository
}

func NewE2EEKeyHandler(repo domain.E2EEPublicKeyRepository) *E2EEKeyHandler {
	return &E2EEKeyHandler{repo: repo}
}

func (h *E2EEKeyHandler) Get(c *fiber.Ctx) error {
	userID := strings.TrimSpace(c.Params("user_id"))
	if userID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid user id"})
	}
	key, err := h.repo.GetPublicKey(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"code": errors.ErrNotFound, "message": "Public key not found"})
	}
	return c.JSON(key)
}

func (h *E2EEKeyHandler) Upload(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	if strings.TrimSpace(userID) == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Authentication required"})
	}

	type request struct {
		PublicKey string `json:"public_key"`
		Algorithm string `json:"algorithm"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Invalid request body"})
	}
	req.PublicKey = strings.TrimSpace(req.PublicKey)
	if len(req.PublicKey) < 16 || len(req.PublicKey) > 8192 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid public key"})
	}
	req.Algorithm = strings.ToLower(strings.TrimSpace(req.Algorithm))
	if req.Algorithm == "" {
		req.Algorithm = "x25519"
	}
	if req.Algorithm != "x25519" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Unsupported key algorithm"})
	}

	if err := h.repo.UpsertPublicKey(c.Context(), userID, req.PublicKey, req.Algorithm); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to store public key"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{"user_id": userID, "public_key": req.PublicKey, "algorithm": req.Algorithm, "status": "stored"})
}
