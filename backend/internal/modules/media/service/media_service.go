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
	img, format, err := image.Decode(bytes.NewReader(data))
	if err != nil { return nil, fmt.Errorf("failed to decode image: %w", err) }
	_ = format
	key := fmt.Sprintf("media/%s/%s", userID, uuid.New().String()+filepath.Ext(name))
	if _, err := s.s3Client.Upload(ctx, key, bytes.NewReader(data), "image/jpeg"); err != nil { return nil, err }
	metadata := &domain.MediaMetadata{ID: uuid.New().String(), OriginalName: name, StoredName: filepath.Base(key), StorageKey: key, StorageURL: fmt.Sprintf("%s/%s", s.publicURLPrefix, key), MimeType: "image/jpeg", FileSize: int64(len(data)), Width: img.Bounds().Dx(), Height: img.Bounds().Dy(), UploaderID: userID, Category: "image", ProcessingStatus: "completed", CreatedAt: time.Now(), UpdatedAt: time.Now()}
	if err := s.repo.SaveMediaMetadata(ctx, metadata); err != nil { return nil, err }
	return &domain.UploadResult{URL: metadata.StorageURL, Key: key, FileSize: int64(len(data)), MimeType: metadata.MimeType, Width: metadata.Width, Height: metadata.Height}, nil
}

func bilinearScale(src image.Image, targetWidth, targetHeight int) *image.RGBA {
	dst := image.NewRGBA(image.Rect(0, 0, targetWidth, targetHeight))
	sb := src.Bounds()
	sw, sh := sb.Dx(), sb.Dy()
	if targetWidth <= 0 || targetHeight <= 0 { return dst }
	for y := 0; y < targetHeight; y++ {
		gy := 0.0
		if targetHeight > 1 { gy = float64(y) * float64(sh-1) / float64(targetHeight-1) }
		y0 := int(gy); y1 := y0 + 1; if y1 >= sh { y1 = sh - 1 }
		fy := gy - float64(y0)
		for x := 0; x < targetWidth; x++ {
			gx := 0.0
			if targetWidth > 1 { gx = float64(x) * float64(sw-1) / float64(targetWidth-1) }
			x0 := int(gx); x1 := x0 + 1; if x1 >= sw { x1 = sw - 1 }
			fx := gx - float64(x0)
			c00 := color.NRGBAModel.Convert(src.At(sb.Min.X+x0, sb.Min.Y+y0)).(color.NRGBA)
			c10 := color.NRGBAModel.Convert(src.At(sb.Min.X+x1, sb.Min.Y+y0)).(color.NRGBA)
			c01 := color.NRGBAModel.Convert(src.At(sb.Min.X+x0, sb.Min.Y+y1)).(color.NRGBA)
			c11 := color.NRGBAModel.Convert(src.At(sb.Min.X+x1, sb.Min.Y+y1)).(color.NRGBA)
			blend := func(a,b uint8,t float64) uint8 { return uint8(float64(a)*(1-t)+float64(b)*t+0.5) }
			r0 := blend(c00.R,c10.R,fx); r1 := blend(c01.R,c11.R,fx)
			g0 := blend(c00.G,c10.G,fx); g1 := blend(c01.G,c11.G,fx)
			b0 := blend(c00.B,c10.B,fx); b1 := blend(c01.B,c11.B,fx)
			a0 := blend(c00.A,c10.A,fx); a1 := blend(c01.A,c11.A,fx)
			dst.SetNRGBA(image.Pt(x,y), color.NRGBA{R: blend(r0,r1,fy), G: blend(g0,g1,fy), B: blend(b0,b1,fy), A: blend(a0,a1,fy)})
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
	targetHeight := max(1, (srcHeight*targetWidth)/srcWidth)
	dst := bilinearScale(src, targetWidth, targetHeight)
	buf := new(bytes.Buffer)
	if err := jpeg.Encode(buf, dst, &jpeg.Options{Quality: quality}); err != nil { return nil, err }
	return buf, nil
}

func max(a, b int) int { if a > b { return a }; return b }

func (s *mediaService) GetMedia(ctx context.Context, mediaID string) (*domain.MediaMetadata, error) { return s.repo.GetMediaMetadata(ctx, mediaID) }
func (s *mediaService) GetUserMedia(ctx context.Context, userID string, page int32) ([]*domain.MediaMetadata, error) { limit := int32(50); if page < 0 { page = 0 }; return s.repo.GetUserMedia(ctx, userID, limit, page*limit) }
func (s *mediaService) DeleteMedia(ctx context.Context, mediaID, userID string) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; if metadata.UploaderID != userID { return fmt.Errorf("unauthorized") }; if err := s.s3Client.Delete(ctx, metadata.StorageKey); err != nil { return err }; return s.repo.DeleteMedia(ctx, mediaID) }
func (s *mediaService) UpdateMediaInfo(ctx context.Context, mediaID, altText, description string, tags []string) error { metadata, err := s.repo.GetMediaMetadata(ctx, mediaID); if err != nil { return err }; metadata.AltText, metadata.Description, metadata.Tags, metadata.UpdatedAt = altText, description, tags, time.Now(); return s.repo.UpdateMediaMetadata(ctx, mediaID, metadata) }
func (s *mediaService) SearchMedia(ctx context.Context, query string, page int32) ([]*domain.MediaMetadata, error) { limit := int32(50); if page < 0 { page = 0 }; return s.repo.SearchMedia(ctx, query, limit, page*limit) }
func (s *mediaService) GetMediaByTags(ctx context.Context, tags []string, page int32) ([]*domain.MediaMetadata, error) { limit := int32(50); if page < 0 { page = 0 }; return s.repo.GetMediaByTags(ctx, tags, limit, page*limit) }
func (s *mediaService) GetTrendingMedia(ctx context.Context, limit int32) ([]*domain.MediaMetadata, error) { return s.repo.GetPublicMedia(ctx, limit, 0) }
