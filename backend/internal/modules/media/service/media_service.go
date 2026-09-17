package service

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/color"
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
	return &mediaService{s3Client: s3Client, publicURLPrefix: publicURLPrefix, repo: repo}
}

func (s *mediaService) UploadImage(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	data, err := io.ReadAll(body)
	if err != nil { return nil, fmt.Errorf("failed to read image body: %w", err) }
	config, formatName, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil { return nil, fmt.Errorf("failed to decode image config: %w", err) }
	width, height := config.Width, config.Height
	mimeType := "image/jpeg"
	if formatName == "png" { mimeType = "image/png" } else if formatName == "gif" { mimeType = "image/gif" }

	key := fmt.Sprintf("images/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	if _, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), mimeType); err != nil { return nil, err }
	imageURL := fmt.Sprintf("%s/%s", s.publicURLPrefix, key)

	thumbnailURL := ""
	if img, _, decodeErr := image.Decode(bytes.NewReader(data)); decodeErr == nil {
		if thumbBuf, thumbErr := s.createScaledImageBuffer(img, 250, 80); thumbErr == nil {
			thumbKey := fmt.Sprintf("thumbnails/%d_%s.jpg", time.Now().Unix(), uuid.New().String())
			if _, uploadErr := s.s3Client.Upload(ctx, thumbKey, thumbBuf, "image/jpeg"); uploadErr == nil { thumbnailURL = fmt.Sprintf("%s/%s", s.publicURLPrefix, thumbKey) }
		}
	}

	result := &domain.UploadResult{URL: imageURL, Key: key, FileSize: int64(len(data)), MimeType: mimeType, Width: width, Height: height, ThumbnailURL: thumbnailURL}
	metadata := &domain.MediaMetadata{ID: uuid.New().String(), OriginalName: name, StoredName: filepath.Base(key), StorageKey: key, StorageURL: result.URL, MimeType: mimeType, FileSize: result.FileSize, Width: width, Height: height, ThumbnailURL: thumbnailURL, UploaderID: userID, IsPublic: false, CreatedAt: time.Now(), UpdatedAt: time.Now(), Category: "image", ProcessingStatus: "completed"}
	_ = s.repo.SaveMediaMetadata(ctx, metadata)
	return result, nil
}

func (s *mediaService) UploadVideo(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("videos/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil { return nil, err }
	if _, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "video/mp4"); err != nil { return nil, err }
	result := &domain.UploadResult{URL: fmt.Sprintf("%s/%s", s.publicURLPrefix, key), Key: key, FileSize: int64(len(data)), MimeType: "video/mp4"}
	metadata := &domain.MediaMetadata{ID: uuid.New().String(), OriginalName: name, StoredName: filepath.Base(key), StorageKey: key, StorageURL: result.URL, MimeType: "video/mp4", FileSize: result.FileSize, UploaderID: userID, IsPublic: false, CreatedAt: time.Now(), UpdatedAt: time.Now(), Category: "video", ProcessingStatus: "processing"}
	_ = s.repo.SaveMediaMetadata(ctx, metadata)
	return result, nil
}

func (s *mediaService) UploadAudio(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("audio/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil { return nil, err }
	if _, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "audio/mpeg"); err != nil { return nil, err }
	result := &domain.UploadResult{URL: fmt.Sprintf("%s/%s", s.publicURLPrefix, key), Key: key, FileSize: int64(len(data)), MimeType: "audio/mpeg"}
	metadata := &domain.MediaMetadata{ID: uuid.New().String(), OriginalName: name, StoredName: filepath.Base(key), StorageKey: key, StorageURL: result.URL, MimeType: "audio/mpeg", FileSize: result.FileSize, UploaderID: userID, IsPublic: false, CreatedAt: time.Now(), UpdatedAt: time.Now(), Category: "audio", ProcessingStatus: "completed"}
	_ = s.repo.SaveMediaMetadata(ctx, metadata)
	return result, nil
}

func (s *mediaService) UploadDocument(ctx context.Context, name string, body io.Reader, userID string) (*domain.UploadResult, error) {
	key := fmt.Sprintf("documents/%d_%s%s", time.Now().Unix(), uuid.New().String(), filepath.Ext(name))
	data, err := io.ReadAll(body)
	if err != nil { return nil, err }
	if _, err = s.s3Client.Upload(ctx, key, bytes.NewReader(data), "application/pdf"); err != nil { return nil, err }
	result := &domain.UploadResult{URL: fmt.Sprintf("%s/%s", s.publicURLPrefix, key), Key: key, FileSize: int64(len(data)), MimeType: "application/pdf"}
	metadata := &domain.MediaMetadata{ID: uuid.New().String(), OriginalName: name, StoredName: filepath.Base(key), StorageKey: key, StorageURL: result.URL, MimeType: "application/pdf", FileSize: result.FileSize, UploaderID: userID, IsPublic: false, CreatedAt: time.Now(), UpdatedAt: time.Now(), Category: "document", ProcessingStatus: "completed"}
	_ = s.repo.SaveMediaMetadata(ctx, metadata)
	return result, nil
}

func (s *mediaService) TransformMedia(ctx context.Context, mediaID string, transformation *domain.MediaTransformation) (*domain.UploadResult, error) {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil { return nil, err }
	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil { return nil, fmt.Errorf("failed to download original media: %w", err) }
	defer reader.Close()
	img, _, err := image.Decode(reader)
	if err != nil { return nil, fmt.Errorf("failed to decode image for transformation: %w", err) }
	targetWidth := transformation.Width
	if targetWidth <= 0 { targetWidth = 800 }
	quality := transformation.Quality
	if quality <= 0 { quality = 85 }
	buf, err := s.createScaledImageBuffer(img, targetWidth, quality)
	if err != nil { return nil, err }
	newKey := fmt.Sprintf("transformed/%s_%dx%d.jpg", mediaID, targetWidth, transformation.Height)
	if _, err = s.s3Client.Upload(ctx, newKey, buf, "image/jpeg"); err != nil { return nil, err }
	return &domain.UploadResult{URL: fmt.Sprintf("%s/%s", s.publicURLPrefix, newKey), Key: newKey, FileSize: int64(buf.Len()), MimeType: "image/jpeg", Width: targetWidth, Height: (img.Bounds().Dy() * targetWidth) / img.Bounds().Dx()}, nil
}

func (s *mediaService) GenerateThumbnail(ctx context.Context, mediaID string) (*domain.UploadResult, error) {
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil { return nil, err }
	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil { return nil, err }
	defer reader.Close()
	img, _, err := image.Decode(reader)
	if err != nil { return nil, err }
	thumbBuf, err := s.createScaledImageBuffer(img, 250, 80)
	if err != nil { return nil, err }
	thumbKey := fmt.Sprintf("thumbnails/%s.jpg", mediaID)
	if _, err = s.s3Client.Upload(ctx, thumbKey, thumbBuf, "image/jpeg"); err != nil { return nil, err }
	thumbURL := fmt.Sprintf("%s/%s", s.publicURLPrefix, thumbKey)
	metadata.ThumbnailURL = thumbURL
	_ = s.repo.UpdateMediaMetadata(ctx, mediaID, metadata)
	return &domain.UploadResult{URL: thumbURL, Key: thumbKey, MimeType: "image/jpeg", FileSize: int64(thumbBuf.Len()), Width: 250, Height: (img.Bounds().Dy() * 250) / img.Bounds().Dx()}, nil
}

func (s *mediaService) CompressMedia(ctx context.Context, mediaID string, quality int) (*domain.UploadResult, error) {
	if quality <= 0 || quality > 100 { quality = 75 }
	metadata, err := s.repo.GetMediaMetadata(ctx, mediaID)
	if err != nil { return nil, err }
	reader, err := s.s3Client.Download(ctx, metadata.StorageKey)
	if err != nil { return nil, err }
	defer reader.Close()
	img, format, err := image.Decode(reader)
	if err != nil { return nil, err }
	buf := new(bytes.Buffer)
	if format == "png" { if err = png.Encode(buf, img); err != nil { return nil, err } } else if err = jpeg.Encode(buf, img, &jpeg.Options{Quality: quality}); err != nil { return nil, err }
	compressedKey := fmt.Sprintf("compressed/%s_q%d.jpg", mediaID, quality)
	if _, err = s.s3Client.Upload(ctx, compressedKey, buf, "image/jpeg"); err != nil { return nil, err }
	return &domain.UploadResult{URL: fmt.Sprintf("%s/%s", s.publicURLPrefix, compressedKey), Key: compressedKey, MimeType: "image/jpeg", FileSize: int64(buf.Len())}, nil
}

func bilinearResize(src image.Image, width, height int) *image.RGBA {
	dst := image.NewRGBA(image.Rect(0, 0, width, height))
	sb := src.Bounds()
	sw, sh := sb.Dx(), sb.Dy()
	if width <= 0 || height <= 0 || sw <= 0 || sh <= 0 { return dst }
	for y := 0; y < height; y++ {
		gy := 0.0
		if height > 1 { gy = float64(y) * float64(sh-1) / float64(height-1) }
		y0 := int(gy); y1 := y0 + 1; if y1 >= sh { y1 = sh - 1 }
		fy := gy - float64(y0)
		for x := 0; x < width; x++ {
			gx := 0.0
			if width > 1 { gx = float64(x) * float64(sw-1) / float64(width-1) }
			x0 := int(gx); x1 := x0 + 1; if x1 >= sw { x1 = sw - 1 }
			fx := gx - float64(x0)
			c00 := color.NRGBAModel.Convert(src.At(sb.Min.X+x0, sb.Min.Y+y0)).(color.NRGBA)
			c10 := color.NRGBAModel.Convert(src.At(sb.Min.X+x1, sb.Min.Y+y0)).(color.NRGBA)
			c01 := color.NRGBAModel.Convert(src.At(sb.Min.X+x0, sb.Min.Y+y1)).(color.NRGBA)
			c11 := color.NRGBAModel.Convert(src.At(sb.Min.X+x1, sb.Min.Y+y1)).(color.NRGBA)
			blend := func(a, b uint8, t float64) uint8 { return uint8(float64(a)*(1-t) + float64(b)*t + 0.5) }
			r0, r1 := blend(c00.R, c10.R, fx), blend(c01.R, c11.R, fx)
			g0, g1 := blend(c00.G, c10.G, fx), blend(c01.G, c11.G, fx)
			b0, b1 := blend(c00.B, c10.B, fx), blend(c01.B, c11.B, fx)
			a0, a1 := blend(c00.A, c10.A, fx), blend(c01.A, c11.A, fx)
			dst.SetNRGBA(image.Pt(x, y), color.NRGBA{R: blend(r0, r1, fy), G: blend(g0, g1, fy), B: blend(b0, b1, fy), A: blend(a0, a1, fy)})
		}
	}
	return dst
}

func (s *mediaService) createScaledImageBuffer(src image.Image, targetWidth int, quality int) (*bytes.Buffer, error) {
	bounds := src.Bounds()
	srcWidth, srcHeight := bounds.Dx(), bounds.Dy()
	if srcWidth <= 0 || srcHeight <= 0 { return nil, fmt.Errorf("invalid image dimensions") }
	if targetWidth >= srcWidth {
		buf := new(bytes.Buffer)
		if err := jpeg.Encode(buf, src, &jpeg.Options{Quality: quality}); err != nil { return nil, err }
		return buf, nil
	}
	targetHeight := (srcHeight * targetWidth) / srcWidth
	if targetHeight < 1 { targetHeight = 1 }
	dst := bilinearResize(src, targetWidth, targetHeight)
	buf := new(bytes.Buffer)
	if err := jpeg.Encode(buf, dst, &jpeg.Options{Quality: quality}); err != nil { return nil, err }
	return buf, nil
}

func (s *mediaService) GetMedia(ctx context.Context, mediaID string) (*domain.MediaMetadata, error) { return s.repo.GetMediaMetadata(ctx, mediaID) }
func (s *mediaService) GetUserMedia(ctx context.Context, userID string, page int32) ([]*domain.MediaMetadata, error) { if page < 0 { page = 0 }; limit := int32(50); return s.repo.GetUserMedia(ctx, userID, limit, page*limit) }
func (s *mediaService) DeleteMedia(ctx context.Context, mediaID, userID string) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; if metadata.UploaderID != userID { return fmt.Errorf("unauthorized") }; if err := s.s3Client.Delete(ctx, metadata.StorageKey); err != nil { return err }; return s.repo.DeleteMedia(ctx, mediaID) }
func (s *mediaService) UpdateMediaInfo(ctx context.Context, mediaID, altText, description string, tags []string) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; metadata.AltText, metadata.Description, metadata.Tags, metadata.UpdatedAt = altText, description, tags, time.Now(); return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata) }
func (s *mediaService) SearchMedia(ctx context.Context, query string, page int32) ([]*domain.MediaMetadata, error) { if page < 0 { page = 0 }; limit := int32(50); return s.repo.SearchMedia(ctx, query, limit, page*limit) }
func (s *mediaService) GetMediaByTags(ctx context.Context, tags []string, page int32) ([]*domain.MediaMetadata, error) { if page < 0 { page = 0 }; limit := int32(50); return s.repo.GetMediaByTags(ctx, tags, limit, page*limit) }
func (s *mediaService) GetTrendingMedia(ctx context.Context, limit int32) ([]*domain.MediaMetadata, error) { return s.repo.GetPublicMedia(ctx, limit, 0) }

func (s *mediaService) BatchUpload(ctx context.Context, files []domain.UploadRequest, userID string) ([]*domain.UploadResult, error) {
	results := make([]*domain.UploadResult, len(files))
	for i, file := range files {
		var result *domain.UploadResult
		var err error
		switch file.Category {
		case "image": result, err = s.UploadImage(ctx, file.Name, file.Body, userID)
		case "video": result, err = s.UploadVideo(ctx, file.Name, file.Body, userID)
		case "audio": result, err = s.UploadAudio(ctx, file.Name, file.Body, userID)
		case "document": result, err = s.UploadDocument(ctx, file.Name, file.Body, userID)
		default: result, err = s.UploadImage(ctx, file.Name, file.Body, userID)
		}
		if err != nil { return nil, err }
		results[i] = result
	}
	return results, nil
}

func (s *mediaService) BatchDelete(ctx context.Context, mediaIDs []string, userID string) error { for _, mediaID := range mediaIDs { if err := s.DeleteMedia(ctx, mediaID, userID); err != nil { return err } }; return nil }
func (s *mediaService) SetMediaPublic(ctx context.Context, mediaID string, isPublic bool) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; metadata.IsPublic, metadata.UpdatedAt = isPublic, time.Now(); return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata) }
func (s *mediaService) SetMediaExpiration(ctx context.Context, mediaID string, expiresAt time.Time) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; metadata.ExpiresAt, metadata.UpdatedAt = &expiresAt, time.Now(); return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata) }
