package security

import (
	"crypto/rand"
	"encoding/hex"
	"strings"

	"github.com/gofiber/fiber/v2"
)

const requestIDHeader = "X-Request-ID"

func newRequestID() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		return ""
	}
	return hex.EncodeToString(b[:])
}

// HTTPHardeningMiddleware applies protocol-level defenses that do not depend
// on business authorization: bounded request bodies, request IDs, cache
// controls for authentication, and a conservative cross-origin policy.
func HTTPHardeningMiddleware() fiber.Handler {
	return func(c *fiber.Ctx) error {
		if c.Method() == fiber.MethodTrace || c.Method() == fiber.MethodConnect {
			return c.SendStatus(fiber.StatusMethodNotAllowed)
		}

		if requestID := strings.TrimSpace(c.Get(requestIDHeader)); requestID != "" && len(requestID) <= 128 {
			c.Set(requestIDHeader, requestID)
		} else if generated := newRequestID(); generated != "" {
			c.Set(requestIDHeader, generated)
		}

		if c.Is("application/json") && c.Request().Header.ContentLength() > 4*1024*1024 {
			return c.Status(fiber.StatusRequestEntityTooLarge).JSON(fiber.Map{"code": "request_too_large", "message": "Request body is too large"})
		}

		path := c.Path()
		if strings.HasPrefix(path, "/api/v10/auth/") || path == "/api/v10/auth" {
			c.Set(fiber.HeaderCacheControl, "no-store, no-cache, must-revalidate")
			c.Set(fiber.HeaderPragma, "no-cache")
		}

		c.Set("X-DNS-Prefetch-Control", "off")
		c.Set("Cross-Origin-Opener-Policy", "same-origin")
		c.Set("Cross-Origin-Resource-Policy", "same-origin")
		c.Set("Origin-Agent-Cluster", "?1")
		c.Set("Referrer-Policy", "strict-origin-when-cross-origin")
		c.Set("Permissions-Policy", "camera=(), microphone=(), geolocation=(), usb=(), payment=()")
		return c.Next()
	}
}
