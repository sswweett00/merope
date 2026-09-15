package infra

import (
	"context"
	"encoding/json"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/developer/domain"
	"local/merope/internal/core/util"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresDeveloperRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresDeveloperRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresDeveloperRepository {
	return &PostgresDeveloperRepository{queries: queries, pool: pool}
}

func (r *PostgresDeveloperRepository) CreateApp(ctx context.Context, app *domain.App) error {
	var dbID pgtype.UUID
	err := r.pool.QueryRow(ctx,
		"INSERT INTO developer_apps (owner_id, name, client_id, client_secret) VALUES ($1, $2, $3, $4) RETURNING id",
		app.OwnerID, app.Name, app.ClientID, app.ClientSecret).Scan(&dbID)
	if err != nil {
		return err
	}
	app.ID = util.UUIDToString(dbID)
	return nil
}

func (r *PostgresDeveloperRepository) GetAppByClientID(ctx context.Context, clientID string) (*domain.App, error) {
	var app domain.App
	err := r.pool.QueryRow(ctx,
		"SELECT id, owner_id, name, client_id, client_secret, redirect_uri FROM developer_apps WHERE client_id = $1",
		clientID).Scan(&app.ID, &app.OwnerID, &app.Name, &app.ClientID, &app.ClientSecret, &app.RedirectURI)
	if err != nil {
		return nil, err
	}
	return &app, nil
}

func (r *PostgresDeveloperRepository) CreateWebhook(ctx context.Context, webhook *domain.Webhook) error {
	return nil
}

func (r *PostgresDeveloperRepository) GetMetrics(ctx context.Context, appID string) (*domain.Metrics, error) {
	return &domain.Metrics{SyncRate: 0, Latency: 0, Load: 0}, nil
}

func (r *PostgresDeveloperRepository) GetWebhooksByAppID(ctx context.Context, appID string) ([]*domain.Webhook, error) {
	return nil, nil
}

func (r *PostgresDeveloperRepository) CreateAPIKey(ctx context.Context, key *domain.APIKey) error {
	_, err := r.pool.Exec(ctx,
		"INSERT INTO api_keys (app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, created_at) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())",
		key.AppID, key.KeyHash, key.KeyPrefix, key.Name, key.Scopes, key.RateLimitRPM, key.IsActive)
	return err
}

func (r *PostgresDeveloperRepository) GetAPIKeyByHash(ctx context.Context, keyHash string) (*domain.APIKey, error) {
	row := r.pool.QueryRow(ctx,
		"SELECT id, app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, last_used_at, expires_at, created_at FROM api_keys WHERE key_hash = $1 AND is_active = TRUE",
		keyHash)

	var key domain.APIKey
	var scopesJSON []byte
	var lastUsed, expires pgtype.Timestamptz
	err := row.Scan(&key.ID, &key.AppID, &key.KeyHash, &key.KeyPrefix, &key.Name, &scopesJSON, &key.RateLimitRPM, &key.IsActive, &lastUsed, &expires, &key.CreatedAt)
	if err != nil {
		return nil, err
	}

	json.Unmarshal(scopesJSON, &key.Scopes)
	if lastUsed.Valid {
		key.LastUsedAt = &lastUsed.Time
	}
	if expires.Valid {
		key.ExpiresAt = &expires.Time
	}

	return &key, nil
}

func (r *PostgresDeveloperRepository) GetAPIKeysByAppID(ctx context.Context, appID string) ([]*domain.APIKey, error) {
	rows, err := r.pool.Query(ctx,
		"SELECT id, app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, last_used_at, expires_at, created_at FROM api_keys WHERE app_id = $1 ORDER BY created_at DESC",
		appID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	keys := []*domain.APIKey{}
	for rows.Next() {
		var key domain.APIKey
		var scopesJSON []byte
		var lastUsed, expires pgtype.Timestamptz
		err := rows.Scan(&key.ID, &key.AppID, &key.KeyHash, &key.KeyPrefix, &key.Name, &scopesJSON, &key.RateLimitRPM, &key.IsActive, &lastUsed, &expires, &key.CreatedAt)
		if err != nil {
			continue
		}
		json.Unmarshal(scopesJSON, &key.Scopes)
		if lastUsed.Valid {
			key.LastUsedAt = &lastUsed.Time
		}
		if expires.Valid {
			key.ExpiresAt = &expires.Time
		}
		keys = append(keys, &key)
	}
	return keys, nil
}

func (r *PostgresDeveloperRepository) UpdateAPIKeyUsage(ctx context.Context, keyID string) error {
	_, err := r.pool.Exec(ctx, "UPDATE api_keys SET last_used_at = NOW() WHERE id = $1", keyID)
	return err
}

func (r *PostgresDeveloperRepository) RevokeAPIKey(ctx context.Context, keyID string) error {
	_, err := r.pool.Exec(ctx, "UPDATE api_keys SET is_active = FALSE WHERE id = $1", keyID)
	return err
}
