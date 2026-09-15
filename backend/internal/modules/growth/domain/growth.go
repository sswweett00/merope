package domain

import (
	"context"
	"time"
)

type Referral struct {
	ID            string
	ReferrerID    string
	ReferredID    string
	Code          string
	RewardGranted bool
	CreatedAt     time.Time
}

type InfluenceRank struct {
	UserID    string
	Score     float64
	Rank      int
	UpdatedAt time.Time
}

type GrowthRepository interface {
	CreateReferral(ctx context.Context, ref *Referral) error
	UpdateInfluence(ctx context.Context, userID string, delta float64) error
	GetLeaderboard(ctx context.Context, limit int) ([]*InfluenceRank, error)
}

type GrowthService interface {
	TrackSignup(ctx context.Context, referrerID, referredID, code string) error
	CalculateInfluence(ctx context.Context, userID string) (float64, error)
	GetTopInfluencers(ctx context.Context, limit int) ([]*InfluenceRank, error)
}
