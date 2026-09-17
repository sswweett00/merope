package transport

import (
	"net/mail"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"

	"local/merope/internal/core/errors"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/identity/domain"
)

type IdentityHandler struct {
	service   domain.IdentityService
	jwtSecret string
	rdb       *redis.Client
}

func NewIdentityHandler(service domain.IdentityService, jwtSecret string, rdb *redis.Client) *IdentityHandler {
	return &IdentityHandler{service: service, jwtSecret: jwtSecret, rdb: rdb}
}

func (h *IdentityHandler) Register(c *fiber.Ctx) error {
	type request struct {
		Username    string `json:"username"`
		Email       string `json:"email"`
		Password    string `json:"password"`
		DisplayName string `json:"display_name"`
		Type        string `json:"type"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Invalid request body"})
	}
	sys := domain.SystemPersonal
	if strings.EqualFold(req.Type, "CORPORATE") {
		sys = domain.SystemCorporate
	} else if req.Type != "" && !strings.EqualFold(req.Type, "PERSONAL") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid account type"})
	}
	req.Username = strings.TrimSpace(security.SanitizeHTML(req.Username))
	req.DisplayName = strings.TrimSpace(security.SanitizeHTML(req.DisplayName))
	req.Email = strings.ToLower(strings.TrimSpace(security.SanitizeHTML(req.Email)))
	if len(req.Username) < 3 || len(req.Username) > 64 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid username"})
	}
	parsedEmail, err := mail.ParseAddress(req.Email)
	if err != nil || parsedEmail.Address != req.Email {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid email format"})
	}
	if len(req.Password) < 8 || len(req.Password) > 128 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid password"})
	}
	user, token, err := h.service.Register(c.Context(), req.Username, req.Email, req.Password, c.IP(), c.Get("User-Agent"), sys)
	if err != nil {
		return c.Status(fiber.StatusConflict).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Unable to create account"})
	}
	// Keep the client-visible response consistent with the existing profile model.
	// Persistence of display_name remains a separate SQL/SQLC contract concern.
	user.DisplayName = req.DisplayName
	refreshToken, err := security.GenerateRefreshToken()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	if err := security.StoreRefreshTokenV2(c.Context(), h.rdb, user.ID, refreshToken, 30*24*time.Hour); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"user": user, "token": token, "refresh_token": refreshToken})
}

func (h *IdentityHandler) Login(c *fiber.Ctx) error {
	type request struct {
		Email       string `json:"email"`
		Password    string `json:"password"`
		DeviceID    string `json:"device_id"`
		Fingerprint string `json:"fingerprint"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Invalid request body"})
	}
	req.Email = strings.ToLower(strings.TrimSpace(security.SanitizeHTML(req.Email)))

	loginKey := "login:" + security.HashDeviceID(req.Email)
	allowed, err := security.RateLimitCheck(c.Context(), h.rdb, loginKey, 10, 15*time.Minute)
	if err != nil {
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "AUTH_LIMIT_UNAVAILABLE", "message": "Authentication service unavailable"})
	}
	if !allowed {
		return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"code": "AUTH_RATE_LIMITED", "message": "Too many authentication attempts"})
	}

	deviceID := strings.TrimSpace(req.DeviceID)
	if deviceID == "" {
		deviceID = strings.TrimSpace(req.Fingerprint)
	}
	user, token, mfaRequired, err := h.service.Login(c.Context(), req.Email, req.Password, deviceID, c.IP(), c.Get("User-Agent"))
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid credentials"})
	}
	if mfaRequired {
		c.Set(fiber.HeaderCacheControl, "no-store")
		return c.JSON(fiber.Map{"mfa_required": true, "user_id": user.ID})
	}
	refreshToken, err := security.GenerateRefreshToken()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	if err := security.StoreRefreshTokenV2(c.Context(), h.rdb, user.ID, refreshToken, 30*24*time.Hour); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{"user": user, "token": token, "refresh_token": refreshToken})
}

func (h *IdentityHandler) SetupMFA(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	secret, url, err := h.service.SetupMFA(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to configure MFA"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{"secret": secret, "url": url})
}

func (h *IdentityHandler) VerifyMFA(c *fiber.Ctx) error {
	type request struct {
		Code string `json:"code"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Invalid request"})
	}
	userID, _ := c.Locals("user_id").(string)
	if userID == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Authentication required"})
	}

	mfaKey := "mfa:" + security.HashDeviceID(userID)
	allowed, err := security.RateLimitCheck(c.Context(), h.rdb, mfaKey, 5, 10*time.Minute)
	if err != nil {
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "MFA_LIMIT_UNAVAILABLE", "message": "Authentication service unavailable"})
	}
	if !allowed {
		return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"code": "MFA_RATE_LIMITED", "message": "Too many MFA attempts"})
	}

	valid, err := h.service.VerifyMFA(c.Context(), userID, req.Code)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to verify MFA"})
	}
	if !valid {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid MFA code"})
	}
	return c.JSON(fiber.Map{"success": true})
}

func (h *IdentityHandler) Export(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	data, err := h.service.ExportData(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to export account data"})
	}
	return c.JSON(data)
}

func (h *IdentityHandler) Logout(c *fiber.Ctx) error {
	tokenID, _ := c.Locals("token_id").(string)
	expiration, _ := c.Locals("token_exp").(time.Time)
	if err := h.service.Logout(c.Context(), tokenID, expiration); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Failed to logout"})
	}
	return c.JSON(fiber.Map{"message": "Logged out successfully"})
}

func (h *IdentityHandler) Me(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	data, err := h.service.ExportData(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to load account"})
	}
	return c.JSON(data["user"])
}

func (h *IdentityHandler) RefreshToken(c *fiber.Ctx) error {
	type request struct {
		RefreshToken string `json:"refresh_token"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil || strings.TrimSpace(req.RefreshToken) == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Refresh token is required"})
	}
	token, newRefreshToken, err := h.service.RefreshToken(c.Context(), req.RefreshToken, c.IP(), c.Get("User-Agent"))
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid or expired refresh token"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{"token": token, "refresh_token": newRefreshToken})
}

func (h *IdentityHandler) PasskeyLogin(c *fiber.Ctx) error {
	return c.Status(fiber.StatusNotImplemented).JSON(fiber.Map{"code": "NOT_IMPLEMENTED", "message": "Passkey authentication is not enabled"})
}
