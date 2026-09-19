package infra

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	sparkDomain "local/merope/internal/modules/spark/domain"
)

type PostgresSparkRepository struct{ queries *db.Queries }

func NewPostgresSparkRepository(queries *db.Queries) *PostgresSparkRepository {
	return &PostgresSparkRepository{queries: queries}
}

func (r *PostgresSparkRepository) FindMatch(ctx context.Context, userID string) (*sparkDomain.Match, error) {
	uid := util.StringToUUID(userID)
	const query = `
SELECT u.id,
       (SELECT COUNT(*) FROM UNNEST(uiv2.interests) AS i
        WHERE i = ANY(uiv1.interests))::float8
FROM users u
JOIN user_interest_vectors uiv2 ON u.id = uiv2.user_id
JOIN user_interest_vectors uiv1 ON uiv1.user_id = $1
WHERE u.id != $1
ORDER BY 2 DESC
LIMIT 1`

	var userBID pgtype.UUID
	var score float64
	if err := r.queries.QueryRow(ctx, query, uid).Scan(&userBID, &score); err != nil {
		return nil, err
	}
	return &sparkDomain.Match{UserAID: userID, UserBID: util.UUIDToString(userBID), Score: score}, nil
}

func (r *PostgresSparkRepository) GetResonanceScore(ctx context.Context, userAID, userBID string) (float64, error) {
	const query = `
SELECT (SELECT COUNT(*) FROM UNNEST(uiv2.interests) AS i
        WHERE i = ANY(uiv1.interests))::float8
FROM user_interest_vectors uiv1, user_interest_vectors uiv2
WHERE uiv1.user_id = $1 AND uiv2.user_id = $2`

	var score float64
	if err := r.queries.QueryRow(ctx, query, util.StringToUUID(userAID), util.StringToUUID(userBID)).Scan(&score); err != nil {
		return 0, err
	}
	return score, nil
}
