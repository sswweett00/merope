package domain

import (
	"context"
	"local/merope/internal/modules/identity/domain"
	"time"
)

type FollowRequest struct {
	FollowerID  string
	FollowingID string
	Status      string
	CreatedAt   time.Time
}

type Report struct {
	ID         string
	ReporterID string
	TargetID   string
	TargetType string
	Reason     string
	CreatedAt  time.Time
}

type PublicProfile struct {
	ID          string    `json:"id"`
	Username    string    `json:"username"`
	DisplayName string    `json:"display_name"`
	Bio         string    `json:"bio"`
	AvatarURL   string    `json:"avatar_url"`
	IsVerified  bool      `json:"is_verified"`
	IsPrivate   bool      `json:"is_private"`
	CreatedAt   time.Time `json:"created_at"`
}

type SocialRepository interface {
	Follow(ctx context.Context, followerID, followingID string) error
	Unfollow(ctx context.Context, followerID, followingID string) error
	GetFollowers(ctx context.Context, userID string) ([]*domain.User, error)
	GetFollowing(ctx context.Context, userID string) ([]*domain.User, error)
	GetMutuals(ctx context.Context, userA, userB string) ([]*domain.User, error)
	Block(ctx context.Context, blockerID, blockedID string) error
	Unblock(ctx context.Context, blockerID, blockedID string) error
	IsBlocked(ctx context.Context, userA, userB string) (bool, error)
	SendFollowRequest(ctx context.Context, followerID, followingID string) error
	RespondToFollowRequest(ctx context.Context, followerID, followingID, status string) error
	GetFollowRequests(ctx context.Context, userID string) ([]*FollowRequest, error)
	GetSuggestedUsers(ctx context.Context, userID string, limit int) ([]*domain.User, error)
	SearchUsers(ctx context.Context, viewerID, query string) ([]*domain.User, error)
	CreateReport(ctx context.Context, r *Report) error
	CreateCircle(ctx context.Context, ownerID, name string) (string, error)
	AddCircleMember(ctx context.Context, circleID, userID string) error
	GetCircles(ctx context.Context, ownerID string) ([]string, error)
}

type SocialService interface {
	GetProfile(ctx context.Context, userID string) (*PublicProfile, error)
	Follow(ctx context.Context, followerID, followingID string) error
	Unfollow(ctx context.Context, followerID, followingID string) error
	GetMutualFriends(ctx context.Context, userA, userB string) ([]*domain.User, error)
	GetFollowers(ctx context.Context, userID string) ([]*domain.User, error)
	GetFollowing(ctx context.Context, userID string) ([]*domain.User, error)
	GlobalSearch(ctx context.Context, viewerID, query string) ([]*domain.User, error)
	ReportContent(ctx context.Context, reporterID, targetID, targetType, reason string) error
	CreatePrivacyCircle(ctx context.Context, ownerID, name string, members []string) (string, error)
}
