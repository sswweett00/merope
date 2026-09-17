package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/modules/content/domain"
)

func (r *PostgresContentRepository) StoreLinkPreview(ctx context.Context, signalID string, preview *domain.LinkPreview) error {
	if preview == nil {
		return fmt.Errorf("link preview is required")
	}
	var postID pgtype.UUID
	if err := postID.Scan(strings.TrimSpace(signalID)); err != nil {
		return fmt.Errorf("invalid signal uuid: %w", err)
	}
	url := strings.TrimSpace(preview.URL)
	if url == "" {
		return fmt.Errorf("link preview url is required")
	}
	_, err := r.queries.Exec(ctx, `
INSERT INTO link_previews (post_id, url, title, description, image_url)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (post_id) DO UPDATE SET
    url = EXCLUDED.url,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    image_url = EXCLUDED.image_url,
    updated_at = NOW()`, postID, url, preview.Title, preview.Description, preview.ImageURL)
	return err
}
