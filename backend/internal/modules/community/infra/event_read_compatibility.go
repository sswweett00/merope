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
