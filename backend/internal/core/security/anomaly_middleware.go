package security

import (
	"context"

	"github.com/gofiber/fiber/v2"
)

func AnomalyDetectorMiddleware(detector AnomalyDetector) fiber.Handler {
	return func(c *fiber.Ctx) error {
		userID := ""
		if uid := c.Locals("user_id"); uid != nil {
			userID = uid.(string)
		}

		payload := c.Body()
		if len(payload) > 0 {
			suspicious, reason := detector.AnalyzePayload(c.Context(), userID, string(payload))
			if suspicious {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"error": "Suspicious request detected: " + reason,
				})
			}
		}

		return c.Next()
	}
}

func ValidateRequest(requiredFields ...string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var body map[string]interface{}
		if err := c.BodyParser(&body); err == nil {
			for _, field := range requiredFields {
				val, ok := body[field]
				if !ok || val == nil || val == "" {
					return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
						"error": "Missing required field: " + field,
						"code":  "VALIDATION_ERROR",
					})
				}
			}
		}
		return c.Next()
	}
}
