package middleware

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/redis/go-redis/v9"
)

const (
	idempotencyKeyHeader = "Idempotency-Key"
	idempotencyTTL       = 24 * time.Hour
	idempotencyLockTTL   = 120 * time.Second
	maxIdempotencyKeyLen = 128
	maxStoredBodyBytes   = 512 * 1024
)

var releaseIdempotencyLock = redis.NewScript(`
if redis.call("GET", KEYS[1]) == ARGV[1] then
  return redis.call("DEL", KEYS[1])
end
return 0
`)

type storedIdempotentResponse struct {
	RequestHash string `json:"request_hash"`
	Status      int    `json:"status"`
	ContentType string `json:"content_type"`
	Body        []byte `json:"body"`
}

// Idempotency provides optional replay protection for authenticated mutations.
// Requests without Idempotency-Key are intentionally left untouched for backwards
// compatibility. Redis is used only as coordination/cache state; authoritative
// application data remains in PostgreSQL.
func Idempotency(rdb *redis.Client, ttl time.Duration) fiber.Handler {
	if ttl <= 0 {
		ttl = idempotencyTTL
	}

	return func(c *fiber.Ctx) error {
		if rdb == nil || isSafeMethod(c.Method()) {
			return c.Next()
		}

		key := strings.TrimSpace(c.Get(idempotencyKeyHeader))
		if key == "" {
			return c.Next()
		}
		if len(key) > maxIdempotencyKeyLen || !validIdempotencyKey(key) {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"code":    "IDEMPOTENCY_KEY_INVALID",
				"message": "Invalid Idempotency-Key",
			})
		}

		userID, _ := c.Locals("user_id").(string)
		if userID == "" {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"code":    "ERR_UNAUTHORIZED",
				"message": "Authentication required",
			})
		}

		body := c.Body()
		requestDigest := sha256.Sum256(body)
		requestHash := hex.EncodeToString(requestDigest[:])
		resourceDigest := sha256.Sum256([]byte(userID + "\x00" + c.Method() + "\x00" + c.Path() + "\x00" + key))
		resourceID := hex.EncodeToString(resourceDigest[:])
		responseKey := "idempotency:v1:" + resourceID
		lockKey := responseKey + ":lock"

		stored, err := rdb.Get(c.Context(), responseKey).Bytes()
		if err == nil {
			var replay storedIdempotentResponse
			if json.Unmarshal(stored, &replay) != nil || replay.RequestHash == "" {
				return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{
					"code":    "IDEMPOTENCY_STATE_INVALID",
					"message": "Idempotency service unavailable",
				})
			}
			if replay.RequestHash != requestHash {
				return c.Status(fiber.StatusConflict).JSON(fiber.Map{
					"code":    "IDEMPOTENCY_KEY_REUSED",
					"message": "Idempotency-Key was already used with a different request",
				})
			}
			if replay.ContentType != "" {
				c.Set("Content-Type", replay.ContentType)
			}
			c.Set("X-Idempotency-Replayed", "true")
			return c.Status(replay.Status).Send(replay.Body)
		}
		if err != redis.Nil {
			return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{
				"code":    "IDEMPOTENCY_UNAVAILABLE",
				"message": "Idempotency service unavailable",
			})
		}

		lockToken := uuid.NewString()
		acquired, err := rdb.SetNX(c.Context(), lockKey, lockToken, idempotencyLockTTL).Result()
		if err != nil {
			return c.Status(fiber.StatusServiceUnavailable).JSON(fiber.Map{
				"code":    "IDEMPOTENCY_UNAVAILABLE",
				"message": "Idempotency service unavailable",
			})
		}
		if !acquired {
			c.Set("Retry-After", "1")
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{
				"code":    "IDEMPOTENCY_IN_PROGRESS",
				"message": "A request with this Idempotency-Key is already in progress",
			})
		}

		defer func() {
			_, _ = releaseIdempotencyLock.Run(c.Context(), rdb, []string{lockKey}, lockToken).Result()
		}()

		err = c.Next()
		status := c.Response().StatusCode()
		responseBody := c.Response().Body()
		if err == nil && status < 500 && len(responseBody) <= maxStoredBodyBytes {
			storedResponse, marshalErr := json.Marshal(storedIdempotentResponse{
				RequestHash: requestHash,
				Status:      status,
				ContentType: c.GetRespHeader("Content-Type"),
				Body:        append([]byte(nil), responseBody...),
			})
			if marshalErr == nil {
				_ = rdb.Set(c.Context(), responseKey, storedResponse, ttl).Err()
			}
		}
		return err
	}
}

func isSafeMethod(method string) bool {
	switch method {
	case fiber.MethodGet, fiber.MethodHead, fiber.MethodOptions:
		return true
	default:
		return false
	}
}

func validIdempotencyKey(value string) bool {
	for _, r := range value {
		switch {
		case r >= 'a' && r <= 'z':
		case r >= 'A' && r <= 'Z':
		case r >= '0' && r <= '9':
		case r == '-' || r == '_' || r == '.' || r == ':':
		default:
			return false
		}
	}
	return true
}
