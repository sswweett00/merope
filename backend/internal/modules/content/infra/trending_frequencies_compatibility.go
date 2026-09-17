package infra

import (
	"context"
	"strings"
)

func (r *PostgresContentRepository) GetTrendingFrequencies(ctx context.Context, limit int32) ([]string, error) {
	if limit <= 0 {
		limit = 20
	}

	rows, err := r.queries.Query(ctx, `
SELECT lower(matches.tag) AS tag
FROM posts p
CROSS JOIN LATERAL regexp_matches(COALESCE(p.content_text, ''), '#([[:alnum:]_]+)', 'g') AS matches(tag)
GROUP BY lower(matches.tag)
ORDER BY COUNT(*) DESC, lower(matches.tag) ASC
LIMIT $1`, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]string, 0)
	for rows.Next() {
		var tag string
		if err := rows.Scan(&tag); err != nil {
			return nil, err
		}
		tag = strings.TrimPrefix(tag, "#")
		if tag != "" {
			result = append(result, tag)
		}
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}
