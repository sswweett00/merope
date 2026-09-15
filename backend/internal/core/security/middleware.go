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
		authHeader := c.Get("Authorization")
		if authHeader == "" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Missing authorization header"})
		}

		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Invalid authorization format"})
		}

		claims, err := ValidateToken(parts[1], secret)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Invalid or expired token"})
		}

		// Check Blacklist
		if IsTokenBlacklisted(c.Context(), rdb, claims.ID) {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Session revoked"})
		}

		// Store claims in locals for downstream handlers
		c.Locals("user_id", claims.UserID)
		c.Locals("role", claims.Role)
		c.Locals("token_id", claims.ID)
		c.Locals("token_exp", claims.ExpiresAt.Time)
		c.Locals("fingerprint", claims.Fingerprint)

		// Security: Validate Fingerprint against current request
		currentFingerprint := GenerateFingerprint(c.IP(), c.Get("User-Agent"))
		if claims.Fingerprint != currentFingerprint {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Session mismatch"})
		}

		// Enterprise Refinement: Enforce Device Signature Handshake (Aether Token Binding)
		deviceSig := c.Get("X-Merope-Device-Sig")
		aetherSig := c.Get("X-Aether-Signature")

		if deviceSig == "" || aetherSig == "" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Aether handshake required (Device/Aether Sig missing)"})
		}

		// Verify Aether Signature against Authorization header
		// In production, fetch the device_secret for this (user_id, device_id)
		// For now, we verify the binding integrity (Simulated Zenith Check)
		expectedAetherSig := GenerateAetherSignature(authHeader, deviceSig)
		if aetherSig != expectedAetherSig {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Aether signature mismatch - Session Hijacking attempt detected"})
		}

		return c.Next()
	}
}

// GenerateAetherSignature creates a device-bound HMAC signature for token binding.
func GenerateAetherSignature(payload, deviceSecret string) string {
	h := hmac.New(sha256.New, []byte(deviceSecret))
	h.Write([]byte(payload))
	return hex.EncodeToString(h.Sum(nil))
}

func RBACMiddleware(enforcer *Enforcer) fiber.Handler {
	return func(c *fiber.Ctx) error {
		role, ok := c.Locals("role").(string)
		if !ok {
			role = "anonymous"
		}

		path := c.Path()
		method := c.Method()

		allowed, err := enforcer.CheckPermission(role, path, method)
		if err != nil || !allowed {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
				"error": "Access denied by security policy",
			})
		}

		return c.Next()
	}
}
