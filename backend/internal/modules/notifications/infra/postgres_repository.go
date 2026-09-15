package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/notifications/domain"
)

type PostgresNotificationsRepository struct {
	queries *db.Queries
}

func NewPostgresNotificationsRepository(queries *db.Queries) *PostgresNotificationsRepository {
	return &PostgresNotificationsRepository{queries: queries}
}

func (r *PostgresNotificationsRepository) Create(ctx context.Context, n *domain.Notification) error {
	return nil
}

func (r *PostgresNotificationsRepository) GetForUser(ctx context.Context, userID string, limit, offset int32) ([]*domain.Notification, error) {
	return nil, nil
}

func (r *PostgresNotificationsRepository) MarkAsRead(ctx context.Context, id, userID string) error {
	return nil
}
