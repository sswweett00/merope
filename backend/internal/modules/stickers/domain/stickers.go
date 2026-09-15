package domain

import (
	"context"
	"time"
)

type Sticker struct {
	ID        string
	PackID    string
	ImageURL  string
	EmojiCode string // Mapping to an emoji for search/suggest
	Width     int
	Height    int
	CreatedAt time.Time
}

type StickerPack struct {
	ID          string
	Name        string
	Description string
	IconURL     string
	CreatorID   string
	IsPremium   bool
	IsPublic    bool
	Stickers    []*Sticker
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type StickerRepository interface {
	CreatePack(ctx context.Context, pack *StickerPack) error
	GetPackByID(ctx context.Context, packID string) (*StickerPack, error)
	GetAllPacks(ctx context.Context, limit, offset int32) ([]*StickerPack, error)
	GetPacksByCreator(ctx context.Context, creatorID string) ([]*StickerPack, error)
	AddStickerToPack(ctx context.Context, sticker *Sticker) error
	DeletePack(ctx context.Context, packID string) error
	DeleteSticker(ctx context.Context, stickerID string) error
	SearchStickers(ctx context.Context, query string) ([]*Sticker, error)
}

type StickerService interface {
	CreateStickerPack(ctx context.Context, name, description, iconURL, creatorID string) (*StickerPack, error)
	AddSticker(ctx context.Context, packID, imageURL, emojiCode string) (*Sticker, error)
	GetDiscoverablePacks(ctx context.Context, page int32) ([]*StickerPack, error)
	GetPack(ctx context.Context, packID string) (*StickerPack, error)
	Search(ctx context.Context, query string) ([]*Sticker, error)
}
