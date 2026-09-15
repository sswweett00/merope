package security

import "testing"

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
