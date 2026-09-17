ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS creator_id UUID REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS amount NUMERIC(20, 2) NOT NULL DEFAULT 0;

ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS currency TEXT NOT NULL DEFAULT 'TRY';

ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS auto_renew BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS benefits TEXT[] NOT NULL DEFAULT '{}';

CREATE INDEX IF NOT EXISTS idx_subscriptions_subscriber_active
    ON subscriptions(user_id, active, expires_at DESC);

CREATE INDEX IF NOT EXISTS idx_subscriptions_creator_active
    ON subscriptions(creator_id, active, expires_at DESC);
