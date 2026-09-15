package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/push/domain"
	"github.com/jackc/pgx/v5/pgxpool"
)

type PostgresPushRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresPushRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresPushRepository {
	return &PostgresPushRepository{queries: queries, pool: pool}
}

func (r *PostgresPushRepository) SaveToken(ctx context.Context, token *domain.PushToken) error {
	_, err := r.pool.Exec(ctx,
		"INSERT INTO push_tokens (user_id, token, token_plain, platform, device_id, app_version, is_active, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())",
		token.UserID, token.Token, token.TokenPlain, token.Platform, token.DeviceID, token.AppVersion, token.IsActive)
	return err
}

func (r *PostgresPushRepository) GetActiveTokens(ctx context.Context, userID string) ([]*domain.PushToken, error) {
	rows, err := r.pool.Query(ctx,
		"SELECT id, user_id, token, token_plain, platform, device_id, app_version, is_active, last_used_at, created_at FROM push_tokens WHERE user_id = $1 AND is_active = TRUE",
		userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	tokens := []*domain.PushToken{}
	for rows.Next() {
		var t domain.PushToken
		err := rows.Scan(&t.ID, &t.UserID, &t.Token, &t.TokenPlain, &t.Platform, &t.DeviceID, &t.AppVersion, &t.IsActive, &t.LastUsedAt, &t.CreatedAt)
		if err != nil {
			continue
		}
		tokens = append(tokens, &t)
	}
	return tokens, nil
}

func (r *PostgresPushRepository) DeactivateToken(ctx context.Context, tokenID string) error {
	_, err := r.pool.Exec(ctx, "UPDATE push_tokens SET is_active = FALSE WHERE id = $1", tokenID)
	return err
}

func (r *PostgresPushRepository) CreateNotification(ctx context.Context, notif *domain.PushNotification) error {
	_, err := r.pool.Exec(ctx,
		"INSERT INTO push_notifications (user_id, title, body, priority, status, created_at) VALUES ($1, $2, $3, $4, $5, NOW())",
		notif.UserID, notif.Title, notif.Body, notif.Priority, notif.Status)
	return err
}

func (r *PostgresPushRepository) UpdateNotificationStatus(ctx context.Context, notifID, status, response string) error {
	_, err := r.pool.Exec(ctx,
		"UPDATE push_notifications SET status = $2, response = $3 WHERE id = $1",
		notifID, status, response)
	return err
}

func (r *PostgresPushRepository) GetPendingNotifications(ctx context.Context, limit int) ([]*domain.PushNotification, error) {
	return nil, nil
}
