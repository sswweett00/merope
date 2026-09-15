-- Maintain a future write horizon for time-partitioned data.
CREATE TABLE IF NOT EXISTS posts_y2027_q1
    PARTITION OF posts
    FOR VALUES FROM ('2027-01-01') TO ('2027-04-01');

CREATE TABLE IF NOT EXISTS posts_y2027_q2
    PARTITION OF posts
    FOR VALUES FROM ('2027-04-01') TO ('2027-07-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2026_q4
    PARTITION OF chat_messages
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2027_q1
    PARTITION OF chat_messages
    FOR VALUES FROM ('2027-01-01') TO ('2027-04-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2027_q2
    PARTITION OF chat_messages
    FOR VALUES FROM ('2027-04-01') TO ('2027-07-01');
