package service

import (
	"context"
	"fmt"
	"local/merope/internal/core/security"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/identity/domain"
	socialDomain "local/merope/internal/modules/social/domain"

	"golang.org/x/sync/errgroup"
)

type socialService struct {
	repo         socialDomain.SocialRepository
	idService    domain.IdentityService
	suggestCache *util.LRUCache[string, []*domain.User]
	searchCache  *util.LRUCache[string, []*domain.User]
	veritasGuard VeritasContentGuard
}

func NewSocialService(repo socialDomain.SocialRepository, idService domain.IdentityService, veritasGuard VeritasContentGuard) socialDomain.SocialService {
	return &socialService{
		repo:         repo,
		idService:    idService,
		suggestCache: util.NewLRUCache[string, []*domain.User](1000),
		searchCache:  util.NewLRUCache[string, []*domain.User](500),
		veritasGuard: veritasGuard,
	}
}

func (s *socialService) Follow(ctx context.Context, followerID, followingID string) error {
	// Veritas: Detect Botting on Follow
	if s.veritasGuard != nil {
		if s.veritasGuard.TrackInteraction(ctx, followerID, followingID, "follow") {
			return fmt.Errorf("excessive follow activity detected")
		}
	}

	// The core social repo handles the relationship in the unified 'merope_core' DB
	return s.repo.Follow(ctx, followerID, followingID)
}

func (s *socialService) hydrateUsers(ctx context.Context, basicUsers []*domain.User) []*domain.User {
	// Hydrate user details from the correct system (Personal or Corporate)
	res := make([]*domain.User, len(basicUsers))
	for i, u := range basicUsers {
		fullUser, err := s.idService.ExportData(ctx, u.ID)
		if err == nil {
			if user, ok := fullUser["user"].(*domain.User); ok {
				res[i] = user
				continue
			}
		}
		res[i] = u // Fallback
	}
	return res
}

func (s *socialService) Unfollow(ctx context.Context, followerID, followingID string) error {
	return s.repo.Unfollow(ctx, followerID, followingID)
}

func (s *socialService) GetMutualFriends(ctx context.Context, userA, userB string) ([]*domain.User, error) {
	return s.repo.GetMutuals(ctx, userA, userB)
}

func (s *socialService) GetFollowers(ctx context.Context, userID string) ([]*domain.User, error) {
	return s.repo.GetFollowers(ctx, userID)
}

func (s *socialService) GetFollowing(ctx context.Context, userID string) ([]*domain.User, error) {
	return s.repo.GetFollowing(ctx, userID)
}

func (s *socialService) RequestFollow(ctx context.Context, followerID, followingID string) error {
	return s.repo.SendFollowRequest(ctx, followerID, followingID)
}

func (s *socialService) HandleFollowRequest(ctx context.Context, followerID, followingID, status string) error {
	err := s.repo.RespondToFollowRequest(ctx, followerID, followingID, status)
	if err == nil && status == "accepted" {
		return s.repo.Follow(ctx, followerID, followingID)
	}
	return err
}

func (s *socialService) ListFollowRequests(ctx context.Context, userID string) ([]*socialDomain.FollowRequest, error) {
	return s.repo.GetFollowRequests(ctx, userID)
}

func (s *socialService) GetSuggestions(ctx context.Context, userID string) ([]*domain.User, error) {
	if cached, ok := s.suggestCache.Get(userID); ok {
		return cached, nil
	}
	users, err := s.repo.GetSuggestedUsers(ctx, userID, 10)
	if err == nil {
		s.suggestCache.Put(userID, users)
	}
	return users, err
}

func (s *socialService) GlobalSearch(ctx context.Context, query string) ([]*domain.User, error) {
	cacheKey := fmt.Sprintf("search:%s", query)
	if cached, ok := s.searchCache.Get(cacheKey); ok {
		return cached, nil
	}
	users, err := s.repo.SearchUsers(ctx, query)
	if err == nil {
		s.searchCache.Put(cacheKey, users)
	}
	return users, err
}

func (s *socialService) BlockUser(ctx context.Context, blockerID, blockedID string) error {
	g, gCtx := errgroup.WithContext(ctx)

	g.Go(func() error {
		return s.repo.Unfollow(gCtx, blockerID, blockedID)
	})
	g.Go(func() error {
		return s.repo.Unfollow(gCtx, blockedID, blockerID)
	})
	g.Go(func() error {
		return s.repo.Block(gCtx, blockerID, blockedID)
	})

	return g.Wait()
}

func (s *socialService) ReportContent(ctx context.Context, reporterID, targetID, targetType, reason string) error {
	// Zenith: Veritas integrity check on reports
	if s.veritasGuard != nil {
		if s.veritasGuard.DetectBotPattern(ctx, reporterID, reason) {
			return fmt.Errorf("excessive reporting activity detected")
		}
	}

	report := &socialDomain.Report{
		ReporterID: reporterID,
		TargetID:   targetID,
		TargetType: targetType,
		Reason:     security.StripHTML(reason),
	}
	return s.repo.CreateReport(ctx, report)
}

func (s *socialService) CreatePrivacyCircle(ctx context.Context, ownerID, name string, members []string) (string, error) {
	sanitizedName := security.StripHTML(name)
	circleID, err := s.repo.CreateCircle(ctx, ownerID, sanitizedName)
	if err != nil {
		return "", err
	}

	for _, mID := range members {
		_ = s.repo.AddCircleMember(ctx, circleID, mID)
	}

	return circleID, nil
}
