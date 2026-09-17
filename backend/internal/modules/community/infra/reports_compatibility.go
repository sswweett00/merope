package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) GetReports(ctx context.Context, communityID, status string, limit, offset int32) ([]*domain.ContentReport, error) {
	var cid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(communityID)); err != nil {
		return nil, fmt.Errorf("invalid community uuid: %w", err)
	}
	if limit <= 0 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	query := `
SELECT id, reporter_id, target_type, target_id, reason, description, status, created_at, resolved_at, resolved_by, resolution
FROM reports
WHERE target_type LIKE 'community:%'
  AND target_id = $1`
	_ = cid
	args := []interface{}{communityID}
	if strings.TrimSpace(status) != "" {
		query += ` AND status = $2 ORDER BY created_at DESC LIMIT $3 OFFSET $4`
		args = append(args, status, limit, offset)
	} else {
		query += ` ORDER BY created_at DESC LIMIT $2 OFFSET $3`
		args = append(args, limit, offset)
	}

	rows, err := r.queries.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.ContentReport, 0)
	for rows.Next() {
		var id, reporterID pgtype.UUID
		var contentType, contentID, reason, description, reportStatus, resolution string
		var createdAt pgtype.Timestamptz
		var resolvedAt pgtype.Timestamptz
		var resolvedBy pgtype.UUID
		if err := rows.Scan(&id, &reporterID, &contentType, &contentID, &reason, &description, &reportStatus, &createdAt, &resolvedAt, &resolvedBy, &resolution); err != nil {
			return nil, err
		}
		report := &domain.ContentReport{
			ID:          id.String(),
			ReporterID:  reporterID.String(),
			ContentType: contentType,
			ContentID:   contentID,
			Reason:      reason,
			Description: description,
			Status:      reportStatus,
			CreatedAt:   createdAt.Time,
			Resolution:  resolution,
		}
		if resolvedAt.Valid {
			t := resolvedAt.Time
			report.ResolvedAt = &t
		}
		if resolvedBy.Valid {
			id := resolvedBy.String()
			report.ResolvedBy = &id
		}
		result = append(result, report)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
