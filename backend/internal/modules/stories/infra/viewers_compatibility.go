package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/modules/stories/domain"
)

func (r *PostgresStoriesRepository) GetStoryViewers(ctx context.Context, storyID string) ([]*domain.StoryViewer, error) {
	var sid pgtype.UUID
	if err := sid.Scan(strings.TrimSpace(storyID)); err != nil {
		return nil, fmt.Errorf("invalid story uuid: %w", err)
	}
	rows, err := r.queries.Query(ctx, `
SELECT u.id, u.username, COALESCE(u.display_name, ''), COALESCE(u.avatar_url, '')
FROM story_views sv
JOIN users u ON u.id = sv.viewer_id
WHERE sv.story_id = $1
ORDER BY sv.viewed_at DESC`, sid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	viewers := make([]*domain.StoryViewer, 0)
	for rows.Next() {
		var id pgtype.UUID
		var username, displayName, avatarURL string
		if err := rows.Scan(&id, &username, &displayName, &avatarURL); err != nil {
			return nil, err
		}
		viewers = append(viewers, &domain.StoryViewer{
			ID:          id.String(),
			Username:    username,
			DisplayName: displayName,
			AvatarURL:   avatarURL,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return viewers, nil
}
