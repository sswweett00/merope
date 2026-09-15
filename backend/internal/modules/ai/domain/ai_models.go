package domain

import (
	"time"
)

type ContentAnalysis struct {
	ID            string
	TargetID      string
	ContentType   string
	ToxicityScore float64
	Sentiment     SentimentResult
	Categories    map[string]float64
	Confidence    float64
	ModelVersion  string
	CreatedAt     time.Time
}

type UserProfileVector struct {
	UserID           string
	Interests        []string
	EngagementVector map[string]float64
	LastUpdated      time.Time
}

type RecommendationItem struct {
	TargetID    string
	Score       float64
	Reason      string
	ContentType string
	CreatedAt   time.Time
}

type RecommendationRequest struct {
	UserID      string
	Limit       int
	ContentType string
	ExcludeIDs  []string
}

type RecommendationResponse struct {
	Items      []*RecommendationItem
	NextCursor string
}

type EntityMention struct {
	ID         string
	EntityType string
	EntityID   string
	Text       string
	Confidence float64
}

type TrendTopic struct {
	Topic      string
	Score      float64
	GrowthRate float64
	PostCount  int64
	SeedUsers  []string
}

type SentimentResult struct {
	Score     float64
	Magnitude float64
	Emotions  map[string]float64
}
