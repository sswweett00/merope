-- Social correctness layer
-- Closes silent-success gaps in reports and privacy circles and aligns
-- the canonical database with the server-authoritative social model.

CREATE TABLE IF NOT EXISTS circles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    is_private BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(owner_id, name)
);

CREATE TABLE IF NOT EXISTS circle_members (
    circle_id UUID NOT NULL REFERENCES circles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (circle_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_circles_owner ON circles(owner_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_circle_members_user ON circle_members(user_id, created_at DESC);

-- Content reports are distinct from automated suspicious-account detection.
CREATE TABLE IF NOT EXISTS content_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_id UUID NOT NULL,
    target_type TEXT NOT NULL,
    reason TEXT NOT NULL,
    details TEXT,
    status TEXT NOT NULL DEFAULT 'open',
    priority SMALLINT NOT NULL DEFAULT 0,
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_content_reports_queue
    ON content_reports(status, priority DESC, created_at ASC);
CREATE INDEX IF NOT EXISTS idx_content_reports_target
    ON content_reports(target_type, target_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_content_reports_reporter
    ON content_reports(reporter_id, created_at DESC);

-- Bring the canonical posts model in line with the server contract.
ALTER TABLE posts ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS is_draft BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE posts ADD COLUMN IF NOT EXISTS scheduled_at TIMESTAMPTZ;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS content_warning TEXT;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS language_code TEXT;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS edited_at TIMESTAMPTZ;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_posts_author_created
    ON posts(author_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_feed_published
    ON posts(published_at DESC, created_at DESC)
    WHERE is_archived = FALSE AND is_draft = FALSE AND deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_posts_expiration
    ON posts(expires_at)
    WHERE expires_at IS NOT NULL AND deleted_at IS NULL;

-- Messaging fields required by the server contract.
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS parent_id UUID;
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS is_edited BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;
ALTER TABLE chat_messages ADD COLUMN IF NOT EXISTS idempotency_key TEXT;

CREATE INDEX IF NOT EXISTS idx_chat_messages_room_created
    ON chat_messages(room_id, created_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_chat_messages_room_idempotency
    ON chat_messages(room_id, author_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

-- Durable session/refresh state. Raw refresh tokens are never persisted here;
-- only a SHA-256 digest is retained.
CREATE TABLE IF NOT EXISTS auth_refresh_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id TEXT,
    token_hash BYTEA NOT NULL UNIQUE,
    parent_token_hash BYTEA,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    replaced_by_hash BYTEA
);
CREATE INDEX IF NOT EXISTS idx_auth_refresh_user
    ON auth_refresh_sessions(user_id, issued_at DESC);
CREATE INDEX IF NOT EXISTS idx_auth_refresh_active
    ON auth_refresh_sessions(user_id, expires_at)
    WHERE revoked_at IS NULL;

-- Request-level auditability for mutations.
CREATE TABLE IF NOT EXISTS request_deduplication (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    route TEXT NOT NULL,
    idempotency_key TEXT NOT NULL,
    request_hash TEXT NOT NULL,
    status_code INTEGER,
    response_body JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (user_id, route, idempotency_key)
);
CREATE INDEX IF NOT EXISTS idx_request_dedup_expiry
    ON request_deduplication(expires_at);
