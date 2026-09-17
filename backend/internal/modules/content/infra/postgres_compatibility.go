package infra

import (
	"context"
	"fmt"
	"strings"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *PostgresContentRepository) DeleteNode(ctx context.Context, nodeID string) error {
	var id pgtype.UUID
	if err := id.Scan(nodeID); err != nil {
		return fmt.Errorf("invalid node uuid: %w", err)
	}
	return r.queries.DeleteComment(ctx, id)
}

func (r *PostgresContentRepository) GetSignalByID(ctx context.Context, signalID string) (*domain.Signal, error) {
	var id pgtype.UUID
	if err := id.Scan(signalID); err != nil {
		return nil, fmt.Errorf("invalid signal uuid: %w", err)
	}

	var authorID, rowID pgtype.UUID
	var username string
	var avatar pgtype.Text
	var content, visibility string
	var mediaURLs []string
	var createdAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT p.id, p.author_id, u.username, u.avatar_url, p.content_text, p.media_urls, p.visibility, p.created_at
FROM posts p
JOIN users u ON u.id = p.author_id
WHERE p.id = $1
ORDER BY p.created_at DESC
LIMIT 1`, id).Scan(&rowID, &authorID, &username, &avatar, &content, &mediaURLs, &visibility, &createdAt); err != nil {
		return nil, err
	}

	return &domain.Signal{
		ID:            util.UUIDToString(rowID),
		AuthorID:      util.UUIDToString(authorID),
		AuthorName:    username,
		AuthorAvatar:  avatar.String,
		ContentText:   content,
		MediaURLs:     mediaURLs,
		Visibility:    visibility,
		CreatedAt:     createdAt.Time,
		CreatedAtUnix: createdAt.Time.Unix(),
	}, nil
}

func (r *PostgresContentRepository) GetSignalsByHashtag(ctx context.Context, hashtag string, limit, offset int32) ([]*domain.Signal, error) {
	tag := strings.TrimSpace(hashtag)
	if tag == "" {
		return []*domain.Signal{}, nil
	}
	if !strings.HasPrefix(tag, "#") {
		tag = "#" + tag
	}
	tag = strings.ToLower(tag)

	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.author_id, u.username, u.avatar_url, p.content_text, p.media_urls, p.visibility, p.created_at
FROM posts p
JOIN users u ON u.id = p.author_id
WHERE LOWER(COALESCE(p.content_text, '')) LIKE '%' || $1 || '%'
ORDER BY p.created_at DESC
LIMIT $2 OFFSET $3`, tag, limit, offset)
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

var _ domain.ContentRepository = (*PostgresContentRepository)(nil)
