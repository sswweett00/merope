package domain

import (
	"context"
	"time"
)

type Story struct {
	ID            string         `json:"id"`
	AuthorID      string         `json:"user_id"`
	Username      string         `json:"username,omitempty"`
	AvatarURL     string         `json:"avatar_url,omitempty"`
	MediaURL      string         `json:"media_url"`
	MediaType     string         `json:"media_type"`
	IsArchived    bool           `json:"is_archived,omitempty"`
	CreatedAt     time.Time      `json:"created_at"`
	ExpiresAt     time.Time      `json:"expires_at"`
	IsViewed      bool           `json:"is_viewed"`
	ViewCount     int32          `json:"view_count"`
	ReactionCount int32          `json:"reaction_count"`
	Reactions     map[string]int `json:"reactions,omitempty"`
}

type StoryViewer struct {
	ID          string `json:"id"`
	Username    string `json:"username"`
	DisplayName string `json:"display_name,omitempty"`
	AvatarURL   string `json:"avatar_url,omitempty"`
}

type StoryHighlight struct {
	ID        string    `json:"id"`
	AuthorID  string    `json:"author_id"`
	Name      string    `json:"name"`
	CoverURL  string    `json:"cover_url,omitempty"`
	Stories   []*Story  `json:"stories"`
	CreatedAt time.Time `json:"created_at"`
}

type StoriesRepository interface {
	CreateStory(ctx context.Context, authorID, mediaURL, mediaType string, expiryHours int) (*Story, error)
	GetActiveStories(ctx context.Context, userID string) ([]*Story, error)
	GetLatestStoryForUser(ctx context.Context, userID string) (*Story, error)
	RecordView(ctx context.Context, storyID, userID string) error
	React(ctx context.Context, storyID, userID, emoji string) error
	GetStoryViewers(ctx context.Context, storyID string) ([]*StoryViewer, error)

	// Highlights
	CreateHighlight(ctx context.Context, authorID, name, coverURL string) (*StoryHighlight, error)
	AddStoryToHighlight(ctx context.Context, highlightID, storyID string) error
	GetHighlights(ctx context.Context, userID string) ([]*StoryHighlight, error)
}

type StoriesService interface {
	PostStory(ctx context.Context, authorID, mediaURL, mType string, expiryHours int) (*Story, error)
	GetFeed(ctx context.Context, userID string) ([]*Story, error)
	GetLatestStoryForUser(ctx context.Context, userID string) (*Story, error)
	ViewStory(ctx context.Context, storyID, userID string) error
	ReactToStory(ctx context.Context, storyID, userID, emoji string) error
	GetStoryViewers(ctx context.Context, storyID string) ([]*StoryViewer, error)

	// Highlights
	CreateHighlight(ctx context.Context, authorID, name string, storyIDs []string) (*StoryHighlight, error)
	GetHighlights(ctx context.Context, userID string) ([]*StoryHighlight, error)
}
