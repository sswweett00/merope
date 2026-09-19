package tenant

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
)

type Tenant struct {
	ID   string
	Name string
}

func Middleware(queries *db.Queries) fiber.Handler {
	return func(c *fiber.Ctx) error {
		domain := c.Hostname()

		// In a real scenario, this would be cached in Redis
		t, err := queries.GetTenantByDomain(c.Context(), domain)
		if err != nil {
			// Fallback to default tenant or error
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "Tenant not found for domain: " + domain})
		}

		c.Locals("tenant_id", util.UUIDToString(t.ID))
		return c.Next()
	}
}

func FromContext(c *fiber.Ctx) (pgtype.UUID, error) {
	var uid pgtype.UUID
	tid, ok := c.Locals("tenant_id").(string)
	if !ok {
		return uid, fmt.Errorf("tenant_id not found in context")
	}
	err := uid.Scan(tid)
	return uid, err
}
