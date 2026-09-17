package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) RemoveMember(ctx context.Context, communityID, userID string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}

	_, err := r.queries.Exec(ctx, `
DELETE FROM community_members
WHERE community_id = $1 AND user_id = $2`, cid, uid)
	return err
}
