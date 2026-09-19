package infra

import (
	"context"
	"encoding/json"

	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/moderation/domain"
)

type PostgresModerationRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresModerationRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresModerationRepository {
	return &PostgresModerationRepository{queries: queries, pool: pool}
}

func (r *PostgresModerationRepository) CreateReport(ctx context.Context, report *domain.Report) error {
	return nil
}

func (r *PostgresModerationRepository) GetReports(ctx context.Context, status string) ([]*domain.Report, error) {
	return nil, nil
}

func (r *PostgresModerationRepository) ResolveReport(ctx context.Context, reportID string, status string) error {
	return nil
}

func (r *PostgresModerationRepository) FlagSuspiciousAccount(ctx context.Context, acc *domain.SuspiciousAccount) error {
	return nil
}

func (r *PostgresModerationRepository) GetSuspiciousAccounts(ctx context.Context) ([]*domain.SuspiciousAccount, error) {
	return nil, nil
}

func (r *PostgresModerationRepository) ResolveSuspiciousAccount(ctx context.Context, userID string, status string) error {
	return nil
}

func (r *PostgresModerationRepository) EnqueueAutoReview(ctx context.Context, item *domain.ReviewQueueItem) error {
	_, err := r.pool.Exec(ctx,
		"INSERT INTO moderation_queue (content_type, content_id, author_id, auto_score, auto_reasons, status, created_at) VALUES ($1, $2, $3, $4, $5, $6, NOW())",
		item.ContentType, item.ContentID, item.AuthorID, item.AutoScore, item.AutoReasons, "pending")
	return err
}

func (r *PostgresModerationRepository) GetReviewQueue(ctx context.Context, status string, limit, offset int32) ([]*domain.ReviewQueueItem, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT mq.id, mq.content_type, mq.content_id, mq.author_id, u.username as author_username, mq.auto_score, mq.auto_reasons, mq.status, mq.assigned_to, mq.resolution, mq.reviewed_at, mq.created_at
		 FROM moderation_queue mq
		 LEFT JOIN users u ON mq.author_id = u.id
		 WHERE mq.status = $1
		 ORDER BY mq.auto_score DESC, mq.created_at DESC
		 LIMIT $2 OFFSET $3`,
		status, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	items := []*domain.ReviewQueueItem{}
	for rows.Next() {
		var item domain.ReviewQueueItem
		var reasonsJSON []byte
		var assignedTo pgtype.UUID
		var resolution pgtype.Text
		var reviewedAt pgtype.Timestamptz
		err := rows.Scan(&item.ID, &item.ContentType, &item.ContentID, &item.AuthorID, &item.AuthorName, &item.AutoScore, &reasonsJSON, &item.Status, &assignedTo, &resolution, &reviewedAt, &item.CreatedAt)
		if err != nil {
			continue
		}
		json.Unmarshal(reasonsJSON, &item.AutoReasons)
		if assignedTo.Valid {
			s := util.UUIDToString(assignedTo)
			item.AssignedTo = &s
		}
		if resolution.Valid {
			item.Resolution = &resolution.String
		}
		if reviewedAt.Valid {
			item.ReviewedAt = &reviewedAt.Time
		}
		items = append(items, &item)
	}
	return items, nil
}

func (r *PostgresModerationRepository) AssignReviewer(ctx context.Context, queueID, reviewerID string) error {
	_, err := r.pool.Exec(ctx,
		"UPDATE moderation_queue SET assigned_to = $2, status = 'in_review' WHERE id = $1",
		queueID, reviewerID)
	return err
}

func (r *PostgresModerationRepository) ResolveReview(ctx context.Context, queueID, resolution string) error {
	_, err := r.pool.Exec(ctx,
		"UPDATE moderation_queue SET status = 'resolved', resolution = $2, reviewed_at = NOW() WHERE id = $1",
		queueID, resolution)
	return err
}

func (r *PostgresModerationRepository) GetAuthorReviewHistory(ctx context.Context, authorID string, limit int) ([]*domain.ReviewQueueItem, error) {
	rows, err := r.pool.Query(ctx,
		"SELECT id, content_type, content_id, author_id, auto_score, auto_reasons, status, created_at FROM moderation_queue WHERE author_id = $1 ORDER BY created_at DESC LIMIT $2",
		authorID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	items := []*domain.ReviewQueueItem{}
	for rows.Next() {
		var item domain.ReviewQueueItem
		var reasonsJSON []byte
		err := rows.Scan(&item.ID, &item.ContentType, &item.ContentID, &item.AuthorID, &item.AutoScore, &reasonsJSON, &item.Status, &item.CreatedAt)
		if err != nil {
			continue
		}
		json.Unmarshal(reasonsJSON, &item.AutoReasons)
		items = append(items, &item)
	}
	return items, nil
}
