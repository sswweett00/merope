package db

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

func (q *Queries) Exec(ctx context.Context, query string, args ...interface{}) (pgconn.CommandTag, error) {
	return q.db.Exec(ctx, query, args...)
}

func (q *Queries) Query(ctx context.Context, query string, args ...interface{}) (pgx.Rows, error) {
	return q.db.Query(ctx, query, args...)
}

func (q *Queries) QueryRow(ctx context.Context, query string, args ...interface{}) pgx.Row {
	return q.db.QueryRow(ctx, query, args...)
}
