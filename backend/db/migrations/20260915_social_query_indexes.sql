-- Query-path indexes for the server-authoritative social graph.

CREATE INDEX IF NOT EXISTS idx_follows_following_status
    ON follows(following_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_follows_follower_status
    ON follows(follower_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_neural_source_activity
    ON neural_connections(source_id, last_interaction_at DESC, weight DESC);

CREATE INDEX IF NOT EXISTS idx_neural_target_activity
    ON neural_connections(target_id, last_interaction_at DESC, weight DESC);

CREATE INDEX IF NOT EXISTS idx_posts_author_time
    ON posts(author_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_posts_visibility_time
    ON posts(visibility, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_posts_tenant_time
    ON posts(tenant_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_messages_author_time
    ON chat_messages(author_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_messages_room_time_id
    ON chat_messages(room_id, created_at DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_users_last_seen
    ON users(last_seen_at DESC, id);

CREATE INDEX IF NOT EXISTS idx_users_created
    ON users(created_at DESC, id);

-- Case-insensitive lookup supports predictable username search. Existing
-- uniqueness remains tenant-scoped in the canonical users table.
CREATE INDEX IF NOT EXISTS idx_users_tenant_username_lower
    ON users(tenant_id, lower(username));

CREATE INDEX IF NOT EXISTS idx_audit_entity_time
    ON audit_logs(entity_type, entity_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_risk_profiles_level
    ON risk_profiles(risk_level, last_assessment_at DESC);
