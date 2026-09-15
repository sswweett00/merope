package db

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

func (q *Queries) UpsertUserPresence(ctx context.Context, userID pgtype.UUID, isOnline bool) error {
	_, err := q.db.Exec(ctx, `
		INSERT INTO user_presence (user_id, is_online, last_seen_at, updated_at)
		VALUES ($1, $2, CASE WHEN $2 THEN NOW() ELSE NOW() END, NOW())
		ON CONFLICT (user_id) DO UPDATE SET
			is_online = EXCLUDED.is_online,
			last_seen_at = CASE WHEN EXCLUDED.is_online THEN NOW() ELSE user_presence.last_seen_at END,
			updated_at = NOW()`, userID, isOnline)
	if err != nil {
		return fmt.Errorf("upsert user presence: %w", err)
	}
	return nil
}

func (q *Queries) GetUserPresence(ctx context.Context, userID pgtype.UUID) (bool, time.Time, error) {
	var online bool
	var lastSeen time.Time
	if err := q.db.QueryRow(ctx, `
		SELECT is_online, last_seen_at
		FROM user_presence
		WHERE user_id = $1`, userID).Scan(&online, &lastSeen); err != nil {
		return false, time.Time{}, fmt.Errorf("get user presence: %w", err)
	}
	return online, lastSeen, nil
}

func (q *Queries) SetProfileLockState(ctx context.Context, userID pgtype.UUID, locked bool) error {
	_, err := q.db.Exec(ctx, `
		INSERT INTO profile_locks (user_id, is_locked, updated_at)
		VALUES ($1, $2, NOW())
		ON CONFLICT (user_id) DO UPDATE SET
			is_locked = EXCLUDED.is_locked,
			updated_at = NOW()`, userID, locked)
	if err != nil {
		return fmt.Errorf("set profile lock state: %w", err)
	}
	return nil
}

func (q *Queries) GetProfileLockState(ctx context.Context, userID pgtype.UUID) (bool, error) {
	var locked bool
	if err := q.db.QueryRow(ctx, `
		SELECT is_locked
		FROM profile_locks
		WHERE user_id = $1`, userID).Scan(&locked); err != nil {
		return false, fmt.Errorf("get profile lock state: %w", err)
	}
	return locked, nil
}

func (q *Queries) AddKeywordFilter(ctx context.Context, userID pgtype.UUID, keyword string) error {
	keyword = strings.TrimSpace(strings.ToLower(keyword))
	if keyword == "" {
		return fmt.Errorf("keyword is required")
	}
	if len([]rune(keyword)) > 128 {
		return fmt.Errorf("keyword is too long")
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO keyword_filters (user_id, keyword)
		VALUES ($1, $2)
		ON CONFLICT (user_id, keyword) DO NOTHING`, userID, keyword)
	if err != nil {
		return fmt.Errorf("add keyword filter: %w", err)
	}
	return nil
}

func (q *Queries) GetKeywordFilters(ctx context.Context, userID pgtype.UUID) ([]string, error) {
	rows, err := q.db.Query(ctx, `
		SELECT keyword
		FROM keyword_filters
		WHERE user_id = $1
		ORDER BY created_at DESC`, userID)
	if err != nil {
		return nil, fmt.Errorf("get keyword filters: %w", err)
	}
	defer rows.Close()

	filters := make([]string, 0)
	for rows.Next() {
		var keyword string
		if err := rows.Scan(&keyword); err != nil {
			return nil, fmt.Errorf("scan keyword filter: %w", err)
		}
		filters = append(filters, keyword)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate keyword filters: %w", err)
	}
	return filters, nil
}
