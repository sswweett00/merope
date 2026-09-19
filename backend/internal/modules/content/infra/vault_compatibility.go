package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) GetUserVaults(ctx context.Context, userID string) ([]*domain.Vault, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT c.id, c.owner_id, c.name, c.is_private, c.created_at,
       COUNT(b.post_id)::INT
FROM bookmark_collections c
LEFT JOIN bookmarks b ON b.collection_id = c.id
WHERE c.owner_id = $1
GROUP BY c.id, c.owner_id, c.name, c.is_private, c.created_at
ORDER BY c.created_at DESC`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Vault, 0)
	for rows.Next() {
		var id, ownerID pgtype.UUID
		var name string
		var isPrivate bool
		var createdAt pgtype.Timestamptz
		var signalCount int32
		if err := rows.Scan(&id, &ownerID, &name, &isPrivate, &createdAt, &signalCount); err != nil {
			return nil, err
		}
		result = append(result, &domain.Vault{
			ID:          util.UUIDToString(id),
			OwnerID:     util.UUIDToString(ownerID),
			Name:        name,
			IsPrivate:   isPrivate,
			CreatedAt:   createdAt.Time,
			SignalCount: int(signalCount),
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

func (r *PostgresContentRepository) GetVaultSignals(ctx context.Context, vaultID string) ([]*domain.Signal, error) {
	var vid pgtype.UUID
	if err := vid.Scan(vaultID); err != nil {
		return nil, fmt.Errorf("invalid vault uuid: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.author_id, u.username, u.avatar_url,
       p.content_text, p.media_urls, p.visibility, p.created_at
FROM bookmarks b
JOIN posts p ON p.id = b.post_id
JOIN users u ON u.id = p.author_id
WHERE b.collection_id = $1
  AND p.deleted_at IS NULL
ORDER BY b.created_at DESC, p.created_at DESC`, vid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Signal, 0)
	for rows.Next() {
		var id, authorID pgtype.UUID
		var username string
		var avatar pgtype.Text
		var content, visibility string
		var mediaURLs []string
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&id, &authorID, &username, &avatar, &content, &mediaURLs, &visibility, &createdAt); err != nil {
			return nil, err
		}
		result = append(result, &domain.Signal{
			ID:            util.UUIDToString(id),
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
