package service

import (
	"context"

	"local/merope/internal/modules/stories/domain"
)

type storiesService struct {
	repo domain.StoriesRepository
}

func NewStoriesService(repo domain.StoriesRepository) domain.StoriesService {
	return &storiesService{repo: repo}
}

func (s *storiesService) PostStory(ctx context.Context, authorID, mediaURL, mType string, expiryHours int) (*domain.Story, error) {
	if expiryHours <= 0 {
		expiryHours = 24
	}
	return s.repo.CreateStory(ctx, authorID, mediaURL, mType, expiryHours)
}

func (s *storiesService) GetFeed(ctx context.Context, userID string) ([]*domain.Story, error) {
	return s.repo.GetActiveStories(ctx, userID)
}

func (s *storiesService) GetLatestStoryForUser(ctx context.Context, userID string) (*domain.Story, error) {
	return s.repo.GetLatestStoryForUser(ctx, userID)
}

func (s *storiesService) ViewStory(ctx context.Context, storyID, userID string) error {
	return s.repo.RecordView(ctx, storyID, userID)
}

func (s *storiesService) ReactToStory(ctx context.Context, storyID, userID, emoji string) error {
	return s.repo.React(ctx, storyID, userID, emoji)
}

func (s *storiesService) GetStoryViewers(ctx context.Context, storyID string) ([]*domain.StoryViewer, error) {
	return s.repo.GetStoryViewers(ctx, storyID)
}

func (s *storiesService) CreateHighlight(ctx context.Context, authorID, name string, storyIDs []string) (*domain.StoryHighlight, error) {
	h, err := s.repo.CreateHighlight(ctx, authorID, name, "")
	if err != nil {
		return nil, err
	}
	for _, sid := range storyIDs {
		if err := s.repo.AddStoryToHighlight(ctx, h.ID, sid); err != nil {
			return nil, err
		}
	}
	return h, nil
}

func (s *storiesService) GetHighlights(ctx context.Context, userID string) ([]*domain.StoryHighlight, error) {
	return s.repo.GetHighlights(ctx, userID)
}
