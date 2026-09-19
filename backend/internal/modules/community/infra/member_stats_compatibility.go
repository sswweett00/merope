package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetMemberStats(ctx context.Context, communityID, userID string) (*domain.CommunityStats, error) {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	stats := &domain.CommunityStats{}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM posts
WHERE author_id = $1 AND deleted_at IS NULL`, uid).Scan(&stats.TotalPosts); err != nil {
		return nil, err
	}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM comments c
JOIN posts p ON p.id = c.post_id
WHERE c.author_id = $1 AND p.deleted_at IS NULL`, uid).Scan(&stats.TotalComments); err != nil {
		return nil, err
	}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM event_attendees ea
JOIN community_proposals e ON e.id = ea.event_id
WHERE ea.user_id = $1 AND e.community_id = $2`, uid, cid).Scan(&stats.TotalEvents); err != nil {
		return nil, err
	}
	return stats, nil
}
