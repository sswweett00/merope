package service

import (
	"context"

	"local/merope/internal/modules/search/domain"
)

type searchService struct {
	repo   domain.SearchRepository
	esRepo domain.ElasticsearchRepository
}

func NewSearchService(repo domain.SearchRepository, esRepo domain.ElasticsearchRepository) domain.SearchService {
	return &searchService{repo: repo, esRepo: esRepo}
}

func (s *searchService) UniversalSearch(ctx context.Context, userID, query string) ([]*domain.SearchResult, error) {
	_ = s.repo.SaveHistory(ctx, userID, query)

	if s.esRepo != nil {
		results, err := s.esRepo.FullTextSearch(ctx, query, 20)
		if err == nil && len(results) > 0 {
			return results, nil
		}
	}

	return s.repo.Search(ctx, query, 20)
}

func (s *searchService) GetRecentHistory(ctx context.Context, userID string) ([]*domain.SearchHistory, error) {
	return s.repo.GetHistory(ctx, userID)
}

func (s *searchService) GetInterests(ctx context.Context, userID string) ([]string, error) {
	return s.repo.GetInterests(ctx, userID)
}

func (s *searchService) UpdateInterests(ctx context.Context, userID string, interests []string) error {
	for _, interest := range interests {
		_ = s.repo.AddInterest(ctx, userID, interest)
	}
	return nil
}

func (s *searchService) SuggestPeople(ctx context.Context, userID string) ([]*domain.SearchResult, error) {
	return s.repo.Search(ctx, "user", 10)
}

func (s *searchService) GetAutocomplete(ctx context.Context, query string, limit int) ([]*domain.SearchResult, error) {
	if s.esRepo != nil {
		suggestions, err := s.esRepo.Autocomplete(ctx, query, limit)
		if err == nil {
			return suggestions, nil
		}
	}
	return s.repo.Search(ctx, query, limit)
}

func (s *searchService) UpdateLocation(ctx context.Context, userID string, lat, lon float64, ghost bool) error {
	return s.repo.UpdateLocation(ctx, userID, lat, lon, ghost)
}

func (s *searchService) DiscoverNearby(ctx context.Context, lat, lon, radius float64, limit int) ([]*domain.NearbyUser, error) {
	return s.repo.GetNearby(ctx, lat, lon, radius, limit)
}
