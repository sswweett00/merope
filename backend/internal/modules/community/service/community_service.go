package service

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/core/security"
	"local/merope/internal/modules/community/domain"

	"github.com/google/uuid"
)

type communityService struct {
	repo domain.CommunityRepository
}

func NewCommunityService(repo domain.CommunityRepository) domain.CommunityService {
	return &communityService{repo: repo}
}

func (s *communityService) CreateGroup(ctx context.Context, ownerID, name, desc string, isPrivate bool) (*domain.Community, error) {
	if name == "" {
		return nil, fmt.Errorf("community name is required")
	}

	slug := security.SanitizeHTML(name)
	slug = security.StripHTML(slug)
	
	comm := &domain.Community{
		ID:          uuid.New().String(),
		OwnerID:     ownerID,
		Name:        security.StripHTML(name),
		Slug:        slug,
		Description: security.SanitizeHTML(desc),
		IsPrivate:   isPrivate,
		MemberCount: 1,
		PostCount:   0,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
		Category:    "general",
		Tags:        []string{},
		Rules:       []string{},
		Settings: domain.CommunitySettings{
			AllowGuestPosts:     false,
			RequireModeration:   false,
			EnableVoiceChat:     true,
			EnableVideoChat:     true,
			EnableScreenShare:   true,
			MaxMembers:         10000,
			AutoDeleteAfterDays: 0,
			ContentFilterLevel:  "medium",
			Language:            "en",
			Timezone:            "UTC",
		},
		Stats: domain.CommunityStats{
			DailyActiveUsers:    1,
			WeeklyActiveUsers:   1,
			MonthlyActiveUsers:  1,
			TotalPosts:          0,
			TotalComments:       0,
			TotalEvents:         0,
			AvgEngagementScore:  0.0,
			ReportCount:         0,
			WarningCount:        0,
		},
	}

	if err := s.repo.CreateCommunity(ctx, comm); err != nil {
		return nil, err
	}
	
	// Add owner as member
	_ = s.repo.JoinCommunity(ctx, comm.ID, ownerID, "owner")
	
	return comm, nil
}

func (s *communityService) Join(ctx context.Context, commID, userID string) error {
	return s.repo.JoinCommunity(ctx, commID, userID, "member")
}

func (s *communityService) Leave(ctx context.Context, commID, userID string) error {
	return s.repo.LeaveCommunity(ctx, commID, userID)
}

// Event Management

func (s *communityService) OrganizeEvent(ctx context.Context, event *domain.Event) (*domain.Event, error) {
	if event.ID == "" {
		event.ID = uuid.New().String()
	}
	
	if event.CreatedAt.IsZero() {
		event.CreatedAt = time.Now()
	}
	
	event.UpdatedAt = time.Now()
	
	if err := s.repo.CreateEvent(ctx, event); err != nil {
		return nil, err
	}
	return event, nil
}

func (s *communityService) AttendEvent(ctx context.Context, eventID, userID string) error {
	return s.repo.RSVP(ctx, eventID, userID, "attending")
}

func (s *communityService) CancelEvent(ctx context.Context, eventID string) error {
	event, err := s.repo.GetEvent(ctx, eventID)
	if err != nil {
		return err
	}
	
	event.Status = "cancelled"
	event.UpdatedAt = time.Now()
	
	return s.repo.UpdateEvent(ctx, eventID, event)
}

func (s *communityService) UpdateEvent(ctx context.Context, eventID string, updates *domain.Event) error {
	return s.repo.UpdateEvent(ctx, eventID, updates)
}

// Subscription Management

func (s *communityService) SubscribeToCreator(ctx context.Context, subID, creatorID, tier string) error {
	return s.repo.CreateSubscription(ctx, subID, creatorID, tier, time.Now().Add(30*24*time.Hour))
}

func (s *communityService) CancelSubscription(ctx context.Context, subID string) error {
	return s.repo.CancelSubscription(ctx, subID)
}

func (s *communityService) UpdateSubscriptionTier(ctx context.Context, subID, tier string) error {
	return s.repo.UpdateSubscription(ctx, subID, tier)
}

// Synergy Collectives

func (s *communityService) FormCollective(ctx context.Context, name, desc, icon string) (*domain.Collective, error) {
	slug := security.SanitizeHTML(name)
	
	coll := &domain.Collective{
		ID:          uuid.New().String(),
		Name:        security.StripHTML(name),
		Slug:        slug,
		Description: security.SanitizeHTML(desc),
		Icon:        icon,
		NodeCount:   0,
		Influence:   0.0,
		MemberCount: 0,
		IsOfficial:  false,
		Category:    "general",
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
		Stats: domain.CollectiveStats{
			TotalThreads:    0,
			TotalReplies:   0,
			ActiveMembers:  0,
			WeeklyActivity: 0,
		},
	}
	
	if err := s.repo.CreateCollective(ctx, coll); err != nil {
		return nil, err
	}
	return coll, nil
}

func (s *communityService) StartThread(ctx context.Context, collectiveID, authorID, title, content string) (*domain.Thread, error) {
	thread := &domain.Thread{
		ID:           uuid.New().String(),
		CollectiveID: collectiveID,
		AuthorID:     authorID,
		Title:        security.StripHTML(title),
		Content:      security.SanitizeHTML(content),
		Resonance:    0,
		ViewCount:    0,
		ReplyCount:   0,
		IsPinned:     false,
		IsLocked:     false,
		IsAnnouncement: false,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
		Tags:         []string{},
		Category:     "general",
	}
	
	if err := s.repo.CreateThread(ctx, thread); err != nil {
		return nil, err
	}
	return thread, nil
}

func (s *communityService) Resonate(ctx context.Context, threadID string, isPositive bool) error {
	delta := 1
	if !isPositive {
		delta = -1
	}
	return s.repo.ResonateThread(ctx, threadID, delta)
}

func (s *communityService) ReplyToThread(ctx context.Context, threadID, authorID, content string) (*domain.ThreadReply, error) {
	reply := &domain.ThreadReply{
		ID:        uuid.New().String(),
		ThreadID:  threadID,
		AuthorID:  authorID,
		Content:   security.SanitizeHTML(content),
		Resonance: 0,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
		IsEdited:  false,
		ParentID:  nil,
	}
	
	if err := s.repo.CreateThreadReply(ctx, reply); err != nil {
		return nil, err
	}
	return reply, nil
}

func (s *communityService) PinThread(ctx context.Context, threadID string, pinned bool) error {
	return s.repo.PinThread(ctx, threadID, pinned)
}

func (s *communityService) LockThread(ctx context.Context, threadID string, locked bool) error {
	return s.repo.LockThread(ctx, threadID, locked)
}

// Member Management

func (s *communityService) PromoteMember(ctx context.Context, commID, userID, role string) error {
	return s.repo.UpdateMemberRole(ctx, commID, userID, role)
}

func (s *communityService) DemoteMember(ctx context.Context, commID, userID, role string) error {
	return s.repo.UpdateMemberRole(ctx, commID, userID, role)
}

func (s *communityService) BanMember(ctx context.Context, commID, userID, reason string, duration *time.Time) error {
	return s.repo.BanMember(ctx, commID, userID, reason, duration)
}

func (s *communityService) UnbanMember(ctx context.Context, commID, userID string) error {
	return s.repo.UnbanMember(ctx, commID, userID)
}

// Moderation

func (s *communityService) ReportContent(ctx context.Context, reporterID, contentType, contentID, reason string) error {
	return s.repo.ReportContent(ctx, reporterID, contentType, contentID, reason)
}

func (s *communityService) ResolveReport(ctx context.Context, reportID, resolution string) error {
	return s.repo.ResolveReport(ctx, reportID, resolution)
}

func (s *communityService) SetCommunityGuidelines(ctx context.Context, communityID string, guidelines []*domain.Guideline) error {
	return s.repo.UpdateGuidelines(ctx, communityID, guidelines)
}

// Analytics

func (s *communityService) GetCommunityAnalytics(ctx context.Context, communityID string, period string) (*domain.CommunityAnalytics, error) {
	return s.repo.GetCommunityAnalytics(ctx, communityID, period)
}

func (s *communityService) GetMemberActivity(ctx context.Context, communityID, userID string, period string) (*domain.MemberActivity, error) {
	return s.repo.GetMemberActivity(ctx, communityID, userID, period)
}

// Discovery

func (s *communityService) SearchCommunities(ctx context.Context, query string, filters map[string]interface{}) ([]*domain.Community, error) {
	return s.repo.SearchCommunities(ctx, query, 50, 0)
}

func (s *communityService) GetTrendingCommunities(ctx context.Context, limit int32) ([]*domain.Community, error) {
	return s.repo.GetTrendingCommunities(ctx, limit)
}

func (s *communityService) GetRecommendedCommunities(ctx context.Context, userID string, limit int32) ([]*domain.Community, error) {
	// In a real implementation, this would use recommendation algorithms
	// For now, return trending communities
	return s.repo.GetTrendingCommunities(ctx, limit)
}
