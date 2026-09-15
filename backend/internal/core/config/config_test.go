package config

import "testing"

func TestValidateProductionConfig(t *testing.T) {
	cfg := &Config{
		Env:                "production",
		Port:               8080,
		JWTSecret:          "01234567890123456789012345678901",
		CORSAllowedOrigins: "https://app.example.com",
	}
	if err := cfg.Validate(); err != nil {
		t.Fatalf("expected valid config, got %v", err)
	}
}

func TestValidateRejectsWeakJWTSecret(t *testing.T) {
	cfg := &Config{Port: 8080, JWTSecret: "too-short"}
	if err := cfg.Validate(); err == nil {
		t.Fatal("expected weak JWT secret to be rejected")
	}
}

func TestValidateRejectsEmptyProductionCORS(t *testing.T) {
	cfg := &Config{
		Env:       "production",
		Port:      8080,
		JWTSecret: "01234567890123456789012345678901",
	}
	if err := cfg.Validate(); err == nil {
		t.Fatal("expected empty production CORS allow-list to be rejected")
	}
}
