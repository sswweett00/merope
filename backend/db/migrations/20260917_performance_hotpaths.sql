-- Targeted indexes for high-frequency read paths. All are additive and
-- safe to apply repeatedly on existing installations.

CREATE INDEX IF NOT EXISTS idx_posts_pending_publish
    ON posts(published_at ASC, id)
    WHERE is_draft = TRUE AND published_at IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_posts_feed_published_time
    ON posts(published_at DESC, id)
    WHERE is_archived = FALSE AND is_draft = FALSE AND deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_comments_post_created
    ON comments(post_id, created_at ASC, id);

CREATE INDEX IF NOT EXISTS idx_collective_members_collective_joined
    ON collective_members(collective_id, joined_at DESC, user_id);

CREATE INDEX IF NOT EXISTS idx_thread_replies_thread_created
    ON thread_replies(thread_id, created_at ASC, id);

CREATE INDEX IF NOT EXISTS idx_event_attendees_event_status
    ON event_attendees(event_id, status, rsvp_at DESC, user_id);

CREATE INDEX IF NOT EXISTS idx_content_reports_target_status
    ON content_reports(target_type, target_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_developer_api_requests_app_time_success
    ON developer_api_requests(app_id, created_at DESC, success);

CREATE INDEX IF NOT EXISTS idx_developer_webhook_deliveries_webhook_time_status
    ON developer_webhook_deliveries(webhook_id, delivered_at DESC, success);
