package db

import (
	"context"
	"github.com/jackc/pgx/v5/pgconn"
)

// Exec exposes the underlying DBTX executor for repositories that need an
// operation not yet promoted to a generated sqlc query. New code should prefer
// explicit sqlc queries where practical.
func (q *Queries) Exec(ctx context.Context, query string, args ...interface{}) (pgconn.CommandTag, error) {
	return q.db.Exec(ctx, query, args...)
}
