package clickhouse

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
)

type EngagementMetrics struct {
	TimeBucket    time.Time `json:"time_bucket"`
	PostID        string    `json:"post_id"`
	UserID        string    `json:"user_id"`
	LikeCount     int64     `json:"like_count"`
	CommentCount  int64     `json:"comment_count"`
	ShareCount    int64     `json:"share_count"`
	ViewCount     int64     `json:"view_count"`
}

func (c *Client) InsertEngagementMetrics(ctx context.Context, metrics *EngagementMetrics) error {
	if metrics == nil {
		return fmt.Errorf("engagement metrics are required")
	}

	userID, err := uuid.Parse(metrics.UserID)
	if metrics.UserID == "" {
		userID = uuid.Nil
		err = nil
	}
	if err != nil {
		return fmt.Errorf("invalid user id: %w", err)
	}

	payload, err := json.Marshal(metrics)
	if err != nil {
		return fmt.Errorf("marshal engagement metrics: %w", err)
	}

	return c.Conn.Exec(ctx,
		`INSERT INTO user_events (event_id, user_id, event_type, payload, created_at) VALUES (?, ?, ?, ?, ?)`,
		uuid.New(), userID, "engagement_metrics", string(payload), metrics.TimeBucket,
	)
}

func (c *Client) GetUserInfluenceScore(ctx context.Context, userID string) (float64, error) {
	uid, err := uuid.Parse(userID)
	if err != nil {
		return 0, fmt.Errorf("invalid user id: %w", err)
	}

	var count uint64
	if err := c.Conn.QueryRow(ctx,
		`SELECT count() FROM user_events WHERE user_id = ?`, uid,
	).Scan(&count); err != nil {
		return 0, err
	}
	return float64(count), nil
}
