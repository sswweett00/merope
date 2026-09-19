package domain

import (
	"context"
	"io"
	"time"
)

type UploadResult struct {
	URL          string
	Key          string
	FileSize     int64
	MimeType     string
	Width        int
	Height       int
	Duration     int // for video/audio in seconds
	ThumbnailURL string
}

type MediaMetadata struct {
	ID               string
	OriginalName     string
	StoredName       string
	StorageKey       string
	StorageURL       string
	MimeType         string
	FileSize         int64
	Width            int
	Height           int
	Duration         int // seconds
	ThumbnailURL     string
	UploaderID       string
	IsPublic         bool
	ExpiresAt        *time.Time
	CreatedAt        time.Time
	UpdatedAt        time.Time
	AltText          string
	Description      string
	Tags             []string
	Category         string // image, video, audio, document, avatar, banner
	ProcessingStatus string // pending, processing, completed, failed
}

type MediaTransformation struct {
	Width     int
	Height    int
	Quality   int
	Format    string // jpeg, png, webp, mp4
	Crop      bool
	Grayscale bool
	Blur      float64
	Rotate    int
}

type MediaRepository interface {
	SaveMediaMetadata(ctx context.Context, metadata *MediaMetadata) error
	GetMediaMetadata(ctx context.Context, mediaID string) (*MediaMetadata, error)
	GetUserMedia(ctx context.Context, userID string, limit, offset int32) ([]*MediaMetadata, error)
	GetMediaByTags(ctx context.Context, tags []string, limit, offset int32) ([]*MediaMetadata, error)
	UpdateMediaMetadata(ctx context.Context, mediaID string, metadata *MediaMetadata) error
	DeleteMedia(ctx context.Context, mediaID string) error
	MarkMediaAsExpired(ctx context.Context) error
	GetPublicMedia(ctx context.Context, limit, offset int32) ([]*MediaMetadata, error)
	SearchMedia(ctx context.Context, query string, limit, offset int32) ([]*MediaMetadata, error)
}

type MediaService interface {
	UploadImage(ctx context.Context, name string, body io.Reader, userID string) (*UploadResult, error)
	UploadVideo(ctx context.Context, name string, body io.Reader, userID string) (*UploadResult, error)
	UploadAudio(ctx context.Context, name string, body io.Reader, userID string) (*UploadResult, error)
	UploadDocument(ctx context.Context, name string, body io.Reader, userID string) (*UploadResult, error)

	// Media Processing
	TransformMedia(ctx context.Context, mediaID string, transformation *MediaTransformation) (*UploadResult, error)
	GenerateThumbnail(ctx context.Context, mediaID string) (*UploadResult, error)
	CompressMedia(ctx context.Context, mediaID string, quality int) (*UploadResult, error)

	// Media Management
	GetMedia(ctx context.Context, mediaID string) (*MediaMetadata, error)
	GetUserMedia(ctx context.Context, userID string, page int32) ([]*MediaMetadata, error)
	DeleteMedia(ctx context.Context, mediaID string, userID string) error
	UpdateMediaInfo(ctx context.Context, mediaID string, altText, description string, tags []string) error

	// Media Search & Discovery
	SearchMedia(ctx context.Context, query string, page int32) ([]*MediaMetadata, error)
	GetMediaByTags(ctx context.Context, tags []string, page int32) ([]*MediaMetadata, error)
	GetTrendingMedia(ctx context.Context, limit int32) ([]*MediaMetadata, error)

	// Batch Operations
	BatchUpload(ctx context.Context, files []UploadRequest, userID string) ([]*UploadResult, error)
	BatchDelete(ctx context.Context, mediaIDs []string, userID string) error

	// Access Control
	SetMediaPublic(ctx context.Context, mediaID string, isPublic bool) error
	SetMediaExpiration(ctx context.Context, mediaID string, expiresAt time.Time) error
}

type UploadRequest struct {
	Name     string
	Body     io.Reader
	MimeType string
	Category string
}
