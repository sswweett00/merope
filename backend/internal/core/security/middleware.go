package security

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
)

func AuthMiddleware(secret string, rdb *redis.Client) fiber.Handler {
	return func(c *fiber.Ctx) error {
		authHeader := strings.TrimSpace(c.Get("Authorization"))
		parts := strings.Fields(authHeader)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": "UNAUTHORIZED", "message": "authentication required"})
		}

		claims, err := ValidateToken(parts[1], secret)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": "UNAUTHORIZED", "message": "invalid or expired token"})
		}

		if rdb == nil || IsTokenBlacklisted(c.Context(), rdb, claims.ID) {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": "SESSION_REVOKED", "message": "session is no longer valid"})
		}

		// Fingerprints are defense-in-depth only. IP changes are common on mobile
		// networks, so an absent legacy fingerprint does not invalidate a session.
		if claims.Fingerprint != "" {
			currentFingerprint := GenerateFingerprint(c.IP(), c.Get("User-Agent"))
			if claims.Fingerprint != currentFingerprint {
				return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code": "SESSION_MISMATCH", "message": "session binding mismatch"})
			}
		}

		c.Locals("user_id", claims.UserID)
		c.Locals("role", claims.Role)
		c.Locals("token_id", claims.ID)
		c.Locals("token_exp", claims.ExpiresAt.Time)
		c.Locals("fingerprint", claims.Fingerprint)
		c.Locals("permissions", claims.Permissions)
		return c.Next()
	}
}

func GenerateAetherSignature(payload, deviceSecret string) string {
	h := hmac.New(sha256.New, []byte(deviceSecret))
	_, _ = h.Write([]byte(payload))
	return hex.EncodeToString(h.Sum(nil))
}

func RBACMiddleware(enforcer *Enforcer) fiber.Handler {
	return func(c *fiber.Ctx) error {
		role, _ := c.Locals("role").(string)
		if role == "" {
			role = "anonymous"
		}

		allowed, err := enforcer.CheckPermission(role, c.Path(), c.Method())
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": "AUTHZ_ERROR", "message": "authorization service unavailable"})
		}
		if !allowed {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"code": "FORBIDDEN", "message": "access denied"})
		}
		return c.Next()
	}
}
