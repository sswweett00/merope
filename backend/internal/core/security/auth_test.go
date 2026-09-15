package security

import (
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

const testJWTSecret = "01234567890123456789012345678901"

func TestGenerateAndValidateToken(t *testing.T) {
	token, err := GenerateTokenWithPermissions("user-1", "user", "fingerprint", testJWTSecret, []string{"message:write"})
	if err != nil {
		t.Fatalf("generate token: %v", err)
	}
	claims, err := ValidateToken(token, testJWTSecret)
	if err != nil {
		t.Fatalf("validate token: %v", err)
	}
	if claims.UserID != "user-1" || claims.Subject != "user-1" || claims.Issuer != tokenIssuer {
		t.Fatalf("unexpected identity claims: %+v", claims.RegisteredClaims)
	}
	if len(claims.Audience) != 1 || claims.Audience[0] != tokenAudience {
		t.Fatalf("unexpected audience: %+v", claims.Audience)
	}
	if !CheckPermission(claims, "message:write") {
		t.Fatalf("expected permission to validate")
	}
}

func TestValidateTokenRejectsWrongSecret(t *testing.T) {
	token, err := GenerateToken("user-1", "user", "fingerprint", testJWTSecret)
	if err != nil {
		t.Fatalf("generate token: %v", err)
	}
	if _, err := ValidateToken(token, "10234567890123456789012345678901"); err == nil {
		t.Fatal("expected wrong signing secret to fail")
	}
}

func TestValidateTokenRejectsWrongIssuer(t *testing.T) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{
		UserID: "user-1",
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        "session-1",
			Subject:   "user-1",
			Issuer:    "attacker",
			Audience:  jwt.ClaimStrings{tokenAudience},
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
		},
	})
	raw, err := token.SignedString([]byte(testJWTSecret))
	if err != nil {
		t.Fatalf("sign token: %v", err)
	}
	if _, err := ValidateToken(raw, testJWTSecret); err == nil {
		t.Fatal("expected issuer mismatch to fail")
	}
}

func TestValidateTokenRequiresExpiration(t *testing.T) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{
		UserID: "user-1",
		RegisteredClaims: jwt.RegisteredClaims{
			ID:        "session-1",
			Subject:   "user-1",
			Issuer:    tokenIssuer,
			Audience:  jwt.ClaimStrings{tokenAudience},
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
		},
	})
	raw, err := token.SignedString([]byte(testJWTSecret))
	if err != nil {
		t.Fatalf("sign token: %v", err)
	}
	if _, err := ValidateToken(raw, testJWTSecret); err == nil {
		t.Fatal("expected missing expiration to fail")
	}
}

func TestAPIKeyFormat(t *testing.T) {
	key, err := GenerateAPIKey()
	if err != nil {
		t.Fatalf("generate api key: %v", err)
	}
	if !ValidateAPIKey(key) {
		t.Fatal("generated api key should validate")
	}
	if ValidateAPIKey("mrpk_not-a-real-key") {
		t.Fatal("invalid api key should not validate")
	}
}
