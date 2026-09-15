package service

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/draw"
	_ "image/gif"
	"image/jpeg"
	"image/png"
	"io"
	"local/merope/internal/modules/media/domain"
	"local/merope/internal/platform/s3"
	"path/filepath"
	"time"

	"github.com/google/uuid"
)

type mediaService struct {
	s3Client        *s3.Client
	publicURLPrefix string
	repo            domain.MediaRepository
}

func NewMediaService(s3Client *s3.Client, publicURLPrefix string, repo domain.MediaRepository) domain.MediaService {
	return &mediaService{
		s3Client:        s3Client,
		publicURLPrefix: publicURLPrefix,
		repo:            repo,
	}
}

func (s *mediaService) UploadImage(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	// Read full image bytes into buffer to allow multi-pass operations (metadata extraction, upload, thumbnail)
	data, err := io.ReadAll(body)
	if err != nil {
		return nil, fmt.Errorf("failed to read image body: %w", err)
	}

	// 1. Extract image dimensions
	config, formatName, err := image.DecodeConfig(bytes.NewReader(data))
	width, height := config.Width, config.Height
	mimeType := "image/jpeg"
	if formatName == "png" {
		mimeType = "image/png"
	} else if formatName == "gif" {
		mimeType = "image/gif"
	}

	key := fmt.Sprintf("images/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	_, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), mimeType)
	if err != nil {
		return nil, err
	}

	imageURL := fmt.Sprintf("%s/%s", s.publicURLPrefix, key)

	// 2. Generate 250px Thumbnail in background or inline
	thumbnailURL := ""
	if img, _, err := image.Decode(bytes.NewReader(data)); err == nil {
		thumbBuf, thumbErr := s.createScaledImageBuffer(img, 250, 80)
		if thumbErr == nil {
			thumbKey := fmt.Sprintf("thumbnails/%d_%s.jpg", time.Now().Unix(), uuid.New().String())
			if _, uploadErr := s.s3Client.Upload(ctx, thumbKey, thumbBuf, "image/jpeg"); uploadErr == nil {
				thumbnailURL = fmt.Sprintf("%s/%s", s.publicURLPrefix, thumbKey)
			}
		}
	}

	result := &domain.UploadResult{
		URL:          imageURL,
		Key:          key,
		FileSize:     int64(len(data)),
		MimeType:     mimeType,
		Width:        width,
		Height:       height,
		ThumbnailURL: thumbnailURL,
	}

	// Save metadata
	metadata := &domain.MediaMetadata{
		ID:               uuid.New().String(),
		OriginalName:     name,
		StoredName:       filepath.Base(key),
		StorageKey:       key,
		StorageURL:       result.URL,
		MimeType:         mimeType,
		FileSize:         result.FileSize,
		Width:            width,
		Height:           height,
		ThumbnailURL:     thumbnailURL,
		UploaderID:       userID,
		IsPublic:         false,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
		Category:         "image",
		ProcessingStatus: "completed",
	}

	_ = s.repo.SaveMediaMetadata(ctx, metadata)

	return result, nil
}

func (s *mediaService) UploadVideo(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("videos/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil {
		return nil, err
	}

	_, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "video/mp4")
	if err != nil {
		return nil, err
	}

	result := &domain.UploadResult{
		URL:      fmt.Sprintf("%s/%s", s.publicURLPrefix, key),
		Key:      key,
		FileSize: int64(len(data)),
		MimeType: "video/mp4",
	}

	// Save metadata
	metadata := &domain.MediaMetadata{
		ID:               uuid.New().String(),
		OriginalName:     name,
		StoredName:       filepath.Base(key),
		StorageKey:       key,
		StorageURL:       result.URL,
		MimeType:         "video/mp4",
		FileSize:         result.FileSize,
		UploaderID:       userID,
		IsPublic:         false,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
		Category:         "video",
		ProcessingStatus: "processing",
	}

	_ = s.repo.SaveMediaMetadata(ctx, metadata)

	return result, nil
}

func (s *mediaService) UploadAudio(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("audio/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil {
		return nil, err
	}

	_, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "audio/mpeg")
	if err != nil {
		return nil, err
	}

	result := &domain.UploadResult{
		URL:      fmt.Sprintf("%s/%s", s.publicURLPrefix, key),
		Key:      key,
		FileSize: int64(len(data)),
		MimeType: "audio/mpeg",
	}

	metadata := &domain.MediaMetadata{
		ID:               uuid.New().String(),
		OriginalName:     name,
		StoredName:       filepath.Base(key),
		StorageKey:       key,
		StorageURL:       result.URL,
		MimeType:         "audio/mpeg",
		FileSize:         result.FileSize,
		UploaderID:       userID,
		IsPublic:         false,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
		Category:         "audio",
		ProcessingStatus: "completed",
	}

	_ = s.repo.SaveMediaMetadata(ctx, metadata)

	return result, nil
}

func (s *mediaService) UploadDocument(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("documents/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil {
		return nil, err
	}

	_, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "application/pdf")
	if err != nil {
		return nil, err
	}

	result := &domain.UploadResult{
		URL:      fmt.Sprintf("%s/%s", s.publicURLPrefix, key),
		Key:      key,
		FileSize: int64(len(data)),
		MimeType: "application/pdf",
	}

	metadata := &domain.MediaMetadata{
		ID:               uuid.New().String(),
		OriginalName:     name,
		StoredName:       filepath.Base(key),
		StorageKey:       key,
		StorageURL:       result.URL,
		MimeType:         "application/pdf",
		FileSize:         result.FileSize,
		UploaderID:       userID,
		IsPublic:         false,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
		Category:         "document",
		ProcessingStatus: "completed",
	}

	_ = s.repo.SaveMediaMetadata(ctx, metadata)

	return result, nil
}

func (s *mediaService) TransformMedia(ctx context.Context, mediaID string, transformation *domain.MediaTransformation) (*domain.UploadResult, error) {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return nil, err
	}

	// Download original media
	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil {
		return nil, fmt.Errorf("failed to download original media: %w", err)
	}
	defer reader.Close()

	img, _, err := image.Decode(reader)
	if err != nil {
		return nil, fmt.Errorf("failed to decode image for transformation: %w", err)
	}

	targetWidth := transformation.Width
	if targetWidth <= 0 {
		targetWidth = 800
	}
	quality := transformation.Quality
	if quality <= 0 {
		quality = 85
	}

	buf, err := s.createScaledImageBuffer(img, targetWidth, quality)
	if err != nil {
		return nil, err
	}

	newKey := fmt.Sprintf("transformed/%s_%dx%d.jpg", mediaID, targetWidth, transformation.Height)
	_, err = s.s3Client.Upload(ctx, newKey, buf, "image/jpeg")
	if err != nil {
		return nil, err
	}

	result := &domain.UploadResult{
		URL:      fmt.Sprintf("%s/%s", s.publicURLPrefix, newKey),
		Key:      newKey,
		FileSize: int64(buf.Len()),
		MimeType: "image/jpeg",
		Width:    targetWidth,
		Height:   (img.Bounds().Dy() * targetWidth) / img.Bounds().Dx(),
	}

	return result, nil
}

func (s *mediaService) GenerateThumbnail(ctx context.Context, mediaID string) (*domain.UploadResult, error) {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return nil, err
	}

	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil {
		return nil, err
	}
	defer reader.Close()

	img, _, err := image.Decode(reader)
	if err != nil {
		return nil, err
	}

	thumbBuf, err := s.createScaledImageBuffer(img, 250, 80)
	if err != nil {
		return nil, err
	}

	thumbKey := fmt.Sprintf("thumbnails/%s.jpg", mediaID)
	_, err = s.s3Client.Upload(ctx, thumbKey, thumbBuf, "image/jpeg")
	if err != nil {
		return nil, err
	}

	thumbURL := fmt.Sprintf("%s/%s", s.publicURLPrefix, thumbKey)

	metadata.ThumbnailURL = thumbURL
	_ = s.repo.UpdateMediaMetadata(ctx, mediaID, metadata)

	return &domain.UploadResult{
		URL:      thumbURL,
		Key:      thumbKey,
		MimeType: "image/jpeg",
		FileSize: int64(thumbBuf.Len()),
		Width:    250,
		Height:   (img.Bounds().Dy() * 250) / img.Bounds().Dx(),
	}, nil
}

func (s *mediaService) CompressMedia(ctx context.Context, mediaID string, quality int) (*domain.UploadResult, error) {
	if quality <= 0 || quality > 100 {
		quality = 75
	}

	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return nil, err
	}

	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil {
		return nil, err
	}
	defer reader.Close()

	img, format, err := image.Decode(reader)
	if err != nil {
		return nil, err
	}

	buf := new(bytes.Buffer)
	if format == "png" {
		_ = png.Encode(buf, img)
	} else {
		_ = jpeg.Encode(buf, img, &jpeg.Options{Quality: quality})
	}

	compressedKey := fmt.Sprintf("compressed/%s_q%d.jpg", mediaID, quality)
	_, err = s.s3Client.Upload(ctx, compressedKey, buf, "image/jpeg")
	if err != nil {
		return nil, err
	}

	return &domain.UploadResult{
		URL:      fmt.Sprintf("%s/%s", s.publicURLPrefix, compressedKey),
		Key:      compressedKey,
		MimeType: "image/jpeg",
		FileSize: int64(buf.Len()),
	}, nil
}

func (s *mediaService) createScaledImageBuffer(src image.Image, targetWidth int, quality int) (*bytes.Buffer, error) {
	bounds := src.Bounds()
	srcWidth := bounds.Dx()
	srcHeight := bounds.Dy()

	if srcWidth <= 0 || srcHeight <= 0 {
		return nil, fmt.Errorf("invalid image dimensions")
	}

	if targetWidth >= srcWidth {
		buf := new(bytes.Buffer)
		err := jpeg.Encode(buf, src, &jpeg.Options{Quality: quality})
		return buf, err
	}

	targetHeight := (srcHeight * targetWidth) / srcWidth
	dst := image.NewRGBA(image.Rect(0, 0, targetWidth, targetHeight))

	// Bilinear resampling using image/draw
	draw.BiLinear.Scale(dst, dst.Bounds(), src, bounds, draw.Over, nil)

	buf := new(bytes.Buffer)
	err := jpeg.Encode(buf, dst, &jpeg.Options{Quality: quality})
	if err != nil {
		return nil, err
	}
	return buf, nil
}

func (s *mediaService) GetMedia(ctx context.Context, mediaID string) (*domain.MediaMetadata, error) {
	return s.repo.GetMediaMetadata(ctx, mediaID)
}

func (s *mediaService) GetUserMedia(ctx context.Context, userID string, page int32) ([]*domain.MediaMetadata, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.GetUserMedia(ctx, userID, limit, offset)
}

func (s *mediaService) DeleteMedia(ctx context.Context, mediaID string, userID string) error {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return err
	}

	if metadata.UploaderID != userID {
		return fmt.Errorf("unauthorized")
	}

	_ = s.s3Client.Delete(ctx, metadata.StorageKey)

	return s.repo.DeleteMedia(ctx, mediaID)
}

func (s *mediaService) UpdateMediaInfo(ctx context.Context, mediaID string, altText, description string, tags []string) error {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return err
	}

	metadata.AltText = altText
	metadata.Description = description
	metadata.Tags = tags
	metadata.UpdatedAt = time.Now()

	return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata)
}

func (s *mediaService) SearchMedia(ctx context.Context, query string, page int32) ([]*domain.MediaMetadata, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.SearchMedia(ctx, query, limit, offset)
}

func (s *mediaService) GetMediaByTags(ctx context.Context, tags []string, page int32) ([]*domain.MediaMetadata, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.GetMediaByTags(ctx, tags, limit, offset)
}

func (s *mediaService) GetTrendingMedia(ctx context.Context, limit int32) ([]*domain.MediaMetadata, error) {
	return s.repo.GetPublicMedia(ctx, limit)
}

func (s *mediaService) BatchUpload(ctx context.Context, files []domain.UploadRequest, userID string) ([]*domain.UploadResult, error) {
	results := make([]*domain.UploadResult, len(files))

	for i, file := range files {
		var result *domain.UploadResult
		var err error

		switch file.Category {
		case "image":
			result, err = s.UploadImage(ctx, file.Name, file.Body, userID)
		case "video":
			result, err = s.UploadVideo(ctx, file.Name, file.Body, userID)
		case "audio":
			result, err = s.UploadAudio(ctx, file.Name, file.Body, userID)
		case "document":
			result, err = s.UploadDocument(ctx, file.Name, file.Body, userID)
		default:
			result, err = s.UploadImage(ctx, file.Name, file.Body, userID)
		}

		if err != nil {
			return nil, err
		}

		results[i] = result
	}

	return results, nil
}

func (s *mediaService) BatchDelete(ctx context.Context, mediaIDs []string, userID string) error {
	for _, mediaID := range mediaIDs {
		if err := s.DeleteMedia(ctx, mediaID, userID); err != nil {
			return err
		}
	}
	return nil
}

func (s *mediaService) SetMediaPublic(ctx context.Context, mediaID string, isPublic bool) error {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return err
	}

	metadata.IsPublic = isPublic
	metadata.UpdatedAt = time.Now()

	return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata)
}

func (s *mediaService) SetMediaExpiration(ctx context.Context, mediaID string, expiresAt time.Time) error {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil {
		return err
	}

	metadata.ExpiresAt = &expiresAt
	metadata.UpdatedAt = time.Now()

	return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata)
}
