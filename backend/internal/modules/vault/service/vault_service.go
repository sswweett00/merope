package service

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/modules/vault/domain"
)

type vaultService struct {
	repo     domain.VaultRepository
	sentinel VaultSentinelEngine
}

func NewVaultService(repo domain.VaultRepository, sentinel VaultSentinelEngine) domain.VaultService {
	return &vaultService{
		repo:     repo,
		sentinel: sentinel,
	}
}

func (s *vaultService) SecureStore(ctx context.Context, userID, title, data, iType string) (*domain.VaultItem, error) {
	if title == "" {
		return nil, fmt.Errorf("title is required")
	}
	if data == "" {
		return nil, fmt.Errorf("encrypted data is required")
	}

	item := &domain.VaultItem{
		UserID:        userID,
		Title:         title,
		EncryptedData: data,
		ItemType:      iType,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}

	if s.sentinel != nil {
		if err := s.sentinel.ValidateItemIntegrity(item); err != nil {
			return nil, fmt.Errorf("sentinel validation failed: %w", err)
		}
		s.sentinel.AuditAccessAttempt(ctx, userID, title, "STORE", true)
	}

	return item, s.repo.AddItem(ctx, item)
}

func (s *vaultService) ListItems(ctx context.Context, userID string) ([]*domain.VaultItem, error) {
	if s.sentinel != nil {
		s.sentinel.AuditAccessAttempt(ctx, userID, "all", "LIST", true)
	}
	return s.repo.GetItems(ctx, userID)
}
