package db

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

// Exec exposes the underlying DBTX executor for operations not yet promoted to
// generated sqlc queries. Prefer explicit sqlc queries for stable hot paths.
func (q *Queries) Exec(ctx context.Context, query string, args ...interface{}) (pgconn.CommandTag, error) {
	return q.db.Exec(ctx, query, args...)
}

// QueryRow exposes the underlying row executor for small compatibility queries.
func (q *Queries) QueryRow(ctx context.Context, query string, args ...interface{}) pgx.Row {
	return q.db.QueryRow(ctx, query, args...)
}
