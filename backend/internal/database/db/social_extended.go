package db

import (
    "context"
    "fmt"

    "github.com/jackc/pgx/v5"
    "github.com/jackc/pgx/v5/pgtype"
)

// CreateCircle persists a user privacy circle and returns its identifier.
func (q *Queries) CreateCircle(ctx context.Context, ownerID pgtype.UUID, name string) (pgtype.UUID, error) {
    var id pgtype.UUID
    err := q.db.QueryRow(ctx, `
        INSERT INTO circles (owner_id, name)
        VALUES ($1, $2)
        ON CONFLICT (owner_id, name)
        DO UPDATE SET updated_at = NOW()
        RETURNING id`, ownerID, name).Scan(&id)
    if err != nil {
        return id, fmt.Errorf("create circle: %w", err)
    }
    return id, nil
}

func (q *Queries) AddCircleMember(ctx context.Context, circleID, userID pgtype.UUID) error {
    _, err := q.db.Exec(ctx, `
        INSERT INTO circle_members (circle_id, user_id)
        VALUES ($1, $2)
        ON CONFLICT (circle_id, user_id) DO NOTHING`, circleID, userID)
    if err != nil {
        return fmt.Errorf("add circle member: %w", err)
    }
    return nil
}

func (q *Queries) CreateContentReport(ctx context.Context, reporterID, targetID pgtype.UUID, targetType, reason string) error {
    _, err := q.db.Exec(ctx, `
        INSERT INTO content_reports (reporter_id, target_id, target_type, reason)
        VALUES ($1, $2, $3, $4)`, reporterID, targetID, targetType, reason)
    if err != nil {
        return fmt.Errorf("create content report: %w", err)
    }
    return nil
}

// BlockUserAtomically removes both graph directions and inserts the deny edge
// in one PostgreSQL statement, preventing partially applied block state.
func (q *Queries) BlockUserAtomically(ctx context.Context, blockerID, blockedID pgtype.UUID) error {
    _, err := q.db.Exec(ctx, `
        WITH removed AS (
            DELETE FROM follows
            WHERE (follower_id = $1 AND following_id = $2)
               OR (follower_id = $2 AND following_id = $1)
        )
        INSERT INTO neural_connections (source_id, target_id, weight, interaction_count, last_interaction_at, connection_type)
        VALUES ($1, $2, 0, 0, NOW(), 'blocked')
        ON CONFLICT (source_id, target_id)
        DO UPDATE SET weight = 0, connection_type = 'blocked', last_interaction_at = NOW()`, blockerID, blockedID)
    if err != nil {
        return fmt.Errorf("block user atomically: %w", err)
    }
    return nil
}

// Keep pgx imported by generated-package extension code for future transactional helpers.
var _ = pgx.ErrNoRows
