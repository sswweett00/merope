package domain

import (
	"context"
	"time"
)

type VaultItem struct {
	ID            string    `json:"id"`
	UserID        string    `json:"userId"`
	Title         string    `json:"title"`
	EncryptedData string    `json:"encryptedData"`
	ItemType      string    `json:"itemType"`
	CreatedAt     time.Time `json:"createdAt"`
	UpdatedAt     time.Time `json:"updatedAt"`
}

type VaultRepository interface {
	AddItem(ctx context.Context, item *VaultItem) error
	GetItems(ctx context.Context, userID string) ([]*VaultItem, error)
}

type VaultService interface {
	SecureStore(ctx context.Context, userID, title, data, iType string) (*VaultItem, error)
	ListItems(ctx context.Context, userID string) ([]*VaultItem, error)
}
