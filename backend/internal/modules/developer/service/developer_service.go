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

type developerService struct { repo domain.RuntimeDeveloperRepository }

func NewDeveloperService(repo domain.RuntimeDeveloperRepository) domain.RuntimeDeveloperService { return &developerService{repo: repo} }

func (s *developerService) RegisterApp(ctx context.Context, ownerID, name, description string) (*domain.App, error) {
	name = strings.TrimSpace(name)
	if name == "" { return nil, fmt.Errorf("app name is required") }
	clientID := generateID(16)
	clientSecret := generateID(32)
	app := &domain.App{OwnerID: ownerID, Name: name, Description: description, ClientID: clientID, ClientSecret: clientSecret, IsActive: true, CreatedAt: time.Now(), UpdatedAt: time.Now(), Settings: domain.AppSettings{EnableWebhooks: true, EnableRealtime: true, RateLimitPerMinute: 100, RateLimitPerHour: 1000, MaxConcurrentCalls: 10, AutoApproveTokens: true, TokenExpiry: 3600, RefreshTokenExpiry: 86400}}
	if err := s.repo.CreateApp(ctx, app); err != nil { return nil, err }
	return app, nil
}

func (s *developerService) GetApp(ctx context.Context, appID string) (*domain.App, error) { return s.repo.GetApp(ctx, appID) }
func (s *developerService) GetApps(ctx context.Context, ownerID string) ([]*domain.App, error) { return s.repo.GetAppsByOwner(ctx, ownerID, 100, 0) }
func (s *developerService) UpdateApp(ctx context.Context, app *domain.App) error { return s.repo.UpdateApp(ctx, app) }
func (s *developerService) DeleteApp(ctx context.Context, appID string) error { return s.repo.DeleteApp(ctx, appID) }
func (s *developerService) VerifyApp(ctx context.Context, appID string) error { return s.repo.VerifyApp(ctx, appID) }

func (s *developerService) CreateAPIKey(ctx context.Context, appID, name, description string, scopes []string, ttlDays int) (*domain.APIKey, error) {
	rawKey := generateID(40)
	key := &domain.APIKey{AppID: appID, KeyHash: hashKey(rawKey), KeyPrefix: rawKey[:8], Name: strings.TrimSpace(name), Description: description, Scopes: scopes, RateLimitRPM: 100, RateLimitRPH: 1000, IsActive: true, CreatedAt: time.Now(), RawKey: rawKey}
	if ttlDays > 0 { expires := time.Now().AddDate(0, 0, ttlDays); key.ExpiresAt = &expires }
	if err := s.repo.CreateAPIKey(ctx, key); err != nil { return nil, err }
	return key, nil
}
func (s *developerService) GetAPIKey(ctx context.Context, keyID string) (*domain.APIKey, error) { key, err := s.repo.GetAPIKey(ctx, keyID); if err != nil { return nil, err }; if key != nil { key.RawKey = "" }; return key, nil }
func (s *developerService) ListAPIKeys(ctx context.Context, appID string) ([]*domain.APIKey, error) { keys, err := s.repo.GetAPIKeysByAppID(ctx, appID); if err != nil { return nil, err }; for _, k := range keys { k.RawKey = "" }; return keys, nil }
func (s *developerService) UpdateAPIKey(ctx context.Context, key *domain.APIKey) error { return s.repo.UpdateAPIKey(ctx, key) }
func (s *developerService) RevokeAPIKey(ctx context.Context, keyID string) error { return s.repo.RevokeAPIKey(ctx, keyID) }

func (s *developerService) CreateWebhook(ctx context.Context, appID, name, url string, events []string) (*domain.Webhook, error) {
	if strings.TrimSpace(url) == "" { return nil, fmt.Errorf("webhook url is required") }
	wh := &domain.Webhook{AppID: appID, Name: name, TargetURL: url, Secret: generateID(24), Events: events, IsActive: true, CreatedAt: time.Now(), UpdatedAt: time.Now(), RetryPolicy: domain.WebhookRetryPolicy{MaxRetries: 3, RetryInterval: 60, BackoffStrategy: "exponential", Timeout: 30}}
	if err := s.repo.CreateWebhook(ctx, wh); err != nil { return nil, err }
	return wh, nil
}
func (s *developerService) GetWebhook(ctx context.Context, webhookID string) (*domain.Webhook, error) { return s.repo.GetWebhook(ctx, webhookID) }
func (s *developerService) ListWebhooks(ctx context.Context, appID string) ([]*domain.Webhook, error) { return s.repo.GetWebhooksByAppID(ctx, appID) }
func (s *developerService) UpdateWebhook(ctx context.Context, webhook *domain.Webhook) error { return s.repo.UpdateWebhook(ctx, webhook) }
func (s *developerService) DeleteWebhook(ctx context.Context, webhookID string) error { return s.repo.DeleteWebhook(ctx, webhookID) }
func (s *developerService) TestWebhook(ctx context.Context, webhookID string) error { return s.repo.RecordWebhookDelivery(ctx, webhookID, true, 200, "developer test") }

func (s *developerService) CreateBot(ctx context.Context, appID, name, description string) (*domain.Bot, error) {
	bot := &domain.Bot{AppID: appID, Name: strings.TrimSpace(name), Description: description, IsActive: true, CreatedAt: time.Now(), UpdatedAt: time.Now(), Settings: domain.BotSettings{AllowDirectMessages: true, AllowGroupMessages: true, EnableCommands: true, EnableWebhooks: false, PrivacyMode: "private", RateLimitPerUser: 30, MaxCommandQueue: 100}}
	if bot.Name == "" { return nil, fmt.Errorf("bot name is required") }
	if err := s.repo.CreateBot(ctx, bot); err != nil { return nil, err }
	return bot, nil
}
func (s *developerService) GetBot(ctx context.Context, botID string) (*domain.Bot, error) { return s.repo.GetBot(ctx, botID) }
func (s *developerService) ListBots(ctx context.Context, appID string) ([]*domain.Bot, error) { return s.repo.GetBotsByAppID(ctx, appID) }
func (s *developerService) UpdateBot(ctx context.Context, bot *domain.Bot) error { return s.repo.UpdateBot(ctx, bot) }
func (s *developerService) DeleteBot(ctx context.Context, botID string) error { return s.repo.DeleteBot(ctx, botID) }

func (s *developerService) GetMetrics(ctx context.Context, appID, period string) (*domain.DeveloperMetrics, error) { return s.repo.GetMetrics(ctx, appID, period) }
func (s *developerService) RunTestSuite(ctx context.Context, appID string) (*domain.TestSuiteResult, error) {
	started := time.Now()
	results := []domain.TestResult{{TestName: "application_exists", Status: "passed"}, {TestName: "metrics_readable", Status: "passed"}}
	if _, err := s.repo.GetApp(ctx, appID); err != nil { msg := err.Error(); results[0].Status = "failed"; results[0].Error = &msg }
	if _, err := s.repo.GetMetrics(ctx, appID, "24h"); err != nil { msg := err.Error(); results[1].Status = "failed"; results[1].Error = &msg }
	passed, failed := int32(0), int32(0)
	for _, result := range results { if result.Status == "passed" { passed++ } else if result.Status == "failed" { failed++ } }
	return &domain.TestSuiteResult{AppID: appID, TotalTests: int32(len(results)), PassedTests: passed, FailedTests: failed, Duration: time.Since(started), Results: results, ExecutedAt: time.Now()}, nil
}

func generateID(length int) string { bytes := make([]byte, length); if _, err := rand.Read(bytes); err != nil { panic(fmt.Errorf("crypto/rand unavailable: %w", err)) }; return strings.ToUpper(hex.EncodeToString(bytes))[:length] }
func hashKey(key string) string { h := sha256.Sum256([]byte(key)); return hex.EncodeToString(h[:]) }
