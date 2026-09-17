package infra

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"
)

const feedFastPathSQL = `
SELECT
    p.id,
    p.author_id,
    p.content_text,
    p.media_urls,
    p.visibility,
    p.published_at,
    p.created_at,
    u.username,
    u.avatar_url
FROM posts p
JOIN users u ON u.id = p.author_id
WHERE p.published_at <= NOW()
  AND p.is_archived = FALSE
  AND p.is_draft = FALSE
  AND p.deleted_at IS NULL
  AND (
      p.visibility = 'public'
      OR EXISTS (
          SELECT 1
          FROM follows f
          WHERE f.follower_id = $1
            AND f.following_id = p.author_id
      )
  )
ORDER BY p.published_at DESC, p.id DESC
LIMIT $2 OFFSET $3
`

func (r *PostgresContentRepository) getStreamFast(ctx context.Context, userID string, limit, offset int32) ([]*domain.Signal, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 50
	}
	if limit > 100 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	rows, err := r.queries.Query(ctx, feedFastPathSQL, uid, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Signal, 0, limit)
	for rows.Next() {
		var id, authorID pgtype.UUID
		var contentText, visibility, authorName string
		var mediaURLs []string
		var publishedAt, createdAt pgtype.Timestamptz
		var avatar pgtype.Text

		if err := rows.Scan(
			&id,
			&authorID,
			&contentText,
			&mediaURLs,
			&visibility,
			&publishedAt,
			&createdAt,
			&authorName,
			&avatar,
		); err != nil {
			return nil, err
		}

		result = append(result, &domain.Signal{
			ID:            util.UUIDToString(id),
			AuthorID:      util.UUIDToString(authorID),
			AuthorName:    authorName,
			AuthorAvatar:  avatar.String,
			ContentText:   contentText,
			MediaURLs:     mediaURLs,
			Visibility:    visibility,
			CreatedAt:     createdAt.Time,
			CreatedAtUnix: publishedAt.Time.Unix(),
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

var _ pgx.Rows = (pgx.Rows)(nil)
