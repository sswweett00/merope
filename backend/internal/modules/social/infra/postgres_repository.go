package infra

import (
    "context"
    "fmt"

    "local/merope/internal/core/util"
    "local/merope/internal/database/db"
    idDomain "local/merope/internal/modules/identity/domain"
    "local/merope/internal/modules/social/domain"

    "github.com/jackc/pgx/v5/pgtype"
)

type PostgresSocialRepository struct {
    queries *db.Queries
}

func NewPostgresSocialRepository(queries *db.Queries) *PostgresSocialRepository {
    return &PostgresSocialRepository{queries: queries}
}

func (r *PostgresSocialRepository) CanViewProfile(ctx context.Context, viewerID, targetID string) (bool, error) {
	var viewer, target pgtype.UUID
	if err := viewer.Scan(viewerID); err != nil {
		return false, fmt.Errorf("invalid viewer uuid: %w", err)
	}
	if err := target.Scan(targetID); err != nil {
		return false, fmt.Errorf("invalid target uuid: %w", err)
	}
	var visible bool
	err := r.queries.QueryRow(ctx, `
SELECT EXISTS (
	SELECT 1
	FROM users u
	WHERE u.id = $1
	  AND (
		u.id = $2
		OR COALESCE(u.is_private, FALSE) = FALSE
		OR EXISTS (
			SELECT 1 FROM follows f
			WHERE f.follower_id = $2
			  AND f.following_id = $1
			  AND f.status = 'accepted'
		)
	  )
	  AND NOT EXISTS (
		SELECT 1 FROM blocks b
		WHERE (b.blocker_id = $2 AND b.blocked_id = $1)
		   OR (b.blocker_id = $1 AND b.blocked_id = $2)
	  )
)`, target, viewer).Scan(&visible)
	if err != nil {
		return false, err
	}
	return visible, nil
}

func (r *PostgresSocialRepository) Follow(ctx context.Context, followerID, followingID string) error {
	var fID, tID pgtype.UUID
	if err := fID.Scan(followerID); err != nil {
		return fmt.Errorf("invalid uuid followerID: %w", err)
	}
	if err := tID.Scan(followingID); err != nil {
		return fmt.Errorf("invalid uuid followingID: %w", err)
	}

	tag, err := r.queries.Exec(ctx, `
INSERT INTO follows (follower_id, following_id, status)
SELECT $1, $2, 'accepted'
FROM users u
WHERE u.id = $2
  AND NOT EXISTS (
      SELECT 1 FROM blocks b
      WHERE (b.blocker_id = $1 AND b.blocked_id = $2)
         OR (b.blocker_id = $2 AND b.blocked_id = $1)
  )
ON CONFLICT (follower_id, following_id)
DO UPDATE SET status = 'accepted'
`, fID, tID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("follow relationship is not permitted")
	}
	return nil
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

func (r *PostgresSocialRepository) IsPrivateUser(ctx context.Context, userID string) (bool, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return false, fmt.Errorf("invalid uuid: %w", err)
	}
	var isPrivate bool
	if err := r.queries.QueryRow(ctx, `SELECT COALESCE(is_private, FALSE) FROM users WHERE id = $1`, uid).Scan(&isPrivate); err != nil {
		return false, err
	}
	return isPrivate, nil
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
	var aID, bID pgtype.UUID
	if err := aID.Scan(userA); err != nil {
		return nil, fmt.Errorf("invalid uuid userA: %w", err)
	}
	if err := bID.Scan(userB); err != nil {
		return nil, fmt.Errorf("invalid uuid userB: %w", err)
	}

	rows, err := r.queries.Query(ctx, `
SELECT u.*
FROM users u
JOIN follows fa ON fa.following_id = u.id
JOIN follows fb ON fb.following_id = u.id
WHERE fa.follower_id = $1
  AND fb.follower_id = $2
  AND fa.status = 'accepted'
  AND fb.status = 'accepted'
  AND NOT EXISTS (
      SELECT 1 FROM blocks b
      WHERE (b.blocker_id = $1 AND b.blocked_id = u.id)
         OR (b.blocker_id = u.id AND b.blocked_id = $1)
         OR (b.blocker_id = $2 AND b.blocked_id = u.id)
         OR (b.blocker_id = u.id AND b.blocked_id = $2)
  )
ORDER BY u.username
`, aID, bID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []db.User
	for rows.Next() {
		var user db.User
		if err := rows.Scan(
			&user.ID, &user.TenantID, &user.Username, &user.DisplayName, &user.Bio,
			&user.Email, &user.PasswordHash, &user.AvatarUrl, &user.IsVerified,
			&user.MfaEnabled, &user.MfaSecret, &user.LastSeenAt, &user.IsOnline,
			&user.IsPrivate, &user.ProfileLock, &user.FailedLoginAttempts,
			&user.LockedUntil, &user.ThemeConfig, &user.CreatedAt, &user.UpdatedAt,
		); err != nil {
			return nil, err
		}
		users = append(users, user)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return r.mapUsers(users), nil
}

func (r *PostgresSocialRepository) IsPrivateUser(ctx context.Context, userID string) (bool, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return false, fmt.Errorf("invalid uuid: %w", err)
	}
	var isPrivate bool
	if err := r.queries.QueryRow(ctx, `SELECT COALESCE(is_private, FALSE) FROM users WHERE id = $1`, uid).Scan(&isPrivate); err != nil {
		return false, err
	}
	return isPrivate, nil
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
    return r.queries.BlockUserAtomically(ctx, bID, bdID)
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
	if status != "accepted" && status != "rejected" && status != "cancelled" {
		return fmt.Errorf("invalid follow request status")
	}

	tag, err := r.queries.Exec(ctx, `
UPDATE follow_requests
SET status = $3
WHERE follower_id = $1
  AND following_id = $2
  AND status = 'pending'
  AND NOT EXISTS (
      SELECT 1 FROM blocks b
      WHERE (b.blocker_id = $1 AND b.blocked_id = $2)
         OR (b.blocker_id = $2 AND b.blocked_id = $1)
  )`, fID, tID, status)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("follow request not found or no longer valid")
	}
	return nil
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

func (r *PostgresSocialRepository) SearchUsers(ctx context.Context, viewerID, query string) ([]*idDomain.User, error) {
    var viewer pgtype.UUID
    if err := viewer.Scan(viewerID); err != nil {
        return nil, fmt.Errorf("invalid uuid viewerID: %w", err)
    }
    users, err := r.queries.SearchUsers(ctx, db.SearchUsersParams{
        Column1: pgtype.Text{String: query, Valid: true},
        ID:      viewer,
        Limit:   20,
    })
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
    var reporterID, targetID pgtype.UUID
    if err := reporterID.Scan(rep.ReporterID); err != nil {
        return fmt.Errorf("invalid uuid reporterID: %w", err)
    }
    if err := targetID.Scan(rep.TargetID); err != nil {
        return fmt.Errorf("invalid uuid targetID: %w", err)
    }
    if rep.TargetType == "" {
        return fmt.Errorf("target type is required")
    }
    if rep.Reason == "" {
        return fmt.Errorf("report reason is required")
    }
    return r.queries.CreateContentReport(ctx, reporterID, targetID, rep.TargetType, rep.Reason)
}

func (r *PostgresSocialRepository) CreateCircle(ctx context.Context, ownerID, name string) (string, error) {
    var oid pgtype.UUID
    if err := oid.Scan(ownerID); err != nil {
        return "", fmt.Errorf("invalid uuid ownerID: %w", err)
    }
    if name == "" {
        return "", fmt.Errorf("circle name is required")
    }
    id, err := r.queries.CreateCircle(ctx, oid, name)
    if err != nil {
        return "", err
    }
    return util.UUIDToString(id), nil
}

func (r *PostgresSocialRepository) AddCircleMember(ctx context.Context, circleID, userID string) error {
    var cid, uid pgtype.UUID
    if err := cid.Scan(circleID); err != nil {
        return fmt.Errorf("invalid uuid circleID: %w", err)
    }
    if err := uid.Scan(userID); err != nil {
        return fmt.Errorf("invalid uuid userID: %w", err)
    }
    return r.queries.AddCircleMember(ctx, cid, uid)
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
