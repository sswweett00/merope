package infra

import (
	"context"
	"fmt"
	"local/merope/internal/database/db"
	"local/merope/internal/core/audit"
	"local/merope/internal/modules/identity/domain"
	"local/merope/internal/platform/redis"
	"local/merope/internal/core/util"
	"encoding/json"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

type HybridIdentityRepository struct {
	personalRepo  *PostgresIdentityRepository
	corporateRepo *PostgresIdentityRepository
	cache         *redis.Client
}

func NewHybridIdentityRepository(personalQueries, corporateQueries *db.Queries, cache *redis.Client, auditor audit.Auditor) *HybridIdentityRepository {
	return &HybridIdentityRepository{
		personalRepo:  NewPostgresIdentityRepository(personalQueries, cache, auditor),
		corporateRepo: NewPostgresIdentityRepository(corporateQueries, cache, auditor),
		cache:         cache,
	}
}

func (r *HybridIdentityRepository) getRepoBySystem(sys domain.SystemType) *PostgresIdentityRepository {
	if sys == domain.SystemCorporate {
		return r.corporateRepo
	}
	return r.personalRepo
}

func (r *HybridIdentityRepository) resolveSystem(ctx context.Context, userID string) (domain.SystemType, error) {
	cacheKey := "sys:" + userID
	val, err := r.cache.Conn.Get(ctx, cacheKey).Result()
	if err == nil {
		return domain.SystemType(val), nil
	}

	// Zenith: Use Core DB for Global User Registry resolution
	var sys string
	err = r.personalRepo.queries.GetGlobalUserRegistry(ctx, util.StringToUUID(userID)).Scan(&sys)
	if err == nil {
		_ = r.cache.Conn.Set(ctx, cacheKey, sys, 24*time.Hour)
		return domain.SystemType(sys), nil
	}

	return domain.SystemPersonal, nil
}

func (r *HybridIdentityRepository) CreateUser(ctx context.Context, u *domain.User) error {
	repo := r.getRepoBySystem(u.SystemType)
	err := repo.CreateUser(ctx, u)
	if err == nil {
		// Update global registry
		_ = r.cache.Conn.Set(ctx, "sys:"+u.ID, string(u.SystemType), 0).Err()
	}
	return err
}

func (r *HybridIdentityRepository) GetUserByID(ctx context.Context, id string) (*domain.User, error) {
	sys, _ := r.resolveSystem(ctx, id)
	return r.getRepoBySystem(sys).GetUserByID(ctx, id)
}

func (r *HybridIdentityRepository) GetUserByIdentifier(ctx context.Context, identifier string) (*domain.User, error) {
	// For identifier lookup (login), we might need to check both if not cached
	user, err := r.personalRepo.GetUserByIdentifier(ctx, identifier)
	if err == nil {
		user.SystemType = domain.SystemPersonal
		return user, nil
	}
	user, err = r.corporateRepo.GetUserByIdentifier(ctx, identifier)
	if err == nil {
		user.SystemType = domain.SystemCorporate
		return user, nil
	}
	return nil, err
}

func (r *HybridIdentityRepository) UpdateUser(ctx context.Context, u *domain.User) error {
	return r.getRepoBySystem(u.SystemType).UpdateUser(ctx, u)
}

func (r *HybridIdentityRepository) UpdateMFA(ctx context.Context, userID string, enabled bool, secret string) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).UpdateMFA(ctx, userID, enabled, secret)
}

func (r *HybridIdentityRepository) CreateSession(ctx context.Context, s *domain.Session) error {
	sys, _ := r.resolveSystem(ctx, s.UserID)
	return r.getRepoBySystem(sys).CreateSession(ctx, s)
}

func (r *HybridIdentityRepository) GetSessions(ctx context.Context, userID string) ([]*domain.Session, error) {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).GetSessions(ctx, userID)
}

func (r *HybridIdentityRepository) RevokeSession(ctx context.Context, sessionID, userID string) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).RevokeSession(ctx, sessionID, userID)
}

func (r *HybridIdentityRepository) UpdateOnlineStatus(ctx context.Context, userID string, isOnline bool) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).UpdateOnlineStatus(ctx, userID, isOnline)
}

func (r *HybridIdentityRepository) SetProfileLock(ctx context.Context, userID string, locked bool) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).SetProfileLock(ctx, userID, locked)
}

func (r *HybridIdentityRepository) IncrementFailedLogin(ctx context.Context, userID string) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).IncrementFailedLogin(ctx, userID)
}

func (r *HybridIdentityRepository) ResetFailedLogin(ctx context.Context, userID string) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).ResetFailedLogin(ctx, userID)
}

func (r *HybridIdentityRepository) LockAccount(ctx context.Context, userID string, until time.Time) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).LockAccount(ctx, userID, until)
}

func (r *HybridIdentityRepository) AddKeywordFilter(ctx context.Context, userID, keyword string) error {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).AddKeywordFilter(ctx, userID, keyword)
}

func (r *HybridIdentityRepository) GetKeywordFilters(ctx context.Context, userID string) ([]string, error) {
	sys, _ := r.resolveSystem(ctx, userID)
	return r.getRepoBySystem(sys).GetKeywordFilters(ctx, userID)
}

func (r *HybridIdentityRepository) BlacklistToken(ctx context.Context, tokenID string, expiration time.Duration) error {
	return r.personalRepo.BlacklistToken(ctx, tokenID, expiration) // Shared cache usually
}

func (r *HybridIdentityRepository) StoreRefreshToken(ctx context.Context, userID, refreshToken string, expiration time.Duration) error {
	return r.personalRepo.StoreRefreshToken(ctx, userID, refreshToken, expiration)
}

func (r *HybridIdentityRepository) ValidateRefreshToken(ctx context.Context, refreshToken string) (string, error) {
	return r.personalRepo.ValidateRefreshToken(ctx, refreshToken)
}

type PostgresIdentityRepository struct {
	queries *db.Queries
	cache   *redis.Client
	auditor audit.Auditor
}

func NewPostgresIdentityRepository(queries *db.Queries, cache *redis.Client, auditor audit.Auditor) *PostgresIdentityRepository {
	return &PostgresIdentityRepository{queries: queries, cache: cache, auditor: auditor}
}

func (r *PostgresIdentityRepository) CreateUser(ctx context.Context, u *domain.User) error {
	params := db.CreateUserParams{
		Username:     u.Username,
		Email:        u.Email,
		PasswordHash: u.PasswordHash,
		AvatarUrl:    pgtype.Text{String: u.AvatarURL, Valid: u.AvatarURL != ""},
	}

	dbUser, err := r.queries.CreateUser(ctx, params)
	if err != nil {
		return fmt.Errorf("failed to create user: %w", err)
	}

	u.ID = util.UUIDToString(dbUser.ID)
	u.CreatedAt = dbUser.CreatedAt.Time
	u.UpdatedAt = dbUser.UpdatedAt.Time

	r.auditor.Record(ctx, audit.Event{
		Action:   "USER_CREATED",
		UserID:   u.ID,
		Entity:   "user",
		EntityID: u.ID,
		Status:   "success",
		Timestamp: time.Now(),
	})

	return nil
}

func (r *PostgresIdentityRepository) GetUserByID(ctx context.Context, id string) (*domain.User, error) {
	cacheKey := "user:" + id
	if val, err := r.cache.Conn.Get(ctx, cacheKey).Result(); err == nil {
		var u domain.User
		if err := json.Unmarshal([]byte(val), &u); err == nil {
			return &u, nil
		}
	}

	var uid pgtype.UUID
	if err := uid.Scan(id); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}

	dbUser, err := r.queries.GetUser(ctx, uid)
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}

	u := r.mapUser(&dbUser)

	data, _ := json.Marshal(u)
	_ = r.cache.Conn.Set(ctx, cacheKey, data, 1*time.Hour).Err()

	return u, nil
}

func (r *PostgresIdentityRepository) GetUserByIdentifier(ctx context.Context, identifier string) (*domain.User, error) {
	dbUser, err := r.queries.GetUserByIdentifier(ctx, identifier)
	if err != nil {
		return nil, fmt.Errorf("failed to get user by identifier: %w", err)
	}

	return r.mapUser(&dbUser), nil
}

func (r *PostgresIdentityRepository) UpdateUser(ctx context.Context, u *domain.User) error {
	var uid pgtype.UUID
	if err := uid.Scan(u.ID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}

	params := db.UpdateUserParams{
		ID:        uid,
		Username:  u.Username,
		Email:     u.Email,
		AvatarUrl: pgtype.Text{String: u.AvatarURL, Valid: u.AvatarURL != ""},
	}

	_, err := r.queries.UpdateUser(ctx, params)
	return err
}

func (r *PostgresIdentityRepository) mapUser(dbUser *db.User) *domain.User {
	u := &domain.User{
		ID:                  util.UUIDToString(dbUser.ID),
		Username:            dbUser.Username,
		Email:               dbUser.Email,
		PasswordHash:        dbUser.PasswordHash,
		AvatarURL:           dbUser.AvatarUrl.String,
		MFAEnabled:          dbUser.MfaEnabled,
		MFASecret:           dbUser.MfaSecret.String,
		FailedLoginAttempts: int(dbUser.FailedLoginAttempts),
		CreatedAt:           dbUser.CreatedAt.Time,
		UpdatedAt:           dbUser.UpdatedAt.Time,
	}

	if dbUser.LockedUntil.Valid {
		u.LockedUntil = &dbUser.LockedUntil.Time
	}

	return u
}

func (r *PostgresIdentityRepository) UpdateMFA(ctx context.Context, userID string, enabled bool, secret string) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	return r.queries.UpdateUserMFA(ctx, db.UpdateUserMFAParams{
		ID:         uid,
		MfaEnabled: enabled,
		MfaSecret:  pgtype.Text{String: secret, Valid: secret != ""},
	})
}

func (r *PostgresIdentityRepository) CreateSession(ctx context.Context, s *domain.Session) error {
	var uid pgtype.UUID
	if err := uid.Scan(s.UserID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	dbSession, err := r.queries.CreateSession(ctx, db.CreateSessionParams{
		UserID:    uid,
		DeviceID:  s.DeviceID,
		IpAddress: s.IPAddress,
		UserAgent: s.UserAgent,
	})
	if err != nil {
		return err
	}
	s.ID = util.UUIDToString(dbSession.ID)
	s.CreatedAt = dbSession.CreatedAt.Time
	return nil
}

func (r *PostgresIdentityRepository) GetSessions(ctx context.Context, userID string) ([]*domain.Session, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	rows, err := r.queries.GetUserSessions(ctx, uid)
	if err != nil {
		return nil, err
	}
	res := make([]*domain.Session, len(rows))
	for i, row := range rows {
		res[i] = &domain.Session{
			ID:           util.UUIDToString(row.ID),
			UserID:       util.UUIDToString(row.UserID),
			DeviceID:     row.DeviceID,
			IPAddress:    row.IpAddress,
			UserAgent:    row.UserAgent,
			IsActive:     row.IsActive,
			LastActiveAt: row.LastActiveAt.Time,
			CreatedAt:    row.CreatedAt.Time,
		}
	}
	return res, nil
}

func (r *PostgresIdentityRepository) RevokeSession(ctx context.Context, sessionID, userID string) error {
	var sid, uid pgtype.UUID
	if err := sid.Scan(sessionID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	return r.queries.DeactivateSession(ctx, db.DeactivateSessionParams{ID: sid, UserID: uid})
}

func (r *PostgresIdentityRepository) UpdateOnlineStatus(ctx context.Context, userID string, isOnline bool) error { return nil }
func (r *PostgresIdentityRepository) SetProfileLock(ctx context.Context, userID string, locked bool) error { return nil }

func (r *PostgresIdentityRepository) IncrementFailedLogin(ctx context.Context, userID string) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	return r.queries.IncrementFailedLogin(ctx, uid)
}

func (r *PostgresIdentityRepository) ResetFailedLogin(ctx context.Context, userID string) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	return r.queries.ResetFailedLogin(ctx, uid)
}

func (r *PostgresIdentityRepository) LockAccount(ctx context.Context, userID string, until time.Time) error {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid uuid: %w", err)
	}
	return r.queries.LockAccount(ctx, db.LockAccountParams{
		ID:          uid,
		LockedUntil: pgtype.Timestamptz{Time: until, Valid: true},
	})
}

func (r *PostgresIdentityRepository) AddKeywordFilter(ctx context.Context, userID, keyword string) error { return nil }
func (r *PostgresIdentityRepository) GetKeywordFilters(ctx context.Context, userID string) ([]string, error) { return nil, nil }

func (r *PostgresIdentityRepository) BlacklistToken(ctx context.Context, tokenID string, expiration time.Duration) error {
	return r.cache.Conn.Set(ctx, "bl:"+tokenID, "1", expiration).Err()
}

func (r *PostgresIdentityRepository) StoreRefreshToken(ctx context.Context, userID, refreshToken string, expiration time.Duration) error {
	return r.cache.Conn.Set(ctx, "refresh:"+refreshToken, userID, expiration).Err()
}

func (r *PostgresIdentityRepository) ValidateRefreshToken(ctx context.Context, refreshToken string) (string, error) {
	userID, err := r.cache.Conn.Get(ctx, "refresh:"+refreshToken).Result()
	if err != nil {
		return "", fmt.Errorf("invalid or expired refresh token")
	}
	return userID, nil
}
