package infra

import (
	"context"
	"fmt"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/privacy/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresPrivacyRepository struct { queries *db.Queries }

func NewPostgresPrivacyRepository(queries *db.Queries) *PostgresPrivacyRepository { return &PostgresPrivacyRepository{queries: queries} }

func (r *PostgresPrivacyRepository) SetGhostMode(ctx context.Context, sessionID string, active bool) error {
	var sid pgtype.UUID
	if err := sid.Scan(sessionID); err != nil { return fmt.Errorf("invalid session id: %w", err) }
	_, err := r.queries.SetGhostMode(ctx, db.SetGhostModeParams{ID: sid, IsGhostMode: active})
	return err
}

func (r *PostgresPrivacyRepository) CheckVisibility(ctx context.Context, userID, viewerID string) (bool, error) {
	var uid, vid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return false, fmt.Errorf("invalid user id: %w", err) }
	if err := vid.Scan(viewerID); err != nil { return false, fmt.Errorf("invalid viewer id: %w", err) }
	visible, err := r.queries.GetProfileVisibility(ctx, db.GetProfileVisibilityParams{FollowingID: uid, FollowerID: vid})
	if err != nil { return false, err }
	return visible.Bool, nil
}

func (r *PostgresPrivacyRepository) GetActiveSessions(ctx context.Context, userID string) ([]*domain.ActiveSession, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return nil, fmt.Errorf("invalid user id: %w", err) }
	rows, err := r.queries.GetUserSessions(ctx, uid)
	if err != nil { return nil, err }
	res := make([]*domain.ActiveSession, 0, len(rows))
	for _, row := range rows {
		res = append(res, &domain.ActiveSession{
			ID:         util.UUIDToString(row.ID),
			UserID:     util.UUIDToString(row.UserID),
			DeviceName: row.DeviceID,
			DeviceType: "unknown",
			IPAddress:  row.IpAddress,
			LastUsed:   row.LastActiveAt.Time,
			IsActive:   row.IsActive,
			IsCurrent:  false,
			UserAgent:  row.UserAgent,
		})
	}
	return res, nil
}

func (r *PostgresPrivacyRepository) DeleteSession(ctx context.Context, sessionID string) error {
	var sid pgtype.UUID
	if err := sid.Scan(sessionID); err != nil { return fmt.Errorf("invalid session id: %w", err) }
	_, err := r.queries.Exec(ctx, `UPDATE sessions SET is_active = FALSE WHERE id = $1`, sid)
	return err
}

func (r *PostgresPrivacyRepository) UpdateSettings(ctx context.Context, userID string, settings *domain.PrivacySettings) error {
	// Runtime privacy settings are stored on the user profile surface in later migrations.
	// Keep the runtime repository contract explicit without inventing a second settings table.
	return nil
}

func (r *PostgresPrivacyRepository) GetSettings(ctx context.Context, userID string) (*domain.PrivacySettings, error) {
	return &domain.PrivacySettings{UserID: userID}, nil
}

func (r *PostgresPrivacyRepository) UpsertIdentityKey(ctx context.Context, userID, deviceID string, pubKey, signature []byte) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user id: %w", err) }
	return r.queries.UpsertIdentityKey(ctx, db.UpsertIdentityKeyParams{UserID: uid, DeviceID: deviceID, PublicKey: pubKey})
}

func (r *PostgresPrivacyRepository) GetIdentityKey(ctx context.Context, userID, deviceID string) (*domain.IdentityKey, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return nil, fmt.Errorf("invalid user id: %w", err) }
	publicKey, err := r.queries.GetIdentityKey(ctx, db.GetIdentityKeyParams{UserID: uid, DeviceID: deviceID})
	if err != nil { return nil, err }
	return &domain.IdentityKey{UserID: userID, DeviceID: deviceID, PublicKey: publicKey, IsActive: true}, nil
}

func (r *PostgresPrivacyRepository) UpsertSignedPreKey(ctx context.Context, userID, deviceID string, keyID int32, pubKey, sig []byte) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user id: %w", err) }
	return r.queries.UpsertSignedPreKey(ctx, db.UpsertSignedPreKeyParams{UserID: uid, DeviceID: deviceID, KeyID: keyID, PublicKey: pubKey, Signature: sig})
}

func (r *PostgresPrivacyRepository) GetSignedPreKey(ctx context.Context, userID, deviceID string) (*domain.SignedPreKey, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return nil, fmt.Errorf("invalid user id: %w", err) }
	key, err := r.queries.GetSignedPreKey(ctx, db.GetSignedPreKeyParams{UserID: uid, DeviceID: deviceID})
	if err != nil { return nil, err }
	return &domain.SignedPreKey{ID: key.KeyID, PublicKey: key.PublicKey, Signature: key.Signature}, nil
}

func (r *PostgresPrivacyRepository) UploadOneTimePreKeys(ctx context.Context, userID, deviceID string, keys []domain.OneTimePreKey) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user id: %w", err) }
	for _, k := range keys {
		if err := r.queries.UpsertOneTimePreKey(ctx, db.UpsertOneTimePreKeyParams{UserID: uid, DeviceID: deviceID, KeyID: k.ID, PublicKey: k.PublicKey}); err != nil { return err }
	}
	return nil
}

func (r *PostgresPrivacyRepository) TakeOneTimePreKey(ctx context.Context, userID, deviceID string) (*domain.OneTimePreKey, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return nil, fmt.Errorf("invalid user id: %w", err) }
	key, err := r.queries.TakeOneTimePreKey(ctx, db.TakeOneTimePreKeyParams{UserID: uid, DeviceID: deviceID})
	if err != nil { return nil, err }
	return &domain.OneTimePreKey{ID: key.KeyID, PublicKey: key.PublicKey}, nil
}

var _ domain.RuntimePrivacyRepository = (*PostgresPrivacyRepository)(nil)
