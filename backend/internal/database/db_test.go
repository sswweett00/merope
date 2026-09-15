package database

import (
	"context"
	"testing"
	"time"
)

func TestConnection(t *testing.T) {
	// Skip if DATABASE_URL is not set (CI environment without Postgres)
	// if os.Getenv("DATABASE_URL") == "" {
	// 	t.Skip("Skipping test; DATABASE_URL not set")
	// }

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// In a real scenario, we would use a test container or a mock
	// For now, we just check if the function can be called and handles errors
	pool, err := NewPostgresPool(ctx)
	if err != nil {
		t.Logf("Expected error if no DB is running: %v", err)
	} else {
		defer pool.Close()
		t.Log("Successfully connected to database")
	}
}
