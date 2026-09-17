package infra

import (
	"context"
	"fmt"
	"strings"

	"local/merope/internal/core/util"
	"github.com/jackc/pgx/v5/pgtype"
)

func (r *postgresCommunityRepository) DeleteCommunity(ctx context.Context, communityID string) error {
	communityID = strings.TrimSpace(communityID)
	if communityID == "" {
		return fmt.Errorf("community id is required")
	}

	var id pgtype.UUID
	if err := id.Scan(communityID); err != nil {
		return fmt.Errorf("invalid community uuid: %w", err)
	}

	_, err := r.queries.Exec(ctx, `DELETE FROM communities WHERE id = $1`, id)
	return err
}

var _ = util.UUIDToString
