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

func (r *postgresCommunityRepository) UpdateMemberRole(ctx context.Context, communityID, userID, role string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}

	switch strings.ToLower(strings.TrimSpace(role)) {
	case "owner", "admin", "moderator", "member", "banned":
		role = strings.ToLower(strings.TrimSpace(role))
	default:
		return fmt.Errorf("invalid member role")
	}

	result, err := r.queries.Exec(ctx, `
UPDATE community_members
SET role = $3
WHERE community_id = $1 AND user_id = $2`, cid, uid, role)
	if err != nil {
		return err
	}
	if result.RowsAffected() == 0 {
		return fmt.Errorf("community member not found")
	}
	return nil
}
