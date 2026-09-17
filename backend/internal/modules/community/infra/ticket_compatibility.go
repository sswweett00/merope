package infra

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) CancelTicket(ctx context.Context, ticketID string) error {
	var tid pgtype.UUID
	if err := tid.Scan(ticketID); err != nil { return err }
	_, err := r.queries.Exec(ctx, `UPDATE transactions SET status = 'cancelled' WHERE id = $1 AND type = 'event_ticket'`, tid)
	return err
}
