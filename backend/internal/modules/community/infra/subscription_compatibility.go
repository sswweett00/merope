package infra

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) CancelSubscription(ctx context.Context, subID string) error {
	var sid pgtype.UUID
	if err := sid.Scan(subID); err != nil { return err }
	_, err := r.queries.Exec(ctx, `UPDATE subscriptions SET active = FALSE WHERE id = $1`, sid)
	return err
}
