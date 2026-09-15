package infra

import (
	"context"
	"time"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/search/domain"
	"local/merope/internal/core/util"
	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresSearchRepository struct {
	queries *db.Queries
}

func NewPostgresSearchRepository(queries *db.Queries) *PostgresSearchRepository {
	return &PostgresSearchRepository{queries: queries}
}

func (r *PostgresSearchRepository) Search(ctx context.Context, query string, limit int) ([]*domain.SearchResult, error) {
	var q pgtype.Text
	_ = q.Scan(query)

	rows, err := r.queries.Search(ctx, db.SearchParams{
		Column1: q,
		Limit:   int32(limit),
	})
	if err != nil {
		return nil, err
	}

	results := make([]*domain.SearchResult, 0, len(rows))
	for _, row := range rows {
		results = append(results, &domain.SearchResult{
			Type:     row.Type,
			ID:       util.UUIDToString(row.ID),
			Title:    row.Title,
			Subtitle: row.Subtitle,
			Score:    row.Score,
		})
	}

	return results, nil
}

func (r *PostgresSearchRepository) SaveHistory(ctx context.Context, userID, query string) error {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.SaveHistory(ctx, db.SaveHistoryParams{
		UserID: uid,
		Query:  query,
	})
}

func (r *PostgresSearchRepository) GetHistory(ctx context.Context, userID string) ([]*domain.SearchHistory, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	rows, err := r.queries.GetHistory(ctx, db.GetHistoryParams{
		UserID: uid,
		Limit:  10,
	})
	if err != nil {
		return nil, err
	}

	history := make([]*domain.SearchHistory, len(rows))
	for i, row := range rows {
		createdAt := time.Time{}
		if row.CreatedAt.Valid {
			createdAt = row.CreatedAt.Time
		}
		history[i] = &domain.SearchHistory{
			ID:        util.UUIDToString(row.ID),
			UserID:    util.UUIDToString(row.UserID),
			Query:     row.Query,
			CreatedAt: createdAt,
		}
	}
	return history, nil
}

func (r *PostgresSearchRepository) AddInterest(ctx context.Context, userID, interest string) error {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.AddInterest(ctx, db.AddInterestParams{
		UserID:    uid,
		Interest:  interest,
	})
}

func (r *PostgresSearchRepository) GetInterests(ctx context.Context, userID string) ([]string, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.GetInterests(ctx, uid)
}

func (r *PostgresSearchRepository) UpdateLocation(ctx context.Context, userID string, lat, lon float64, ghost bool) error {
	return nil
}

func (r *PostgresSearchRepository) GetNearby(ctx context.Context, lat, lon, radius float64, limit int) ([]*domain.NearbyUser, error) {
	return nil, nil
}

func (r *PostgresSearchRepository) IndexPost(ctx context.Context, id, content string) error {
	return nil
}

func (r *PostgresSearchRepository) IndexUser(ctx context.Context, id, username string) error {
	return nil
}
