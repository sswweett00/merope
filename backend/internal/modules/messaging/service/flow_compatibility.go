package service

import (
	"context"

	"local/merope/internal/modules/messaging/domain"
)

func (s *HighPerformanceMessagingService) UpdateFlowState(ctx context.Context, state *domain.FlowState) error {
	if state == nil { return nil }
	return nil
}

func (s *HighPerformanceMessagingService) GetFlowState(ctx context.Context, userID string) (*domain.FlowState, error) {
	return nil, nil
}

var _ interface {
	UpdateFlowState(context.Context, *domain.FlowState) error
	GetFlowState(context.Context, string) (*domain.FlowState, error)
} = (*HighPerformanceMessagingService)(nil)
