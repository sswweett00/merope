package infra

import (
	"context"
	"fmt"
	"strings"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) CreateCollective(ctx context.Context, coll *domain.Collective) error {
	if coll == nil {
		return fmt.Errorf("collective is required")
	}
	var id pgtype.UUID
	if coll.ID != "" {
		if err := id.Scan(coll.ID); err != nil {
			return fmt.Errorf("invalid collective uuid: %w", err)
		}
	} else {
		id = pgtype.UUID{Bytes: [16]byte{}, Valid: false}
	}

	var rowID pgtype.UUID
	var createdAt, updatedAt pgtype.Timestamptz
	err := r.queries.QueryRow(ctx, `
INSERT INTO collectives (id, name, slug, description, icon, banner_url, is_official, category)
VALUES (COALESCE($1, gen_random_uuid()), $2, $3, $4, $5, $6, $7, $8)
RETURNING id, created_at, updated_at`, idOrNull(id), coll.Name, coll.Slug, coll.Description, coll.Icon, coll.BannerURL, coll.IsOfficial, coll.Category).
		Scan(&rowID, &createdAt, &updatedAt)
	if err != nil {
		return err
	}

	coll.ID = util.UUIDToString(rowID)
	coll.CreatedAt = createdAt.Time
	coll.UpdatedAt = updatedAt.Time
	return nil
}

func idOrNull(id pgtype.UUID) interface{} {
	if !id.Valid {
		return nil
	}
	return id
}

func (r *postgresCommunityRepository) GetCollective(ctx context.Context, collectiveID string) (*domain.Collective, error) {
	var id pgtype.UUID
	if err := id.Scan(collectiveID); err != nil {
		return nil, fmt.Errorf("invalid collective uuid: %w", err)
	}

	var coll domain.Collective
	var dbID pgtype.UUID
	var createdAt, updatedAt pgtype.Timestamptz
	var description, icon, bannerURL, category string
	var isOfficial bool
	var memberCount int32
	if err := r.queries.QueryRow(ctx, `
SELECT c.id, c.name, c.slug, c.description, c.icon, c.banner_url, c.is_official,
       c.category, c.created_at, c.updated_at,
       (SELECT COUNT(*)::int FROM collective_members cm WHERE cm.collective_id = c.id)
FROM collectives c
WHERE c.id = $1`, id).Scan(
		&dbID, &coll.Name, &coll.Slug, &description, &icon, &bannerURL, &isOfficial,
		&category, &createdAt, &updatedAt, &memberCount,
	); err != nil {
		return nil, err
	}

	coll.ID = util.UUIDToString(dbID)
	coll.Description = description
	coll.Icon = icon
	coll.BannerURL = bannerURL
	coll.IsOfficial = isOfficial
	coll.Category = category
	coll.MemberCount = memberCount
	coll.CreatedAt = createdAt.Time
	coll.UpdatedAt = updatedAt.Time
	return &coll, nil
}

func (r *postgresCommunityRepository) GetCollectives(ctx context.Context, limit, offset int32) ([]*domain.Collective, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}

	rows, err := r.queries.Query(ctx, `
SELECT c.id, c.name, c.slug, c.description, c.icon, c.banner_url, c.is_official,
       c.category, c.created_at, c.updated_at,
       (SELECT COUNT(*)::int FROM collective_members cm WHERE cm.collective_id = c.id)
FROM collectives c
ORDER BY c.is_official DESC, c.created_at DESC
LIMIT $1 OFFSET $2`, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Collective, 0)
	for rows.Next() {
		var coll domain.Collective
		var dbID pgtype.UUID
		var createdAt, updatedAt pgtype.Timestamptz
		var description, icon, bannerURL, category string
		var isOfficial bool
		var memberCount int32
		if err := rows.Scan(
			&dbID, &coll.Name, &coll.Slug, &description, &icon, &bannerURL, &isOfficial,
			&category, &createdAt, &updatedAt, &memberCount,
		); err != nil {
			return nil, err
		}
		coll.ID = util.UUIDToString(dbID)
		coll.Description = description
		coll.Icon = icon
		coll.BannerURL = bannerURL
		coll.IsOfficial = isOfficial
		coll.Category = category
		coll.MemberCount = memberCount
		coll.CreatedAt = createdAt.Time
		coll.UpdatedAt = updatedAt.Time
		result = append(result, &coll)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

func (r *postgresCommunityRepository) UpdateCollective(ctx context.Context, collectiveID string, updates *domain.Collective) error {
	collectiveID = strings.TrimSpace(collectiveID)
	if collectiveID == "" || updates == nil {
		return fmt.Errorf("collective id and updates are required")
	}
	var id pgtype.UUID
	if err := id.Scan(collectiveID); err != nil {
		return fmt.Errorf("invalid collective uuid: %w", err)
	}
	name := strings.TrimSpace(updates.Name)
	if name == "" {
		return fmt.Errorf("collective name is required")
	}
	_, err := r.queries.Exec(ctx, `
UPDATE collectives
SET name = $2,
    slug = $3,
    description = $4,
    icon = $5,
    banner_url = $6,
    category = $7,
    updated_at = NOW()
WHERE id = $1`, id, name, strings.TrimSpace(updates.Slug), updates.Description, updates.Icon, updates.BannerURL, strings.TrimSpace(updates.Category))
	return err
}

func (r *postgresCommunityRepository) DeleteCollective(ctx context.Context, collectiveID string) error {
	id := strings.TrimSpace(collectiveID)
	if id == "" {
		return fmt.Errorf("collective id is required")
	}
	var uid pgtype.UUID
	if err := uid.Scan(id); err != nil {
		return fmt.Errorf("invalid collective uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `DELETE FROM collectives WHERE id = $1`, uid)
	return err
}
