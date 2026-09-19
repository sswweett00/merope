package security

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
)

func AuthMiddleware(secret string, rdb *redis.Client) fiber.Handler {
	return func(c *fiber.Ctx) error {
		auth := c.Get("Authorization")
		if !strings.HasPrefix(auth, "Bearer ") {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		claims, err := ValidateToken(strings.TrimSpace(strings.TrimPrefix(auth, "Bearer ")), secret)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		blacklisted, blacklistErr := CheckTokenBlacklist(c.Context(), rdb, claims.ID)
		if blacklistErr != nil {
			return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"error": "Authentication state unavailable"})
		}
		if blacklisted {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}
		if claims.Fingerprint != "" && GenerateFingerprint(c.IP(), c.Get("User-Agent")) != claims.Fingerprint {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
		}

		c.Locals("user_id", claims.UserID)
		c.Locals("role", claims.Role)
		c.Locals("token_id", claims.ID)
		if claims.ExpiresAt != nil {
			c.Locals("token_exp", claims.ExpiresAt.Time)
		}
		c.Locals("fingerprint", claims.Fingerprint)
		c.Locals("permissions", claims.Permissions)
		return c.Next()
	}
}

func RBACMiddleware(enforcer *Enforcer) fiber.Handler {
	return func(c *fiber.Ctx) error {
		if enforcer == nil {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "Forbidden"})
		}
		role, _ := c.Locals("role").(string)
		allowed, err := enforcer.CheckPermission(role, c.Path(), c.Method())
		if err != nil || !allowed {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "Forbidden"})
		}
		return c.Next()
	}
}
