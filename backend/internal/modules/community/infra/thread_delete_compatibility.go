package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) DeleteThread(ctx context.Context, threadID string) error {
	threadID = strings.TrimSpace(threadID)
	if threadID == "" {
		return fmt.Errorf("thread id is required")
	}

	var id pgtype.UUID
	if err := id.Scan(threadID); err != nil {
		return fmt.Errorf("invalid thread uuid: %w", err)
	}

	tx, err := r.queries.Exec(ctx, `DELETE FROM thread_replies WHERE thread_id = $1`, id)
	if err != nil {
		return err
	}
	_ = tx
	_, err = r.queries.Exec(ctx, `DELETE FROM threads WHERE id = $1`, id)
	return err
}
