package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/stories/domain"
)

type PostgresStoriesRepository struct {
	queries *db.Queries
}

func NewPostgresStoriesRepository(queries *db.Queries) *PostgresStoriesRepository {
	return &PostgresStoriesRepository{queries: queries}
}

func parseStoryUUID(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}

func (r *PostgresStoriesRepository) CreateStory(ctx context.Context, authorID, mediaURL, mediaType string, expiryHours int) (*domain.Story, error) {
	aid, err := parseStoryUUID(authorID)
	if err != nil {
		return nil, err
	}
	if expiryHours <= 0 {
		expiryHours = 24
	}

	var story domain.Story
	var id, dbAuthorID pgtype.UUID
	var createdAt, expiresAt pgtype.Timestamptz
	err = r.queries.QueryRow(ctx, `
INSERT INTO stories (author_id, media_url, media_type, expires_at)
VALUES ($1, $2, $3, NOW() + make_interval(hours => $4))
RETURNING id, author_id, media_url, media_type, created_at, expires_at`, aid, mediaURL, mediaType, expiryHours).Scan(&id, &dbAuthorID, &story.MediaURL, &story.MediaType, &createdAt, &expiresAt)
	if err != nil {
		return nil, err
	}
	story.ID = util.UUIDToString(id)
	story.AuthorID = util.UUIDToString(dbAuthorID)
	story.CreatedAt = createdAt.Time
	story.ExpiresAt = expiresAt.Time
	story.IsViewed = false
	return &story, nil
}

func (r *PostgresStoriesRepository) scanStoryRows(rows interface {
	Next() bool
	Scan(...interface{}) error
}) ([]*domain.Story, error) {
	return nil, nil
}

func (r *PostgresStoriesRepository) GetActiveStories(ctx context.Context, userID string) ([]*domain.Story, error) {
	uid, err := parseStoryUUID(userID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries.Query(ctx, `
SELECT s.id,
       s.author_id,
       u.username,
       COALESCE(u.avatar_url, ''),
       s.media_url,
       s.media_type,
       s.created_at,
       s.expires_at,
       EXISTS (
           SELECT 1 FROM story_views sv
           WHERE sv.story_id = s.id AND sv.viewer_id = $1
       ) AS is_viewed,
       (SELECT COUNT(*)::int FROM story_views sv2 WHERE sv2.story_id = s.id) AS view_count,
       (SELECT COUNT(*)::int FROM story_reactions sr WHERE sr.story_id = s.id) AS reaction_count
FROM stories s
JOIN users u ON u.id = s.author_id
WHERE s.expires_at > NOW()
  AND s.is_archived = FALSE
  AND (
      s.author_id = $1
      OR s.visibility = 'public'
      OR EXISTS (
          SELECT 1
          FROM follows f
          WHERE f.follower_id = $1
            AND f.following_id = s.author_id
            AND f.status = 'accepted'
      )
  )
ORDER BY s.created_at DESC, s.id DESC
LIMIT 100`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	stories := make([]*domain.Story, 0)
	for rows.Next() {
		story := &domain.Story{}
		var id, authorID pgtype.UUID
		if err := rows.Scan(&id, &authorID, &story.Username, &story.AvatarURL, &story.MediaURL, &story.MediaType, &story.CreatedAt, &story.ExpiresAt, &story.IsViewed, &story.ViewCount, &story.ReactionCount); err != nil {
			return nil, err
		}
		story.ID = util.UUIDToString(id)
		story.AuthorID = util.UUIDToString(authorID)
		stories = append(stories, story)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return stories, nil
}

func (r *PostgresStoriesRepository) GetLatestStoryForUser(ctx context.Context, userID string) (*domain.Story, error) {
	uid, err := parseStoryUUID(userID)
	if err != nil {
		return nil, err
	}
	var story domain.Story
	var id, authorID pgtype.UUID
	if err := r.queries.QueryRow(ctx, `
SELECT s.id, s.author_id, u.username, COALESCE(u.avatar_url, ''),
       s.media_url, s.media_type, s.created_at, s.expires_at,
       EXISTS (SELECT 1 FROM story_views sv WHERE sv.story_id = s.id AND sv.viewer_id = $1),
       (SELECT COUNT(*)::int FROM story_views sv2 WHERE sv2.story_id = s.id),
       (SELECT COUNT(*)::int FROM story_reactions sr WHERE sr.story_id = s.id)
FROM stories s
JOIN users u ON u.id = s.author_id
WHERE s.author_id = $2 AND s.expires_at > NOW() AND s.is_archived = FALSE
ORDER BY s.created_at DESC, s.id DESC
LIMIT 1`, uid, uid).Scan(&id, &authorID, &story.Username, &story.AvatarURL, &story.MediaURL, &story.MediaType, &story.CreatedAt, &story.ExpiresAt, &story.IsViewed, &story.ViewCount, &story.ReactionCount); err != nil {
		return nil, err
	}
	story.ID = util.UUIDToString(id)
	story.AuthorID = util.UUIDToString(authorID)
	return &story, nil
}

func (r *PostgresStoriesRepository) RecordView(ctx context.Context, storyID, userID string) error {
	sid, err := parseStoryUUID(storyID)
	if err != nil {
		return err
	}
	uid, err := parseStoryUUID(userID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO story_views (story_id, viewer_id)
VALUES ($1, $2)
ON CONFLICT (story_id, viewer_id) DO UPDATE SET viewed_at = NOW()`, sid, uid)
	return err
}

func (r *PostgresStoriesRepository) React(ctx context.Context, storyID, userID, emoji string) error {
	sid, err := parseStoryUUID(storyID)
	if err != nil {
		return err
	}
	uid, err := parseStoryUUID(userID)
	if err != nil {
		return err
	}
	emoji = strings.TrimSpace(emoji)
	if emoji == "" {
		return fmt.Errorf("emoji is required")
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO story_reactions (story_id, user_id, emoji)
VALUES ($1, $2, $3)
ON CONFLICT (story_id, user_id) DO UPDATE SET emoji = EXCLUDED.emoji, created_at = NOW()`, sid, uid, emoji)
	return err
}

func (r *PostgresStoriesRepository) GetStoryViewers(ctx context.Context, storyID string) ([]*domain.StoryViewer, error) {
	sid, err := parseStoryUUID(storyID)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries.Query(ctx, `
SELECT u.id, u.username, COALESCE(u.display_name, ''), COALESCE(u.avatar_url, '')
FROM story_views sv
JOIN users u ON u.id = sv.viewer_id
WHERE sv.story_id = $1
ORDER BY sv.viewed_at DESC`, sid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	viewers := make([]*domain.StoryViewer, 0)
	for rows.Next() {
		viewer := &domain.StoryViewer{}
		var id pgtype.UUID
		if err := rows.Scan(&id, &viewer.Username, &viewer.DisplayName, &viewer.AvatarURL); err != nil {
			return nil, err
		}
		viewer.ID = util.UUIDToString(id)
		viewers = append(viewers, viewer)
	}
	return viewers, rows.Err()
}

func (r *PostgresStoriesRepository) CreateHighlight(ctx context.Context, authorID, name, coverURL string) (*domain.StoryHighlight, error) {
	return nil, fmt.Errorf("story highlights are not part of the active storage contract")
}

func (r *PostgresStoriesRepository) AddStoryToHighlight(ctx context.Context, highlightID, storyID string) error {
	return fmt.Errorf("story highlights are not part of the active storage contract")
}

func (r *PostgresStoriesRepository) GetHighlights(ctx context.Context, userID string) ([]*domain.StoryHighlight, error) {
	return nil, fmt.Errorf("story highlights are not part of the active storage contract")
}

var _ domain.StoriesRepository = (*PostgresStoriesRepository)(nil)
