package db

import (
	"context"
	"github.com/jackc/pgx/v5/pgtype"
)

// DeleteComment deletes a content comment by id. The comments table is part of
// the content model consumed by sqlc-generated comment queries.
func (q *Queries) DeleteComment(ctx context.Context, id pgtype.UUID) error {
	_, err := q.db.Exec(ctx, `DELETE FROM comments WHERE id = $1`, id)
	return err
}
