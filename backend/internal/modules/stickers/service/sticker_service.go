package service

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/modules/stickers/domain"
)

type stickerService struct {
	repo domain.StickerRepository
}

func NewStickerService(repo domain.StickerRepository) domain.StickerService {
	return &stickerService{repo: repo}
}

func (s *stickerService) CreateStickerPack(ctx context.Context, name, description, iconURL, creatorID string) (*domain.StickerPack, error) {
	pack := &domain.StickerPack{
		ID:          fmt.Sprintf("pack_%d", time.Now().UnixNano()),
		Name:        name,
		Description: description,
		IconURL:     iconURL,
		CreatorID:   creatorID,
		Stickers:    []*domain.Sticker{},
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}

	if err := s.repo.CreatePack(ctx, pack); err != nil {
		return nil, err
	}

	return pack, nil
}

func (s *stickerService) AddSticker(ctx context.Context, packID, imageURL, emojiCode string) (*domain.Sticker, error) {
	sticker := &domain.Sticker{
		ID:        fmt.Sprintf("stk_%d", time.Now().UnixNano()),
		PackID:    packID,
		ImageURL:  imageURL,
		EmojiCode: emojiCode,
		CreatedAt: time.Now(),
	}

	if err := s.repo.AddStickerToPack(ctx, sticker); err != nil {
		return nil, err
	}

	return sticker, nil
}

func (s *stickerService) GetDiscoverablePacks(ctx context.Context, page int32) ([]*domain.StickerPack, error) {
	return s.repo.GetAllPacks(ctx, 20, page*20)
}

func (s *stickerService) GetPack(ctx context.Context, packID string) (*domain.StickerPack, error) {
	return s.repo.GetPackByID(ctx, packID)
}

func (s *stickerService) Search(ctx context.Context, query string) ([]*domain.Sticker, error) {
	return s.repo.SearchStickers(ctx, query)
}
