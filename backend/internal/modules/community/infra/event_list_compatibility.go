package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) ListEvents(ctx context.Context, communityID *string, userID, status string, limit, offset int32) ([]*domain.Event, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	uid, err := uuidFromString(userID)
	if err != nil {
		return nil, err
	}

	args := []interface{}{uid}
	where := `
WHERE (
    p.proposer_id = $1
    OR EXISTS (
        SELECT 1
        FROM event_attendees viewer_attendee
        WHERE viewer_attendee.event_id = p.id
          AND viewer_attendee.user_id = $1
          AND viewer_attendee.status = 'going'
    )
    OR EXISTS (
        SELECT 1
        FROM community_members viewer_member
        WHERE viewer_member.community_id = p.community_id
          AND viewer_member.user_id = $1
          AND viewer_member.role <> 'banned'
    )
)`

	if communityID != nil && strings.TrimSpace(*communityID) != "" {
		cid, parseErr := uuidFromString(*communityID)
		if parseErr != nil {
			return nil, parseErr
		}
		args = append(args, cid)
		where += fmt.Sprintf(" AND p.community_id = $%d", len(args))
	}

	switch strings.ToLower(strings.TrimSpace(status)) {
	case "upcoming", "published", "active":
		where += " AND p.ends_at > NOW()"
	case "completed", "expired":
		where += " AND p.ends_at <= NOW()"
	case "", "all":
	default:
		return nil, fmt.Errorf("unsupported event status: %s", status)
	}

	limitArg := len(args) + 1
	offsetArg := len(args) + 2
	args = append(args, limit, offset)
	rows, err := r.queries.Query(ctx, fmt.Sprintf(`
SELECT p.id, p.community_id, p.proposer_id, p.title, p.description, p.created_at, p.ends_at
FROM community_proposals p
%s
ORDER BY p.ends_at ASC, p.id ASC
LIMIT $%d OFFSET $%d`, where, limitArg, offsetArg), args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Event, 0)
	for rows.Next() {
		var event domain.Event
		var id, communityIDValue, creatorID pgtype.UUID
		var description pgtype.Text
		var createdAt, endsAt pgtype.Timestamptz
		if err := rows.Scan(&id, &communityIDValue, &creatorID, &event.Title, &description, &createdAt, &endsAt); err != nil {
			return nil, err
		}
		community := util.UUIDToString(communityIDValue)
		event.ID = util.UUIDToString(id)
		event.CommunityID = &community
		event.CreatorID = util.UUIDToString(creatorID)
		event.Description = description.String
		event.StartTime = createdAt.Time
		event.EndTime = endsAt.Time
		event.Status = "published"
		if !endsAt.Time.After(createdAt.Time) {
			event.Status = "completed"
		}
		event.CreatedAt = createdAt.Time
		event.UpdatedAt = createdAt.Time
		result = append(result, &event)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

func uuidFromString(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}
