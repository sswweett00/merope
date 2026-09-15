package middleware

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
	"local/merope/internal/core/util"
)

// Professional Sliding Window Rate Limiter using Redis Sorted Sets
const slidingWindowLua = `
local key = KEYS[1]
local now = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local limit = tonumber(ARGV[3])
local member = ARGV[4]

-- Remove timestamps outside the sliding window
redis.call('ZREMRANGEBYSCORE', key, 0, now - window)

-- Count remaining requests in the window
local count = redis.call('ZCARD', key)

if count < limit then
    -- Add current request timestamp
    redis.call('ZADD', key, now, member)
    -- Set TTL to the window duration to clean up idle keys
    redis.call('EXPIRE', key, math.ceil(window / 1000) + 1)
    return {0, count + 1}
else
    -- Limit exceeded
    return {1, count}
end
`

type RedisRateLimiter struct {
	rdb         *redis.Client
	maxRequests int
	window      time.Duration
	script      *redis.Script
}

func NewRedisRateLimiter(rdb *redis.Client, maxRequests int, window time.Duration) *RedisRateLimiter {
	return &RedisRateLimiter{
		rdb:         rdb,
		maxRequests: maxRequests,
		window:      window,
		script:      redis.NewScript(slidingWindowLua),
	}
}

// RateLimit provides a distributed sliding window rate limiting middleware
func (rl *RedisRateLimiter) RateLimit(keyPrefix string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ip := c.IP()
		if forwarded := c.Get("X-Forwarded-For"); forwarded != "" {
			ip = strings.Split(forwarded, ",")[0]
		}

		userID := ""
		role := "guest"
		if uid := c.Locals("user_id"); uid != nil {
			userID = uid.(string)
		}
		if r := c.Locals("user_role"); r != nil {
			role = r.(string)
		}

		// Tiered Rate Limiting logic
		limit := rl.maxRequests
		if role == "verified" {
			limit *= 5 // Verified users get 5x more throughput
		} else if role == "admin" {
			return c.Next() // Admins are not rate-limited
		}

		var key string
		if userID != "" {
			key = fmt.Sprintf("rl:user:%s:%s", keyPrefix, userID)
		} else {
			key = fmt.Sprintf("rl:ip:%s:%s", keyPrefix, ip)
		}

		now := time.Now().UnixNano() / int64(time.Millisecond)
		windowMs := rl.window.Milliseconds()

		// Unique member for ZADD to ensure multiple requests at the same MS don't overwrite
		member := fmt.Sprintf("%d:%s", now, util.NewShortID())

		res, err := rl.script.Run(c.Context(), rl.rdb, []string{key}, now, windowMs, limit, member).Result()
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Rate limit failure"})
		}

		parts := res.([]interface{})
		blocked := parts[0].(int64) == 1
		remaining := int64(limit) - parts[1].(int64)

		c.Set("X-RateLimit-Limit", fmt.Sprintf("%d", limit))
		c.Set("X-RateLimit-Remaining", fmt.Sprintf("%d", remaining))

		if blocked {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error": "Merope: Rate limit exceeded. Please wait.",
				"retry_after": fmt.Sprintf("%ds", rl.window/time.Second),
			})
		}

		return c.Next()
	}
}
