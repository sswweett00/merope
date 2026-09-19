package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/nbutton23/zxcvbn-go"
	"github.com/pquerna/otp/totp"
	"golang.org/x/crypto/bcrypt"

	"local/merope/internal/core/security"
	"local/merope/internal/modules/identity/domain"
)

type refreshTokenRotator interface {
	RotateRefreshToken(ctx context.Context, oldToken, newToken string, expiration time.Duration) (string, error)
}

type identityService struct {
	repo      domain.IdentityRepository
	jwtSecret string
	sentinel  IdentitySentinel
}

func NewIdentityService(repo domain.IdentityRepository, jwtSecret string, sentinel IdentitySentinel) domain.IdentityService {
	return &identityService{repo: repo, jwtSecret: jwtSecret, sentinel: sentinel}
}

func (s *identityService) Register(ctx context.Context, username, email, password, ip, ua string, sys domain.SystemType) (*domain.User, string, error) {
	strength := zxcvbn.PasswordStrength(password, []string{username, email})
	if strength.Score < 3 {
		return nil, "", fmt.Errorf("password is too weak (score: %d/4). Try a longer phrase or add symbols", strength.Score)
	}
	hashedPassword, err := security.HashPassword(password)
	if err != nil {
		return nil, "", fmt.Errorf("failed to hash password: %w", err)
	}
	user := &domain.User{Username: username, Email: email, PasswordHash: hashedPassword, SystemType: sys}
	if err := s.repo.CreateUser(ctx, user); err != nil {
		return nil, "", err
	}
	fingerprint := security.GenerateFingerprint(ip, ua)
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
	if user.LockedUntil != nil && user.LockedUntil.After(time.Now()) {
		return nil, "", false, fmt.Errorf("account is temporarily locked due to multiple failed attempts. Try again later")
	}
	var valid bool
	if strings.HasPrefix(user.PasswordHash, "$argon2id$") {
		valid, err = security.ComparePassword(password, user.PasswordHash)
	} else {
		err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password))
		valid = err == nil
	}
	if !valid {
		_ = s.repo.IncrementFailedLogin(ctx, user.ID)
		refreshed, refreshErr := s.repo.GetUserByID(ctx, user.ID)
		if refreshErr == nil && refreshed.FailedLoginAttempts >= 5 {
			lockUntil := time.Now().Add(15 * time.Minute)
			_ = s.repo.LockAccount(ctx, user.ID, lockUntil)
			return nil, "", false, fmt.Errorf("account locked for 15 minutes due to 5 failed attempts")
		}
		return nil, "", false, fmt.Errorf("invalid credentials")
	}
	if user.FailedLoginAttempts > 0 {
		_ = s.repo.ResetFailedLogin(ctx, user.ID)
	}
	if !strings.HasPrefix(user.PasswordHash, "$argon2id$") {
		if newHash, hashErr := security.HashPassword(password); hashErr == nil {
			user.PasswordHash = newHash
			_ = s.repo.UpdateUser(ctx, user)
		}
	}
	if user.MFAEnabled {
		return user, "", true, nil
	}
	if s.sentinel != nil {
		risk, _ := s.sentinel.AssessRisk(ctx, user.ID, ip, ua)
		if risk > 0.8 {
			return nil, "", false, fmt.Errorf("high risk detected, please use different authentication method")
		}
		_, _ = s.sentinel.VerifyDeviceFingerprint(ctx, user.ID, security.GenerateFingerprint(ip, ua))
	}
	session := &domain.Session{UserID: user.ID, DeviceID: deviceID, IPAddress: ip, UserAgent: ua}
	if err := s.repo.CreateSession(ctx, session); err != nil {
		return nil, "", false, fmt.Errorf("failed to create session")
	}
	fingerprint := security.GenerateFingerprint(ip, ua)
	token, err := security.GenerateToken(user.ID, "user", fingerprint, s.jwtSecret)
	if err != nil {
		return nil, "", false, fmt.Errorf("failed to generate token: %w", err)
	}
	return user, token, false, nil
}

func (s *identityService) SetupMFA(ctx context.Context, userID string) (string, string, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return "", "", err
	}
	key, err := totp.Generate(totp.GenerateOpts{Issuer: "Merope Social OS", AccountName: user.Email})
	if err != nil {
		return "", "", err
	}
	if err := s.repo.UpdateMFA(ctx, userID, false, key.Secret()); err != nil {
		return "", "", err
	}
	return key.Secret(), key.URL(), nil
}

func (s *identityService) VerifyMFA(ctx context.Context, userID, code string) (bool, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return false, err
	}
	if !totp.Validate(code, user.MFASecret) {
		return false, nil
	}
	if !user.MFAEnabled {
		if err := s.repo.UpdateMFA(ctx, userID, true, user.MFASecret); err != nil {
			return false, err
		}
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
	return map[string]interface{}{"user": user, "sessions": sessions, "exported_at": time.Now().UTC()}, nil
}

func (s *identityService) Logout(ctx context.Context, tokenID string, expiration time.Time) error {
	duration := time.Until(expiration)
	if duration <= 0 {
		return nil
	}
	return s.repo.BlacklistToken(ctx, tokenID, duration)
}

func (s *identityService) RefreshToken(ctx context.Context, refreshToken, ip, ua string) (string, string, error) {
	newRefreshToken, err := security.GenerateRefreshToken()
	if err != nil {
		return "", "", fmt.Errorf("failed to generate refresh token: %w", err)
	}
	expiration := 30 * 24 * time.Hour

	var userID string
	if rotator, ok := s.repo.(refreshTokenRotator); ok {
		userID, err = rotator.RotateRefreshToken(ctx, refreshToken, newRefreshToken, expiration)
		if err != nil {
			return "", "", err
		}
	} else {
		userID, err = s.repo.ValidateRefreshToken(ctx, refreshToken)
		if err != nil {
			return "", "", err
		}
		if err := s.repo.StoreRefreshToken(ctx, userID, newRefreshToken, expiration); err != nil {
			return "", "", fmt.Errorf("failed to store refresh token")
		}
	}

	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return "", "", fmt.Errorf("user not found")
	}
	// Refresh requests must issue an access token bound to the same request
	// fingerprint that AuthMiddleware will evaluate on the next API call.
	fingerprint := security.GenerateFingerprint(ip, ua)
	token, err := security.GenerateToken(user.ID, "user", fingerprint, s.jwtSecret)
	if err != nil {
		return "", "", fmt.Errorf("failed to generate access token: %w", err)
	}
	return token, newRefreshToken, nil
}
