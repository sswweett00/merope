package domain

import (
	"context"
	"time"
)

type ContentTask struct {
	TargetID    string
	ContentType string
	Text        string
	MediaURL    string
}

type AIRepository interface {
	StoreAnalysis(ctx context.Context, analysis *ContentAnalysis) error
	GetAnalysis(ctx context.Context, id string) (*ContentAnalysis, error)
	GetAnalysesByTarget(ctx context.Context, targetID string) ([]*ContentAnalysis, error)
	BatchStoreAnalyses(ctx context.Context, analyses []*ContentAnalysis) error
	StoreUserVector(ctx context.Context, vector *UserProfileVector) error
	GetUserVector(ctx context.Context, userID string) (*UserProfileVector, error)
	StoreRecommendationLog(ctx context.Context, userID, contentID string, score float64, reason string) error
	IncrementTrendScore(ctx context.Context, topic string, delta float64) error
	GetTrendTopics(ctx context.Context, window time.Duration) ([]TrendTopic, error)
	RefreshTrendMaterializedView(ctx context.Context) error
}

type AIService interface {
	AnalyzeContent(ctx context.Context, targetID, contentType, text, mediaURL string) (*ContentAnalysis, error)
	AnalyzeBatch(ctx context.Context, tasks []ContentTask) ([]*ContentAnalysis, error)
	GetRecommendations(ctx context.Context, req *RecommendationRequest) (*RecommendationResponse, error)
	GetTrendingTopics(ctx context.Context, window time.Duration) ([]TrendTopic, error)
	ClassifyEntity(ctx context.Context, text string) ([]EntityMention, error)
}
