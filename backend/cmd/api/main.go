package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"local/merope/internal/core/config"
	"local/merope/internal/core/wiring"
)

func main() {
	// Root context for the entire application lifetime
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	cfg := config.Load(ctx)

	// Build the application graph using manual DI
	app, resources, _, cleanup := wiring.BuildApp(ctx, cfg)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Start server in a goroutine
	go func() {
		log.Printf("Merope API starting on port %s", port)
		if err := app.Listen(":" + port); err != nil {
			log.Printf("Fiber server stopped: %v", err)
		}
	}()

	// Orchestrate Graceful Shutdown
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	<-stop
	log.Println("Graceful shutdown signal received...")

	// 1. Give the server a timeout to drain active connections
	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()

	if err := app.ShutdownWithContext(shutdownCtx); err != nil {
		log.Printf("Forced shutdown due to error: %v", err)
	} else {
		log.Println("Fiber server shut down gracefully.")
	}

	// 2. Run cleanup for database connections, pools, and workers
	log.Println("Cleaning up resources (DB, NATS, Workers)...")
	cleanup()

	log.Println("Merope API shutdown complete. Farewell.")
}
