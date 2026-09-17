package infra

import (
	"context"
	"errors"

	"local/merope/internal/modules/content/domain"
)

func (r *ScyllaContentRepository) DeleteNode(ctx context.Context, nodeID string) error {
	return errors.New("content node deletion uses PostgreSQL as source of truth")
}

var _ interface {
	UpdateSignalStatus(context.Context, string, bool, bool, bool) error
	GetStream(context.Context, string, int32, int32) ([]*domain.Signal, error)
	AddResonance(context.Context, string, string, int) error
	CreateNode(context.Context, string, string, *string, string) (*domain.Node, error)
	GetNodesForSignal(context.Context, string) ([]*domain.Node, error)
} = (*ScyllaContentRepository)(nil)
