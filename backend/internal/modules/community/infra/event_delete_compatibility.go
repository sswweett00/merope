package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) DeleteEvent(ctx context.Context, eventID string) error {
	eventID = strings.TrimSpace(eventID)
	if eventID == "" {
		return fmt.Errorf("event id is required")
	}

	var id pgtype.UUID
	if err := id.Scan(eventID); err != nil {
		return fmt.Errorf("invalid event uuid: %w", err)
	}

	_, err := r.queries.Exec(ctx, `DELETE FROM events WHERE id = $1`, id)
	return err
}
