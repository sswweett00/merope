package domain

import (
	"context"
	"time"
)

type SearchResult struct {
	Type     string  `json:"type"` // user, post, community, event
	ID       string  `json:"id"`
	Title    string  `json:"title"`
	Subtitle string  `json:"subtitle"`
	Score    float64 `json:"score"`
}

type SearchHistory struct {
	ID        string
	UserID    string
	Query     string
	CreatedAt time.Time
}

type NearbyUser struct {
	ID        string  `json:"id"`
	Username  string  `json:"username"`
	AvatarUrl string  `json:"avatar_url"`
	Distance  float64 `json:"distance"`
}

type ElasticsearchRepository interface {
	FullTextSearch(ctx context.Context, query string, limit int) ([]*SearchResult, error)
	Autocomplete(ctx context.Context, query string, limit int) ([]*SearchResult, error)
	IndexPost(ctx context.Context, id, content, authorName string) error
	IndexUser(ctx context.Context, id, username, displayName string) error
	DeleteIndex(ctx context.Context, id, indexType string) error
}

type SearchRepository interface {
	Search(ctx context.Context, query string, limit int) ([]*SearchResult, error)
	IndexUser(ctx context.Context, id, username string) error
	IndexPost(ctx context.Context, id, content string) error
	SaveHistory(ctx context.Context, userID, query string) error
	GetHistory(ctx context.Context, userID string) ([]*SearchHistory, error)
	AddInterest(ctx context.Context, userID, interest string) error
	GetInterests(ctx context.Context, userID string) ([]string, error)
	UpdateLocation(ctx context.Context, userID string, lat, lon float64, ghost bool) error
	GetNearby(ctx context.Context, lat, lon, radius float64, limit int) ([]*NearbyUser, error)
}

type SearchService interface {
	UniversalSearch(ctx context.Context, userID, query string) ([]*SearchResult, error)
	GetRecentHistory(ctx context.Context, userID string) ([]*SearchHistory, error)
	UpdateInterests(ctx context.Context, userID string, interests []string) error
	SuggestPeople(ctx context.Context, userID string) ([]*SearchResult, error)
	GetAutocomplete(ctx context.Context, query string, limit int) ([]*SearchResult, error)
	UpdateLocation(ctx context.Context, userID string, lat, lon float64, ghost bool) error
	DiscoverNearby(ctx context.Context, lat, lon, radius float64, limit int) ([]*NearbyUser, error)
}
