package service

import (
	"context"

	"local/merope/internal/modules/messaging/domain"
)

func (s *HighPerformanceMessagingService) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	return s.pgRepo.GetMessageHistory(ctx, messageID)
}
