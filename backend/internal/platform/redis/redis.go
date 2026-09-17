package redis

import (
	"os"
	"strconv"
	"time"

	"github.com/redis/go-redis/v9"
)

type Client struct {
	Conn *redis.Client
}

func New(addr, password string) *Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:            addr,
		Password:        password,
		DB:              0,
		PoolSize:        envInt("REDIS_POOL_SIZE", 64),
		MinIdleConns:    envInt("REDIS_MIN_IDLE_CONNS", 8),
		PoolTimeout:     envDuration("REDIS_POOL_TIMEOUT", 2*time.Second),
		DialTimeout:     envDuration("REDIS_DIAL_TIMEOUT", 3*time.Second),
		ReadTimeout:     envDuration("REDIS_READ_TIMEOUT", 2*time.Second),
		WriteTimeout:    envDuration("REDIS_WRITE_TIMEOUT", 2*time.Second),
		MaxRetries:      2,
		MinRetryBackoff: 50 * time.Millisecond,
		MaxRetryBackoff: 250 * time.Millisecond,
	})
	return &Client{Conn: rdb}
}

func (c *Client) Close() error {
	return c.Conn.Close()
}

func envInt(name string, fallback int) int {
	value := os.Getenv(name)
	if value == "" {
		return fallback
	}
	parsed, err := strconv.Atoi(value)
	if err != nil || parsed <= 0 {
		return fallback
	}
	return parsed
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
