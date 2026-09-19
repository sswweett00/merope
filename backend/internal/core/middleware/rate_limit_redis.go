package middleware

import (
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"

	"local/merope/internal/core/util"
)

const slidingWindowLua = `
local key = KEYS[1]
local now = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local limit = tonumber(ARGV[3])
local member = ARGV[4]
redis.call('ZREMRANGEBYSCORE', key, 0, now - window)
local count = redis.call('ZCARD', key)
if count < limit then
    redis.call('ZADD', key, now, member)
    redis.call('EXPIRE', key, math.ceil(window / 1000) + 1)
    return {0, count + 1}
else
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
	return &RedisRateLimiter{rdb: rdb, maxRequests: maxRequests, window: window, script: redis.NewScript(slidingWindowLua)}
}

func (rl *RedisRateLimiter) RateLimit(keyPrefix string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		if rl.rdb == nil {
			return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{"code": "RATE_LIMIT_UNAVAILABLE", "message": "rate limiting service unavailable"})
		}

		ip := c.IP()
		userID, _ := c.Locals("user_id").(string)
		role, _ := c.Locals("role").(string)
		limit := rl.maxRequests
		switch role {
		case "verified":
			limit *= 5
		case "admin":
			limit *= 2
		}

		key := fmt.Sprintf("rl:ip:%s:%s", keyPrefix, ip)
		if userID != "" {
			key = fmt.Sprintf("rl:user:%s:%s", keyPrefix, userID)
		}
		now := time.Now().UnixMilli()
		member := fmt.Sprintf("%d:%s", now, util.NewShortID())
		res, err := rl.script.Run(c.Context(), rl.rdb, []string{key}, now, rl.window.Milliseconds(), limit, member).Result()
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": "RATE_LIMIT_FAILURE", "message": "rate limit check failed"})
		}
		parts, ok := res.([]interface{})
		if !ok || len(parts) != 2 {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": "RATE_LIMIT_FAILURE", "message": "rate limit check failed"})
		}
		blocked, ok := parts[0].(int64)
		if !ok {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": "RATE_LIMIT_FAILURE", "message": "rate limit check failed"})
		}
		count, ok := parts[1].(int64)
		if !ok {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": "RATE_LIMIT_FAILURE", "message": "rate limit check failed"})
		}
		remaining := int64(limit) - count
		if remaining < 0 {
			remaining = 0
		}
		c.Set("X-RateLimit-Limit", fmt.Sprintf("%d", limit))
		c.Set("X-RateLimit-Remaining", fmt.Sprintf("%d", remaining))
		if blocked == 1 {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"code":        "RATE_LIMITED",
				"message":     "rate limit exceeded",
				"retry_after": int(rl.window / time.Second),
			})
		}
		return c.Next()
	}
}
