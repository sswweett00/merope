package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetCommunity(ctx context.Context, commID string) (*domain.Community, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(commID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}

	var c domain.Community
	var dbID, ownerID pgtype.UUID
	var description, avatarURL string
	var isPrivate bool
	var createdAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT id, owner_id, name, description, avatar_url, is_private, created_at
FROM communities
WHERE id = $1`, id).Scan(&dbID, &ownerID, &c.Name, &description, &avatarURL, &isPrivate, &createdAt); err != nil {
		return nil, err
	}

	var memberCount int32
	if err := r.queries.QueryRow(ctx, `SELECT COUNT(*)::int FROM community_members WHERE community_id = $1 AND role <> 'banned'`, id).Scan(&memberCount); err != nil {
		return nil, err
	}

	c.ID = util.UUIDToString(dbID)
	c.OwnerID = util.UUIDToString(ownerID)
	c.Description = description
	c.AvatarURL = avatarURL
	c.IsPrivate = isPrivate
	c.MemberCount = memberCount
	c.PostCount = 0
	c.CreatedAt = createdAt.Time
	c.UpdatedAt = createdAt.Time
	return &c, nil
}

func (r *postgresCommunityRepository) GetCommunityBySlug(ctx context.Context, slug string) (*domain.Community, error) {
	slug = strings.TrimSpace(slug)
	if slug == "" {
		return nil, fmt.Errorf("community slug is required")
	}

	var id pgtype.UUID
	if err := r.queries.QueryRow(ctx, `SELECT id FROM communities WHERE LOWER(REPLACE(name, ' ', '-')) = LOWER($1) LIMIT 1`, slug).Scan(&id); err != nil {
		return nil, err
	}
	return r.GetCommunity(ctx, util.UUIDToString(id))
}

func (r *postgresCommunityRepository) GetCommunityMembers(ctx context.Context, commID, role string, limit, offset int32) ([]*domain.CommunityMember, error) {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(commID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}
	if limit <= 0 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	query := `
SELECT cm.community_id, cm.user_id, cm.role, cm.joined_at
FROM community_members cm
WHERE cm.community_id = $1`
	args := []interface{}{cid}
	if strings.TrimSpace(role) != "" {
		query += ` AND cm.role = $2 ORDER BY cm.joined_at ASC LIMIT $3 OFFSET $4`
		args = append(args, role, limit, offset)
	} else {
		query += ` ORDER BY cm.joined_at ASC LIMIT $2 OFFSET $3`
		args = append(args, limit, offset)
	}

	rows, err := r.queries.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	members := make([]*domain.CommunityMember, 0)
	for rows.Next() {
		var communityID, userID pgtype.UUID
		var memberRole string
		var joinedAt pgtype.Timestamptz
		if err := rows.Scan(&communityID, &userID, &memberRole, &joinedAt); err != nil {
			return nil, err
		}
		members = append(members, &domain.CommunityMember{
			ID:           util.UUIDToString(userID),
			CommunityID:  util.UUIDToString(communityID),
			UserID:       util.UUIDToString(userID),
			Role:         memberRole,
			JoinedAt:     joinedAt.Time,
			IsActive:     memberRole != "banned",
			Preferences:  domain.MemberPreferences{},
			PostCount:    0,
			CommentCount: 0,
			Reputation:   0,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return members, nil
}

func (r *postgresCommunityRepository) GetTrendingCommunities(ctx context.Context, limit int32) ([]*domain.Community, error) {
	if limit <= 0 || limit > 100 {
		limit = 20
	}
	rows, err := r.queries.Query(ctx, `
SELECT c.id, c.owner_id, c.name, COALESCE(c.description, ''), COALESCE(c.avatar_url, ''), c.is_private, c.created_at,
       COUNT(cm.user_id) FILTER (WHERE cm.role <> 'banned')::int AS member_count
FROM communities c
LEFT JOIN community_members cm ON cm.community_id = c.id
GROUP BY c.id, c.owner_id, c.name, c.description, c.avatar_url, c.is_private, c.created_at
ORDER BY member_count DESC, c.created_at DESC
LIMIT $1`, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	communities := make([]*domain.Community, 0)
	for rows.Next() {
		var community domain.Community
		var id, ownerID pgtype.UUID
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&id, &ownerID, &community.Name, &community.Description, &community.AvatarURL, &community.IsPrivate, &createdAt, &community.MemberCount); err != nil {
			return nil, err
		}
		community.ID = util.UUIDToString(id)
		community.OwnerID = util.UUIDToString(ownerID)
		community.CreatedAt = createdAt.Time
		community.UpdatedAt = createdAt.Time
		communities = append(communities, &community)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return communities, nil
}

var _ domain.CommunityRepository = (*postgresCommunityRepository)(nil)
