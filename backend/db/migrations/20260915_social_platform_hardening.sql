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

CREATE INDEX IF NOT EXISTS idx_outbox_claimable
    ON outbox_events(next_attempt_at, created_at)
    WHERE published_at IS NULL AND (locked_at IS NULL OR locked_at < NOW() - INTERVAL '2 minutes');

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

CREATE INDEX IF NOT EXISTS idx_story_views_viewer
    ON story_views(viewer_id, viewed_at DESC);

CREATE INDEX IF NOT EXISTS idx_activity_daily_date
    ON user_activity_daily(activity_date DESC, user_id);

CREATE INDEX IF NOT EXISTS idx_devices_push_token
    ON device_registrations(push_token);

-- A notification fan-out event should not create unbounded duplicates for the
-- same user/entity/type within one event. Application code may still create
-- multiple legitimate notifications over time.
CREATE UNIQUE INDEX IF NOT EXISTS uq_notification_delivery_channel
    ON notification_deliveries(notification_id, channel);

-- Enforce normalized values for security-sensitive policy columns.
ALTER TABLE profile_privacy
    ADD CONSTRAINT profile_privacy_message_policy
    CHECK (allow_messages_from IN ('everyone', 'followers', 'nobody')),
    ADD CONSTRAINT profile_privacy_mention_policy
    CHECK (allow_mentions_from IN ('everyone', 'followers', 'nobody')),
    ADD CONSTRAINT profile_privacy_tag_policy
    CHECK (allow_tags_from IN ('everyone', 'followers', 'nobody'));

-- Remove expired idempotency records without requiring a blocking table scan.
CREATE INDEX IF NOT EXISTS idx_idempotency_expiry_user
    ON idempotency_keys(user_id, expires_at);
