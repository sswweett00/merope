package infra

import (
	"context"
	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) GetMentionsForUser(ctx context.Context, userID string, limit, offset int32) ([]*domain.Mention, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil { return nil, err }
	rows, err := r.queries.ExecQuery(ctx, `SELECT id, user_id, entity_type, entity_id, created_at FROM mentions WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2 OFFSET $3`, uid, limit, offset)
	if err != nil { return nil, err }
	defer rows.Close()
	result := make([]*domain.Mention, 0)
	for rows.Next() {
		var m domain.Mention
		if err := rows.Scan(&m.ID, &m.UserID, &m.EntityType, &m.EntityID, &m.CreatedAt); err != nil { return nil, err }
		result = append(result, &m)
	}
	return result, rows.Err()
}

var _ interface{ GetMentionsForUser(context.Context, string, int32, int32) ([]*domain.Mention, error) } = (*PostgresContentRepository)(nil)
