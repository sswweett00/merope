package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) CanViewCommunity(ctx context.Context, viewerID, communityID string) (bool, error) {
	var uid, cid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(viewerID)); err != nil {
		return false, fmt.Errorf("invalid viewer uuid: %w", err)
	}
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return false, fmt.Errorf("invalid community uuid: %w", err)
	}
	var visible bool
	if err := r.queries.QueryRow(ctx, `
SELECT EXISTS (
	SELECT 1
	FROM communities c
	WHERE c.id = $1
	  AND (
		c.is_private = FALSE
		OR c.owner_id = $2
		OR EXISTS (
			SELECT 1
			FROM community_members cm
			WHERE cm.community_id = $1
			  AND cm.user_id = $2
			  AND cm.role <> 'banned'
		)
	  )
)`, cid, uid).Scan(&visible); err != nil {
		return false, err
	}
	return visible, nil
}

func (r *postgresCommunityRepository) GetCommunity(ctx context.Context, commID string) (*domain.Community, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(commID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}

	var c domain.Community
	var dbID, ownerID pgtype.UUID
	var createdAt, updatedAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT
    c.id,
    c.owner_id,
    c.name,
    COALESCE(c.slug, ''),
    COALESCE(c.description, ''),
    COALESCE(c.avatar_url, ''),
    COALESCE(c.banner_url, ''),
    c.is_private,
    c.is_verified,
    COUNT(cm.user_id) FILTER (WHERE cm.role <> 'banned')::int AS member_count,
    c.created_at,
    c.updated_at,
    COALESCE(c.category, 'general'),
    COALESCE(c.tags, '{}'),
    COALESCE(c.rules, '{}')
FROM communities c
LEFT JOIN community_members cm ON cm.community_id = c.id
WHERE c.id = $1
GROUP BY c.id, c.owner_id, c.name, c.slug, c.description, c.avatar_url, c.banner_url,
         c.is_private, c.is_verified, c.created_at, c.updated_at, c.category, c.tags, c.rules`, id).
		Scan(
			&dbID,
			&ownerID,
			&c.Name,
			&c.Slug,
			&c.Description,
			&c.AvatarURL,
			&c.BannerURL,
			&c.IsPrivate,
			&c.IsVerified,
			&c.MemberCount,
			&createdAt,
			&updatedAt,
			&c.Category,
			&c.Tags,
			&c.Rules,
		); err != nil {
		return nil, err
	}

	c.ID = util.UUIDToString(dbID)
	c.OwnerID = util.UUIDToString(ownerID)
	c.PostCount = 0
	c.CreatedAt = createdAt.Time
	c.UpdatedAt = updatedAt.Time
	c.Settings = domain.CommunitySettings{}
	c.Stats = domain.CommunityStats{}
	c.Tags = append([]string(nil), c.Tags...)
	c.Rules = append([]string(nil), c.Rules...)
	return &c, nil
}

func (r *postgresCommunityRepository) UpdateCommunity(ctx context.Context, commID string, updates *domain.Community) error {
	if updates == nil {
		return fmt.Errorf("community updates are required")
	}
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(commID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	name := strings.TrimSpace(updates.Name)
	if name == "" {
		return fmt.Errorf("community name is required")
	}
	category := strings.TrimSpace(updates.Category)
	if category == "" {
		category = "general"
	}
	tags := updates.Tags
	if tags == nil {
		tags = []string{}
	}
	rules := updates.Rules
	if rules == nil {
		rules = []string{}
	}
	_, err := r.queries.Exec(ctx, `
UPDATE communities
SET name = $2,
    description = $3,
    avatar_url = $4,
    banner_url = $5,
    is_private = $6,
    category = $7,
    tags = $8,
    rules = $9,
    updated_at = NOW()
WHERE id = $1`, id, name, updates.Description, updates.AvatarURL, updates.BannerURL, updates.IsPrivate, category, tags, rules)
	return err
}

func (r *postgresCommunityRepository) GetCommunityBySlug(ctx context.Context, slug string) (*domain.Community, error) {
	slug = strings.TrimSpace(slug)
	if slug == "" {
		return nil, fmt.Errorf("community slug is required")
	}

	var id pgtype.UUID
	if err := r.queries.QueryRow(ctx, `SELECT id FROM communities WHERE LOWER(slug) = LOWER($1) LIMIT 1`, slug).Scan(&id); err != nil {
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
SELECT cm.community_id, cm.user_id, u.username, COALESCE(u.avatar_url, ''), cm.role, cm.joined_at
FROM community_members cm
JOIN users u ON u.id = cm.user_id
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
		var username, avatarURL, memberRole string
		var joinedAt pgtype.Timestamptz
		if err := rows.Scan(&communityID, &userID, &username, &avatarURL, &memberRole, &joinedAt); err != nil {
			return nil, err
		}
		members = append(members, &domain.CommunityMember{
			ID:           util.UUIDToString(userID),
			CommunityID:  util.UUIDToString(communityID),
			UserID:       util.UUIDToString(userID),
			Role:         memberRole,
			JoinedAt:     joinedAt.Time,
			IsActive:     memberRole != "banned",
			LastActiveAt: joinedAt.Time,
			Preferences:  domain.MemberPreferences{},
			PostCount:    0,
			CommentCount: 0,
			Reputation:   0,
			Badges:       []string{},
		})
		_ = username
		_ = avatarURL
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return members, nil
}

func (r *postgresCommunityRepository) LeaveCommunity(ctx context.Context, commID, userID string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(commID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `
DELETE FROM community_members
WHERE community_id = $1 AND user_id = $2 AND role <> 'banned'`, cid, uid)
	return err
}

func (r *postgresCommunityRepository) GetTrendingCommunities(ctx context.Context, limit int32) ([]*domain.Community, error) {
	if limit <= 0 || limit > 100 {
		limit = 20
	}
	rows, err := r.queries.Query(ctx, `
SELECT
    c.id,
    c.owner_id,
    c.name,
    COALESCE(c.slug, ''),
    COALESCE(c.description, ''),
    COALESCE(c.avatar_url, ''),
    COALESCE(c.banner_url, ''),
    c.is_private,
    c.is_verified,
    COUNT(cm.user_id) FILTER (WHERE cm.role <> 'banned')::int AS member_count,
    c.created_at,
    c.updated_at,
    COALESCE(c.category, 'general'),
    COALESCE(c.tags, '{}'),
    COALESCE(c.rules, '{}')
FROM communities c
LEFT JOIN community_members cm ON cm.community_id = c.id
WHERE c.is_private = FALSE
GROUP BY c.id, c.owner_id, c.name, c.slug, c.description, c.avatar_url, c.banner_url,
         c.is_private, c.is_verified, c.created_at, c.updated_at, c.category, c.tags, c.rules
ORDER BY member_count DESC, c.created_at DESC, c.id ASC
LIMIT $1`, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	communities := make([]*domain.Community, 0)
	for rows.Next() {
		var community domain.Community
		var id, ownerID pgtype.UUID
		var createdAt, updatedAt pgtype.Timestamptz
		if err := rows.Scan(
			&id,
			&ownerID,
			&community.Name,
			&community.Slug,
			&community.Description,
			&community.AvatarURL,
			&community.BannerURL,
			&community.IsPrivate,
			&community.IsVerified,
			&community.MemberCount,
			&createdAt,
			&updatedAt,
			&community.Category,
			&community.Tags,
			&community.Rules,
		); err != nil {
			return nil, err
		}
		community.ID = util.UUIDToString(id)
		community.OwnerID = util.UUIDToString(ownerID)
		community.CreatedAt = createdAt.Time
		community.UpdatedAt = updatedAt.Time
		community.Settings = domain.CommunitySettings{}
		community.Stats = domain.CommunityStats{}
		community.Tags = append([]string(nil), community.Tags...)
		community.Rules = append([]string(nil), community.Rules...)
		communities = append(communities, &community)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return communities, nil
}
