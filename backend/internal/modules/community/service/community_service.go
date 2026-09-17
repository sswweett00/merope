package service

import (
	"context"
	"fmt"
	"strings"
	"time"
	"unicode"

	"github.com/google/uuid"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/community/domain"
)

type communityService struct {
	repo domain.CommunityRepository
}

func NewCommunityService(repo domain.CommunityRepository) domain.CommunityService {
	return &communityService{repo: repo}
}

func slugify(value string, id uuid.UUID) string {
	value = strings.ToLower(security.StripHTML(value))
	var b strings.Builder
	lastDash := false
	for _, r := range value {
		switch {
		case unicode.IsLetter(r) || unicode.IsDigit(r):
			b.WriteRune(r)
			lastDash = false
		case !lastDash:
			b.WriteByte('-')
			lastDash = true
		}
	}
	slug := strings.Trim(b.String(), "-")
	if slug == "" {
		slug = "community"
	}
	return fmt.Sprintf("%s-%s", slug, id.String()[:8])
}

func (s *communityService) CreateGroup(ctx context.Context, ownerID, name, desc string, isPrivate bool) (*domain.Community, error) {
	name = strings.TrimSpace(security.StripHTML(name))
	if name == "" {
		return nil, fmt.Errorf("community name is required")
	}

	id := uuid.New()
	comm := &domain.Community{
		ID:          id.String(),
		OwnerID:     ownerID,
		Name:        name,
		Slug:        slugify(name, id),
		Description: strings.TrimSpace(security.SanitizeHTML(desc)),
		IsPrivate:   isPrivate,
		MemberCount: 1,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
		Category:    "general",
		Tags:        []string{},
		Rules:       []string{},
		Settings:    domain.CommunitySettings{},
		Stats:       domain.CommunityStats{},
	}
	if err := s.repo.CreateCommunity(ctx, comm); err != nil {
		return nil, err
	}
	if err := s.repo.JoinCommunity(ctx, comm.ID, ownerID, "owner"); err != nil {
		return nil, err
	}
	return comm, nil
}

func (s *communityService) Join(ctx context.Context, commID, userID string) error {
	return s.repo.JoinCommunity(ctx, commID, userID, "member")
}

func (s *communityService) Leave(ctx context.Context, commID, userID string) error {
	return s.repo.LeaveCommunity(ctx, commID, userID)
}

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

func (s *communityService) SubscribeToCreator(ctx context.Context, subscriberID, creatorID, tier, subID string) error {
	if subID == "" {
		subID = uuid.New().String()
	}
	return s.repo.CreateSubscription(ctx, subID, subscriberID, creatorID, tier, time.Now().Add(30*24*time.Hour))
}

func (s *communityService) CancelSubscription(ctx context.Context, subID string) error {
	return s.repo.CancelSubscription(ctx, subID)
}

func (s *communityService) UpdateSubscriptionTier(ctx context.Context, subID, tier string) error {
	return s.repo.UpdateSubscription(ctx, subID, tier)
}

func (s *communityService) FormCollective(ctx context.Context, name, desc, icon string) (*domain.Collective, error) {
	id := uuid.New()
	cleanName := strings.TrimSpace(security.StripHTML(name))
	if cleanName == "" {
		return nil, fmt.Errorf("collective name is required")
	}
	collective := &domain.Collective{
		ID:          id.String(),
		Name:        cleanName,
		Slug:        slugify(cleanName, id),
		Description: strings.TrimSpace(security.SanitizeHTML(desc)),
		Icon:        strings.TrimSpace(icon),
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
		Stats:       domain.CollectiveStats{},
	}
	if err := s.repo.CreateCollective(ctx, collective); err != nil {
		return nil, err
	}
	return collective, nil
}

func (s *communityService) StartThread(ctx context.Context, collectiveID, authorID, title, content string) (*domain.Thread, error) {
	thread := &domain.Thread{
		ID:           uuid.New().String(),
		CollectiveID: collectiveID,
		AuthorID:     authorID,
		Title:        security.StripHTML(title),
		Content:      security.SanitizeHTML(content),
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
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
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

func (s *communityService) ReportContent(ctx context.Context, reporterID, contentType, contentID, reason string) error {
	return s.repo.ReportContent(ctx, reporterID, contentType, contentID, reason)
}

func (s *communityService) ResolveReport(ctx context.Context, reportID, resolution string) error {
	return s.repo.ResolveReport(ctx, reportID, resolution)
}

func (s *communityService) SetCommunityGuidelines(ctx context.Context, communityID string, guidelines []*domain.Guideline) error {
	return s.repo.UpdateGuidelines(ctx, communityID, guidelines)
}

func (s *communityService) GetCommunityAnalytics(ctx context.Context, communityID, period string) (*domain.CommunityAnalytics, error) {
	return s.repo.GetCommunityAnalytics(ctx, communityID, period)
}

func (s *communityService) GetMemberActivity(ctx context.Context, communityID, userID, period string) (*domain.MemberActivity, error) {
	return s.repo.GetMemberActivity(ctx, communityID, userID, period)
}

func (s *communityService) SearchCommunities(ctx context.Context, query string, filters map[string]interface{}) ([]*domain.Community, error) {
	limit := int32(20)
	offset := int32(0)
	if v, ok := filters["limit"].(int32); ok {
		limit = v
	}
	if v, ok := filters["offset"].(int32); ok {
		offset = v
	}
	return s.repo.SearchCommunities(ctx, query, limit, offset)
}

func (s *communityService) GetTrendingCommunities(ctx context.Context, limit int32) ([]*domain.Community, error) {
	return s.repo.GetTrendingCommunities(ctx, limit)
}

func (s *communityService) GetRecommendedCommunities(ctx context.Context, userID string, limit int32) ([]*domain.Community, error) {
	return s.repo.ListCommunities(ctx, userID, "", limit, 0)
}
