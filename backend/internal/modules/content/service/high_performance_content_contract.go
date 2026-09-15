package service

import (
	"context"
	"time"

	"local/merope/internal/modules/content/domain"
)

func (s *HighPerformanceContentService) GetSignal(ctx context.Context, signalID string) (*domain.Signal, error) {
	return s.pgRepo.GetSignalByID(ctx, signalID)
}

func (s *HighPerformanceContentService) GetUserSignals(ctx context.Context, userID string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	return s.pgRepo.GetSignalsByUser(ctx, userID, limit, page*limit)
}

func (s *HighPerformanceContentService) GetHashtagSignals(ctx context.Context, hashtag string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	return s.pgRepo.GetSignalsByHashtag(ctx, hashtag, limit, page*limit)
}

func (s *HighPerformanceContentService) GetTrendingContent(ctx context.Context, limit int32) ([]*domain.Signal, error) {
	return s.pgRepo.GetTrendingSignals(ctx, limit)
}

func (s *HighPerformanceContentService) SearchContent(ctx context.Context, query string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	return s.pgRepo.SearchSignals(ctx, query, limit, page*limit)
}

func (s *HighPerformanceContentService) ShareSignal(ctx context.Context, userID, signalID string) error {
	return s.pgRepo.UpdateSignalMetrics(ctx, signalID, 0, 0, 1)
}

func (s *HighPerformanceContentService) ViewSignal(ctx context.Context, userID, signalID string) error {
	return s.pgRepo.UpdateSignalMetrics(ctx, signalID, 1, 0, 0)
}

func (s *HighPerformanceContentService) UpdateSignal(ctx context.Context, signal *domain.Signal) error {
	return s.pgRepo.UpdateSignal(ctx, signal)
}

func (s *HighPerformanceContentService) DeleteSignal(ctx context.Context, signalID string) error {
	return s.pgRepo.DeleteSignal(ctx, signalID)
}

func (s *HighPerformanceContentService) UpdateNode(ctx context.Context, nodeID, content string) error {
	return s.pgRepo.UpdateNode(ctx, nodeID, content)
}

func (s *HighPerformanceContentService) DeleteNode(ctx context.Context, nodeID string) error {
	return s.pgRepo.DeleteNode(ctx, nodeID)
}

func (s *HighPerformanceContentService) GetWavePool(ctx context.Context, signalID string) (*domain.WavePoolData, error) {
	return s.pgRepo.GetWavePoolBySignal(ctx, signalID)
}

func (s *HighPerformanceContentService) GetUserMentions(ctx context.Context, userID string, page int32) ([]*domain.Mention, error) {
	limit := int32(50)
	return s.pgRepo.GetMentionsForUser(ctx, userID, limit, page*limit)
}

func (s *HighPerformanceContentService) GetTrendingHashtags(ctx context.Context, limit int32) ([]string, error) {
	return s.pgRepo.GetTrendingFrequencies(ctx, limit)
}

func (s *HighPerformanceContentService) CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error) {
	return s.pgRepo.CreateVault(ctx, ownerID, name, isPrivate)
}

func (s *HighPerformanceContentService) SaveToVault(ctx context.Context, userID, signalID string, vaultID *string) error {
	return s.pgRepo.VaultSignal(ctx, userID, signalID, vaultID)
}

func (s *HighPerformanceContentService) GetUserVaults(ctx context.Context, userID string) ([]*domain.Vault, error) {
	return s.pgRepo.GetUserVaults(ctx, userID)
}

func (s *HighPerformanceContentService) GetVaultContent(ctx context.Context, vaultID string) ([]*domain.Signal, error) {
	return s.pgRepo.GetVaultSignals(ctx, vaultID)
}

func (s *HighPerformanceContentService) ScheduleContent(ctx context.Context, signalID string, scheduledAt time.Time) error {
	return s.pgRepo.ScheduleSignal(ctx, signalID, scheduledAt)
}

func (s *HighPerformanceContentService) GetScheduledContent(ctx context.Context, userID string) ([]*domain.Signal, error) {
	return s.pgRepo.GetScheduledSignals(ctx, userID)
}

func (s *HighPerformanceContentService) GenerateLinkPreview(ctx context.Context, url string) (*domain.LinkPreview, error) {
	return &domain.LinkPreview{URL: url}, nil
}
