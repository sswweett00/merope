-- AI Content Analysis Engine
-- Migration: 20260730

CREATE TABLE IF NOT EXISTS ai_content_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    target_id UUID NOT NULL,
    content_type TEXT NOT NULL,
    toxicity_score DOUBLE PRECISION NOT NULL DEFAULT 0,
    sentiment_score DOUBLE PRECISION NOT NULL DEFAULT 0,
    sentiment_magnitude DOUBLE PRECISION NOT NULL DEFAULT 0,
    sentiment_emotions JSONB DEFAULT '{}',
    categories JSONB DEFAULT '{}',
    confidence DOUBLE PRECISION NOT NULL DEFAULT 0,
    model_version TEXT NOT NULL DEFAULT 'v1.0.0',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_analysis_target ON ai_content_analyses(target_id);
CREATE INDEX idx_ai_analysis_content_type ON ai_content_analyses(content_type);
CREATE INDEX idx_ai_analysis_toxicity ON ai_content_analyses(toxicity_score DESC);
CREATE INDEX idx_ai_analysis_created ON ai_content_analyses(created_at DESC);

CREATE TABLE IF NOT EXISTS user_interest_vectors (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    interests TEXT[] DEFAULT '{}',
    engagement_vector JSONB DEFAULT '{}',
    last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_interests_gin ON user_interest_vectors USING GIN(interests);

CREATE TABLE IF NOT EXISTS content_embeddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_id UUID NOT NULL,
    content_type TEXT NOT NULL,
    embedding vector(384),
    model_version TEXT NOT NULL DEFAULT 'v1.0.0',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_embeddings_content ON content_embeddings(content_id);
CREATE INDEX idx_content_embeddings_type ON content_embeddings(content_type);

CREATE TABLE IF NOT EXISTS recommendation_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content_id UUID NOT NULL,
    score DOUBLE PRECISION NOT NULL,
    reason TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rec_logs_user ON recommendation_logs(user_id);
CREATE INDEX idx_rec_logs_content ON recommendation_logs(content_id);
CREATE INDEX idx_rec_logs_user_content ON recommendation_logs(user_id, content_id);
CREATE INDEX idx_rec_logs_created ON recommendation_logs(created_at DESC);

-- Materialized view target table for trending topics
CREATE TABLE IF NOT EXISTS trend_topics (
    topic TEXT PRIMARY KEY,
    score DOUBLE PRECISION NOT NULL DEFAULT 0,
    growth_rate DOUBLE PRECISION NOT NULL DEFAULT 0,
    post_count BIGINT NOT NULL DEFAULT 0,
    seed_users JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_trend_topics_score ON trend_topics(score DESC);
CREATE INDEX idx_trend_topics_growth ON trend_topics(growth_rate DESC);
CREATE INDEX idx_trend_topics_updated ON trend_topics(updated_at DESC);

-- Materialized view for trending topics
CREATE MATERIALIZED VIEW IF NOT EXISTS trend_topics_mv AS
SELECT
    topic,
    score,
    growth_rate,
    post_count,
    seed_users,
    created_at,
    updated_at
FROM trend_topics
WHERE updated_at >= NOW() - INTERVAL '7 days'
ORDER BY score DESC;

CREATE UNIQUE INDEX idx_trend_topics_mv_topic ON trend_topics_mv(topic);

-- Refresh function for materialized view
CREATE OR REPLACE FUNCTION refresh_trend_topics_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY trend_topics_mv;
END;
$$ LANGUAGE plpgsql;