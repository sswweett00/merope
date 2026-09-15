package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/vault/domain"
	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
)

type PostgresVaultRepository struct {
	queries *db.Queries
}

func NewPostgresVaultRepository(queries *db.Queries) *PostgresVaultRepository {
	return &PostgresVaultRepository{queries: queries}
}

func (r *PostgresVaultRepository) AddItem(ctx context.Context, item *domain.VaultItem) error {
	var uid pgtype.UUID
	_ = uid.Scan(item.UserID)
	_, err := r.queries.AddVaultItem(ctx, db.AddVaultItemParams{
		UserID:        uid,
		Title:         item.Title,
		EncryptedData: item.EncryptedData,
		ItemType:      item.ItemType,
	})
	return err
}

func (r *PostgresVaultRepository) GetItems(ctx context.Context, userID string) ([]*domain.VaultItem, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	rows, err := r.queries.GetUserVault(ctx, uid)
	if err != nil {
		return nil, err
	}

	var items []*domain.VaultItem
	for _, row := range rows {
		items = append(items, &domain.VaultItem{
			ID:            util.UUIDToString(row.ID),
			UserID:        util.UUIDToString(row.UserID),
			Title:         row.Title,
			EncryptedData: row.EncryptedData,
			ItemType:      row.ItemType,
			CreatedAt:     row.CreatedAt.Time,
		})
	}

	return items, nil
}
