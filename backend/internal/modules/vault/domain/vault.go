package domain

import (
	"context"
	"time"
)

type VaultItem struct {
	ID            string
	UserID        string
	Title         string
	EncryptedData string
	ItemType      string
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

type VaultRepository interface {
	AddItem(ctx context.Context, item *VaultItem) error
	GetItems(ctx context.Context, userID string) ([]*VaultItem, error)
}

type VaultService interface {
	SecureStore(ctx context.Context, userID, title, data, iType string) (*VaultItem, error)
	ListItems(ctx context.Context, userID string) ([]*VaultItem, error)
}
