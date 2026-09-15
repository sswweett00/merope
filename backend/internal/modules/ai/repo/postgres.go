package repo

import (
	"context"
	"encoding/json"
	"time"

	"local/merope/internal/database/db"
	ai_domain "local/merope/internal/modules/ai/domain"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresAIRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresAIRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresAIRepository {
	return &PostgresAIRepository{queries: queries, pool: pool}
}

func (r *PostgresAIRepository) StoreAnalysis(ctx context.Context, analysis *ai_domain.ContentAnalysis) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO ai_content_analyses (id, target_id, content_type, toxicity_score, sentiment_score, sentiment_magnitude, sentiment_emotions, categories, confidence, model_version, created_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
		analysis.ID, analysis.TargetID, analysis.ContentType, analysis.ToxicityScore,
		analysis.Sentiment.Score, analysis.Sentiment.Magnitude, analysis.Sentiment.Emotions,
		analysis.Categories, analysis.Confidence, analysis.ModelVersion, analysis.CreatedAt,
	)
	return err
}

func (r *PostgresAIRepository) GetAnalysis(ctx context.Context, id string) (*ai_domain.ContentAnalysis, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT id, target_id, content_type, toxicity_score, sentiment_score, sentiment_magnitude, sentiment_emotions, categories, confidence, model_version, created_at
		 FROM ai_content_analyses WHERE id = $1`,
		id,
	)
	return r.scanAnalysis(row.Scan)
}

func (r *PostgresAIRepository) GetAnalysesByTarget(ctx context.Context, targetID string) ([]*ai_domain.ContentAnalysis, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, target_id, content_type, toxicity_score, sentiment_score, sentiment_magnitude, sentiment_emotions, categories, confidence, model_version, created_at
		 FROM ai_content_analyses WHERE target_id = $1 ORDER BY created_at DESC`,
		targetID,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var analyses []*ai_domain.ContentAnalysis
	for rows.Next() {
		analysis, err := r.scanAnalysis(rows.Scan)
		if err != nil {
			continue
		}
		analyses = append(analyses, analysis)
	}
	return analyses, nil
}

func (r *PostgresAIRepository) BatchStoreAnalyses(ctx context.Context, analyses []*ai_domain.ContentAnalysis) error {
	for _, analysis := range analyses {
		if err := r.StoreAnalysis(ctx, analysis); err != nil {
			return err
		}
	}
	return nil
}

func (r *PostgresAIRepository) StoreUserVector(ctx context.Context, vector *ai_domain.UserProfileVector) error {
	interestsJSON, err := json.Marshal(vector.Interests)
	if err != nil {
		return err
	}
	engagementJSON, err := json.Marshal(vector.EngagementVector)
	if err != nil {
		return err
	}
	_, err = r.pool.Exec(ctx,
		`INSERT INTO user_interest_vectors (user_id, interests, engagement_vector, last_updated)
		 VALUES ($1, $2, $3, $4)
		 ON CONFLICT (user_id) DO UPDATE SET interests = $2, engagement_vector = $3, last_updated = $4`,
		vector.UserID, interestsJSON, engagementJSON, vector.LastUpdated,
	)
	return err
}

func (r *PostgresAIRepository) GetUserVector(ctx context.Context, userID string) (*ai_domain.UserProfileVector, error) {
	row := r.pool.QueryRow(ctx,
		`SELECT user_id, interests, engagement_vector, last_updated FROM user_interest_vectors WHERE user_id = $1`,
		userID,
	)
	var userIDCol pgtype.UUID
	var interestsJSON []byte
	var engagementJSON []byte
	var lastUpdated pgtype.Timestamptz

	err := row.Scan(&userIDCol, &interestsJSON, &engagementJSON, &lastUpdated)
	if err != nil {
		return nil, err
	}

	interests := []string{}
	if len(interestsJSON) > 0 {
		_ = json.Unmarshal(interestsJSON, &interests)
	}
	engagementVector := map[string]float64{}
	if len(engagementJSON) > 0 {
		_ = json.Unmarshal(engagementJSON, &engagementVector)
	}

	return &ai_domain.UserProfileVector{
		UserID:          uuid.UUID(userIDCol.Bytes).String(),
		Interests:       interests,
		EngagementVector: engagementVector,
		LastUpdated:     lastUpdated.Time,
	}, nil
}

func (r *PostgresAIRepository) StoreRecommendationLog(ctx context.Context, userID, contentID string, score float64, reason string) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO recommendation_logs (user_id, content_id, score, reason, created_at) VALUES ($1, $2, $3, $4, NOW())`,
		userID, contentID, score, reason,
	)
	return err
}

func (r *PostgresAIRepository) IncrementTrendScore(ctx context.Context, topic string, delta float64) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO trend_topics (topic, score, growth_rate, post_count, seed_users, updated_at)
		 VALUES ($1, $2, 0, 0, '{}', NOW())
		 ON CONFLICT (topic) DO UPDATE SET score = trend_topics.score + $2, updated_at = NOW()`,
		topic, delta,
	)
	return err
}

func (r *PostgresAIRepository) GetTrendTopics(ctx context.Context, window time.Duration) ([]ai_domain.TrendTopic, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT topic, score, growth_rate, post_count, seed_users, created_at FROM trend_topics
		 WHERE updated_at >= NOW() - $1 ORDER BY score DESC LIMIT 50`,
		window,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var topics []ai_domain.TrendTopic
	for rows.Next() {
		var t ai_domain.TrendTopic
		var seedUsersJSON []byte
		var createdAt pgtype.Timestamptz
		err := rows.Scan(&t.Topic, &t.Score, &t.GrowthRate, &t.PostCount, &seedUsersJSON, &createdAt)
		if err != nil {
			continue
		}
		if len(seedUsersJSON) > 0 {
			_ = json.Unmarshal(seedUsersJSON, &t.SeedUsers)
		}
		topics = append(topics, t)
	}
	return topics, nil
}

func (r *PostgresAIRepository) RefreshTrendMaterializedView(ctx context.Context) error {
	_, err := r.pool.Exec(ctx, `REFRESH MATERIALIZED VIEW CONCURRENTLY trend_topics_mv`)
	return err
}

func (r *PostgresAIRepository) scanAnalysis(scanFunc func(dest ...interface{}) error) (*ai_domain.ContentAnalysis, error) {
	var analysis ai_domain.ContentAnalysis
	var sentimentScore pgtype.Float8
	var sentimentMagnitude pgtype.Float8
	var emotionsJSON []byte
	var categoriesJSON []byte

	err := scanFunc(
		&analysis.ID, &analysis.TargetID, &analysis.ContentType, &analysis.ToxicityScore,
		&sentimentScore, &sentimentMagnitude, &emotionsJSON, &categoriesJSON,
		&analysis.Confidence, &analysis.ModelVersion, &analysis.CreatedAt,
	)
	if err != nil {
		return nil, err
	}

	analysis.Sentiment = ai_domain.SentimentResult{
		Score:     sentimentScore.Float64,
		Magnitude: sentimentMagnitude.Float64,
		Emotions:  map[string]float64{},
	}
	if len(emotionsJSON) > 0 {
		_ = json.Unmarshal(emotionsJSON, &analysis.Sentiment.Emotions)
	}
	if len(categoriesJSON) > 0 {
		_ = json.Unmarshal(categoriesJSON, &analysis.Categories)
	}

	return &analysis, nil
}
