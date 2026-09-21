package service

import (
    "context"
    "fmt"
    "math"
    "strings"
    "time"

    "local/merope/internal/modules/growth/domain"
)

type growthService struct {
    repo domain.GrowthRepository
}

func NewGrowthService(repo domain.GrowthRepository) domain.GrowthService {
    return &growthService{repo: repo}
}

func (s *growthService) TrackSignup(ctx context.Context, referrerID, referredID, code string) error {
    ref := &domain.Referral{
        ReferrerID: referrerID,
        ReferredID: referredID,
        Code:       code,
    }
    return s.repo.CreateReferral(ctx, ref)
}

func (s *growthService) CalculateInfluence(ctx context.Context, userID string) (float64, error) {
    profile, err := s.repo.GetProfile(ctx, userID)
    if err != nil {
        return 0, err
    }
    return float64(profile.Reputation) + float64(profile.Level*10) + float64(profile.CurrentStreak), nil
}

func (s *growthService) GetTopInfluencers(ctx context.Context, limit int) ([]*domain.InfluenceRank, error) {
    return s.repo.GetLeaderboard(ctx, limit)
}

func (s *growthService) GetProfile(ctx context.Context, userID string) (*domain.Profile, error) {
    profile, err := s.repo.GetProfile(ctx, userID)
    if err != nil {
        return nil, err
    }
    profile.Tier = TierForLevel(profile.Level)
    return profile, nil
}

func (s *growthService) RecordEvent(ctx context.Context, userID, action, sourceID string) (*domain.EventResult, error) {
    action = strings.TrimSpace(strings.ToLower(action))
    sourceID = strings.TrimSpace(sourceID)
    if userID == "" || action == "" || sourceID == "" {
        return nil, fmt.Errorf("user_id, action and source_id are required")
    }

    allowed := map[string]bool{
        "daily_login": true,
        "post_created": true,
        "comment_created": true,
        "reaction_added": true,
        "message_sent": true,
        "content_viewed": true,
        "follow_created": true,
        "story_created": true,
        "story_viewed": true,
        "community_joined": true,
        "community_event_rsvp": true,
        "referral_completed": true,
    }
    if !allowed[action] {
        return nil, fmt.Errorf("unsupported progression action")
    }

    return s.repo.RecordEvent(ctx, userID, action, sourceID)
}

func (s *growthService) ListQuests(ctx context.Context, userID, cadence string) ([]*domain.Quest, error) {
    if cadence != "daily" && cadence != "weekly" && cadence != "all" {
        cadence = "daily"
    }
    return s.repo.ListQuests(ctx, userID, cadence)
}

func (s *growthService) ClaimQuest(ctx context.Context, userID, questID string) (*domain.Quest, error) {
    return s.repo.ClaimQuest(ctx, userID, questID)
}

func (s *growthService) ClaimStreakShield(ctx context.Context, userID string) (*domain.Profile, error) {
    return s.repo.ClaimStreakShield(ctx, userID)
}

func (s *growthService) ActivateBoost(ctx context.Context, userID string) (*domain.Profile, error) {
    return s.repo.ActivateBoost(ctx, userID, 20, 15*time.Minute)
}

func (s *growthService) ListAchievements(ctx context.Context, userID string) ([]*domain.Achievement, error) {
    return s.repo.ListAchievements(ctx, userID)
}

func (s *growthService) GetSeasonLeaderboard(ctx context.Context, userID string, limit int) ([]*domain.LeaderboardEntry, error) {
    if limit <= 0 || limit > 100 {
        limit = 20
    }
    return s.repo.GetSeasonLeaderboard(ctx, userID, limit)
}

func LevelForXP(xp int64) int {
    if xp <= 0 {
        return 1
    }
    // Progression curve: level 2 at 100 XP, then quadratic growth.
    return int(math.Floor(math.Sqrt(float64(xp)/100.0))) + 1
}

func NextLevelXP(level int) int64 {
    if level < 1 {
        level = 1
    }
    return int64(level*level) * 100
}

func TierForLevel(level int) string {
    switch {
    case level >= 50:
        return "Apex"
    case level >= 25:
        return "Nova"
    case level >= 15:
        return "Orbit"
    case level >= 10:
        return "Pulse"
    case level >= 5:
        return "Spark"
    default:
        return "Seed"
    }
}
