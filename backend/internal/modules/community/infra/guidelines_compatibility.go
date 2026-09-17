package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetCommunityGuidelines(ctx context.Context, communityID string) ([]*domain.Guideline, error) {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT id, community_id, title, description, display_order, is_active, created_at
FROM community_guidelines
WHERE community_id = $1 AND is_active = TRUE
ORDER BY display_order ASC, created_at ASC`, cid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Guideline, 0)
	for rows.Next() {
		var rowID, rowCommunityID pgtype.UUID
		var title, description string
		var order int
		var active bool
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&rowID, &rowCommunityID, &title, &description, &order, &active, &createdAt); err != nil {
			return nil, err
		}
		result = append(result, &domain.Guideline{
			ID:          util.UUIDToString(rowID),
			CommunityID: util.UUIDToString(rowCommunityID),
			Title:       title,
			Description: description,
			Order:       order,
			IsActive:    active,
			CreatedAt:   createdAt.Time,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

func (r *postgresCommunityRepository) UpdateGuidelines(ctx context.Context, communityID string, guidelines []*domain.Guideline) error {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}
	if _, err := r.queries.Exec(ctx, `DELETE FROM community_guidelines WHERE community_id = $1`, cid); err != nil {
		return err
	}

	for index, guideline := range guidelines {
		if guideline == nil {
			continue
		}
		title := strings.TrimSpace(guideline.Title)
		description := strings.TrimSpace(guideline.Description)
		if title == "" {
			return fmt.Errorf("guideline title is required at index %d", index)
		}
		if description == "" {
			return fmt.Errorf("guideline description is required at index %d", index)
		}
		order := guideline.Order
		if order < 0 {
			order = index
		}
		_, err := r.queries.Exec(ctx, `
INSERT INTO community_guidelines (community_id, title, description, display_order, is_active)
VALUES ($1, $2, $3, $4, $5)`, cid, title, description, order, guideline.IsActive)
		if err != nil {
			return err
		}
	}
	return nil
}
