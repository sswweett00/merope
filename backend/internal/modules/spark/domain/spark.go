package domain

import (
	"context"
)

type Match struct {
	UserAID string
	UserBID string
	Score   float64
}

type SparkService interface {
	FindMatch(ctx context.Context, userID string) (*Match, error)
	GetResonanceScore(ctx context.Context, userAID, userBID string) float64
}

type SparkRepository interface {
	FindMatch(ctx context.Context, userID string) (*Match, error)
	GetResonanceScore(ctx context.Context, userAID, userBID string) (float64, error)
}
