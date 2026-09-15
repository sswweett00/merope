package domain

import (
	"context"
	"time"
)

type Story struct {
	ID         string
	AuthorID   string
	Username   string
	AvatarURL  string
	MediaURL   string
	MediaType  string
	IsArchived bool
	CreatedAt  time.Time
	ExpiresAt  time.Time
	Reactions  map[string]int // emoji -> count
}

type StoryHighlight struct {
	ID        string
	AuthorID  string
	Name      string
	CoverURL  string
	Stories   []*Story
	CreatedAt time.Time
}

type StoriesRepository interface {
	CreateStory(ctx context.Context, authorID, mediaURL, mediaType string, expiryHours int) (*Story, error)
	GetActiveStories(ctx context.Context, userID string) ([]*Story, error)
	RecordView(ctx context.Context, storyID, userID string) error
	React(ctx context.Context, storyID, userID, emoji string) error

	// Highlights
	CreateHighlight(ctx context.Context, authorID, name, coverURL string) (*StoryHighlight, error)
	AddStoryToHighlight(ctx context.Context, highlightID, storyID string) error
	GetHighlights(ctx context.Context, userID string) ([]*StoryHighlight, error)
}

type StoriesService interface {
	PostStory(ctx context.Context, authorID, mediaURL, mType string, expiryHours int) (*Story, error)
	GetFeed(ctx context.Context, userID string) ([]*Story, error)
	ViewStory(ctx context.Context, storyID, userID string) error
	ReactToStory(ctx context.Context, storyID, userID, emoji string) error

	// Highlights
	CreateHighlight(ctx context.Context, authorID, name string, storyIDs []string) (*StoryHighlight, error)
	GetHighlights(ctx context.Context, userID string) ([]*StoryHighlight, error)
}
