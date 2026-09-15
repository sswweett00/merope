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

func validRequestID(value string) bool {
	if len(value) != 32 {
		return false
	}
	for _, r := range value {
		if !((r >= '0' && r <= '9') || (r >= 'a' && r <= 'f') || (r >= 'A' && r <= 'F')) {
			return false
		}
	}
	return true
}

func HTTPHardeningMiddleware() fiber.Handler {
	return func(c *fiber.Ctx) error {
		if c.Method() == fiber.MethodTrace || c.Method() == fiber.MethodConnect {
			return c.SendStatus(fiber.StatusMethodNotAllowed)
		}

		requestID := strings.TrimSpace(c.Get(requestIDHeader))
		if validRequestID(requestID) {
			c.Set(requestIDHeader, strings.ToLower(requestID))
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
		c.Set("Referrer-Policy", "no-referrer")
		c.Set("Permissions-Policy", "camera=(), microphone=(), geolocation=(), usb=(), payment=()")
		return c.Next()
	}
}
