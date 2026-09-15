package domain

import (
	"context"
	"time"
)

type Report struct {
	ID         string
	ReporterID string
	TargetType string
	TargetID   string
	Reason     string
	Status     string
	CreatedAt  time.Time
}

type SuspiciousAccount struct {
	UserID         string    `json:"user_id"`
	TrustScore     float64   `json:"trust_score"`
	BotProbability float64   `json:"bot_probability"`
	Reason         string    `json:"reason"`
	DetectedAt     time.Time `json:"detected_at"`
}

type ReviewQueueItem struct {
	ID          string
	ContentType string
	ContentID   string
	AuthorID    string
	AuthorName  string
	AutoScore   float64
	AutoReasons []string
	Status      string
	AssignedTo  *string
	Resolution  *string
	ReviewedAt  *time.Time
	CreatedAt   time.Time
}

type ModerationRepository interface {
	CreateReport(ctx context.Context, report *Report) error
	GetReports(ctx context.Context, status string) ([]*Report, error)
	ResolveReport(ctx context.Context, reportID string, status string) error

	FlagSuspiciousAccount(ctx context.Context, acc *SuspiciousAccount) error
	GetSuspiciousAccounts(ctx context.Context) ([]*SuspiciousAccount, error)
	ResolveSuspiciousAccount(ctx context.Context, userID string, status string) error

	EnqueueAutoReview(ctx context.Context, item *ReviewQueueItem) error
	GetReviewQueue(ctx context.Context, status string, limit, offset int32) ([]*ReviewQueueItem, error)
	AssignReviewer(ctx context.Context, queueID, reviewerID string) error
	ResolveReview(ctx context.Context, queueID, resolution string) error
	GetAuthorReviewHistory(ctx context.Context, authorID string, limit int) ([]*ReviewQueueItem, error)
}

type ModerationService interface {
	ReportContent(ctx context.Context, reporterID, targetType, targetID, reason string) error
	IdentifyBots(ctx context.Context) ([]*SuspiciousAccount, error)
	BanAccount(ctx context.Context, userID string) error
	MarkAccountSafe(ctx context.Context, userID string) error

	AutoFlagContent(ctx context.Context, contentType, contentID, authorID string) error
	ClassifyContent(ctx context.Context, contentType, contentID, text string) (*ContentClassification, error)
	GetReviewQueue(ctx context.Context, status string, page int32) ([]*ReviewQueueItem, error)
	AssignReview(ctx context.Context, queueID, reviewerID string) error
	ResolveReview(ctx context.Context, queueID, decision string) error
	GetAuthorStats(ctx context.Context, authorID string) (float64, error)
}

type ContentClassification struct {
	Score       float64
	Categories  map[string]float64
	Reasons     []string
	Action      string
	Confidence  float64
}
