package infra

import (
	"context"
	"errors"

	"local/merope/internal/modules/content/domain"
)

func (r *ScyllaContentRepository) DeleteNode(ctx context.Context, nodeID string) error {
	// PostgreSQL remains the source of truth for comment lifecycle operations.
	// The Scylla mirror does not expose a safe node-only delete without the
	// signal partition key, so the primary repository owns deletion.
	return errors.New("content node deletion uses PostgreSQL as source of truth")
}

var _ domain.ContentRepository = (*ScyllaContentRepository)(nil)
