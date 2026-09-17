package middleware

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

const maxRequestIDLength = 128

// RequestID ensures every request has a bounded, propagation-safe correlation id.
// Caller supplied ids are accepted only when they contain a conservative ASCII
// character set, preventing log/control-character injection.
func RequestID() fiber.Handler {
	return func(c *fiber.Ctx) error {
		requestID := strings.TrimSpace(c.Get("X-Request-ID"))
		if !validRequestID(requestID) {
			requestID = uuid.NewString()
		}

		c.Locals("request_id", requestID)
		c.Set("X-Request-ID", requestID)
		return c.Next()
	}
}

func GetRequestID(c *fiber.Ctx) string {
	if c == nil {
		return ""
	}
	requestID, _ := c.Locals("request_id").(string)
	return requestID
}

func validRequestID(value string) bool {
	if value == "" || len(value) > maxRequestIDLength {
		return false
	}
	for _, r := range value {
		switch {
		case r >= 'a' && r <= 'z':
		case r >= 'A' && r <= 'Z':
		case r >= '0' && r <= '9':
		case r == '-' || r == '_' || r == '.' || r == ':' || r == '/':
		default:
			return false
		}
	}
	return true
}
