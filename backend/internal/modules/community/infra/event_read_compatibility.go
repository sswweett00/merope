package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetEvent(ctx context.Context, eventID string) (*domain.Event, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(eventID)); err != nil {
		return nil, fmt.Errorf("invalid event uuid: %w", err)
	}

	var event domain.Event
	var rowID, communityID, creatorID pgtype.UUID
	var title string
	var description pgtype.Text
	var createdAt, endsAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT id, community_id, proposer_id, title, description, created_at, ends_at
FROM community_proposals
WHERE id = $1`, id).Scan(
		&rowID,
		&communityID,
		&creatorID,
		&title,
		&description,
		&createdAt,
		&endsAt,
	); err != nil {
		return nil, err
	}

	community := util.UUIDToString(communityID)
	event.ID = util.UUIDToString(rowID)
	event.CommunityID = &community
	event.CreatorID = util.UUIDToString(creatorID)
	event.Title = title
	event.Description = description.String
	event.StartTime = createdAt.Time
	event.EndTime = endsAt.Time
	event.Status = "published"
	event.CreatedAt = createdAt.Time
	event.UpdatedAt = createdAt.Time
	return &event, nil
}

func (r *postgresCommunityRepository) GetUpcomingEvents(ctx context.Context, userID string, limit int32) ([]*domain.Event, error) {
	var uid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}
	if limit <= 0 || limit > 100 {
		limit = 20
	}

	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.community_id, p.proposer_id, p.title, p.description, p.created_at, p.ends_at
FROM community_proposals p
LEFT JOIN event_attendees ea ON ea.event_id = p.id AND ea.user_id = $1 AND ea.status = 'going'
WHERE p.ends_at > NOW()
  AND (p.proposer_id = $1 OR ea.user_id IS NOT NULL)
ORDER BY p.ends_at ASC
LIMIT $2`, uid, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Event, 0)
	for rows.Next() {
		var event domain.Event
		var id, communityID, creatorID pgtype.UUID
		var description pgtype.Text
		var createdAt, endsAt pgtype.Timestamptz
		if err := rows.Scan(&id, &communityID, &creatorID, &event.Title, &description, &createdAt, &endsAt); err != nil {
			return nil, err
		}
		community := util.UUIDToString(communityID)
		event.ID = util.UUIDToString(id)
		event.CommunityID = &community
		event.CreatorID = util.UUIDToString(creatorID)
		event.Description = description.String
		event.StartTime = createdAt.Time
		event.EndTime = endsAt.Time
		event.Status = "published"
		event.CreatedAt = createdAt.Time
		event.UpdatedAt = createdAt.Time
		result = append(result, &event)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
