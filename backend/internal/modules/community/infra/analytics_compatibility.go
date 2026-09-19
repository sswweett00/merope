func (r *postgresCommunityRepository) UpdateCommunityStats(ctx context.Context, communityID string) error {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `
UPDATE communities
SET updated_at = NOW()
WHERE id = $1`, cid)
	return err
}

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

func (r *postgresCommunityRepository) GetCommunityAnalytics(ctx context.Context, communityID, period string) (*domain.CommunityAnalytics, error) {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}

	window := 30 * 24 * time.Hour
	switch strings.ToLower(strings.TrimSpace(period)) {
	case "day", "daily", "24h":
		window = 24 * time.Hour
	case "week", "weekly", "7d":
		window = 7 * 24 * time.Hour
	case "month", "monthly", "30d", "":
		window = 30 * 24 * time.Hour
	}

	var memberCount, newMembers, activeMembers, eventCount int32
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM community_members
WHERE community_id = $1 AND role <> 'banned'`, cid).Scan(&memberCount); err != nil {
		return nil, err
	}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM community_members
WHERE community_id = $1 AND role <> 'banned' AND joined_at >= NOW() - $2::interval`, cid, window.String()).Scan(&newMembers); err != nil {
		return nil, err
	}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(DISTINCT proposer_id)::int
FROM community_proposals
WHERE community_id = $1 AND created_at >= NOW() - $2::interval`, cid, window.String()).Scan(&activeMembers); err != nil {
		// Older installations may not expose proposal timestamps; preserve analytics availability.
		activeMembers = 0
	}
	if err := r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM community_proposals
WHERE community_id = $1`, cid).Scan(&eventCount); err != nil {
		return nil, err
	}

	return &domain.CommunityAnalytics{
		CommunityID:    util.UUIDToString(cid),
		Period:         period,
		MemberCount:    memberCount,
		NewMembers:     newMembers,
		ActiveMembers:  activeMembers,
		EventCount:     eventCount,
		PostCount:      0,
		CommentCount:   0,
		EngagementRate: 0,
		AvgSessionTime: 0,
		TopContent:     []string{},
	}, nil
}

func (r *postgresCommunityRepository) GetMemberActivity(ctx context.Context, communityID, userID, period string) (*domain.MemberActivity, error) {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	window := 30 * 24 * time.Hour
	switch strings.ToLower(strings.TrimSpace(period)) {
	case "day", "daily", "24h":
		window = 24 * time.Hour
	case "week", "weekly", "7d":
		window = 7 * 24 * time.Hour
	case "month", "monthly", "30d", "":
		window = 30 * 24 * time.Hour
	}

	var joinedAt, lastActivity pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT joined_at, joined_at
FROM community_members
WHERE community_id = $1 AND user_id = $2`, cid, uid).Scan(&joinedAt, &lastActivity); err != nil {
		return nil, err
	}

	var postsCreated, reactionsGiven int32
	_ = r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM posts
WHERE author_id = $1 AND created_at >= NOW() - $2::interval`, uid, window.String()).Scan(&postsCreated)
	_ = r.queries.QueryRow(ctx, `
SELECT COUNT(*)::int
FROM reactions
WHERE user_id = $1 AND created_at >= NOW() - $2::interval`, uid, window.String()).Scan(&reactionsGiven)

	return &domain.MemberActivity{
		UserID:         util.UUIDToString(uid),
		CommunityID:    util.UUIDToString(cid),
		Period:         period,
		PostsCreated:   postsCreated,
		CommentsMade:   0,
		EventsAttended: 0,
		ReactionsGiven: reactionsGiven,
		TimeSpent:      0,
		LastActiveAt:   lastActivity.Time,
	}, nil
}
