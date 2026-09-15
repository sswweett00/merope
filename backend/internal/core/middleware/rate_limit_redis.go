package middleware

import (
	"fmt"
	"strings"
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

type RedisRateLimiter struct { rdb *redis.Client; maxRequests int; window time.Duration; script *redis.Script }

func NewRedisRateLimiter(rdb *redis.Client, maxRequests int, window time.Duration) *RedisRateLimiter {
	return &RedisRateLimiter{rdb: rdb, maxRequests: maxRequests, window: window, script: redis.NewScript(slidingWindowLua)}
}

func (rl *RedisRateLimiter) RateLimit(keyPrefix string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ip := c.IP()
		if forwarded := c.Get("X-Forwarded-For"); forwarded != "" { ip = strings.Split(forwarded, ",")[0] }
		userID := ""
		role := "guest"
		if uid := c.Locals("user_id"); uid != nil { userID, _ = uid.(string) }
		if r := c.Locals("user_role"); r != nil { role, _ = r.(string) }
		limit := rl.maxRequests
		if role == "verified" { limit *= 5 } else if role == "admin" { return c.Next() }
		key := fmt.Sprintf("rl:ip:%s:%s", keyPrefix, ip)
		if userID != "" { key = fmt.Sprintf("rl:user:%s:%s", keyPrefix, userID) }
		now := time.Now().UnixNano() / int64(time.Millisecond)
		member := fmt.Sprintf("%d:%s", now, util.NewShortID())
		res, err := rl.script.Run(c.Context(), rl.rdb, []string{key}, now, rl.window.Milliseconds(), limit, member).Result()
		if err != nil { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Rate limit failure"}) }
		parts, ok := res.([]interface{}); if !ok || len(parts) != 2 { return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Rate limit failure"}) }
		blocked := parts[0].(int64) == 1
		remaining := int64(limit) - parts[1].(int64)
		if remaining < 0 { remaining = 0 }
		c.Set("X-RateLimit-Limit", fmt.Sprintf("%d", limit)); c.Set("X-RateLimit-Remaining", fmt.Sprintf("%d", remaining))
		if blocked { return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"error": "Merope: Rate limit exceeded. Please wait.", "retry_after": fmt.Sprintf("%ds", int(rl.window/time.Second))}) }
		return c.Next()
	}
}
