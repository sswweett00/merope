CREATE TABLE IF NOT EXISTS developer_apps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    client_id TEXT NOT NULL UNIQUE,
    client_secret TEXT NOT NULL,
    redirect_uri TEXT,
    scopes TEXT[] NOT NULL DEFAULT '{}',
    grant_types TEXT[] NOT NULL DEFAULT '{client_credentials,refresh_token}',
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    icon_url TEXT,
    homepage_url TEXT,
    terms_url TEXT,
    privacy_url TEXT,
    callback_urls TEXT[] NOT NULL DEFAULT '{}',
    settings JSONB NOT NULL DEFAULT '{"enable_webhooks":true,"enable_realtime":true,"enable_batch_api":false,"rate_limit_per_minute":100,"rate_limit_per_hour":1000,"max_concurrent_calls":10,"require_user_approval":false,"auto_approve_tokens":true,"token_expiry":3600,"refresh_token_expiry":86400}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(owner_id, name)
);
CREATE INDEX IF NOT EXISTS idx_developer_apps_owner ON developer_apps(owner_id, created_at DESC);

CREATE TABLE IF NOT EXISTS developer_api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_id UUID NOT NULL REFERENCES developer_apps(id) ON DELETE CASCADE,
    key_hash TEXT NOT NULL UNIQUE,
    key_prefix TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    scopes TEXT[] NOT NULL DEFAULT '{}',
    rate_limit_rpm INTEGER NOT NULL DEFAULT 100,
    rate_limit_rph INTEGER NOT NULL DEFAULT 1000,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    ip_whitelist TEXT[] NOT NULL DEFAULT '{}',
    last_used_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_developer_api_keys_app ON developer_api_keys(app_id, created_at DESC);

CREATE TABLE IF NOT EXISTS developer_webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_id UUID NOT NULL REFERENCES developer_apps(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    target_url TEXT NOT NULL,
    secret TEXT NOT NULL,
    events TEXT[] NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    retry_policy JSONB NOT NULL DEFAULT '{"max_retries":3,"retry_interval":60,"backoff_strategy":"exponential","timeout":30}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_developer_webhooks_app ON developer_webhooks(app_id, created_at DESC);

CREATE TABLE IF NOT EXISTS developer_bots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    app_id UUID NOT NULL REFERENCES developer_apps(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    avatar_url TEXT,
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_official BOOLEAN NOT NULL DEFAULT FALSE,
    permissions TEXT[] NOT NULL DEFAULT '{}',
    capabilities JSONB NOT NULL DEFAULT '[]',
    settings JSONB NOT NULL DEFAULT '{"allow_direct_messages":true,"allow_group_messages":true,"enable_commands":true,"enable_webhooks":false,"privacy_mode":"private","rate_limit_per_user":30,"max_command_queue":100}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_developer_bots_app ON developer_bots(app_id, created_at DESC);

CREATE TABLE IF NOT EXISTS developer_api_requests (
    id BIGSERIAL PRIMARY KEY,
    app_id UUID NOT NULL REFERENCES developer_apps(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL DEFAULT 'GET',
    duration_ms INTEGER NOT NULL DEFAULT 0,
    success BOOLEAN NOT NULL DEFAULT TRUE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    bandwidth_bytes BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_developer_api_requests_app_time ON developer_api_requests(app_id, created_at DESC);

CREATE TABLE IF NOT EXISTS developer_webhook_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    webhook_id UUID NOT NULL REFERENCES developer_webhooks(id) ON DELETE CASCADE,
    payload JSONB NOT NULL DEFAULT '{}',
    status_code INTEGER NOT NULL DEFAULT 0,
    success BOOLEAN NOT NULL DEFAULT FALSE,
    error_message TEXT,
    response_body TEXT,
    delivered_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_developer_webhook_deliveries_webhook ON developer_webhook_deliveries(webhook_id, delivered_at DESC);

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'bot_webhooks')
       AND NOT EXISTS (
           SELECT 1 FROM pg_constraint
           WHERE conname = 'bot_webhooks_bot_id_fkey'
             AND conrelid = 'bot_webhooks'::regclass
       ) THEN
        ALTER TABLE bot_webhooks
            ADD CONSTRAINT bot_webhooks_bot_id_fkey
            FOREIGN KEY (bot_id) REFERENCES developer_apps(id) ON DELETE CASCADE;
    END IF;
END $$;
