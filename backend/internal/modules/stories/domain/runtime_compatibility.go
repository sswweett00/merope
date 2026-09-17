package domain

import "context"

type StoryViewer struct {
	ID          string `json:"id"`
	Username    string `json:"username"`
	DisplayName string `json:"displayName,omitempty"`
	AvatarURL   string `json:"avatarUrl,omitempty"`
}

type RuntimeStoriesRepository interface {
	StoriesRepository
	GetStoryViewers(context.Context, string) ([]*StoryViewer, error)
}

type RuntimeStoriesService interface {
	StoriesService
	GetStoryViewers(context.Context, string) ([]*StoryViewer, error)
}
