package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"time"
	"local/merope/internal/modules/notifications/domain"
	pushDomain "local/merope/internal/modules/push/domain"
)

type pushService struct {
	tokenRepo pushDomain.PushRepository
	notifRepo domain.NotificationsRepository
	dispatcher func(ctx context.Context, token, title, body string, data map[string]string, priority string) error
}

func NewPushNotificationService(
	tokenRepo pushDomain.PushRepository,
	notifRepo domain.NotificationsRepository,
	dispatcher func(ctx context.Context, token, title, body string, data map[string]string, priority string) error,
) pushDomain.PushService {
	return &pushService{tokenRepo: tokenRepo, notifRepo: notifRepo, dispatcher: dispatcher}
}

func (s *pushService) RegisterDevice(ctx context.Context, userID, token, platform, deviceID string) error {
	tokenHash := hashToken(token)
	existing, _ := s.tokenRepo.GetActiveTokens(ctx, userID)
	for _, t := range existing {
		if t.Token == tokenHash {
			return nil
		}
	}

	pt := &pushDomain.PushToken{
		UserID:    userID,
		Token:     tokenHash,
		TokenPlain: token,
		Platform:  platform,
		DeviceID:  deviceID,
		IsActive:  true,
		CreatedAt: time.Now().Format(time.RFC3339),
	}
	return s.tokenRepo.SaveToken(ctx, pt)
}

func (s *pushService) UnregisterDevice(ctx context.Context, tokenID string) error {
	return s.tokenRepo.DeactivateToken(ctx, tokenID)
}

func (s *pushService) Dispatch(ctx context.Context, userID, title, body string, data map[string]string) error {
	if s.notifRepo != nil {
		_ = s.notifRepo.Create(ctx, &domain.Notification{
			ReceiverID: userID,
			EntityType: "push",
			Type:       "push",
			IsRead:     false,
			CreatedAt:  time.Now(),
		})
	}

	tokens, err := s.tokenRepo.GetActiveTokens(ctx, userID)
	if err != nil {
		return err
	}
	if len(tokens) == 0 {
		return nil
	}

	priority := "high"
	pn := &pushDomain.PushNotification{
		UserID:    userID,
		Title:     title,
		Body:      body,
		Data:      data,
		Priority:  priority,
		Status:    "pending",
		CreatedAt: time.Now().Format(time.RFC3339),
	}
	if err := s.tokenRepo.CreateNotification(ctx, pn); err != nil {
		return err
	}

	for _, token := range tokens {
		plainToken := token.Token
		if token.TokenPlain != "" {
			plainToken = token.TokenPlain
		}
		_ = s.dispatcher(ctx, plainToken, title, body, data, priority)
	}

	return s.tokenRepo.UpdateNotificationStatus(ctx, pn.ID, "sent", "")
}

func (s *pushService) GetDeliveryReport(ctx context.Context, notifID string) (*pushDomain.PushNotification, error) {
	return nil, nil
}

func (s *pushService) ListDevices(ctx context.Context, userID string) ([]*pushDomain.PushToken, error) {
	return s.tokenRepo.GetActiveTokens(ctx, userID)
}

func hashToken(token string) string {
	h := sha256.Sum256([]byte(token))
	return hex.EncodeToString(h[:])
}
