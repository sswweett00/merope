package db

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

// GetGlobalUserRegistry preserves the generated-query contract expected by
// the identity repository while keeping the registry query in the shared DB layer.
func (q *Queries) GetGlobalUserRegistry(ctx context.Context, userID pgtype.UUID) pgx.Row {
	return q.db.QueryRow(ctx, `SELECT system_type FROM global_user_registry WHERE user_id = $1`, userID)
}
