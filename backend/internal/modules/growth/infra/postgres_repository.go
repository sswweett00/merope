package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/growth/domain"
)

type PostgresGrowthRepository struct {
	queries *db.Queries
}

func NewPostgresGrowthRepository(queries *db.Queries) *PostgresGrowthRepository {
	return &PostgresGrowthRepository{queries: queries}
}

func (r *PostgresGrowthRepository) CreateReferral(ctx context.Context, ref *domain.Referral) error {
	return nil
}

func (r *PostgresGrowthRepository) UpdateInfluence(ctx context.Context, userID string, delta float64) error {
	return nil
}

func (r *PostgresGrowthRepository) GetLeaderboard(ctx context.Context, limit int) ([]*domain.InfluenceRank, error) {
	return nil, nil
}
