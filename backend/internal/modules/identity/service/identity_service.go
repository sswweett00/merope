package service

import (
	"context"
	"fmt"
	"strings"
	"time"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/identity/domain"

	"github.com/nbutton23/zxcvbn-go"
	"golang.org/x/crypto/bcrypt"
	"github.com/pquerna/otp/totp"
)

type identityService struct {
	repo      domain.IdentityRepository
	jwtSecret string
	sentinel  IdentitySentinel
}

func NewIdentityService(repo domain.IdentityRepository, jwtSecret string, sentinel IdentitySentinel) domain.IdentityService {
	return &identityService{
		repo:      repo,
		jwtSecret: jwtSecret,
		sentinel:  sentinel,
	}
}

func (s *identityService) Register(ctx context.Context, username, email, password, ip, ua string, sys domain.SystemType) (*domain.User, string, error) {
	// Password Strength Validation
	strength := zxcvbn.PasswordStrength(password, []string{username, email})
	if strength.Score < 3 {
		return nil, "", fmt.Errorf("password is too weak (score: %d/4). Try a longer phrase or add symbols", strength.Score)
	}

	hashedPassword, err := security.HashPassword(password)
	if err != nil {
		return nil, "", fmt.Errorf("failed to hash password: %w", err)
	}

	user := &domain.User{
		Username:     username,
		Email:        email,
		PasswordHash: hashedPassword,
		SystemType:   sys,
	}

	if err := s.repo.CreateUser(ctx, user); err != nil {
		return nil, "", err
	}

	fingerprint := security.GenerateFingerprint(ip, ua)

	// Sentinel: Register device fingerprint
	if s.sentinel != nil {
		_ = s.sentinel.RegisterDevice(ctx, user.ID, fingerprint)
	}

	token, err := security.GenerateToken(user.ID, "user", fingerprint, s.jwtSecret)
	if err != nil {
		return nil, "", fmt.Errorf("failed to generate token: %w", err)
	}

	return user, token, nil
}

func (s *identityService) Login(ctx context.Context, identifier, password, deviceID, ip, ua string) (*domain.User, string, bool, error) {
	user, err := s.repo.GetUserByIdentifier(ctx, identifier)
	if err != nil {
		return nil, "", false, fmt.Errorf("invalid credentials")
	}

	// Check Lockout
	if user.LockedUntil != nil && user.LockedUntil.After(time.Now()) {
		return nil, "", false, fmt.Errorf("account is temporarily locked due to multiple failed attempts. Try again later")
	}

	var valid bool
	if strings.HasPrefix(user.PasswordHash, "$argon2id$") {
		valid, err = security.ComparePassword(password, user.PasswordHash)
	} else {
		err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password))
		valid = (err == nil)
	}

	if !valid {
		_ = s.repo.IncrementFailedLogin(ctx, user.ID)

		user, _ = s.repo.GetUserByID(ctx, user.ID)
		if user.FailedLoginAttempts >= 5 {
			lockUntil := time.Now().Add(15 * time.Minute)
			_ = s.repo.LockAccount(ctx, user.ID, lockUntil)
			return nil, "", false, fmt.Errorf("account locked for 15 minutes due to 5 failed attempts")
		}

		return nil, "", false, fmt.Errorf("invalid credentials")
	}

	// Reset failed attempts on success
	if user.FailedLoginAttempts > 0 {
		_ = s.repo.ResetFailedLogin(ctx, user.ID)
	}

	// Upgrade user to Argon2id if they were on bcrypt
	if !strings.HasPrefix(user.PasswordHash, "$argon2id$") {
		newHash, _ := security.HashPassword(password)
		user.PasswordHash = newHash
		_ = s.repo.UpdateUser(ctx, user)
	}

	// Check if MFA is required
	if user.MFAEnabled {
		return user, "", true, nil
	}

	// Sentinel: Adaptive Risk Assessment
	if s.sentinel != nil {
		risk, _ := s.sentinel.AssessRisk(ctx, user.ID, ip, ua)
		if risk > 0.8 {
			return nil, "", false, fmt.Errorf("high risk detected, please use different authentication method")
		}

		known, _ := s.sentinel.VerifyDeviceFingerprint(ctx, user.ID, security.GenerateFingerprint(ip, ua))
		if !known {
			// Trigger MFA or additional verification if device is unknown
			// For now, we'll just log or require MFA if enabled
			if !user.MFAEnabled {
				// Potentially force MFA setup or block
			}
		}
	}

	// Create Session
	session := &domain.Session{
		UserID:    user.ID,
		DeviceID:  deviceID,
		IPAddress: ip,
		UserAgent: ua,
	}
	_ = s.repo.CreateSession(ctx, session)

	fingerprint := security.GenerateFingerprint(ip, ua)
	token, err := security.GenerateToken(user.ID, "user", fingerprint, s.jwtSecret)
	if err != nil {
		return nil, "", false, fmt.Errorf("failed to generate token: %w", err)
	}

	// Sentinel: Token Binding Verification (for subsequent requests, this would be in middleware)
	// But here we can verify the binding if it was provided in request
	// (Assuming the client provides a binding hash based on AetherAuthShield)

	return user, token, false, nil
}

func (s *identityService) SetupMFA(ctx context.Context, userID string) (string, string, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return "", "", err
	}

	key, err := totp.Generate(totp.GenerateOpts{
		Issuer:      "Merope Social OS",
		AccountName: user.Email,
	})
	if err != nil {
		return "", "", err
	}

	// Save secret (but don't enable yet)
	err = s.repo.UpdateMFA(ctx, userID, false, key.Secret())
	if err != nil {
		return "", "", err
	}

	return key.Secret(), key.URL(), nil
}

func (s *identityService) VerifyMFA(ctx context.Context, userID, code string) (bool, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return false, err
	}

	valid := totp.Validate(code, user.MFASecret)
	if !valid {
		return false, nil
	}

	// If it was first time setup, enable it
	if !user.MFAEnabled {
		_ = s.repo.UpdateMFA(ctx, userID, true, user.MFASecret)
	}

	return true, nil
}

func (s *identityService) UpdateStatus(ctx context.Context, userID string, isOnline bool) error {
	return s.repo.UpdateOnlineStatus(ctx, userID, isOnline)
}

func (s *identityService) LockProfile(ctx context.Context, userID string, locked bool) error {
	return s.repo.SetProfileLock(ctx, userID, locked)
}

func (s *identityService) ExportData(ctx context.Context, userID string) (map[string]interface{}, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	sessions, _ := s.repo.GetSessions(ctx, userID)

	return map[string]interface{}{
		"user":     user,
		"sessions": sessions,
		"exported_at": time.Now(),
	}, nil
}

func (s *identityService) Logout(ctx context.Context, tokenID string, expiration time.Time) error {
	duration := time.Until(expiration)
	if duration <= 0 {
		return nil
	}
	return s.repo.BlacklistToken(ctx, tokenID, duration)
}

func (s *identityService) RefreshToken(ctx context.Context, refreshToken string) (string, string, error) {
	userID, err := s.repo.ValidateRefreshToken(ctx, refreshToken)
	if err != nil {
		return "", "", err
	}

	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return "", "", fmt.Errorf("user not found")
	}

	fingerprint := security.GenerateFingerprint("", "")
	token, err := security.GenerateToken(user.ID, "user", fingerprint, s.jwtSecret)
	if err != nil {
		return "", "", fmt.Errorf("failed to generate token: %w", err)
	}

	newRefreshToken, err := security.GenerateRefreshToken()
	if err != nil {
		return "", "", fmt.Errorf("failed to generate refresh token: %w", err)
	}

	expiration := 30 * 24 * time.Hour
	_ = s.repo.StoreRefreshToken(ctx, user.ID, newRefreshToken, expiration)

	return token, newRefreshToken, nil
}
