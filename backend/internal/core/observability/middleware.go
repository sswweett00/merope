package observability

import (
	"fmt"
	"strconv"
	"time"

	"github.com/gofiber/fiber/v2"
	"go.opentelemetry.io/otel/attribute"
)

func Middleware() fiber.Handler {
	return func(c *fiber.Ctx) error {
		start := time.Now()
		path := c.Path()
		method := c.Method()

		// Start Tracing Span
		ctx, span := Tracer.Start(c.Context(), fmt.Sprintf("%s %s", method, path))
		defer span.End()

		c.SetUserContext(ctx)

		// Process Request
		err := c.Next()

		// Record Metrics
		status := c.Response().StatusCode()
		duration := time.Since(start).Seconds()

		HttpRequestsTotal.WithLabelValues(method, path, strconv.Itoa(status)).Inc()
		HttpRequestDuration.WithLabelValues(method, path).Observe(duration)

		span.SetAttributes(
			attribute.String("http.method", method),
			attribute.String("http.path", path),
			attribute.Int("http.status", status),
		)

		return err
	}
}

// fmt was missing in the tracing.go so I will fix it in the next step if needed,
// but wait, I used fmt in tracing.go? No, I used it in Middleware.go.
// Ah, I see I forgot to import fmt in Middleware.go
