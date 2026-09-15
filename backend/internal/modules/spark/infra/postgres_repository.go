package infra

import (
	"context"
	"local/merope/internal/database/db"
	sparkDomain "local/merope/internal/modules/spark/domain"
	"local/merope/internal/core/util"
)

type PostgresSparkRepository struct {
	queries *db.Queries
}

func NewPostgresSparkRepository(queries *db.Queries) *PostgresSparkRepository {
	return &PostgresSparkRepository{queries: queries}
}

func (r *PostgresSparkRepository) FindMatch(ctx context.Context, userID string) (*sparkDomain.Match, error) {
	row, err := r.queries.FindMatch(ctx, util.StringToUUID(userID))
	if err != nil {
		return nil, err
	}
	return &sparkDomain.Match{
		UserAID: userID,
		UserBID: util.UUIDToString(row.UserBID),
		Score:   row.Score,
	}, nil
}

func (r *PostgresSparkRepository) GetResonanceScore(ctx context.Context, userAID, userBID string) (float64, error) {
	score, err := r.queries.GetResonanceScore(ctx, db.GetResonanceScoreParams{
		UserID:   util.StringToUUID(userAID),
		UserID_2: util.StringToUUID(userBID),
	})
	if err != nil {
		return 0, err
	}
	return score, nil
}
