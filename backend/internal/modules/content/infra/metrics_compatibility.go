package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *PostgresContentRepository) UpdateSignalMetrics(ctx context.Context, signalID string, viewCount, commentCount, shareCount int) error {
	var id pgtype.UUID
	if err := id.Scan(signalID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `
UPDATE posts
SET view_count = $2,
    comment_count = $3,
    share_count = $4,
    updated_at = NOW()
WHERE id = $1`, id, viewCount, commentCount, shareCount)
	return err
}
