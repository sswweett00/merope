package security

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/redis/go-redis/v9"
)

const tokenAudience = "merope-api"
const tokenIssuer = "merope-auth"
const securityEventTTL = 30 * 24 * time.Hour

var atomicRateLimitScript = redis.NewScript(`
local count = redis.call("INCR", KEYS[1])
if count == 1 then
  redis.call("EXPIRE", KEYS[1], ARGV[1])
end
return count
`)

type Claims struct {
	UserID      string   `json:"user_id"`
	Role        string   `json:"role"`
	Fingerprint string   `json:"fingerprint,omitempty"`
	DeviceID    string   `json:"device_id,omitempty"`
	Permissions []string `json:"permissions,omitempty"`
	jwt.RegisteredClaims
}

func GenerateToken(userID, role, fingerprint, secret string) (string, error) {
	return GenerateTokenWithPermissions(userID, role, fingerprint, secret, nil)
}

func GenerateTokenWithPermissions(userID, role, fingerprint, secret string, permissions []string) (string, error) {
	if strings.TrimSpace(secret) == "" || strings.TrimSpace(userID) == "" {
		return "", fmt.Errorf("token secret and user id are required")
	}
	tokenID, err := GenerateRefreshToken()
	if err != nil {
		return "", fmt.Errorf("generate token id: %w", err)
	}
	now := time.Now()
	claims := Claims{
		UserID:      userID,
		Role:        role,
		Fingerprint: fingerprint,
		Permissions: permissions,
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        tokenID,
			Issuer:    tokenIssuer,
			Audience:  jwt.ClaimStrings{tokenAudience},
			ExpiresAt: jwt.NewNumericDate(now.Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(now),
			NotBefore: jwt.NewNumericDate(now),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func GenerateRefreshToken() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

func ValidateToken(tokenStr, secret string) (*Claims, error) {
	if strings.TrimSpace(secret) == "" || tokenStr == "" {
		return nil, fmt.Errorf("invalid token configuration")
	}
	token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		if token.Method != jwt.SigningMethodHS256 {
			return nil, fmt.Errorf("unexpected signing method")
		}
		return []byte(secret), nil
	}, jwt.WithIssuer(tokenIssuer), jwt.WithAudience(tokenAudience))
	if err != nil {
		return nil, err
	}
	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid || claims.Subject != "" && claims.Subject != claims.UserID {
		return nil, fmt.Errorf("invalid token")
	}
	return claims, nil
}

func GenerateFingerprint(ip, ua string) string {
	hash := sha256.Sum256([]byte(ip + "\x00" + ua))
	return base64.RawStdEncoding.EncodeToString(hash[:])
}

func BlacklistToken(ctx context.Context, rdb *redis.Client, tokenID string, expiration time.Duration) error {
	if rdb == nil || tokenID == "" {
		return fmt.Errorf("redis and token id are required")
	}
	if expiration <= 0 {
		return nil
	}
	return rdb.Set(ctx, "bl:"+tokenID, "1", expiration).Err()
}

func IsTokenBlacklisted(ctx context.Context, rdb *redis.Client, tokenID string) bool {
	if rdb == nil || tokenID == "" {
		return true
	}
	val, err := rdb.Get(ctx, "bl:"+tokenID).Result()
	return err == nil && val == "1"
}

func GenerateAPIKey() (string, error) {
	b := make([]byte, 48)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return "mrpk_" + base64.RawURLEncoding.EncodeToString(b), nil
}

func ValidateAPIKey(apiKey string) bool {
	if !strings.HasPrefix(apiKey, "mrpk_") {
		return false
	}
	encoded := strings.TrimPrefix(apiKey, "mrpk_")
	decoded, err := base64.RawURLEncoding.DecodeString(encoded)
	return err == nil && len(decoded) == 48
}

func GenerateSessionID() (string, error) {
	b := make([]byte, 24)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

func StoreRefreshToken(ctx context.Context, rdb *redis.Client, userID, refreshToken string, expiration time.Duration) error {
	if rdb == nil || userID == "" || refreshToken == "" || expiration <= 0 {
		return fmt.Errorf("invalid refresh token storage request")
	}
	return StoreRefreshTokenV2(ctx, rdb, userID, refreshToken, expiration)
}

func ValidateRefreshToken(ctx context.Context, rdb *redis.Client, refreshToken string) (string, error) {
	return ValidateRefreshTokenV2(ctx, rdb, refreshToken)
}

func HashDeviceID(deviceInfo string) string {
	hash := sha256.Sum256([]byte(deviceInfo))
	return base64.RawStdEncoding.EncodeToString(hash[:])
}

func CheckPermission(claims *Claims, requiredPermission string) bool {
	if claims == nil {
		return false
	}
	for _, permission := range claims.Permissions {
		if permission == requiredPermission || permission == "*" {
			return true
		}
	}
	return false
}

func HasAnyPermission(claims *Claims, requiredPermissions []string) bool {
	for _, required := range requiredPermissions {
		if CheckPermission(claims, required) {
			return true
		}
	}
	return false
}

func HasAllPermissions(claims *Claims, requiredPermissions []string) bool {
	for _, required := range requiredPermissions {
		if !CheckPermission(claims, required) {
			return false
		}
	}
	return true
}

func AddDeviceFingerprint(ctx context.Context, rdb *redis.Client, userID, deviceID, fingerprint string) error {
	if rdb == nil || userID == "" || deviceID == "" || fingerprint == "" {
		return fmt.Errorf("invalid device fingerprint request")
	}
	return rdb.Set(ctx, fmt.Sprintf("device:%s:%s", userID, deviceID), fingerprint, 30*24*time.Hour).Err()
}

func ValidateDeviceFingerprint(ctx context.Context, rdb *redis.Client, userID, deviceID, fingerprint string) (bool, error) {
	if rdb == nil || userID == "" || deviceID == "" || fingerprint == "" {
		return false, fmt.Errorf("invalid device fingerprint request")
	}
	stored, err := rdb.Get(ctx, fmt.Sprintf("device:%s:%s", userID, deviceID)).Result()
	if err != nil {
		return false, err
	}
	return stored == fingerprint, nil
}

func RateLimitCheck(ctx context.Context, rdb *redis.Client, userID string, limit int, window time.Duration) (bool, error) {
	if rdb == nil || userID == "" || limit <= 0 || window <= 0 {
		return false, fmt.Errorf("invalid rate limit request")
	}
	key := fmt.Sprintf("ratelimit:%s", userID)
	result, err := atomicRateLimitScript.Run(ctx, rdb, []string{key}, int64(window/time.Second)).Result()
	if err != nil {
		return false, err
	}
	count, ok := result.(int64)
	if !ok {
		return false, fmt.Errorf("invalid rate limit response")
	}
	return count <= int64(limit), nil
}

func SecurityEvent(ctx context.Context, rdb *redis.Client, eventType, userID, details string) error {
	if rdb == nil || strings.TrimSpace(eventType) == "" {
		return fmt.Errorf("redis is required")
	}
	key := fmt.Sprintf("security:%s:%d:%s", eventType, time.Now().UnixNano(), userID)
	pipe := rdb.Pipeline()
	pipe.HSet(ctx, key, map[string]interface{}{
		"user_id":   userID,
		"event":     eventType,
		"details":   details,
		"timestamp": time.Now().UTC().Unix(),
	})
	pipe.Expire(ctx, key, securityEventTTL)
	_, err := pipe.Exec(ctx)
	return err
}
