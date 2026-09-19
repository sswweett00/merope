package infra

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) GetTrendingSignals(ctx context.Context, limit int32) ([]*domain.Signal, error) {
	if limit <= 0 {
		limit = 20
	}

	rows, err := r.queries.Query(ctx, `
SELECT p.id,
       p.author_id,
       u.username,
       u.avatar_url,
       p.content_text,
       p.media_urls,
       p.visibility,
       p.created_at,
       COUNT(DISTINCT r.user_id)::int AS reaction_count,
       COUNT(DISTINCT c.id)::int AS comment_count
FROM posts p
JOIN users u ON u.id = p.author_id
LEFT JOIN reactions r ON r.target_id = p.id
LEFT JOIN comments c ON c.post_id = p.id
WHERE p.published_at <= NOW()
  AND p.is_archived = FALSE
  AND p.visibility = 'public'
GROUP BY p.id, p.author_id, u.username, u.avatar_url, p.content_text, p.media_urls, p.visibility, p.created_at
ORDER BY (COUNT(DISTINCT r.user_id) * 3 + COUNT(DISTINCT c.id) * 2) DESC,
         p.created_at DESC
LIMIT $1`, limit)
	if err != nil {
		return nil, err
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
		var reactionCount, commentCount int
		if err := rows.Scan(&rowID, &authorID, &username, &avatar, &content, &mediaURLs, &visibility, &createdAt, &reactionCount, &commentCount); err != nil {
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
			LikeCount:     reactionCount,
			CommentCount:  commentCount,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
