package infra

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

// BanMember persists moderation state in the community membership record.
// Duration/reason remain audit concerns and are emitted by the service layer.
func (r *postgresCommunityRepository) BanMember(ctx context.Context, commID, userID, reason string, duration *time.Time) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(commID); err != nil { return fmt.Errorf("invalid community uuid: %w", err) }
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user uuid: %w", err) }
	_, err := r.queries.Exec(ctx, `UPDATE community_members SET role = 'banned' WHERE community_id = $1 AND user_id = $2`, cid, uid)
	return err
}

func (r *postgresCommunityRepository) UnbanMember(ctx context.Context, commID, userID string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(commID); err != nil { return fmt.Errorf("invalid community uuid: %w", err) }
	if err := uid.Scan(userID); err != nil { return fmt.Errorf("invalid user uuid: %w", err) }
	_, err := r.queries.Exec(ctx, `UPDATE community_members SET role = 'member' WHERE community_id = $1 AND user_id = $2 AND role = 'banned'`, cid, uid)
	return err
}

func (r *postgresCommunityRepository) ReportContent(ctx context.Context, reporterID, contentType, contentID, reason string) error {
	var reporter, target pgtype.UUID
	if err := reporter.Scan(strings.TrimSpace(reporterID)); err != nil {
		return fmt.Errorf("invalid reporter uuid: %w", err)
	}
	if err := target.Scan(strings.TrimSpace(contentID)); err != nil {
		return fmt.Errorf("invalid content uuid: %w", err)
	}
	contentType = strings.TrimSpace(contentType)
	reason = strings.TrimSpace(reason)
	if contentType == "" || reason == "" {
		return fmt.Errorf("content type and reason are required")
	}

	_, err := r.queries.Exec(ctx, `
INSERT INTO content_reports (
	reporter_id, target_type, target_id, reason, details, status, priority, created_at
) VALUES ($1, $2, $3, $4, '', 'open', 0, NOW())`, reporter, contentType, target, reason)
	return err
}
