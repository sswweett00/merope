package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/privacy/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresPrivacyRepository struct {
	queries *db.Queries
}

func NewPostgresPrivacyRepository(queries *db.Queries) *PostgresPrivacyRepository {
	return &PostgresPrivacyRepository{queries: queries}
}

func (r *PostgresPrivacyRepository) SetGhostMode(ctx context.Context, sessionID string, active bool) error {
	var sid pgtype.UUID
	_ = sid.Scan(sessionID)
	_, err := r.queries.SetGhostMode(ctx, db.SetGhostModeParams{
		ID:          sid,
		IsGhostMode: active,
	})
	return err
}

func (r *PostgresPrivacyRepository) CheckVisibility(ctx context.Context, userID, viewerID string) (bool, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	var vid pgtype.UUID
	_ = vid.Scan(viewerID)

	visible, err := r.queries.GetProfileVisibility(ctx, db.GetProfileVisibilityParams{
		FollowingID: uid,
		FollowerID:  vid,
	})
	if err != nil {
		return false, err
	}

	return visible.Bool, nil
}

func (r *PostgresPrivacyRepository) GetActiveSessions(ctx context.Context, userID string) ([]*domain.ActiveSession, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	sessions, err := r.queries.GetUserSessions(ctx, uid)
	if err != nil {
		return nil, err
	}
	var domainSessions []*domain.ActiveSession
	for _, s := range sessions {
		domainSessions = append(domainSessions, &domain.ActiveSession{
			ID:       util.UUIDToString(s.ID),
			Device:   s.DeviceID,
			IP:       s.IpAddress,
			LastUsed: s.LastActiveAt.Time.Unix(),
		})
	}
	return domainSessions, nil
}

func (r *PostgresPrivacyRepository) DeleteSession(ctx context.Context, sessionID string) error {
	// Note: You might need to add DeleteSession to query.sql
	return nil
}

func (r *PostgresPrivacyRepository) UpdateSettings(ctx context.Context, userID string, settings *domain.PrivacySettings) error {
	// Note: You might need to add UpdatePrivacySettings to query.sql
	return nil
}

func (r *PostgresPrivacyRepository) GetSettings(ctx context.Context, userID string) (*domain.PrivacySettings, error) {
	return &domain.PrivacySettings{UserID: userID}, nil
}

// E2EE Implementation
func (r *PostgresPrivacyRepository) UpsertIdentityKey(ctx context.Context, userID, deviceID string, pubKey []byte) error {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.UpsertIdentityKey(ctx, db.UpsertIdentityKeyParams{
		UserID:    uid,
		DeviceID:  deviceID,
		PublicKey: pubKey,
	})
}

func (r *PostgresPrivacyRepository) GetIdentityKey(ctx context.Context, userID, deviceID string) ([]byte, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.GetIdentityKey(ctx, db.GetIdentityKeyParams{
		UserID:   uid,
		DeviceID: deviceID,
	})
}

func (r *PostgresPrivacyRepository) UpsertSignedPreKey(ctx context.Context, userID, deviceID string, keyID int32, pubKey, sig []byte) error {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	return r.queries.UpsertSignedPreKey(ctx, db.UpsertSignedPreKeyParams{
		UserID:    uid,
		DeviceID:  deviceID,
		KeyID:     keyID,
		PublicKey: pubKey,
		Signature: sig,
	})
}

func (r *PostgresPrivacyRepository) GetSignedPreKey(ctx context.Context, userID, deviceID string) (*domain.SignedPreKey, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	key, err := r.queries.GetSignedPreKey(ctx, db.GetSignedPreKeyParams{
		UserID:   uid,
		DeviceID: deviceID,
	})
	if err != nil {
		return nil, err
	}
	return &domain.SignedPreKey{
		ID:        key.KeyID,
		PublicKey: key.PublicKey,
		Signature: key.Signature,
	}, nil
}

func (r *PostgresPrivacyRepository) UploadOneTimePreKeys(ctx context.Context, userID, deviceID string, keys []domain.OneTimePreKey) error {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	for _, k := range keys {
		err := r.queries.UpsertOneTimePreKey(ctx, db.UpsertOneTimePreKeyParams{
			UserID:    uid,
			DeviceID:  deviceID,
			KeyID:     k.ID,
			PublicKey: k.PublicKey,
		})
		if err != nil {
			return err
		}
	}
	return nil
}

func (r *PostgresPrivacyRepository) TakeOneTimePreKey(ctx context.Context, userID, deviceID string) (*domain.OneTimePreKey, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	key, err := r.queries.TakeOneTimePreKey(ctx, db.TakeOneTimePreKeyParams{
		UserID:   uid,
		DeviceID: deviceID,
	})
	if err != nil {
		return nil, err
	}
	return &domain.OneTimePreKey{
		ID:        key.KeyID,
		PublicKey: key.PublicKey,
	}, nil
}
