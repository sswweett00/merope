package domain

import (
	"context"
)

type PushToken struct {
	ID         string
	UserID     string
	Token      string
	TokenPlain string
	Platform   string
	DeviceID   string
	AppVersion string
	IsActive   bool
	LastUsedAt string
	CreatedAt  string
}

type PushNotification struct {
	ID          string
	UserID      string
	TokenID     string
	Title       string
	Body        string
	Data        map[string]string
	Priority    string
	CollapseKey string
	TTLSeconds  int
	Status      string
	Provider    string
	Response    string
	CreatedAt   string
}

type PushRepository interface {
	SaveToken(ctx context.Context, token *PushToken) error
	GetActiveTokens(ctx context.Context, userID string) ([]*PushToken, error)
	DeactivateToken(ctx context.Context, tokenID string) error
	CreateNotification(ctx context.Context, notif *PushNotification) error
	UpdateNotificationStatus(ctx context.Context, notifID, status, response string) error
	GetPendingNotifications(ctx context.Context, limit int) ([]*PushNotification, error)
}

type PushService interface {
	RegisterDevice(ctx context.Context, userID, token, platform, deviceID string) error
	UnregisterDevice(ctx context.Context, tokenID string) error
	Dispatch(ctx context.Context, userID, title, body string, data map[string]string) error
	GetDeliveryReport(ctx context.Context, notifID string) (*PushNotification, error)
	ListDevices(ctx context.Context, userID string) ([]*PushToken, error)
}
