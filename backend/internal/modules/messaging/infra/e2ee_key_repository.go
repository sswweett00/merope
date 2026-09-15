package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
	"local/merope/internal/modules/messaging/domain"
)

type PostgresE2EEPublicKeyRepository struct {
	pool *pgxpool.Pool
}

func NewPostgresE2EEPublicKeyRepository(pool *pgxpool.Pool) *PostgresE2EEPublicKeyRepository {
	return &PostgresE2EEPublicKeyRepository{pool: pool}
}

func (r *PostgresE2EEPublicKeyRepository) GetPublicKey(ctx context.Context, userID string) (*domain.E2EEPublicKey, error) {
	if r == nil || r.pool == nil {
		return nil, fmt.Errorf("e2ee public key repository unavailable")
	}
	var key domain.E2EEPublicKey
	if err := r.pool.QueryRow(ctx,
		`SELECT user_id, public_key, algorithm
		 FROM user_e2ee_public_keys
		 WHERE user_id = $1`, userID).Scan(&key.UserID, &key.PublicKey, &key.Algorithm); err != nil {
		return nil, err
	}
	return &key, nil
}

func (r *PostgresE2EEPublicKeyRepository) UpsertPublicKey(ctx context.Context, userID, publicKey, algorithm string) error {
	if r == nil || r.pool == nil {
		return fmt.Errorf("e2ee public key repository unavailable")
	}
	_, err := r.pool.Exec(ctx,
		`INSERT INTO user_e2ee_public_keys (user_id, public_key, algorithm, updated_at)
		 VALUES ($1, $2, $3, NOW())
		 ON CONFLICT (user_id) DO UPDATE
		 SET public_key = EXCLUDED.public_key,
		     algorithm = EXCLUDED.algorithm,
		     updated_at = NOW()`,
		userID, publicKey, algorithm)
	return err
}
