package infra

import (
	"context"

	"local/merope/internal/database/db"
	"local/merope/internal/modules/content/domain"
)

// FastPostgresContentRepository keeps the existing repository contract while
// routing the feed hot path through the lean query implementation.
type FastPostgresContentRepository struct {
	*PostgresContentRepository
}

func NewFastPostgresContentRepository(queries *db.Queries) *FastPostgresContentRepository {
	return &FastPostgresContentRepository{
		PostgresContentRepository: NewPostgresContentRepository(queries),
	}
}

func (r *FastPostgresContentRepository) GetStream(ctx context.Context, userID string, limit, offset int32) ([]*domain.Signal, error) {
	return r.getStreamFast(ctx, userID, limit, offset)
}
