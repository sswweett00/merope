package infra

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

// BanMember persists moderation state in the community membership record.
// Duration/reason remain audit concerns and are emitted by the service layer.
func (r *postgresCommunityRepository) BanMember(ctx context.Context, commID, userID, reason string, duration *time.Time) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(commID); err != nil { return fmt.Errorf("invalid community uuid: %w", err) }
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user uuid: %w", err) }
	_, err := r.queries.Exec(ctx, `UPDATE community_members SET role = 'banned' WHERE community_id = $1 AND user_id = $2`, cid, uid)
	return err
}

func (r *postgresCommunityRepository) UnbanMember(ctx context.Context, commID, userID string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(commID); err != nil { return fmt.Errorf("invalid community uuid: %w", err) }
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user uuid: %w", err) }
	_, err := r.queries.Exec(ctx, `UPDATE community_members SET role = 'member' WHERE community_id = $1 AND user_id = $2 AND role = 'banned'`, cid, uid)
	return err
}
