package infra

import (
	"context"
	"errors"
	"fmt"
	"time"

	"local/merope/internal/platform/scylla"
	"local/merope/internal/modules/social/domain"
	identityDomain "local/merope/internal/modules/identity/domain"
	contentDomain "local/merope/internal/modules/content/domain"

	"github.com/google/uuid"
)

type ScyllaSocialRepository struct {
	client *scylla.Client
}

func NewScyllaSocialRepository(client *scylla.Client) *ScyllaSocialRepository {
	return &ScyllaSocialRepository{client: client}
}

func (r *ScyllaSocialRepository) Follow(ctx context.Context, followerID, followingID string) error {
	return errors.New("follow/unfollow use PostgreSQL as source of truth")
}

func (r *ScyllaSocialRepository) Unfollow(ctx context.Context, followerID, followingID string) error {
	return errors.New("follow/unfollow use PostgreSQL as source of truth")
}

func (r *ScyllaSocialRepository) GetFollowers(ctx context.Context, userID string) ([]*identityDomain.User, error) {
	return nil, errors.New("follower queries use PostgreSQL")
}

func (r *ScyllaSocialRepository) GetFollowing(ctx context.Context, userID string) ([]*identityDomain.User, error) {
	return nil, errors.New("following queries use PostgreSQL")
}

func (r *ScyllaSocialRepository) GetMutuals(ctx context.Context, userA, userB string) ([]*identityDomain.User, error) {
	return nil, errors.New("mutual queries use PostgreSQL")
}

func (r *ScyllaSocialRepository) CreateCircle(ctx context.Context, ownerID, name string) (string, error) {
	return "", errors.New("circles use PostgreSQL")
}

func (r *ScyllaSocialRepository) AddCircleMember(ctx context.Context, circleID, userID string) error {
	return nil
}

func (r *ScyllaSocialRepository) GetCircles(ctx context.Context, userID string) ([]string, error) {
	return nil, nil
}

func (r *ScyllaSocialRepository) Block(ctx context.Context, blockerID, blockedID string) error {
	return nil
}

func (r *ScyllaSocialRepository) Unblock(ctx context.Context, blockerID, blockedID string) error {
	return nil
}

func (r *ScyllaSocialRepository) IsBlocked(ctx context.Context, userA, userB string) (bool, error) {
	return false, nil
}

func (r *ScyllaSocialRepository) SendFollowRequest(ctx context.Context, followerID, followingID string) error {
	return nil
}

func (r *ScyllaSocialRepository) RespondToFollowRequest(ctx context.Context, followerID, followingID, status string) error {
	return nil
}

func (r *ScyllaSocialRepository) GetFollowRequests(ctx context.Context, userID string) ([]*domain.FollowRequest, error) {
	return nil, nil
}

func (r *ScyllaSocialRepository) GetSuggestedUsers(ctx context.Context, userID string, limit int) ([]*identityDomain.User, error) {
	return nil, nil
}

func (r *ScyllaSocialRepository) SearchUsers(ctx context.Context, query string) ([]*identityDomain.User, error) {
	return nil, nil
}

func (r *ScyllaSocialRepository) CreateReport(ctx context.Context, rep *domain.Report) error {
	return nil
}

func (r *ScyllaSocialRepository) FanOutSignalToFollowers(ctx context.Context, signal *contentDomain.Signal, followerIDs []string) error {
	signalUUID, err := uuid.Parse(signal.ID)
	if err != nil {
		return fmt.Errorf("invalid signal_id: %w", err)
	}

	authorUUID, err := uuid.Parse(signal.AuthorID)
	if err != nil {
		return fmt.Errorf("invalid author_id: %w", err)
	}

	now := time.Now().UnixMilli()
	visibility := signal.Visibility
	if visibility == "" {
		visibility = "public"
	}

	mediaURLs := sliceOrDefault(signal.MediaURLs)
	resonanceScore := 0.0
	if signal.ResonanceScore > 0 {
		resonanceScore = signal.ResonanceScore
	}

	for _, fid := range followerIDs {
		followerUUID, err := uuid.Parse(fid)
		if err != nil {
			continue
		}

		_ = r.client.Exec(ctx,
			`INSERT INTO user_timeline (user_id, created_at, signal_id, author_id, author_name, author_avatar, content_text, media_urls, visibility, resonance_score, wave_amplitude, is_pinned)
			 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
			followerUUID, now, signalUUID, authorUUID, signal.AuthorName, signal.AuthorAvatar,
			signal.ContentText, mediaURLs, visibility, resonanceScore, signal.WaveAmplitude, false,
		)
	}

	return nil
}

func (r *ScyllaSocialRepository) GetUserTimeline(ctx context.Context, userID string, limit, offset int32) ([]*contentDomain.Signal, error) {
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return nil, fmt.Errorf("invalid user_id: %w", err)
	}

	if limit <= 0 || limit > 100 {
		limit = 20
	}

	if offset > 0 {
		return nil, errors.New("timeline pagination beyond page 1 requires PostgreSQL fallback")
	}

	signals := make([]*contentDomain.Signal, 0, limit)

	q := r.client.Session.Query(
		`SELECT signal_id, author_id, author_name, author_avatar, content_text, media_urls, visibility, resonance_score, wave_amplitude, is_pinned, created_at
		 FROM user_timeline
		 WHERE user_id = ?
		 LIMIT ?`,
		userUUID, limit,
	).WithContext(ctx).Iter()

	var signalID, authorID uuid.UUID
	var authorName, authorAvatar, contentText, visibility string
	var mediaURLs []string
	var resonanceScore float64
	var waveAmp int
	var isPinned bool
	var createdAt int64

	for q.Scan(&signalID, &authorID, &authorName, &authorAvatar, &contentText, &mediaURLs, &visibility, &resonanceScore, &waveAmp, &isPinned, &createdAt) {
		signals = append(signals, &contentDomain.Signal{
			ID:              signalID.String(),
			AuthorID:        authorID.String(),
			AuthorName:      authorName,
			AuthorAvatar:    authorAvatar,
			ContentText:     contentText,
			MediaURLs:       sliceOrDefault(mediaURLs),
			Visibility:      visibility,
			ResonanceScore:  resonanceScore,
			WaveAmplitude:   waveAmp,
			IsPinned:        isPinned,
			CreatedAt:       time.UnixMilli(createdAt),
		})
	}

	if err := q.Close(); err != nil {
		return nil, fmt.Errorf("failed to read timeline: %w", err)
	}

	return signals, nil
}

func (r *ScyllaSocialRepository) RemoveSignalFromTimeline(ctx context.Context, userID, signalID string) error {
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}
	signalUUID, err := uuid.Parse(signalID)
	if err != nil {
		return fmt.Errorf("invalid signal_id: %w", err)
	}

	return r.client.Exec(ctx,
		`DELETE FROM user_timeline WHERE user_id = ? AND signal_id = ?`,
		userUUID, signalUUID,
	)
}

func (r *ScyllaSocialRepository) SetPresence(ctx context.Context, userID, status string, ttlSeconds int) error {
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}

	now := time.Now().UnixMilli()

	if ttlSeconds > 0 {
		return r.client.Exec(ctx,
			`UPDATE presence_by_user USING TTL ? SET status = ?, last_seen = ? WHERE user_id = ?`,
			ttlSeconds, status, now, userUUID,
		)
	}
	return r.client.Exec(ctx,
		`UPDATE presence_by_user SET status = ?, last_seen = ? WHERE user_id = ?`,
		status, now, userUUID,
	)
}

func (r *ScyllaSocialRepository) SetTyping(ctx context.Context, roomID, userID, userName string) error {
	roomUUID, err := uuid.Parse(roomID)
	if err != nil {
		return fmt.Errorf("invalid room_id: %w", err)
	}
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}

	return r.client.Exec(ctx,
		`INSERT INTO typing_indicator (room_id, user_id, user_name, updated_at) VALUES (?, ?, ?, ?)`,
		roomUUID, userUUID, userName, time.Now().UnixMilli(),
	)
}

func (r *ScyllaSocialRepository) RemoveTyping(ctx context.Context, roomID, userID string) error {
	roomUUID, err := uuid.Parse(roomID)
	if err != nil {
		return fmt.Errorf("invalid room_id: %w", err)
	}
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}

	return r.client.Exec(ctx,
		`DELETE FROM typing_indicator WHERE room_id = ? AND user_id = ?`,
		roomUUID, userUUID,
	)
}

func sliceOrDefault(s []string) []string {
	if s == nil {
		return []string{}
	}
	return s
}
