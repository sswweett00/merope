package domain

import (
    "context"
    "time"
)

type Profile struct {
    UserID          string    `json:"user_id"`
    XP              int64     `json:"xp"`
    Level           int       `json:"level"`
    NextLevelXP     int64     `json:"next_level_xp"`
    Reputation      int64     `json:"reputation"`
    Energy          int       `json:"energy"`
    CurrentStreak   int       `json:"current_streak"`
    LongestStreak   int       `json:"longest_streak"`
    Combo           int       `json:"combo"`
    ComboMultiplier float64   `json:"combo_multiplier"`
    BoostActive     bool      `json:"boost_active"`
    BoostUntil      *time.Time `json:"boost_until,omitempty"`
    StreakShields   int       `json:"streak_shields"`
    Tier            string    `json:"tier"`
    SeasonXP        int64     `json:"season_xp"`
    SeasonRank      int       `json:"season_rank"`
}

type EventResult struct {
    Applied          bool        `json:"applied"`
    XP              int64       `json:"xp"`
    XPGranted       int64       `json:"xp_granted"`
    Multiplier       float64     `json:"multiplier"`
    Level           int         `json:"level"`
    LevelUp         bool        `json:"level_up"`
    CurrentStreak   int         `json:"current_streak"`
    Combo           int         `json:"combo"`
    QuestProgress   int         `json:"quest_progress"`
    Achievements    []Achievement `json:"achievements"`
}

type Quest struct {
    ID               string `json:"id"`
    Code             string `json:"code"`
    Title            string `json:"title"`
    Description      string `json:"description"`
    Action           string `json:"action"`
    Target           int    `json:"target"`
    Progress         int    `json:"progress"`
    XPReward         int64  `json:"xp_reward"`
    ReputationReward int64  `json:"reputation_reward"`
    Cadence          string `json:"cadence"`
    Claimed          bool   `json:"claimed"`
    Completed        bool   `json:"completed"`
}

type Achievement struct {
    ID               string    `json:"id"`
    Code             string    `json:"code"`
    Name             string    `json:"name"`
    Description      string    `json:"description"`
    Icon             string    `json:"icon"`
    XPReward         int64     `json:"xp_reward"`
    ReputationReward int64     `json:"reputation_reward"`
    UnlockedAt       *time.Time `json:"unlocked_at,omitempty"`
    Unlocked         bool      `json:"unlocked"`
}

type LeaderboardEntry struct {
    Rank  int    `json:"rank"`
    UserID string `json:"user_id"`
    XP    int64  `json:"xp"`
}

type GrowthRepository interface {
    CreateReferral(ctx context.Context, ref *Referral) error
    UpdateInfluence(ctx context.Context, userID string, delta float64) error
    GetLeaderboard(ctx context.Context, limit int) ([]*InfluenceRank, error)

    GetProfile(ctx context.Context, userID string) (*Profile, error)
    RecordEvent(ctx context.Context, userID, action, sourceID string) (*EventResult, error)
    ListQuests(ctx context.Context, userID string, cadence string) ([]*Quest, error)
    ClaimQuest(ctx context.Context, userID, questID string) (*Quest, error)
    ClaimStreakShield(ctx context.Context, userID string) (*Profile, error)
    ActivateBoost(ctx context.Context, userID string, energyCost int, duration time.Duration) (*Profile, error)
    ListAchievements(ctx context.Context, userID string) ([]*Achievement, error)
    GetSeasonLeaderboard(ctx context.Context, userID string, limit int) ([]*LeaderboardEntry, error)
}

type GrowthService interface {
    TrackSignup(ctx context.Context, referrerID, referredID, code string) error
    CalculateInfluence(ctx context.Context, userID string) (float64, error)
    GetTopInfluencers(ctx context.Context, limit int) ([]*InfluenceRank, error)

    GetProfile(ctx context.Context, userID string) (*Profile, error)
    RecordEvent(ctx context.Context, userID, action, sourceID string) (*EventResult, error)
    ListQuests(ctx context.Context, userID, cadence string) ([]*Quest, error)
    ClaimQuest(ctx context.Context, userID, questID string) (*Quest, error)
    ClaimStreakShield(ctx context.Context, userID string) (*Profile, error)
    ActivateBoost(ctx context.Context, userID string) (*Profile, error)
    ListAchievements(ctx context.Context, userID string) ([]*Achievement, error)
    GetSeasonLeaderboard(ctx context.Context, userID string, limit int) ([]*LeaderboardEntry, error)
}
