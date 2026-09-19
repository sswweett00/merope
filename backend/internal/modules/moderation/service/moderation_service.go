package service

import (
	"context"
	"strings"
	"time"

	"local/merope/internal/core/security"
	"local/merope/internal/modules/moderation/domain"
)

type moderationService struct {
	repo domain.ModerationRepository
}

func NewModerationService(repo domain.ModerationRepository) domain.ModerationService {
	return &moderationService{repo: repo}
}

func (s *moderationService) ReportContent(ctx context.Context, reporterID, targetType, targetID, reason string) error {
	report := &domain.Report{
		ReporterID: reporterID,
		TargetType: targetType,
		TargetID:   targetID,
		Reason:     security.SanitizeHTML(reason),
		Status:     "pending",
		CreatedAt:  time.Now(),
	}
	return s.repo.CreateReport(ctx, report)
}

func (s *moderationService) IdentifyBots(ctx context.Context) ([]*domain.SuspiciousAccount, error) {
	return s.repo.GetSuspiciousAccounts(ctx)
}

func (s *moderationService) BanAccount(ctx context.Context, userID string) error {
	return s.repo.ResolveSuspiciousAccount(ctx, userID, "banned")
}

func (s *moderationService) MarkAccountSafe(ctx context.Context, userID string) error {
	return s.repo.ResolveSuspiciousAccount(ctx, userID, "safe")
}

func (s *moderationService) AutoFlagContent(ctx context.Context, contentType, contentID, authorID string) error {
	classification, _ := s.ClassifyContent(ctx, contentType, contentID, "")
	if classification.Score == 0 {
		return nil
	}

	item := &domain.ReviewQueueItem{
		ContentType: contentType,
		ContentID:   contentID,
		AuthorID:    authorID,
		AutoScore:   classification.Score,
		AutoReasons: classification.Reasons,
		Status:      "pending",
		CreatedAt:   time.Now(),
	}
	return s.repo.EnqueueAutoReview(ctx, item)
}

func (s *moderationService) ClassifyContent(ctx context.Context, contentType, contentID, text string) (*domain.ContentClassification, error) {
	classification := &domain.ContentClassification{
		Score:      0,
		Categories: map[string]float64{},
		Reasons:    []string{},
		Confidence: 0,
	}

	if text == "" {
		return classification, nil
	}

	lowerText := strings.ToLower(text)
	words := strings.Fields(lowerText)

	if len(words) == 0 {
		return classification, nil
	}

	capsCount := 0
	for _, r := range text {
		if r >= 'A' && r <= 'Z' {
			capsCount++
		}
	}
	if len(words) > 5 && float64(capsCount)/float64(len(text)) > 0.5 {
		classification.Reasons = append(classification.Reasons, "excessive_caps")
		classification.Score += 0.2
		classification.Categories["spam"] = 0.3
	}

	uniqWords := make(map[string]bool)
	for _, w := range words {
		uniqWords[w] = true
	}
	repeatRatio := float64(len(uniqWords)) / float64(len(words))
	if repeatRatio < 0.3 && len(words) > 10 {
		classification.Reasons = append(classification.Reasons, "repetitive_content")
		classification.Score += 0.25
		classification.Categories["spam"] += 0.3
	}

	mentionCount := strings.Count(text, "@")
	if mentionCount > 5 {
		classification.Reasons = append(classification.Reasons, "excessive_mentions")
		classification.Score += 0.3
		classification.Categories["spam"] += 0.4
	}

	spamPatterns := []string{"click here", "free money", "win prize", "limited time", "act now", "buy now", "discount code"}
	for _, pattern := range spamPatterns {
		if strings.Contains(lowerText, pattern) {
			classification.Reasons = append(classification.Reasons, "spam_pattern: "+pattern)
			classification.Score += 0.4
			classification.Categories["spam"] += 0.5
			break
		}
	}

	if classification.Score > 0.7 {
		classification.Action = "hide_pending_review"
		classification.Confidence = min(classification.Score, 1.0)
	} else if classification.Score > 0.4 {
		classification.Action = "flag_for_review"
		classification.Confidence = min(classification.Score, 0.8)
	}

	return classification, nil
}

func min(a, b float64) float64 {
	if a < b {
		return a
	}
	return b
}

func (s *moderationService) GetReviewQueue(ctx context.Context, status string, page int32) ([]*domain.ReviewQueueItem, error) {
	limit := int32(20)
	offset := page * limit
	return s.repo.GetReviewQueue(ctx, status, limit, offset)
}

func (s *moderationService) AssignReview(ctx context.Context, queueID, reviewerID string) error {
	return s.repo.AssignReviewer(ctx, queueID, reviewerID)
}

func (s *moderationService) ResolveReview(ctx context.Context, queueID, decision string) error {
	return s.repo.ResolveReview(ctx, queueID, decision)
}

func (s *moderationService) GetAuthorStats(ctx context.Context, authorID string) (float64, error) {
	items, err := s.repo.GetAuthorReviewHistory(ctx, authorID, 50)
	if err != nil {
		return 0, err
	}
	if len(items) == 0 {
		return 0, nil
	}

	totalScore := 0.0
	for _, item := range items {
		totalScore += item.AutoScore
	}
	return totalScore / float64(len(items)), nil
}
