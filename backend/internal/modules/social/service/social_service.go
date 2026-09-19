package service

import (
    "context"
    "fmt"
    "strings"

    "local/merope/internal/core/security"
    "local/merope/internal/core/util"
    "local/merope/internal/modules/identity/domain"
    socialDomain "local/merope/internal/modules/social/domain"
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

func (s *socialService) GetProfile(ctx context.Context, viewerID, userID string) (*socialDomain.PublicProfile, error) {
    viewerID = strings.TrimSpace(viewerID)
    userID = strings.TrimSpace(userID)
    if viewerID == "" || userID == "" {
        return nil, fmt.Errorf("user id is required")
    }
    visible, err := s.repo.CanViewProfile(ctx, viewerID, userID)
    if err != nil {
        return nil, err
    }
    if !visible {
        return nil, socialDomain.ErrProfileForbidden
    }
    exported, err := s.idService.ExportData(ctx, userID)
    if err != nil {
        return nil, err
    }
    user, ok := exported["user"].(*domain.User)
    if !ok || user == nil {
        return nil, fmt.Errorf("user not found")
    }
    return &socialDomain.PublicProfile{
        ID:          user.ID,
        Username:    user.Username,
        DisplayName: user.DisplayName,
        Bio:         user.Bio,
        AvatarURL:   user.AvatarURL,
        IsVerified:  user.IsVerified,
        IsPrivate:   user.IsPrivate,
        CreatedAt:   user.CreatedAt,
    }, nil
}

func (s *socialService) Follow(ctx context.Context, followerID, followingID string) error {
    if followerID == "" || followingID == "" || followerID == followingID {
        return fmt.Errorf("invalid follow relationship")
    }
    if s.veritasGuard != nil && s.veritasGuard.TrackInteraction(ctx, followerID, followingID, "follow") {
        return fmt.Errorf("excessive follow activity detected")
    }
    return s.repo.Follow(ctx, followerID, followingID)
}

func (s *socialService) hydrateUsers(ctx context.Context, basicUsers []*domain.User) []*domain.User {
    res := make([]*domain.User, len(basicUsers))
    for i, u := range basicUsers {
        fullUser, err := s.idService.ExportData(ctx, u.ID)
        if err == nil {
            if user, ok := fullUser["user"].(*domain.User); ok {
                res[i] = user
                continue
            }
        }
        res[i] = u
    }
    return res
}

func (s *socialService) Unfollow(ctx context.Context, followerID, followingID string) error {
    if followerID == "" || followingID == "" || followerID == followingID {
        return fmt.Errorf("invalid follow relationship")
    }
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
    if followerID == "" || followingID == "" || followerID == followingID {
        return fmt.Errorf("invalid follow request")
    }
    return s.repo.SendFollowRequest(ctx, followerID, followingID)
}

func (s *socialService) HandleFollowRequest(ctx context.Context, followerID, followingID, status string) error {
    switch status {
    case "accepted", "rejected", "cancelled":
    default:
        return fmt.Errorf("invalid follow request status")
    }

    if err := s.repo.RespondToFollowRequest(ctx, followerID, followingID, status); err != nil {
        return err
    }
    if status != "accepted" {
        return nil
    }
    return s.repo.Follow(ctx, followerID, followingID)
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

func (s *socialService) GlobalSearch(ctx context.Context, viewerID, query string) ([]*domain.User, error) {
    normalizedQuery := strings.ToLower(strings.TrimSpace(query))
    if len(normalizedQuery) < 2 || len(normalizedQuery) > 80 {
        return nil, fmt.Errorf("search query must be between 2 and 80 characters")
    }
    cacheKey := fmt.Sprintf("search:%s:%s", viewerID, normalizedQuery)
    if cached, ok := s.searchCache.Get(cacheKey); ok {
        return cached, nil
    }
    users, err := s.repo.SearchUsers(ctx, viewerID, normalizedQuery)
    if err == nil {
        s.searchCache.Put(cacheKey, users)
    }
    return users, err
}

func (s *socialService) BlockUser(ctx context.Context, blockerID, blockedID string) error {
    if blockerID == "" || blockedID == "" || blockerID == blockedID {
        return fmt.Errorf("invalid block relationship")
    }
    // Repository performs both edge removal and deny-edge creation atomically.
    return s.repo.Block(ctx, blockerID, blockedID)
}

func (s *socialService) ReportContent(ctx context.Context, reporterID, targetID, targetType, reason string) error {
    if reporterID == "" || targetID == "" || targetType == "" {
        return fmt.Errorf("invalid report target")
    }
    sanitizedReason := security.StripHTML(reason)
    if len(sanitizedReason) < 3 || len(sanitizedReason) > 2000 {
        return fmt.Errorf("report reason must be between 3 and 2000 characters")
    }
    if s.veritasGuard != nil && s.veritasGuard.DetectBotPattern(ctx, reporterID, sanitizedReason) {
        return fmt.Errorf("excessive reporting activity detected")
    }

    return s.repo.CreateReport(ctx, &socialDomain.Report{
        ReporterID: reporterID,
        TargetID:   targetID,
        TargetType: targetType,
        Reason:     sanitizedReason,
    })
}

func (s *socialService) CreatePrivacyCircle(ctx context.Context, ownerID, name string, members []string) (string, error) {
    sanitizedName := security.StripHTML(name)
    if ownerID == "" || sanitizedName == "" || len(sanitizedName) > 80 {
        return "", fmt.Errorf("invalid privacy circle")
    }

    circleID, err := s.repo.CreateCircle(ctx, ownerID, sanitizedName)
    if err != nil {
        return "", err
    }

    seen := make(map[string]struct{}, len(members))
    for _, memberID := range members {
        if memberID == "" || memberID == ownerID {
            continue
        }
        if _, exists := seen[memberID]; exists {
            continue
        }
        seen[memberID] = struct{}{}
        if err := s.repo.AddCircleMember(ctx, circleID, memberID); err != nil {
            return "", fmt.Errorf("add privacy circle member: %w", err)
        }
    }

    return circleID, nil
}
