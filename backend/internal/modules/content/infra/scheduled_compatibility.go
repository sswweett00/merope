package infra

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) ScheduleSignal(ctx context.Context, signalID string, scheduledAt time.Time) error {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(signalID)); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	if scheduledAt.IsZero() {
		return fmt.Errorf("scheduled time is required")
	}
	_, err := r.queries.Exec(ctx, `
UPDATE posts
SET scheduled_at = $2,
    is_draft = TRUE,
    updated_at = NOW()
WHERE id = $1`, id, scheduledAt)
	return err
}

func (r *PostgresContentRepository) GetScheduledSignals(ctx context.Context, userID string) ([]*domain.Signal, error) {
	var uid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.author_id, u.username, u.avatar_url,
       p.content_text, p.media_urls, p.visibility,
       p.created_at, p.updated_at, p.scheduled_at, p.expires_at,
       p.is_archived, p.is_draft, p.content_warning
FROM posts p
JOIN users u ON u.id = p.author_id
WHERE p.author_id = $1
  AND p.scheduled_at IS NOT NULL
  AND p.is_draft = TRUE
  AND p.deleted_at IS NULL
ORDER BY p.scheduled_at ASC, p.created_at DESC`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Signal, 0)
	for rows.Next() {
		var id, authorID pgtype.UUID
		var username string
		var avatar pgtype.Text
		var content, visibility, contentWarning string
		var mediaURLs []string
		var createdAt, updatedAt pgtype.Timestamptz
		var scheduledAt, expiresAt pgtype.Timestamptz
		var archived, draft bool
		if err := rows.Scan(&id, &authorID, &username, &avatar, &content, &mediaURLs, &visibility,
			&createdAt, &updatedAt, &scheduledAt, &expiresAt, &archived, &draft, &contentWarning); err != nil {
			return nil, err
		}

		scheduled := scheduledAt.Time
		expires := expiresAt.Time
		var scheduledPtr, expiresPtr *time.Time
		if scheduledAt.Valid {
			scheduledPtr = &scheduled
		}
		if expiresAt.Valid {
			expiresPtr = &expires
		}
		result = append(result, &domain.Signal{
			ID:             util.UUIDToString(id),
			AuthorID:       util.UUIDToString(authorID),
			AuthorName:     username,
			AuthorAvatar:   avatar.String,
			ContentText:    content,
			MediaURLs:      mediaURLs,
			Visibility:     visibility,
			IsArchived:     archived,
			IsDraft:        draft,
			ContentWarning: contentWarning,
			CreatedAt:      createdAt.Time,
			CreatedAtUnix:  createdAt.Time.Unix(),
			UpdatedAt:      updatedAt.Time,
			ScheduledAt:    scheduledPtr,
			ExpiresAt:      expiresPtr,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
