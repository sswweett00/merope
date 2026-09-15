package database

import (
	"context"
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

func NewPostgresPool(ctx context.Context) (*pgxpool.Pool, error) {
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		return nil, fmt.Errorf("DATABASE_URL environment variable is required")
	}

	cfg, err := pgxpool.ParseConfig(connStr)
	if err != nil {
		return nil, fmt.Errorf("invalid DATABASE_URL: %w", err)
	}

	cfg.MaxConns = envInt32("DATABASE_MAX_CONNS", 50)
	cfg.MinConns = envInt32("DATABASE_MIN_CONNS", 5)
	cfg.MaxConnLifetime = envDuration("DATABASE_MAX_CONN_LIFETIME", 30*time.Minute)
	cfg.MaxConnIdleTime = envDuration("DATABASE_MAX_CONN_IDLE_TIME", 5*time.Minute)
	cfg.HealthCheckPeriod = envDuration("DATABASE_HEALTH_CHECK_PERIOD", 30*time.Second)

	if cfg.MinConns < 0 || cfg.MaxConns < 1 || cfg.MinConns > cfg.MaxConns {
		return nil, fmt.Errorf("invalid database pool sizing: min=%d max=%d", cfg.MinConns, cfg.MaxConns)
	}

	pool, err := pgxpool.NewWithConfig(ctx, cfg)
	if err != nil {
		return nil, fmt.Errorf("unable to create connection pool: %w", err)
	}

	pingCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := pool.Ping(pingCtx); err != nil {
		pool.Close()
		return nil, fmt.Errorf("unable to ping database: %w", err)
	}

	return pool, nil
}

func envInt32(name string, fallback int32) int32 {
	value := os.Getenv(name)
	if value == "" {
		return fallback
	}
	parsed, err := strconv.ParseInt(value, 10, 32)
	if err != nil || parsed < 0 {
		return fallback
	}
	return int32(parsed)
}

func envDuration(name string, fallback time.Duration) time.Duration {
	value := os.Getenv(name)
	if value == "" {
		return fallback
	}
	parsed, err := time.ParseDuration(value)
	if err != nil || parsed <= 0 {
		return fallback
	}
	return parsed
}
