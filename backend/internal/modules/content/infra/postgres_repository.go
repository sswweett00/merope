package infra

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/content/domain"
)

type PostgresContentRepository struct {
	queries *db.Queries
}

func NewPostgresContentRepository(queries *db.Queries) *PostgresContentRepository {
	return &PostgresContentRepository{queries: queries}
}

func (r *PostgresContentRepository) CreateSignal(ctx context.Context, p *domain.Signal) error {
	var aid pgtype.UUID
	if err := aid.Scan(p.AuthorID); err != nil {
		return fmt.Errorf("invalid author uuid: %w", err)
	}

	dbPost, err := r.queries.CreatePost(ctx, db.CreatePostParams{
		AuthorID:    aid,
		ContentText: p.ContentText,
		MediaUrls:   p.MediaURLs,
		Visibility:  p.Visibility,
	})
	if err != nil {
		return err
	}

	p.ID = util.UUIDToString(dbPost.ID)
	p.CreatedAt = dbPost.CreatedAt.Time
	return nil
}

func (r *PostgresContentRepository) GetStream(ctx context.Context, userID string, limit, offset int32) ([]*domain.Signal, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid user uuid: %w", err)
	}

	rows, err := r.queries.GetFeed(ctx, db.GetFeedParams{
		FollowerID: uid,
		Limit:      limit,
		Offset:     offset,
	})
	if err != nil {
		return nil, err
	}

	res := make([]*domain.Signal, len(rows))
	for i, row := range rows {
		res[i] = &domain.Signal{
			ID:            util.UUIDToString(row.ID),
			AuthorID:      util.UUIDToString(row.AuthorID),
			AuthorName:    row.AuthorUsername,
			AuthorAvatar:  row.AuthorAvatar.String,
			ContentText:   row.ContentText,
			MediaURLs:     row.MediaUrls,
			Visibility:    row.Visibility,
			CreatedAt:     row.CreatedAt.Time,
			CreatedAtUnix: row.CreatedAt.Time.Unix(),
		}
	}
	return res, nil
}

func (r *PostgresContentRepository) AddResonance(ctx context.Context, userID, targetID string, amplitude int) error {
	var uid, tid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}
	if err := tid.Scan(targetID); err != nil {
		return fmt.Errorf("invalid target uuid: %w", err)
	}

	_, err := r.queries.AddReaction(ctx, db.AddReactionParams{
		UserID:       uid,
		TargetID:     tid,
		ReactionType: "resonance",
	})
	return err
}

func (r *PostgresContentRepository) CreateNode(ctx context.Context, signalID, authorID string, parentID *string, content string) (*domain.Node, error) {
	var pid, aid, prid pgtype.UUID
	if err := pid.Scan(signalID); err != nil {
		return nil, fmt.Errorf("invalid uuid signalID: %w", err)
	}
	if err := aid.Scan(authorID); err != nil {
		return nil, fmt.Errorf("invalid uuid authorID: %w", err)
	}
	if parentID != nil {
		if err := prid.Scan(*parentID); err != nil {
			return nil, fmt.Errorf("invalid uuid parentID: %w", err)
		}
	}

	dbComment, err := r.queries.CreateComment(ctx, db.CreateCommentParams{
		PostID:   pid,
		AuthorID: aid,
		ParentID: prid,
		Content:  content,
	})
	if err != nil {
		return nil, err
	}

	return &domain.Node{
		ID:        util.UUIDToString(dbComment.ID),
		SignalID:  util.UUIDToString(dbComment.PostID),
		AuthorID:  util.UUIDToString(dbComment.AuthorID),
		ParentID:  parentID,
		Content:   dbComment.Content,
		CreatedAt: dbComment.CreatedAt.Time,
	}, nil
}

func (r *PostgresContentRepository) GetNodesForSignal(ctx context.Context, signalID string) ([]*domain.Node, error) {
	var pid pgtype.UUID
	if err := pid.Scan(signalID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}

	rows, err := r.queries.GetCommentsForPost(ctx, pid)
	if err != nil {
		return nil, err
	}

	res := make([]*domain.Node, len(rows))
	for i, row := range rows {
		var prid *string
		if row.ParentID.Valid {
			s := util.UUIDToString(row.ParentID)
			prid = &s
		}

		res[i] = &domain.Node{
			ID:           util.UUIDToString(row.ID),
			SignalID:     util.UUIDToString(row.PostID),
			AuthorID:     util.UUIDToString(row.AuthorID),
			AuthorName:   row.AuthorUsername,
			AuthorAvatar: row.AuthorAvatar.String,
			ParentID:     prid,
			Content:      row.Content,
			CreatedAt:    row.CreatedAt.Time,
		}
	}
	return res, nil
}

func (r *PostgresContentRepository) UpdateSignalStatus(ctx context.Context, signalID string, pinned, archived, draft bool) error {
	var sid pgtype.UUID
	if err := sid.Scan(signalID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	_, err := r.queries.Exec(ctx, `
UPDATE posts
SET is_archived = $2,
    is_draft = $3,
    updated_at = NOW()
WHERE id = $1`, sid, archived, draft)
	return err
}

func (r *PostgresContentRepository) UpdateSignal(ctx context.Context, s *domain.Signal) error {
	var sid pgtype.UUID
	if err := sid.Scan(s.ID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	return r.queries.UpdatePost(ctx, s.ContentText, s.MediaURLs, sid)
}

func (r *PostgresContentRepository) DeleteSignal(ctx context.Context, signalID string) error {
	var sid pgtype.UUID
	if err := sid.Scan(signalID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	return r.queries.DeletePost(ctx, sid)
}

func (r *PostgresContentRepository) CreateMentions(ctx context.Context, mentions []*domain.Mention) error {
	return nil
}

func (r *PostgresContentRepository) LinkFrequencies(ctx context.Context, signalID string, tags []string) error {
	return nil
}

func (r *PostgresContentRepository) CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error) {
	var uid pgtype.UUID
	if err := uid.Scan(ownerID); err != nil {
		return "", fmt.Errorf("invalid owner uuid: %w", err)
	}

	var id pgtype.UUID
	if err := r.queries.QueryRow(ctx, `
INSERT INTO bookmark_collections (owner_id, name, is_private)
VALUES ($1, $2, $3)
RETURNING id`, uid, name, isPrivate).Scan(&id); err != nil {
		return "", err
	}
	return util.UUIDToString(id), nil
}

func (r *PostgresContentRepository) VaultSignal(ctx context.Context, userID, signalID string, vaultID *string) error {
	var uid, sid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return fmt.Errorf("invalid user uuid: %w", err)
	}
	if err := sid.Scan(signalID); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}

	var collection pgtype.UUID
	if vaultID != nil && *vaultID != "" {
		if err := collection.Scan(*vaultID); err != nil {
			return fmt.Errorf("invalid vault uuid: %w", err)
		}
	}
	_, err := r.queries.Exec(ctx, `
INSERT INTO bookmarks (user_id, post_id, collection_id)
VALUES ($1, $2, $3)
ON CONFLICT (user_id, post_id)
DO UPDATE SET collection_id = EXCLUDED.collection_id`, uid, sid, collection)
	return err
}
