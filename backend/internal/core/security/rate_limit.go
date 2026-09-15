package security

import (
	"time"

	"local/merope/internal/core/middleware"
	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
)

func RateLimitMiddleware(rdb *redis.Client, max int, expiration time.Duration, keyPrefix string) fiber.Handler {
	limiter := middleware.NewRedisRateLimiter(rdb, max, expiration)
	return limiter.RateLimit(keyPrefix)
}

// GlobalLimit for general API access
func GlobalLimit(rdb *redis.Client) fiber.Handler {
	return RateLimitMiddleware(rdb, 60, 1*time.Minute, "ratelimit:global")
}

// AuthLimit for sensitive auth endpoints
func AuthLimit(rdb *redis.Client) fiber.Handler {
	return RateLimitMiddleware(rdb, 5, 1*time.Minute, "ratelimit:auth")
}
