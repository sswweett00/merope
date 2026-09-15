package transport

import (
	"context"
	"encoding/json"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
	"local/merope/internal/core/errors"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/identity/domain"
)

type preAuthChallenge struct {
	UserID      string `json:"user_id"`
	Fingerprint string `json:"fingerprint"`
}

type PreAuthMFAHandler struct {
	service   domain.IdentityService
	jwtSecret string
	rdb       *redis.Client
}

func NewPreAuthMFAHandler(service domain.IdentityService, jwtSecret string, rdb *redis.Client) *PreAuthMFAHandler {
	return &PreAuthMFAHandler{service: service, jwtSecret: jwtSecret, rdb: rdb}
}

func (h *PreAuthMFAHandler) Login(c *fiber.Ctx) error {
	type request struct {
		Email       string `json:"email"`
		Password    string `json:"password"`
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

	user, token, mfaRequired, err := h.service.Login(c.Context(), req.Email, req.Password, req.Fingerprint, c.IP(), c.Get("User-Agent"))
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid credentials"})
	}
	if !mfaRequired {
		refreshToken, err := security.GenerateRefreshToken()
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
		}
		if err := security.StoreRefreshTokenV2(c.Context(), h.rdb, user.ID, refreshToken, 30*24*time.Hour); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
		}
		c.Set(fiber.HeaderCacheControl, "no-store")
		return c.JSON(fiber.Map{"user": user, "token": token, "refresh_token": refreshToken, "expires_in": 900})
	}

	challengeID, err := security.GenerateRefreshToken()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish MFA challenge"})
	}
	payload, err := json.Marshal(preAuthChallenge{UserID: user.ID, Fingerprint: req.Fingerprint})
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish MFA challenge"})
	}
	key := "mfa:challenge:" + security.HashDeviceID(challengeID)
	if err := h.rdb.Set(c.Context(), key, payload, 5*time.Minute).Err(); err != nil {
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "MFA_CHALLENGE_UNAVAILABLE", "message": "Authentication service unavailable"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{
		"requires_mfa":       true,
		"mfa_required":       true,
		"user_id":            user.ID,
		"challenge_id":        challengeID,
		"mfa_method":          "totp",
		"expires_in_seconds": 300,
	})
}

func (h *PreAuthMFAHandler) Verify(c *fiber.Ctx) error {
	type request struct {
		ChallengeID string `json:"challenge_id"`
		Code        string `json:"code"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil || strings.TrimSpace(req.ChallengeID) == "" || strings.TrimSpace(req.Code) == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Challenge and code are required"})
	}

	key := "mfa:challenge:" + security.HashDeviceID(strings.TrimSpace(req.ChallengeID))
	raw, err := h.rdb.Get(c.Context(), key).Bytes()
	if err != nil {
		if err == redis.Nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid or expired MFA challenge"})
		}
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "MFA_CHALLENGE_UNAVAILABLE", "message": "Authentication service unavailable"})
	}

	var challenge preAuthChallenge
	if err := json.Unmarshal(raw, &challenge); err != nil || challenge.UserID == "" {
		_ = h.rdb.Del(context.Background(), key).Err()
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid or expired MFA challenge"})
	}

	allowed, err := security.RateLimitCheck(c.Context(), h.rdb, "mfa:user:"+security.HashDeviceID(challenge.UserID), 5, 10*time.Minute)
	if err != nil {
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "MFA_LIMIT_UNAVAILABLE", "message": "Authentication service unavailable"})
	}
	if !allowed {
		return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"code": "MFA_RATE_LIMITED", "message": "Too many MFA attempts"})
	}

	valid, err := h.service.VerifyMFA(c.Context(), challenge.UserID, strings.TrimSpace(req.Code))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to verify MFA"})
	}
	if !valid {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": errors.ErrAuthFailed, "message": "Invalid MFA code"})
	}
	if err := h.rdb.Del(c.Context(), key).Err(); err != nil {
		return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "MFA_CHALLENGE_UNAVAILABLE", "message": "Authentication service unavailable"})
	}

	token, err := security.GenerateToken(challenge.UserID, "user", challenge.Fingerprint, h.jwtSecret)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	refreshToken, err := security.GenerateRefreshToken()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}
	if err := security.StoreRefreshTokenV2(c.Context(), h.rdb, challenge.UserID, refreshToken, 30*24*time.Hour); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to establish session"})
	}

	data, err := h.service.ExportData(c.Context(), challenge.UserID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to load account"})
	}
	c.Set(fiber.HeaderCacheControl, "no-store")
	return c.JSON(fiber.Map{
		"success":       true,
		"user":          data["user"],
		"token":         token,
		"refresh_token": refreshToken,
		"expires_in":    900,
	})
}
