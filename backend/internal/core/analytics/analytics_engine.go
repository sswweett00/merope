package analytics

import (
	"context"
	"time"
	"local/merope/internal/core/events"
	"local/merope/internal/core/logger"
	ch "local/merope/internal/platform/clickhouse"
)

type EngagementMetrics struct {
	UserID       string
	PostID       string
	LikeCount    int64
	CommentCount int64
	ResonanceCount int64
	Shares       int64
	Reach        int64
	Impressions  int64
	EngagementRate float64
	TimeWindow   string
	RecordedAt   time.Time
}

type UserStats struct {
	UserID          string
	Period          string // daily, weekly, monthly
	TimezoneOffset  int
	PostsPublished  int64
	TotalLikes      int64
	TotalComments   int64
	NewFollowers    int64
	LostFollowers   int64
	FollowersGainedToday int64
	InfluenceRank   int64
	EngagementRate  float64
	ContentScore    float64
	Reach           int64
	AudienceGrowth  float64
	RetentionRate   float64
	RecalculateAt   time.Time
}

func NewAnalyticsEngine(chClient *ch.Client, bus events.Publisher) *AnalyticsEngine {
	return &AnalyticsEngine{
		ch: chClient,
		bus: bus,
	}
}

type AnalyticsEngine struct {
	ch   *ch.Client
	bus  events.Publisher
}

func (e *AnalyticsEngine) AggregateDailyStats(ctx context.Context, date time.Time) error {
	dayStart := time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, time.UTC)
	dayEnd := dayStart.Add(24 * time.Hour)

	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}

	err := e.ch.InsertEngagementMetrics(ctx, &ch.EngagementMetrics{
		TimeBucket: dayStart,
		PostID: "",
		UserID: "",
		LikeCount: 0,
		CommentCount: 0,
		ShareCount: 0,
		ViewCount: 0,
	})
	if err != nil {
		logger.Warn("Analytics aggregation failed, retrying")
		_ = e.bus.Publish(ctx, "analytics.aggregation.failed", events.Event{
			Type: "ANALYTICS_AGGREGATION_FAILED",
			Payload: map[string]interface{}{
				"date": dayStart.Unix(),
				"error": err.Error(),
			},
		})
		return err
	}

	logger.Info("Daily analytics aggregated", "date", dayStart.Format("2006-01-02"))
	return nil
}

func (e *AnalyticsEngine) RecalculateInfluenceRank(ctx context.Context, userID string) error {
	score, err := e.ch.GetUserInfluenceScore(ctx, userID)
	if err != nil {
		return err
	}

	_ = e.bus.Publish(ctx, "analytics.rank.recalculated", events.Event{
		Type: "INFLUENCE_RANK_RECALCULATED",
		Payload: map[string]interface{}{
			"user_id": userID,
			"influence_score": score,
		},
	})

	return nil
}

func (e *AnalyticsEngine) RefreshTrendingTopics(ctx context.Context) error {
	// Refresh trend calculations
	return nil
}

func (e *AnalyticsEngine) GenerateReport(ctx context.Context, tenantID string, period string) (*AnalyticsReport, error) {
	return &AnalyticsReport{}, nil
}

type AnalyticsReport struct {
	ID            string
	TenantID      string
	PeriodStart   time.Time
	PeriodEnd     time.Time
	TotalUsers    int64
	ActiveUsers   int64
	NewSignups    int64
	TotalPosts    int64
	TotalMessages int64
	TotalRevenue  float64
	TopHashtags   []string
	GeneratedAt   time.Time
}

type AnalyticsRepository interface {
	GetUserEngagement(ctx context.Context, userID string, days int) ([]*EngagementMetrics, error)
	GetUserStats(ctx context.Context, userID string, period string) (*UserStats, error)
	RecordEngagement(ctx context.Context, metrics *EngagementMetrics) error
	GetContentAnalytics(ctx context.Context, contentID string) (map[string]interface{}, error)
	GetFunnelAnalytics(ctx context.Context, funnel string, days int) ([]map[string]interface{}, error)
	GetRetentionCohort(ctx context.Context, cohortDate time.Time) ([]*CohortMetric, error)
	GetTopContent(ctx context.Context, contentType string, limit int) ([]map[string]interface{}, error)
}

type CohortMetric struct {
	CohortDate  time.Time
	SignupCount int64
	Day1        int64
	Day7        int64
	Day30       int64
}
