package security

import (
	"github.com/gofiber/fiber/v2"
)

func SecurityHeadersMiddleware() fiber.Handler {
	return func(c *fiber.Ctx) error {
		// Hardening headers
		c.Set("X-XSS-Protection", "1; mode=block")
		c.Set("X-Content-Type-Options", "nosniff")
		c.Set("X-Frame-Options", "DENY")
		c.Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload")
		c.Set("Content-Security-Policy", "default-src 'self'; script-src 'self'; object-src 'none'; base-uri 'none'; frame-ancestors 'none';")
		c.Set("Referrer-Policy", "strict-origin-when-cross-origin")
		c.Set("Permissions-Policy", "geolocation=(), camera=(), microphone=()")

		return c.Next()
	}
}
