package infra

import (
	"context"
	"fmt"

	"local/merope/internal/core/util"
	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) GetAttendees(ctx context.Context, eventID string, limit, offset int32) ([]string, error) {
	var eid pgtype.UUID
	if err := eid.Scan(eventID); err != nil {
		return nil, fmt.Errorf("invalid event uuid: %w", err)
	}
	if limit <= 0 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	rows, err := r.queries.Query(ctx, `
SELECT user_id
FROM event_attendees
WHERE event_id = $1
  AND status = 'going'
ORDER BY rsvp_at ASC, user_id ASC
LIMIT $2 OFFSET $3`, eid, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	attendees := make([]string, 0)
	for rows.Next() {
		var uid pgtype.UUID
		if err := rows.Scan(&uid); err != nil {
			return nil, err
		}
		attendees = append(attendees, util.UUIDToString(uid))
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return attendees, nil
}
