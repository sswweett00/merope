package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
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
SELECT cr.id, cr.reporter_id, cr.target_type, cr.target_id, cr.reason, COALESCE(cr.details, ''),
       cr.status, cr.created_at, cr.resolved_at, cr.assigned_to
FROM content_reports cr
WHERE cr.target_type = 'community'
  AND cr.target_id = $1`
	args := []interface{}{cid}
	if strings.TrimSpace(status) != "" {
		query += ` AND cr.status = $2 ORDER BY cr.priority DESC, cr.created_at DESC LIMIT $3 OFFSET $4`
		args = append(args, status, limit, offset)
	} else {
		query += ` ORDER BY cr.priority DESC, cr.created_at DESC LIMIT $2 OFFSET $3`
		args = append(args, limit, offset)
	}

	rows, err := r.queries.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.ContentReport, 0)
	for rows.Next() {
		var id, reporterID, targetID, assignedTo pgtype.UUID
		var contentType, reason, details, reportStatus string
		var createdAt, resolvedAt pgtype.Timestamptz
		if err := rows.Scan(&id, &reporterID, &contentType, &targetID, &reason, &details, &reportStatus, &createdAt, &resolvedAt, &assignedTo); err != nil {
			return nil, err
		}
		report := &domain.ContentReport{
			ID:          util.UUIDToString(id),
			ReporterID:  util.UUIDToString(reporterID),
			ContentType: contentType,
			ContentID:   util.UUIDToString(targetID),
			Reason:      reason,
			Description: details,
			Status:      reportStatus,
			CreatedAt:   createdAt.Time,
		}
		if resolvedAt.Valid {
			t := resolvedAt.Time
			report.ResolvedAt = &t
		}
		if assignedTo.Valid {
			u := util.UUIDToString(assignedTo)
			report.ResolvedBy = &u
		}
		result = append(result, report)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
