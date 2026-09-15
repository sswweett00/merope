package infra

import (
	"context"
	"fmt"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/content/domain"
	"local/merope/internal/core/util"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresContentRepository struct {
	queries *db.Queries
}

func NewPostgresContentRepository(queries *db.Queries) *PostgresContentRepository {
	return &PostgresContentRepository{queries: queries}
}

func (r *PostgresContentRepository) CreateSignal(ctx context.Context, p *domain.Signal) error {
	var aid pgtype.UUID
	_ = aid.Scan(p.AuthorID)

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
	_ = uid.Scan(userID)

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
			ID:           util.UUIDToString(row.ID),
			AuthorID:     util.UUIDToString(row.AuthorID),
			AuthorName:   row.AuthorUsername,
			AuthorAvatar: row.AuthorAvatar.String,
			ContentText:  row.ContentText,
			MediaURLs:    row.MediaUrls,
			Visibility:   row.Visibility,
			CreatedAt:    row.CreatedAt.Time,
		}
	}
	return res, nil
}

func (r *PostgresContentRepository) AddResonance(ctx context.Context, userID, targetID string, amplitude int) error {
	var uid, tid pgtype.UUID
	_ = uid.Scan(userID)
	_ = tid.Scan(targetID)

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

func (r *PostgresContentRepository) UpdateSignalStatus(ctx context.Context, signalID string, pinned, archived, draft bool) error { return nil }
func (r *PostgresContentRepository) UpdateSignal(ctx context.Context, s *domain.Signal) error {
	var sid pgtype.UUID
	_ = sid.Scan(s.ID)
	return r.queries.UpdatePost(ctx, s.ContentText, s.MediaURLs, sid)
}
func (r *PostgresContentRepository) DeleteSignal(ctx context.Context, signalID string) error {
	var sid pgtype.UUID
	_ = sid.Scan(signalID)
	return r.queries.DeletePost(ctx, sid)
}
func (r *PostgresContentRepository) CreateMentions(ctx context.Context, mentions []*domain.Mention) error { return nil }
func (r *PostgresContentRepository) CreateWavePool(ctx context.Context, signalID, question string, endsAt time.Time, options []string) error { return nil }
func (r *PostgresContentRepository) VoteWave(ctx context.Context, poolID, optionID, userID string) error { return nil }
func (r *PostgresContentRepository) GetWaveResults(ctx context.Context, poolID string) (map[string]int, error) { return nil, nil }
func (r *PostgresContentRepository) LinkFrequencies(ctx context.Context, signalID string, tags []string) error { return nil }
func (r *PostgresContentRepository) CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error) { return "", nil }
func (r *PostgresContentRepository) VaultSignal(ctx context.Context, userID, signalID string, vaultID *string) error { return nil }
