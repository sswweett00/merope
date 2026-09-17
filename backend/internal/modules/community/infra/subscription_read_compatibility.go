package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetSubscription(ctx context.Context, subscriptionID string) (*domain.Subscription, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(subscriptionID)); err != nil {
		return nil, fmt.Errorf("invalid subscription uuid: %w", err)
	}

	var sub domain.Subscription
	var rowID, creatorID pgtype.UUID
	var tier string
	var startedAt, expiresAt pgtype.Timestamptz
	var active bool
	if err := r.queries.QueryRow(ctx, `
SELECT id, user_id, plan, started_at, expires_at, active
FROM subscriptions
WHERE id = $1`, id).Scan(&rowID, &creatorID, &tier, &startedAt, &expiresAt, &active); err != nil {
		return nil, err
	}

	sub.ID = util.UUIDToString(rowID)
	sub.CreatorID = util.UUIDToString(creatorID)
	sub.Tier = tier
	sub.StartedAt = startedAt.Time
	sub.ExpiresAt = expiresAt.Time
	if active {
		sub.Status = "active"
	} else {
		sub.Status = "cancelled"
	}
	return &sub, nil
}
