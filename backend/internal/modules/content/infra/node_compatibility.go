package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *PostgresContentRepository) UpdateNode(ctx context.Context, nodeID, content string) error {
	var id pgtype.UUID
	if err := id.Scan(nodeID); err != nil {
		return fmt.Errorf("invalid node uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `
UPDATE comments
SET content = $2,
    updated_at = NOW()
WHERE id = $1`, id, content)
	return err
}
