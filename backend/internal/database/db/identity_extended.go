package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"
)

func (q *Queries) GetGlobalUserRegistrySystemType(ctx context.Context, userID pgtype.UUID) (string, error) {
	var systemType string
	if err := q.db.QueryRow(ctx, `SELECT system_type FROM global_user_registry WHERE user_id = $1`, userID).Scan(&systemType); err != nil {
		return "", fmt.Errorf("get global user registry system type: %w", err)
	}
	return systemType, nil
}
