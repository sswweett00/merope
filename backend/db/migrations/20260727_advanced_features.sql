-- Advanced Features Migration (v10.1 Singularity+)

-- 1. E2EE (Signal Protocol)
CREATE TABLE identity_keys (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    public_key BYTEA NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, device_id)
);

CREATE TABLE signed_prekeys (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    key_id INTEGER NOT NULL,
    public_key BYTEA NOT NULL,
    signature BYTEA NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, device_id, key_id)
);

CREATE TABLE onetime_prekeys (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    key_id INTEGER NOT NULL,
    public_key BYTEA NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, device_id, key_id)
);

-- 2. Nearby (PostGIS)
-- Ensure PostGIS is enabled (might require superuser, but we include it for schema completeness)
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE user_locations (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    is_ghost_mode BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_locations_gist ON user_locations USING GIST (location);

-- 3. Bot Platform Enhancements
CREATE TABLE bot_webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bot_id UUID NOT NULL REFERENCES developer_apps(id) ON DELETE CASCADE,
    callback_url TEXT NOT NULL,
    events TEXT[] DEFAULT '{}',
    secret_token TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Analytics (ClickHouse is used for main analytics, but we can track simple events in Postgres for small scale)
-- Note: High-volume events go to ClickHouse directly.

-- 5. Finance/Escrow (Updating existing table if needed or adding helper tables)
-- existing escrow_records table is present in schema.sql, adding more details:
ALTER TABLE escrow_records ADD COLUMN IF NOT EXISTS buyer_id UUID REFERENCES users(id);
ALTER TABLE escrow_records ADD COLUMN IF NOT EXISTS seller_id UUID REFERENCES users(id);
ALTER TABLE escrow_records ADD COLUMN IF NOT EXISTS description TEXT;
