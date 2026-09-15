package service

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"time"

	"local/merope/internal/modules/developer/domain"
)

type developerService struct {
	repo domain.DeveloperRepository
}

func NewDeveloperService(repo domain.DeveloperRepository) domain.DeveloperService {
	return &developerService{repo: repo}
}

func (s *developerService) RegisterApp(ctx context.Context, ownerID, name string) (*domain.App, error) {
	clientID := generateID(16)
	clientSecret := generateID(32)

	app := &domain.App{
		OwnerID:      ownerID,
		Name:         name,
		ClientID:     clientID,
		ClientSecret: clientSecret,
	}

	if err := s.repo.CreateApp(ctx, app); err != nil {
		return nil, err
	}

	return app, nil
}

func (s *developerService) SetupWebhook(ctx context.Context, appID, url string, events []string) (*domain.Webhook, error) {
	webhook := &domain.Webhook{
		AppID:     appID,
		TargetURL: url,
		Events:    events,
		IsActive:  true,
	}

	if err := s.repo.CreateWebhook(ctx, webhook); err != nil {
		return nil, err
	}

	return webhook, nil
}

func (s *developerService) GetAppHealth(ctx context.Context, appID string) (*domain.Metrics, error) {
	return s.repo.GetMetrics(ctx, appID)
}

func (s *developerService) ListWebhooks(ctx context.Context, appID string) ([]*domain.Webhook, error) {
	return s.repo.GetWebhooksByAppID(ctx, appID)
}

func (s *developerService) GenerateAPIKey(ctx context.Context, appID, name string, scopes []string, ttlDays int) (*domain.APIKey, error) {
	rawKey := generateID(40)
	keyPrefix := rawKey[:8]

	apiKey := &domain.APIKey{
		AppID:        appID,
		KeyHash:      hashKey(rawKey),
		KeyPrefix:    keyPrefix,
		Name:         name,
		Scopes:       scopes,
		RateLimitRPM: 100,
		IsActive:     true,
		CreatedAt:    time.Now(),
		RawKey:       rawKey,
	}

	if ttlDays > 0 {
		expires := time.Now().AddDate(0, 0, ttlDays)
		apiKey.ExpiresAt = &expires
	}

	if err := s.repo.CreateAPIKey(ctx, apiKey); err != nil {
		return nil, err
	}

	return apiKey, nil
}

func (s *developerService) ValidateAPIKey(ctx context.Context, keyHash string) (*domain.APIKey, error) {
	key, err := s.repo.GetAPIKeyByHash(ctx, keyHash)
	if err != nil {
		return nil, err
	}
	if key == nil {
		return nil, fmt.Errorf("invalid API key")
	}
	if !key.IsActive {
		return nil, fmt.Errorf("API key revoked")
	}
	if key.ExpiresAt != nil && key.ExpiresAt.Before(time.Now()) {
		return nil, fmt.Errorf("API key expired")
	}

	_ = s.repo.UpdateAPIKeyUsage(ctx, key.ID)
	key.RawKey = ""
	return key, nil
}

func (s *developerService) ListAPIKeys(ctx context.Context, appID string) ([]*domain.APIKey, error) {
	keys, err := s.repo.GetAPIKeysByAppID(ctx, appID)
	if err != nil {
		return nil, err
	}
	for _, k := range keys {
		k.RawKey = ""
	}
	return keys, nil
}

func (s *developerService) RevokeAPIKey(ctx context.Context, keyID string) error {
	return s.repo.RevokeAPIKey(ctx, keyID)
}

func generateID(length int) string {
	bytes := make([]byte, length)
	rand.Read(bytes)
	return strings.ToUpper(fmt.Sprintf("%x", bytes))[:length]
}

func hashKey(key string) string {
	h := sha256.Sum256([]byte(key))
	return hex.EncodeToString(h[:])
}
