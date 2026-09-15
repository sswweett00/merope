-- Production hardening for social-platform persistence.
-- Kept as a follow-up migration so the original core migration remains immutable.

ALTER TABLE outbox_events
    ADD COLUMN IF NOT EXISTS locked_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS locked_by TEXT;

ALTER TABLE idempotency_keys
    ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;

ALTER TABLE content_reports
    ADD CONSTRAINT content_reports_priority_range CHECK (priority BETWEEN 0 AND 100);

ALTER TABLE notification_deliveries
    ADD CONSTRAINT notification_deliveries_attempts_nonnegative CHECK (attempts >= 0);

ALTER TABLE feed_feedback
    ADD CONSTRAINT feed_feedback_weight_finite CHECK (weight = weight AND abs(weight) <= 1000);

-- Partial indexes must use immutable predicates. Time-based eligibility is
-- evaluated by worker queries rather than embedded in the predicate.
DROP INDEX IF EXISTS idx_outbox_claimable;
DROP INDEX IF EXISTS idx_stories_author_active;

CREATE INDEX IF NOT EXISTS idx_outbox_claimable
    ON outbox_events(next_attempt_at, occurred_at)
    WHERE published_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_outbox_unpublished_type
    ON outbox_events(event_type, occurred_at)
    WHERE published_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_consumed_events_retention
    ON consumed_events(processed_at);

CREATE INDEX IF NOT EXISTS idx_reports_assigned_queue
    ON content_reports(assigned_to, status, priority DESC, created_at)
    WHERE status IN ('open', 'review');

CREATE INDEX IF NOT EXISTS idx_notifications_entity
    ON notifications(entity_type, entity_id, created_at DESC)
    WHERE entity_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_stories_author_expiry
    ON stories(author_id, expires_at DESC, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_stories_expiry
    ON stories(expires_at, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_story_views_viewer
    ON story_views(viewer_id, viewed_at DESC);

CREATE INDEX IF NOT EXISTS idx_activity_daily_date
    ON user_activity_daily(activity_date DESC, user_id);

CREATE INDEX IF NOT EXISTS idx_devices_push_token
    ON device_registrations(push_token);

CREATE UNIQUE INDEX IF NOT EXISTS uq_notification_delivery_channel
    ON notification_deliveries(notification_id, channel);

ALTER TABLE profile_privacy
    ADD CONSTRAINT profile_privacy_message_policy
    CHECK (allow_messages_from IN ('everyone', 'followers', 'nobody')),
    ADD CONSTRAINT profile_privacy_mention_policy
    CHECK (allow_mentions_from IN ('everyone', 'followers', 'nobody')),
    ADD CONSTRAINT profile_privacy_tag_policy
    CHECK (allow_tags_from IN ('everyone', 'followers', 'nobody'));

CREATE INDEX IF NOT EXISTS idx_idempotency_expiry_user
    ON idempotency_keys(user_id, expires_at);

CREATE INDEX IF NOT EXISTS idx_idempotency_in_progress
    ON idempotency_keys(user_id, route, created_at)
    WHERE completed_at IS NULL;
