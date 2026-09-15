-- Merope Singularity Schema v11.0
-- Optimized for Massive Scalability, Neural Integrity, and Federated Identity

-- 0. Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 1. Federated Identity & Multi-Tenancy
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
    system_type TEXT NOT NULL, -- PERSONAL, CORPORATE
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

-- 2. Neural Connections (AI-Ready Social Graph)
CREATE TABLE neural_connections (
    source_id UUID NOT NULL REFERENCES users(id),
    target_id UUID NOT NULL REFERENCES users(id),
    weight FLOAT4 NOT NULL DEFAULT 0.1, -- Connection strength (0.0 to 1.0)
    interaction_count INTEGER DEFAULT 1,
    last_interaction_at TIMESTAMPTZ DEFAULT NOW(),
    connection_type TEXT NOT NULL, -- follower, mutual, workspace_colleague
    PRIMARY KEY (source_id, target_id)
);

CREATE TABLE follows (
    follower_id UUID NOT NULL REFERENCES users(id),
    following_id UUID NOT NULL REFERENCES users(id),
    status TEXT NOT NULL DEFAULT 'accepted',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

-- 3. Partitioned Content Engine (Posts)
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

-- Create initial partitions
CREATE TABLE posts_y2026_q3 PARTITION OF posts FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE posts_y2026_q4 PARTITION OF posts FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');

-- 4. Partitioned Communication Engine (Messaging)
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

-- 5. Sovereign Finance
CREATE TABLE wallets (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    balance BIGINT NOT NULL DEFAULT 0, -- Store in minor units (e.g. cents)
    currency TEXT NOT NULL DEFAULT 'TRY',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_wallet_id UUID REFERENCES wallets(user_id),
    receiver_wallet_id UUID REFERENCES wallets(user_id),
    amount BIGINT NOT NULL,
    tx_type TEXT NOT NULL, -- transfer, deposit, escrow, refund
    status TEXT NOT NULL DEFAULT 'completed',
    reference TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Audit & Sentinel
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

-- 7. Indices for Performance
CREATE INDEX idx_users_tenant_username ON users(tenant_id, username);
CREATE INDEX idx_neural_weight ON neural_connections(weight DESC);
CREATE INDEX idx_chat_messages_room ON chat_messages(room_id, created_at DESC);
CREATE INDEX idx_audit_user_action ON audit_logs(user_id, action, created_at DESC);
