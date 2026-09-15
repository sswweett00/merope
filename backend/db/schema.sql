-- Merope Singularity Schema v11.2
-- Optimized for server-authoritative social runtime.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    domain TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    custom_config JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE global_user_registry (
    user_id UUID PRIMARY KEY,
    system_type TEXT NOT NULL,
    tenant_id UUID REFERENCES tenants(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id),
    system_type TEXT NOT NULL DEFAULT 'PERSONAL',
    username TEXT NOT NULL,
    display_name TEXT,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    mfa_secret TEXT,
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMPTZ,
    last_seen_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(tenant_id, username),
    UNIQUE(tenant_id, email)
);

CREATE TABLE neural_connections (
    source_id UUID NOT NULL REFERENCES users(id),
    target_id UUID NOT NULL REFERENCES users(id),
    weight FLOAT4 NOT NULL DEFAULT 0.1,
    interaction_count INTEGER DEFAULT 1,
    last_interaction_at TIMESTAMPTZ DEFAULT NOW(),
    connection_type TEXT NOT NULL,
    PRIMARY KEY (source_id, target_id)
);

CREATE TABLE follows (
    follower_id UUID NOT NULL REFERENCES users(id),
    following_id UUID NOT NULL REFERENCES users(id),
    status TEXT NOT NULL DEFAULT 'accepted',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

CREATE TABLE posts (
    id UUID NOT NULL DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id),
    author_id UUID NOT NULL REFERENCES users(id),
    content_text TEXT,
    media_urls TEXT[] DEFAULT '{}',
    visibility TEXT DEFAULT 'public',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE posts_y2026_q3 PARTITION OF posts FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE posts_y2026_q4 PARTITION OF posts FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');

CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id),
    name TEXT,
    is_group BOOLEAN DEFAULT FALSE,
    is_e2ee_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE chat_messages (
    id UUID NOT NULL DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id),
    author_id UUID NOT NULL REFERENCES users(id),
    content TEXT,
    encrypted_payload TEXT,
    message_type TEXT DEFAULT 'text',
    is_burn_on_read BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE chat_messages_y2026_q3 PARTITION OF chat_messages FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');

CREATE TABLE wallets (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    balance BIGINT NOT NULL DEFAULT 0,
    currency TEXT NOT NULL DEFAULT 'TRY',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_wallet_id UUID REFERENCES wallets(user_id),
    receiver_wallet_id UUID REFERENCES wallets(user_id),
    amount BIGINT NOT NULL,
    tx_type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'completed',
    reference TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id TEXT,
    metadata JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE risk_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    trust_score FLOAT4 DEFAULT 1.0,
    risk_level TEXT DEFAULT 'low',
    last_assessment_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE circles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id),
    name TEXT NOT NULL,
    is_private BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(owner_id, name)
);

CREATE TABLE circle_members (
    circle_id UUID NOT NULL REFERENCES circles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (circle_id, user_id)
);

CREATE TABLE content_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES users(id),
    target_id UUID NOT NULL,
    target_type TEXT NOT NULL,
    reason TEXT NOT NULL,
    details TEXT,
    status TEXT NOT NULL DEFAULT 'open',
    priority SMALLINT NOT NULL DEFAULT 0,
    assigned_to UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

CREATE TABLE auth_refresh_sessions (
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

CREATE TABLE request_deduplication (
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

CREATE TABLE user_presence (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    is_online BOOLEAN NOT NULL DEFAULT FALSE,
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE profile_locks (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE keyword_filters (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    keyword TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, keyword)
);

CREATE INDEX idx_users_tenant_username ON users(tenant_id, username);
CREATE INDEX idx_neural_weight ON neural_connections(weight DESC);
CREATE INDEX idx_chat_messages_room ON chat_messages(room_id, created_at DESC);
CREATE INDEX idx_audit_user_action ON audit_logs(user_id, action, created_at DESC);
CREATE INDEX idx_circles_owner ON circles(owner_id, created_at DESC);
CREATE INDEX idx_circle_members_user ON circle_members(user_id, created_at DESC);
CREATE INDEX idx_content_reports_queue ON content_reports(status, priority DESC, created_at ASC);
CREATE INDEX idx_content_reports_target ON content_reports(target_type, target_id, created_at DESC);
CREATE INDEX idx_auth_refresh_user ON auth_refresh_sessions(user_id, issued_at DESC);
CREATE INDEX idx_request_dedup_expiry ON request_deduplication(expires_at);
CREATE INDEX idx_user_presence_online ON user_presence(is_online, updated_at DESC);
CREATE INDEX idx_keyword_filters_user ON keyword_filters(user_id, created_at DESC);
