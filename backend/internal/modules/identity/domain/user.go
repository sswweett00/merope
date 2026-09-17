package domain

import (
	"context"
	"time"
)

type SystemType string

const (
	SystemPersonal  SystemType = "PERSONAL"
	SystemCorporate SystemType = "CORPORATE"
)

type User struct {
	ID                  string             `json:"id"`
	SystemType          SystemType         `json:"system_type"`
	Username            string             `json:"username"`
	DisplayName         string             `json:"display_name"`
	Bio                 string             `json:"bio"`
	Email               string             `json:"email"`
	PasswordHash        string             `json:"-"`
	AvatarURL           string             `json:"avatar_url"`
	IsVerified          bool               `json:"is_verified"`
	MFAEnabled          bool               `json:"mfa_enabled"`
	MFASecret           string             `json:"-"`
	LastSeenAt          time.Time          `json:"last_seen_at"`
	IsOnline            bool               `json:"is_online"`
	IsPrivate           bool               `json:"is_private"`
	ProfileLock         bool               `json:"profile_lock"`
	FailedLoginAttempts int                `json:"failed_login_attempts"`
	LockedUntil         *time.Time         `json:"locked_until"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Session struct {
	ID           string    `json:"id"`
	UserID       string    `json:"user_id"`
	DeviceID     string    `json:"device_id"`
	IPAddress    string    `json:"ip_address"`
	Latitude     float64   `json:"latitude"`
	Longitude    float64   `json:"longitude"`
	City         string    `json:"city"`
	Country      string    `json:"country"`
	UserAgent    string    `json:"user_agent"`
	IsActive     bool      `json:"is_active"`
	LastActiveAt time.Time `json:"last_active_at"`
	CreatedAt    time.Time `json:"created_at"`
}

type IdentityRepository interface {
	CreateUser(ctx context.Context, user *User) error
	GetUserByID(ctx context.Context, id string) (*User, error)
	GetUserByIdentifier(ctx context.Context, identifier string) (*User, error)
	UpdateUser(ctx context.Context, user *User) error
	UpdateMFA(ctx context.Context, userID string, enabled bool, secret string) error
	UpdateOnlineStatus(ctx context.Context, userID string, isOnline bool) error
	SetProfileLock(ctx context.Context, userID string, locked bool) error

	// Security (v10.1)
	IncrementFailedLogin(ctx context.Context, userID string) error
	ResetFailedLogin(ctx context.Context, userID string) error
	LockAccount(ctx context.Context, userID string, until time.Time) error

	// Sessions
	CreateSession(ctx context.Context, session *Session) error
	GetSessions(ctx context.Context, userID string) ([]*Session, error)
	RevokeSession(ctx context.Context, sessionID, userID string) error

	// Privacy Filters
	AddKeywordFilter(ctx context.Context, userID, keyword string) error
	GetKeywordFilters(ctx context.Context, userID string) ([]string, error)

	// Blacklisting
	BlacklistToken(ctx context.Context, tokenID string, expiration time.Duration) error
	StoreRefreshToken(ctx context.Context, userID, refreshToken string, expiration time.Duration) error
	ValidateRefreshToken(ctx context.Context, refreshToken string) (string, error)
}

type IdentityService interface {
	Register(ctx context.Context, username, email, password, ip, ua string, sys SystemType) (*User, string, error)
	Login(ctx context.Context, identifier, password, deviceID, ip, ua string) (*User, string, bool, error)
	SetupMFA(ctx context.Context, userID string) (string, string, error)
	VerifyMFA(ctx context.Context, userID, code string) (bool, error)
	UpdateStatus(ctx context.Context, userID string, isOnline bool) error
	LockProfile(ctx context.Context, userID string, locked bool) error

	// GDPR (v4.0)
	ExportData(ctx context.Context, userID string) (map[string]interface{}, error)
	Logout(ctx context.Context, tokenID string, expiration time.Time) error
	RefreshToken(ctx context.Context, refreshToken, ip, ua string) (string, string, error)
}
