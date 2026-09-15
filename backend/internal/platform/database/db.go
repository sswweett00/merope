package database

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/redis/go-redis/v9"
)

type EnterpriseDB struct {
	Pool  *pgxpool.Pool
	Redis *redis.Client
}

func NewEnterpriseDB(ctx context.Context, pgConnString string, redisAddr string) (*EnterpriseDB, error) {
	// Configure optimized pgx pool
	config, err := pgxpool.ParseConfig(pgConnString)
	if err != nil {
		return nil, fmt.Errorf("failed to parse pgx config: %w", err)
	}

	config.MaxConns = 50
	config.MinConns = 10
	config.MaxConnLifetime = 30 * time.Minute
	config.MaxConnIdleTime = 5 * time.Minute

	pool, err := pgxpool.NewWithConfig(ctx, config)
	if err != nil {
		return nil, fmt.Errorf("failed to create pgxpool: %w", err)
	}

	if err := pool.Ping(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping postgres: %w", err)
	}

	// Configure Redis Client
	rdb := redis.NewClient(&redis.Options{
			Addr:         redisAddr,
			Password:     "", // Set in production via env
			DB:           0,
			PoolSize:     100,
			MinIdleConns: 10,
	})

	if err := rdb.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("failed to connect to redis: %w", err)
	}

	return &EnterpriseDB{
		Pool:  pool,
		Redis: rdb,
	}, nil
}

func (db *EnterpriseDB) Close() {
	if db.Pool != nil {
		db.Pool.Close()
	}
	if db.Redis != nil {
		db.Redis.Close()
	}
}
