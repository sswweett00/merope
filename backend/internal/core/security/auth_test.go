package security

import "testing"

func TestGenerateAndValidateToken(t *testing.T) {
	secret := "01234567890123456789012345678901"
	token, err := GenerateTokenWithPermissions("user-1", "user", "fingerprint", secret, []string{"message:write"})
	if err != nil {
		t.Fatalf("generate token: %v", err)
	}
	claims, err := ValidateToken(token, secret)
	if err != nil {
		t.Fatalf("validate token: %v", err)
	}
	if claims.UserID != "user-1" || !CheckPermission(claims, "message:write") {
		t.Fatalf("unexpected claims: %+v", claims)
	}
}

func TestValidateTokenRejectsWrongSecret(t *testing.T) {
	token, err := GenerateToken("user-1", "user", "fingerprint", "01234567890123456789012345678901")
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
