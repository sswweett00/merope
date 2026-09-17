-- Align the subscription history query with its ORDER BY.
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_started
    ON subscriptions(user_id, started_at DESC);
