package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

const updatePost = `-- name: UpdatePost :exec
UPDATE posts SET content_text = $1, media_urls = $2, updated_at = NOW() WHERE id = $3
`

func (q *Queries) UpdatePost(ctx context.Context, contentText string, mediaUrls []string, id pgtype.UUID) error {
	_, err := q.db.Exec(ctx, updatePost, contentText, mediaUrls, id)
	return err
}

const deletePost = `-- name: DeletePost :exec
DELETE FROM posts WHERE id = $1
`

func (q *Queries) DeletePost(ctx context.Context, id pgtype.UUID) error {
	_, err := q.db.Exec(ctx, deletePost, id)
	return err
}

const deleteComment = `-- name: DeleteComment :exec
DELETE FROM comments WHERE id = $1
`

func (q *Queries) DeleteComment(ctx context.Context, id pgtype.UUID) error {
	_, err := q.db.Exec(ctx, deleteComment, id)
	return err
}
