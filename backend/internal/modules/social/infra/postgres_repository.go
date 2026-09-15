package infra

import (
	"context"
	"fmt"
	"local/merope/internal/database/db"
	idDomain "local/merope/internal/modules/identity/domain"
	"local/merope/internal/modules/social/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresSocialRepository struct {
	queries *db.Queries
}

func NewPostgresSocialRepository(queries *db.Queries) *PostgresSocialRepository {
	return &PostgresSocialRepository{queries: queries}
}

func (r *PostgresSocialRepository) Follow(ctx context.Context, followerID, followingID string) error {
	var fID, tID pgtype.UUID
	if err := fID.Scan(followerID); err != nil {
		return fmt.Errorf("invalid uuid followerID: %w", err)
	}
	if err := tID.Scan(followingID); err != nil {
		return fmt.Errorf("invalid uuid followingID: %w", err)
	}
	return r.queries.FollowUser(ctx, db.FollowUserParams{FollowerID: fID, FollowingID: tID})
}

func (r *PostgresSocialRepository) Unfollow(ctx context.Context, followerID, followingID string) error {
	var fID, tID pgtype.UUID
	if err := fID.Scan(followerID); err != nil {
		return fmt.Errorf("invalid uuid followerID: %w", err)
	}
	if err := tID.Scan(followingID); err != nil {
		return fmt.Errorf("invalid uuid followingID: %w", err)
	}
	return r.queries.UnfollowUser(ctx, db.UnfollowUserParams{FollowerID: fID, FollowingID: tID})
}

func (r *PostgresSocialRepository) GetFollowers(ctx context.Context, userID string) ([]*idDomain.User, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	users, err := r.queries.GetFollowers(ctx, uid)
	if err != nil {
		return nil, err
	}
	return r.mapUsers(users), nil
}

func (r *PostgresSocialRepository) GetFollowing(ctx context.Context, userID string) ([]*idDomain.User, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	users, err := r.queries.GetFollowing(ctx, uid)
	if err != nil {
		return nil, err
	}
	return r.mapUsers(users), nil
}

func (r *PostgresSocialRepository) GetMutuals(ctx context.Context, userA, userB string) ([]*idDomain.User, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userA); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	users, err := r.queries.GetMutuals(ctx, uid)
	if err != nil {
		return nil, err
	}
	return r.mapUsers(users), nil
}

func (r *PostgresSocialRepository) Block(ctx context.Context, blockerID, blockedID string) error {
	var bID, bdID pgtype.UUID
	if err := bID.Scan(blockerID); err != nil {
		return fmt.Errorf("invalid uuid blockerID: %w", err)
	}
	if err := bdID.Scan(blockedID); err != nil {
		return fmt.Errorf("invalid uuid blockedID: %w", err)
	}
	return r.queries.BlockUser(ctx, db.BlockUserParams{BlockerID: bID, BlockedID: bdID})
}

func (r *PostgresSocialRepository) Unblock(ctx context.Context, blockerID, blockedID string) error {
	var bID, bdID pgtype.UUID
	if err := bID.Scan(blockerID); err != nil {
		return fmt.Errorf("invalid uuid blockerID: %w", err)
	}
	if err := bdID.Scan(blockedID); err != nil {
		return fmt.Errorf("invalid uuid blockedID: %w", err)
	}
	return r.queries.UnblockUser(ctx, db.UnblockUserParams{BlockerID: bID, BlockedID: bdID})
}

func (r *PostgresSocialRepository) IsBlocked(ctx context.Context, userA, userB string) (bool, error) {
	var aID, bID pgtype.UUID
	if err := aID.Scan(userA); err != nil {
		return false, fmt.Errorf("invalid uuid userA: %w", err)
	}
	if err := bID.Scan(userB); err != nil {
		return false, fmt.Errorf("invalid uuid userB: %w", err)
	}
	return r.queries.IsBlocked(ctx, db.IsBlockedParams{BlockerID: aID, BlockedID: bID})
}

func (r *PostgresSocialRepository) SendFollowRequest(ctx context.Context, followerID, followingID string) error {
	var fID, tID pgtype.UUID
	if err := fID.Scan(followerID); err != nil {
		return fmt.Errorf("invalid uuid followerID: %w", err)
	}
	if err := tID.Scan(followingID); err != nil {
		return fmt.Errorf("invalid uuid followingID: %w", err)
	}
	return r.queries.SendFollowRequest(ctx, db.SendFollowRequestParams{FollowerID: fID, FollowingID: tID})
}

func (r *PostgresSocialRepository) RespondToFollowRequest(ctx context.Context, followerID, followingID, status string) error {
	var fID, tID pgtype.UUID
	if err := fID.Scan(followerID); err != nil {
		return fmt.Errorf("invalid uuid followerID: %w", err)
	}
	if err := tID.Scan(followingID); err != nil {
		return fmt.Errorf("invalid uuid followingID: %w", err)
	}
	return r.queries.RespondToFollowRequest(ctx, db.RespondToFollowRequestParams{FollowerID: fID, FollowingID: tID, Status: status})
}

func (r *PostgresSocialRepository) GetFollowRequests(ctx context.Context, userID string) ([]*domain.FollowRequest, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	rows, err := r.queries.GetFollowRequestsByUser(ctx, uid)
	if err != nil {
		return nil, err
	}

	requests := make([]*domain.FollowRequest, len(rows))
	for i, row := range rows {
		requests[i] = &domain.FollowRequest{
			FollowerID:  util.UUIDToString(row.FollowerID),
			FollowingID: util.UUIDToString(row.FollowingID),
			Status:      row.Status,
			CreatedAt:   row.CreatedAt.Time,
		}
	}
	return requests, nil
}

func (r *PostgresSocialRepository) GetSuggestedUsers(ctx context.Context, userID string, limit int) ([]*idDomain.User, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}
	users, err := r.queries.GetSuggestedUsers(ctx, db.GetSuggestedUsersParams{ID: uid, Limit: int32(limit)})
	if err != nil {
		return nil, err
	}

	res := make([]*idDomain.User, len(users))
	for i, u := range users {
		res[i] = &idDomain.User{
			ID:        util.UUIDToString(u.ID),
			Username:  u.Username,
			AvatarURL: u.AvatarUrl.String,
		}
	}
	return res, nil
}

func (r *PostgresSocialRepository) SearchUsers(ctx context.Context, query string) ([]*idDomain.User, error) {
	users, err := r.queries.SearchUsers(ctx, db.SearchUsersParams{Column1: pgtype.Text{String: query, Valid: true}, ID: pgtype.UUID{}, Limit: 20})
	if err != nil {
		return nil, err
	}

	res := make([]*idDomain.User, len(users))
	for i, u := range users {
		res[i] = &idDomain.User{
			ID:        util.UUIDToString(u.ID),
			Username:  u.Username,
			AvatarURL: u.AvatarUrl.String,
		}
	}
	return res, nil
}

func (r *PostgresSocialRepository) CreateReport(ctx context.Context, rep *domain.Report) error {
	var targetID pgtype.UUID
	if err := targetID.Scan(rep.TargetID); err != nil {
		return fmt.Errorf("invalid uuid targetID: %w", err)
	}

	return r.queries.FlagSuspiciousAccount(ctx, db.FlagSuspiciousAccountParams{
		TargetID: targetID,
		Reason:   rep.Reason,
	})
}

func (r *PostgresSocialRepository) CreateCircle(ctx context.Context, ownerID, name string) (string, error) {
	return "", nil // CreateCircle missing in SQL
}

func (r *PostgresSocialRepository) AddCircleMember(ctx context.Context, circleID, userID string) error {
	return nil // AddCircleMember missing in SQL
}

func (r *PostgresSocialRepository) GetCircles(ctx context.Context, ownerID string) ([]string, error) {
	var oid pgtype.UUID
	if err := oid.Scan(ownerID); err != nil {
		return nil, fmt.Errorf("invalid uuid: %w", err)
	}

	rows, err := r.queries.GetCircles(ctx, oid)
	if err != nil {
		return nil, err
	}

	ids := make([]string, len(rows))
	for i, row := range rows {
		ids[i] = util.UUIDToString(row.ID)
	}
	return ids, nil
}

func (r *PostgresSocialRepository) mapUsers(dbUsers []db.User) []*idDomain.User {
	res := make([]*idDomain.User, len(dbUsers))
	for i, u := range dbUsers {
		res[i] = &idDomain.User{
			ID:        util.UUIDToString(u.ID),
			Username:  u.Username,
			AvatarURL: u.AvatarUrl.String,
		}
	}
	return res
}
