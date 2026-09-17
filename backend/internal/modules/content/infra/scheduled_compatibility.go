package infra

import (
	"context"
	"fmt"

	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) GetScheduledSignals(ctx context.Context, userID string) ([]*domain.Signal, error) {
	return nil, fmt.Errorf("scheduled content persistence is not present in the current posts schema")
}
