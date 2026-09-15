-- Production query indexes for identity, social graph, content and messaging.
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_tenant_username_ci
    ON users (tenant_id, lower(username));

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_tenant_email_ci
    ON users (tenant_id, lower(email));

CREATE INDEX IF NOT EXISTS idx_users_last_seen
    ON users(last_seen_at DESC);

CREATE INDEX IF NOT EXISTS idx_follows_following_created
    ON follows(following_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_follows_follower_created
    ON follows(follower_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_posts_author_created
    ON posts(author_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_posts_visibility_created
    ON posts(visibility, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_posts_content_trgm
    ON posts USING GIN (content_text gin_trgm_ops)
    WHERE content_text IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_chat_messages_author_created
    ON chat_messages(author_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_rooms_tenant_created
    ON chat_rooms(tenant_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_entity
    ON audit_logs(entity_type, entity_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_risk_profiles_level
    ON risk_profiles(risk_level, last_assessment_at DESC);
