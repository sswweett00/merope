package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"sync/atomic"
	"time"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/core/config"
	"local/merope/internal/core/wiring"
)

func main() {
	var ready atomic.Bool
	ready.Store(true)

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGINT, syscall.SIGTERM)
	defer cancel()

	cfg := config.Load(ctx)
	app, resources, _, cleanup := wiring.BuildApp(ctx, cfg)
	defer cleanup()

	if err := wiring.RegisterStoriesRoutes(app, cfg, resources.PostgresPool, resources.Redis); err != nil {
		log.Fatalf("failed to register stories routes: %v", err)
	}

	app.Get("/health/live", func(c *fiber.Ctx) error {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{"status": "ok"})
	})

	app.Get("/health/ready", func(c *fiber.Ctx) error {
		if !ready.Load() {
			return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"status": "draining"})
		}

		checkCtx, cancel := context.WithTimeout(c.Context(), 2*time.Second)
		defer cancel()

		checks := fiber.Map{"postgres": "ok", "redis": "ok", "nats": "ok"}
		if resources.PostgresPool == nil || resources.PostgresPool.Ping(checkCtx) != nil {
			checks["postgres"] = "unavailable"
		}
		if resources.Redis == nil || resources.Redis.Conn.Ping(checkCtx).Err() != nil {
			checks["redis"] = "unavailable"
		}
		if resources.NATS == nil || resources.NATS.Conn == nil || !resources.NATS.Conn.IsConnected() {
			checks["nats"] = "unavailable"
		}

		ready := checks["postgres"] == "ok" && checks["redis"] == "ok" && checks["nats"] == "ok"
		status := fiber.StatusOK
		readiness := "ready"
		if !ready {
			status = fiber.StatusServiceUnavailable
			readiness = "degraded"
		}
		return c.Status(status).JSON(fiber.Map{"status": readiness, "checks": checks})
	})

	serverErr := make(chan error, 1)
	go func() {
		log.Printf("Merope API starting on port %d", cfg.Port)
		serverErr <- app.Listen(":" + fmt.Sprint(cfg.Port))
	}()

	select {
	case err := <-serverErr:
		if err != nil {
			log.Fatalf("API server stopped unexpectedly: %v", err)
		}
	case <-ctx.Done():
		// Stop advertising readiness before beginning graceful shutdown so a
		// load balancer can drain this instance instead of sending new work to it.
		ready.Store(false)

		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
		defer shutdownCancel()
		if err := app.ShutdownWithContext(shutdownCtx); err != nil {
			log.Printf("forced API shutdown: %v", err)
		}
	}
}
