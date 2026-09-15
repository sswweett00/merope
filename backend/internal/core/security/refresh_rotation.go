package security

import (
	"context"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
)

const refreshV2Prefix = "refresh:v2:"

var rotateRefreshTokenScript = redis.NewScript(`
local current = redis.call("GET", KEYS[1])
if not current then
  current = redis.call("GET", KEYS[2])
  if current then
    redis.call("DEL", KEYS[2])
  end
end
if not current then
  return ""
end
redis.call("DEL", KEYS[1])
redis.call("SET", KEYS[3], current, "EX", ARGV[1])
return current
`)

func refreshTokenDigest(token string) string {
	digest := sha256.Sum256([]byte(token))
	return base64.RawURLEncoding.EncodeToString(digest[:])
}

func refreshV2Key(token string) string {
	return refreshV2Prefix + refreshTokenDigest(token)
}

// StoreRefreshTokenV2 stores only a SHA-256-derived key in Redis. The raw
// refresh token is returned to the caller but is never used as a Redis key.
func StoreRefreshTokenV2(ctx context.Context, rdb *redis.Client, userID, refreshToken string, expiration time.Duration) error {
	if rdb == nil || userID == "" || refreshToken == "" || expiration <= 0 {
		return fmt.Errorf("invalid refresh token storage request")
	}
	return rdb.Set(ctx, refreshV2Key(refreshToken), userID, expiration).Err()
}

// RotateRefreshTokenV2 atomically consumes the old refresh token and creates a
// new server-side refresh capability. It accepts legacy raw-token keys only
// for one migration step; the legacy key is deleted in the same Redis script.
func RotateRefreshTokenV2(ctx context.Context, rdb *redis.Client, oldToken, newToken string, expiration time.Duration) (string, error) {
	if rdb == nil || oldToken == "" || newToken == "" || expiration <= 0 {
		return "", fmt.Errorf("invalid refresh token rotation request")
	}

	keys := []string{
		refreshV2Key(oldToken),
		"refresh:" + oldToken,
		refreshV2Key(newToken),
	}
	userID, err := rotateRefreshTokenScript.Run(ctx, rdb.Conn, keys, int64(expiration/time.Second)).Result()
	if err != nil {
		return "", fmt.Errorf("refresh token rotation failed: %w", err)
	}
	if userID == "" {
		return "", fmt.Errorf("invalid or expired refresh token")
	}
	return userID, nil
}

// ValidateRefreshTokenV2 accepts both hardened v2 tokens and one-time legacy
// raw-key tokens. Legacy tokens remain valid only until their first rotation.
func ValidateRefreshTokenV2(ctx context.Context, rdb *redis.Client, refreshToken string) (string, error) {
	if rdb == nil || refreshToken == "" {
		return "", fmt.Errorf("invalid or expired refresh token")
	}
	userID, err := rdb.Get(ctx, refreshV2Key(refreshToken)).Result()
	if err == nil && userID != "" {
		return userID, nil
	}
	userID, err = rdb.Get(ctx, "refresh:"+refreshToken).Result()
	if err != nil || userID == "" {
		return "", fmt.Errorf("invalid or expired refresh token")
	}
	return userID, nil
}
