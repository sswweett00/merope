package infra

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetSubscription(ctx context.Context, subID string) (*domain.Subscription, error) {
	id, err := parseUUID(subID)
	if err != nil {
		return nil, err
	}
	var sub domain.Subscription
	var idv, subscriberID, creatorID pgtype.UUID
	var plan, currency, status string
	var amount float64
	var startedAt, expiresAt pgtype.Timestamptz
	var autoRenew bool
	var benefits []string
	if err := r.queries.QueryRow(ctx, `
SELECT id, user_id, creator_id, plan, amount, currency,
       CASE WHEN active AND expires_at > NOW() THEN 'active'
            WHEN active THEN 'expired' ELSE 'cancelled' END AS status,
       started_at, expires_at, auto_renew, benefits
FROM subscriptions
WHERE id = $1`, id).Scan(&idv, &subscriberID, &creatorID, &plan, &amount, &currency, &status, &startedAt, &expiresAt, &autoRenew, &benefits); err != nil {
		return nil, err
	}
	sub.ID = util.UUIDToString(idv)
	sub.SubscriberID = util.UUIDToString(subscriberID)
	sub.CreatorID = util.UUIDToString(creatorID)
	sub.Tier = plan
	sub.Amount = amount
	sub.Currency = currency
	sub.Status = status
	sub.StartedAt = startedAt.Time
	sub.ExpiresAt = expiresAt.Time
	sub.AutoRenew = autoRenew
	sub.Benefits = benefits
	return &sub, nil
}

func (r *postgresCommunityRepository) GetUserSubscriptions(ctx context.Context, userID string) ([]*domain.Subscription, error) {
	uid, err := parseUUID(userID)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries.Query(ctx, `
SELECT id, user_id, creator_id, plan, amount, currency,
       CASE WHEN active AND expires_at > NOW() THEN 'active'
            WHEN active THEN 'expired' ELSE 'cancelled' END AS status,
       started_at, expires_at, auto_renew, benefits
FROM subscriptions
WHERE user_id = $1
ORDER BY started_at DESC`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make([]*domain.Subscription, 0)
	for rows.Next() {
		var sub domain.Subscription
		var id, subscriberID, creatorID pgtype.UUID
		var plan, currency, status string
		var amount float64
		var startedAt, expiresAt pgtype.Timestamptz
		var autoRenew bool
		var benefits []string
		if err := rows.Scan(&id, &subscriberID, &creatorID, &plan, &amount, &currency, &status, &startedAt, &expiresAt, &autoRenew, &benefits); err != nil {
			return nil, err
		}
		sub.ID = util.UUIDToString(id)
		sub.SubscriberID = util.UUIDToString(subscriberID)
		sub.CreatorID = util.UUIDToString(creatorID)
		sub.Tier = plan
		sub.Amount = amount
		sub.Currency = currency
		sub.Status = status
		sub.StartedAt = startedAt.Time
		sub.ExpiresAt = expiresAt.Time
		sub.AutoRenew = autoRenew
		sub.Benefits = benefits
		result = append(result, &sub)
	}
	return result, rows.Err()
}

func (r *postgresCommunityRepository) UpdateSubscription(ctx context.Context, subID, tier string) error {
	id, err := parseUUID(subID)
	if err != nil {
		return err
	}
	tier = strings.TrimSpace(tier)
	if tier == "" {
		return fmt.Errorf("subscription tier is required")
	}
	_, err = r.queries.Exec(ctx, `UPDATE subscriptions SET plan = $2 WHERE id = $1`, id, tier)
	return err
}

func (r *postgresCommunityRepository) CreateSubscription(ctx context.Context, subID, subscriberID, creatorID, tier string, expiresAt time.Time) error {
	id, err := parseUUID(subID)
	if err != nil {
		return err
	}
	subscriber, err := parseUUID(subscriberID)
	if err != nil {
		return err
	}
	creator, err := parseUUID(creatorID)
	if err != nil {
		return err
	}
	tier = strings.TrimSpace(tier)
	if tier == "" {
		return fmt.Errorf("subscription tier is required")
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO subscriptions (id, user_id, creator_id, plan, active, expires_at, auto_renew, benefits)
VALUES ($1, $2, $3, $4, TRUE, $5, TRUE, '{}')`, id, subscriber, creator, tier, expiresAt)
	return err
}

func (r *postgresCommunityRepository) CancelSubscription(ctx context.Context, subID string) error {
	id, err := parseUUID(subID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `UPDATE subscriptions SET active = FALSE WHERE id = $1`, id)
	return err
}
