CREATE TABLE user_events (
    event_id UUID,
    user_id UUID,
    event_type String,
    payload String,
    created_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(created_at)
ORDER BY (created_at, user_id);
