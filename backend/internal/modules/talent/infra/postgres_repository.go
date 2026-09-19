package infra

import (
	"context"

	"local/merope/internal/database/db"
	"local/merope/internal/modules/talent/domain"
)

type PostgresTalentRepository struct {
	queries *db.Queries
}

func NewPostgresTalentRepository(queries *db.Queries) *PostgresTalentRepository {
	return &PostgresTalentRepository{queries: queries}
}

func (r *PostgresTalentRepository) CreateJob(ctx context.Context, j *domain.Job) error {
	return nil
}

func (r *PostgresTalentRepository) GetJobs(ctx context.Context) ([]*domain.Job, error) {
	return nil, nil
}

func (r *PostgresTalentRepository) Apply(ctx context.Context, app *domain.JobApplication) error {
	return nil
}

func (r *PostgresTalentRepository) GetProfile(ctx context.Context, userID string) (*domain.ProfessionalProfile, error) {
	return nil, nil
}

func (r *PostgresTalentRepository) UpdateProfile(ctx context.Context, profile *domain.ProfessionalProfile) error {
	return nil
}
