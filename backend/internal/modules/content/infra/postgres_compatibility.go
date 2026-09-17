package infra

import (
	"context"
	"fmt"

	"local/merope/internal/modules/content/domain"
	"github.com/jackc/pgx/v5/pgtype"
)

func (r *PostgresContentRepository) DeleteNode(ctx context.Context, nodeID string) error {
	var id pgtype.UUID
	if err := id.Scan(nodeID); err != nil {
		return fmt.Errorf("invalid node uuid: %w", err)
	}
	return r.queries.DeleteComment(ctx, id)
}

var _ domain.ContentRepository = (*PostgresContentRepository)(nil)
