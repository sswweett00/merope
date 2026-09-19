package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) CreateThreadReply(ctx context.Context, reply *domain.ThreadReply) error {
	var threadID, authorID pgtype.UUID
	if err := threadID.Scan(reply.ThreadID); err != nil {
		return fmt.Errorf("invalid thread id: %w", err)
	}
	if err := authorID.Scan(reply.AuthorID); err != nil {
		return fmt.Errorf("invalid author id: %w", err)
	}

	var parentID pgtype.UUID
	if reply.ParentID != nil && *reply.ParentID != "" {
		if err := parentID.Scan(*reply.ParentID); err != nil {
			return fmt.Errorf("invalid parent id: %w", err)
		}
	}

	row := r.queries.QueryRow(ctx, `
INSERT INTO thread_replies (thread_id, author_id, parent_id, content, resonance, is_edited)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING id, created_at, updated_at`,
		threadID, authorID, parentID, reply.Content, reply.Resonance, reply.IsEdited,
	)

	var id pgtype.UUID
	var createdAt, updatedAt pgtype.Timestamptz
	if err := row.Scan(&id, &createdAt, &updatedAt); err != nil {
		return err
	}
	reply.ID = util.UUIDToString(id)
	reply.CreatedAt = createdAt.Time
	reply.UpdatedAt = updatedAt.Time
	return nil
}
