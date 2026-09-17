package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) ListCommunities(ctx context.Context, userID, category string, limit, offset int32) ([]*domain.Community, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	var uid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	category = strings.TrimSpace(category)
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
    COUNT(cm.user_id) FILTER (WHERE cm.role <> 'banned')::int,
    c.created_at,
    c.updated_at,
    COALESCE(c.category, 'general'),
    COALESCE(c.tags, '{}'),
    COALESCE(c.rules, '{}'),
    EXISTS (
        SELECT 1
        FROM community_members viewer_cm
        WHERE viewer_cm.community_id = c.id
          AND viewer_cm.user_id = $1
          AND viewer_cm.role <> 'banned'
    ) AS is_joined,
    COALESCE((
        SELECT viewer_cm.role
        FROM community_members viewer_cm
        WHERE viewer_cm.community_id = c.id
          AND viewer_cm.user_id = $1
          AND viewer_cm.role <> 'banned'
        LIMIT 1
    ), 'member') AS user_role
FROM communities c
LEFT JOIN community_members cm ON cm.community_id = c.id
WHERE (
    c.is_private = FALSE
    OR c.owner_id = $1
    OR EXISTS (
        SELECT 1
        FROM community_members viewer_cm
        WHERE viewer_cm.community_id = c.id
          AND viewer_cm.user_id = $1
          AND viewer_cm.role <> 'banned'
    )
)
  AND ($2 = '' OR c.category = $2)
GROUP BY c.id, c.owner_id, c.name, c.slug, c.description, c.avatar_url, c.banner_url,
         c.is_private, c.is_verified, c.created_at, c.updated_at, c.category, c.tags, c.rules
ORDER BY
    CASE
        WHEN c.owner_id = $1 THEN 0
        WHEN EXISTS (
            SELECT 1
            FROM community_members viewer_cm
            WHERE viewer_cm.community_id = c.id
              AND viewer_cm.user_id = $1
              AND viewer_cm.role <> 'banned'
        ) THEN 1
        ELSE 2
    END,
    COUNT(cm.user_id) FILTER (WHERE cm.role <> 'banned') DESC,
    c.created_at DESC,
    c.id ASC
LIMIT $3 OFFSET $4`, uid, category, limit, offset)
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
			&community.IsJoined,
			&community.UserRole,
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

var _ domain.CommunityRepository = (*postgresCommunityRepository)(nil)
