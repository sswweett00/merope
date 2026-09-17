package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) JoinCollective(ctx context.Context, collectiveID, userID string) error {
	collectiveID = strings.TrimSpace(collectiveID)
	userID = strings.TrimSpace(userID)
	if collectiveID == "" || userID == "" {
		return fmt.Errorf("collective and user ids are required")
	}

	var cid, uid pgtype.UUID
	if err := cid.Scan(collectiveID); err != nil {
		return fmt.Errorf("invalid collective uuid: %w", err)
	}
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}

	_, err := r.queries.Exec(ctx, `
INSERT INTO collective_members (collective_id, user_id, role)
VALUES ($1, $2, 'member')
ON CONFLICT (collective_id, user_id) DO NOTHING`, cid, uid)
	return err
}

func (r *postgresCommunityRepository) LeaveCollective(ctx context.Context, collectiveID, userID string) error {
	collectiveID = strings.TrimSpace(collectiveID)
	userID = strings.TrimSpace(userID)
	if collectiveID == "" || userID == "" {
		return fmt.Errorf("collective and user ids are required")
	}

	var cid, uid pgtype.UUID
	if err := cid.Scan(collectiveID); err != nil {
		return fmt.Errorf("invalid collective uuid: %w", err)
	}
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}

	_, err := r.queries.Exec(ctx, `DELETE FROM collective_members WHERE collective_id = $1 AND user_id = $2`, cid, uid)
	return err
}
