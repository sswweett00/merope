package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) SearchSignals(ctx context.Context, query string, limit, offset int32) ([]*domain.Signal, error) {
	query = strings.TrimSpace(query)
	if query == "" {
		return []*domain.Signal{}, nil
	}
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}

	term := "%" + strings.ToLower(query) + "%"
	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.author_id, u.username, u.avatar_url, p.content_text, p.media_urls, p.visibility, p.created_at
FROM posts p
JOIN users u ON u.id = p.author_id
WHERE p.deleted_at IS NULL
  AND p.is_archived = FALSE
  AND p.is_draft = FALSE
  AND LOWER(COALESCE(p.content_text, '')) LIKE $1
ORDER BY p.created_at DESC
LIMIT $2 OFFSET $3`, term, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("search signals: %w", err)
	}
	defer rows.Close()

	result := make([]*domain.Signal, 0)
	for rows.Next() {
		var rowID, authorID pgtype.UUID
		var username string
		var avatar pgtype.Text
		var content, visibility string
		var mediaURLs []string
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&rowID, &authorID, &username, &avatar, &content, &mediaURLs, &visibility, &createdAt); err != nil {
			return nil, err
		}
		result = append(result, &domain.Signal{
			ID:            util.UUIDToString(rowID),
			AuthorID:      util.UUIDToString(authorID),
			AuthorName:    username,
			AuthorAvatar:  avatar.String,
			ContentText:   content,
			MediaURLs:     mediaURLs,
			Visibility:    visibility,
			CreatedAt:     createdAt.Time,
			CreatedAtUnix: createdAt.Time.Unix(),
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
