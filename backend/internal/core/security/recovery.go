package security

import (
	"log/slog"
	"runtime/debug"

	"github.com/gofiber/fiber/v2"
)

func RecoverMiddleware() fiber.Handler {
	return func(c *fiber.Ctx) error {
		defer func() {
			if r := recover(); r != nil {
				slog.Error("panic recovered", "error", r, "stack", string(debug.Stack()))
				_ = c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"error": "Internal server error occurred",
				})
			}
		}()
		return c.Next()
	}
}
