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

type Claims struct {
	UserID      string `json:"user_id"`
	Role        string `json:"role"`
	Fingerprint string `json:"fingerprint"` // Session Fingerprint (IP+UA hash)
	DeviceID    string `json:"device_id"`    // Device identifier
	Permissions []string `json:"permissions"` // User permissions
	jwt.RegisteredClaims
}

func GenerateToken(userID, role, fingerprint, secret string) (string, error) {
	return GenerateTokenWithPermissions(userID, role, fingerprint, secret, []string{})
}

func GenerateTokenWithPermissions(userID, role, fingerprint, secret string, permissions []string) (string, error) {
	tokenID, _ := GenerateRefreshToken() // Use same generator for unique ID
	claims := Claims{
		UserID:      userID,
		Role:        role,
		Fingerprint: fingerprint,
		Permissions: permissions,
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        tokenID,
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)), // Shorter lived access tokens
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
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
	return base64.URLEncoding.EncodeToString(b), nil
}

func ValidateToken(tokenStr, secret string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(secret), nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		return claims, nil
	}

	return nil, fmt.Errorf("invalid token")
}

func GenerateFingerprint(ip, ua string) string {
	hash := sha256.Sum256([]byte(ip + ua))
	return base64.StdEncoding.EncodeToString(hash[:])
}

// BlacklistToken adds a token to Redis with an expiration
func BlacklistToken(ctx context.Context, rdb *redis.Client, tokenID string, expiration time.Duration) error {
	return rdb.Set(ctx, "bl:"+tokenID, "1", expiration).Err()
}

// IsTokenBlacklisted checks if a token is in the Redis blacklist
func IsTokenBlacklisted(ctx context.Context, rdb *redis.Client, tokenID string) bool {
	val, err := rdb.Get(ctx, "bl:"+tokenID).Result()
	return err == nil && val == "1"
}

// Enterprise-level security functions

// GenerateAPIKey generates a secure API key for external integrations
func GenerateAPIKey() (string, error) {
	b := make([]byte, 48)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return "mrpk_" + base64.URLEncoding.EncodeToString(b), nil
}

// ValidateAPIKey validates an API key format
func ValidateAPIKey(apiKey string) bool {
	if len(apiKey) < 10 || len(apiKey) > 100 {
		return false
	}
	// In production, implement more sophisticated validation
	return true
}

// GenerateSessionID generates a unique session identifier
func GenerateSessionID() (string, error) {
	b := make([]byte, 24)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.URLEncoding.EncodeToString(b), nil
}

func SanitizeSQL(text string) string {
	replacer := strings.NewReplacer(
		"'", "''",
		"\"", "\"\"",
		"--", "",
		";", "",
	)
	return replacer.Replace(text)
}

// RefreshTokenStore stores a refresh token in Redis with user binding
func StoreRefreshToken(ctx context.Context, rdb *redis.Client, userID, refreshToken string, expiration time.Duration) error {
	key := "refresh:" + refreshToken
	return rdb.Set(ctx, key, userID, expiration).Err()
}

// ValidateRefreshToken checks if a refresh token exists in Redis and returns the bound userID
func ValidateRefreshToken(ctx context.Context, rdb *redis.Client, refreshToken string) (string, error) {
	key := "refresh:" + refreshToken
	userID, err := rdb.Get(ctx, key).Result()
	if err != nil {
		return "", fmt.Errorf("invalid or expired refresh token")
	}
	return userID, nil
}

// HashDeviceID creates a consistent hash for device identification
func HashDeviceID(deviceInfo string) string {
	hash := sha256.Sum256([]byte(deviceInfo))
	return base64.StdEncoding.EncodeToString(hash[:])
}

// CheckPermission checks if a user has a specific permission
func CheckPermission(claims *Claims, requiredPermission string) bool {
	for _, permission := range claims.Permissions {
		if permission == requiredPermission || permission == "*" {
			return true
		}
	}
	return false
}

// HasAnyPermission checks if user has any of the required permissions
func HasAnyPermission(claims *Claims, requiredPermissions []string) bool {
	for _, required := range requiredPermissions {
		if CheckPermission(claims, required) {
			return true
		}
	}
	return false
}

// HasAllPermissions checks if user has all required permissions
func HasAllPermissions(claims *Claims, requiredPermissions []string) bool {
	for _, required := range requiredPermissions {
		if !CheckPermission(claims, required) {
			return false
		}
	}
	return true
}

// AddDeviceFingerprint adds device fingerprint to session tracking
func AddDeviceFingerprint(ctx context.Context, rdb *redis.Client, userID, deviceID, fingerprint string) error {
	key := fmt.Sprintf("device:%s:%s", userID, deviceID)
	return rdb.Set(ctx, key, fingerprint, 30*24*time.Hour).Err()
}

// ValidateDeviceFingerprint validates device fingerprint against stored value
func ValidateDeviceFingerprint(ctx context.Context, rdb *redis.Client, userID, deviceID, fingerprint string) (bool, error) {
	key := fmt.Sprintf("device:%s:%s", userID, deviceID)
	stored, err := rdb.Get(ctx, key).Result()
	if err != nil {
		return false, err
	}
	return stored == fingerprint, nil
}

// RateLimitCheck checks if a user has exceeded rate limits
func RateLimitCheck(ctx context.Context, rdb *redis.Client, userID string, limit int, window time.Duration) (bool, error) {
	key := fmt.Sprintf("ratelimit:%s", userID)
	
	// Use Redis INCR for atomic counter
	count, err := rdb.Incr(ctx, key).Result()
	if err != nil {
		return false, err
	}
	
	// Set expiration if this is the first request
	if count == 1 {
		rdb.Expire(ctx, key, window)
	}
	
	return count <= int64(limit), nil
}

// SecurityEvent logs security events for audit purposes
func SecurityEvent(ctx context.Context, rdb *redis.Client, eventType, userID, details string) error {
	key := fmt.Sprintf("security:%s:%d", eventType, time.Now().Unix())
	event := map[string]interface{}{
		"user_id":  userID,
		"event":    eventType,
		"details":  details,
		"timestamp": time.Now().Unix(),
	}
	return rdb.HSet(ctx, key, event).Err()
}
