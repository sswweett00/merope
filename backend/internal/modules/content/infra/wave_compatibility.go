package infra

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) CreateWavePool(ctx context.Context, signalID, question string, endsAt time.Time, options []string) error {
	if strings.TrimSpace(question) == "" {
		return fmt.Errorf("wave question is required")
	}
	if len(options) < 2 {
		return fmt.Errorf("wave requires at least two options")
	}

	var sid pgtype.UUID
	if err := sid.Scan(signalID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}

	var pollID pgtype.UUID
	if err := r.queries.QueryRow(ctx, `
INSERT INTO polls (post_id, question, ends_at)
VALUES ($1, $2, $3)
RETURNING id`, sid, question, pgtype.Timestamptz{Time: endsAt, Valid: true}).Scan(&pollID); err != nil {
		return err
	}

	for _, option := range options {
		option = strings.TrimSpace(option)
		if option == "" {
			return fmt.Errorf("wave option cannot be empty")
		}
		if _, err := r.queries.Exec(ctx, `INSERT INTO poll_options (poll_id, option_text) VALUES ($1, $2)`, pollID, option); err != nil {
			return err
		}
	}
	return nil
}

func (r *PostgresContentRepository) VoteWave(ctx context.Context, poolID, optionID, userID string) error {
	var pid, oid, uid pgtype.UUID
	if err := pid.Scan(poolID); err != nil {
		return fmt.Errorf("invalid wave pool uuid: %w", err)
	}
	if err := oid.Scan(optionID); err != nil {
		return fmt.Errorf("invalid wave option uuid: %w", err)
	}
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}

	var exists bool
	if err := r.queries.QueryRow(ctx, `SELECT EXISTS (SELECT 1 FROM poll_options WHERE id = $1 AND poll_id = $2)`, oid, pid).Scan(&exists); err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("wave option does not belong to wave pool")
	}

	_, err := r.queries.Exec(ctx, `
INSERT INTO poll_votes (poll_id, option_id, user_id)
VALUES ($1, $2, $3)
ON CONFLICT (poll_id, user_id) DO UPDATE SET option_id = EXCLUDED.option_id`, pid, oid, uid)
	return err
}

func (r *PostgresContentRepository) GetWaveResults(ctx context.Context, poolID string) (map[string]int, error) {
	var pid pgtype.UUID
	if err := pid.Scan(poolID); err != nil {
		return nil, fmt.Errorf("invalid wave pool uuid: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT po.option_text, COUNT(pv.user_id)::int
FROM poll_options po
LEFT JOIN poll_votes pv ON pv.option_id = po.id
WHERE po.poll_id = $1
GROUP BY po.id, po.option_text
ORDER BY po.id`, pid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	results := make(map[string]int)
	for rows.Next() {
		var option string
		var count int
		if err := rows.Scan(&option, &count); err != nil {
			return nil, err
		}
		results[option] = count
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return results, nil
}

func (r *PostgresContentRepository) GetWavePoolBySignal(ctx context.Context, signalID string) (*domain.WavePoolData, error) {
	var sid pgtype.UUID
	if err := sid.Scan(signalID); err != nil {
		return nil, fmt.Errorf("invalid signal uuid: %w", err)
	}

	var poolID pgtype.UUID
	var question string
	var endsAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT id, question, ends_at
FROM polls
WHERE post_id = $1
ORDER BY created_at DESC
LIMIT 1`, sid).Scan(&poolID, &question, &endsAt); err != nil {
		return nil, err
	}

	rows, err := r.queries.Query(ctx, `
SELECT option_text
FROM poll_options
WHERE poll_id = $1
ORDER BY id`, poolID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	options := make([]string, 0)
	for rows.Next() {
		var option string
		if err := rows.Scan(&option); err != nil {
			return nil, err
		}
		options = append(options, option)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &domain.WavePoolData{Question: question, Options: options, EndsAt: endsAt.Time}, nil
}
