package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/stories/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresStoriesRepository struct {
	queries *db.Queries
}

func NewPostgresStoriesRepository(queries *db.Queries) *PostgresStoriesRepository {
	return &PostgresStoriesRepository{queries: queries}
}

func (r *PostgresStoriesRepository) CreateStory(ctx context.Context, authorID, mediaURL, mediaType string, expiryHours int) (*domain.Story, error) {
	var aid pgtype.UUID
	_ = aid.Scan(authorID)

	dbStory, err := r.queries.CreateStory(ctx, db.CreateStoryParams{
		AuthorID:  aid,
		MediaUrl:  mediaURL,
		MediaType: mediaType,
	})
	if err != nil {
		return nil, err
	}

	return &domain.Story{
		ID:        util.UUIDToString(dbStory.ID),
		AuthorID:  util.UUIDToString(dbStory.AuthorID),
		MediaURL:  dbStory.MediaUrl,
		MediaType: dbStory.MediaType,
		CreatedAt: dbStory.CreatedAt.Time,
		ExpiresAt: dbStory.ExpiresAt.Time,
	}, nil
}

func (r *PostgresStoriesRepository) GetActiveStories(ctx context.Context, userID string) ([]*domain.Story, error) {
	rows, err := r.queries.GetActiveStories(ctx)
	if err != nil {
		return nil, err
	}

	res := make([]*domain.Story, len(rows))
	for i, row := range rows {
		res[i] = &domain.Story{
			ID:        util.UUIDToString(row.ID),
			AuthorID:  util.UUIDToString(row.AuthorID),
			Username:  row.AuthorUsername,
			AvatarURL: row.AuthorAvatar.String,
			MediaURL:  row.MediaUrl,
			MediaType: row.MediaType,
			CreatedAt: row.CreatedAt.Time,
			ExpiresAt: row.ExpiresAt.Time,
		}
	}
	return res, nil
}

func (r *PostgresStoriesRepository) RecordView(ctx context.Context, storyID, userID string) error {
	var sid, uid pgtype.UUID
	_ = sid.Scan(storyID)
	_ = uid.Scan(userID)

	return r.queries.RecordStoryView(ctx, db.RecordStoryViewParams{
		StoryID: sid,
		UserID:  uid,
	})
}

func (r *PostgresStoriesRepository) React(ctx context.Context, storyID, userID, emoji string) error { return nil }
func (r *PostgresStoriesRepository) CreateHighlight(ctx context.Context, authorID, name, coverURL string) (*domain.StoryHighlight, error) { return nil, nil }
func (r *PostgresStoriesRepository) AddStoryToHighlight(ctx context.Context, highlightID, storyID string) error { return nil }
func (r *PostgresStoriesRepository) GetHighlights(ctx context.Context, userID string) ([]*domain.StoryHighlight, error) { return nil, nil }
