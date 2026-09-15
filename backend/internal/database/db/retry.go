package db

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

type RetriableDB struct {
	db DBTX
}

func NewRetriable(db DBTX) *RetriableDB {
	return &RetriableDB{db: db}
}

func (r *RetriableDB) Exec(ctx context.Context, sql string, args ...interface{}) (pgconn.CommandTag, error) {
	var tag pgconn.CommandTag
	var err error

	// Basit bir retry mekanizması (3 deneme)
	for i := 0; i < 3; i++ {
		tag, err = r.db.Exec(ctx, sql, args...)
		if err == nil {
			return tag, nil
		}
		time.Sleep(time.Duration(i*100) * time.Millisecond)
	}
	return tag, err
}

func (r *RetriableDB) Query(ctx context.Context, sql string, args ...interface{}) (pgx.Rows, error) {
	return r.db.Query(ctx, sql, args...)
}

func (r *RetriableDB) QueryRow(ctx context.Context, sql string, args ...interface{}) pgx.Row {
	return r.db.QueryRow(ctx, sql, args...)
}
