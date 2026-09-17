-- Extend the write horizon for time-partitioned production tables.
-- Keeping multiple quarters pre-created prevents a timestamp rollover from
-- turning normal writes into partition-routing failures.

CREATE TABLE IF NOT EXISTS posts_y2027_q3
    PARTITION OF posts
    FOR VALUES FROM ('2027-07-01') TO ('2027-10-01');

CREATE TABLE IF NOT EXISTS posts_y2027_q4
    PARTITION OF posts
    FOR VALUES FROM ('2027-10-01') TO ('2028-01-01');

CREATE TABLE IF NOT EXISTS posts_y2028_q1
    PARTITION OF posts
    FOR VALUES FROM ('2028-01-01') TO ('2028-04-01');

CREATE TABLE IF NOT EXISTS posts_y2028_q2
    PARTITION OF posts
    FOR VALUES FROM ('2028-04-01') TO ('2028-07-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2027_q3
    PARTITION OF chat_messages
    FOR VALUES FROM ('2027-07-01') TO ('2027-10-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2027_q4
    PARTITION OF chat_messages
    FOR VALUES FROM ('2027-10-01') TO ('2028-01-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2028_q1
    PARTITION OF chat_messages
    FOR VALUES FROM ('2028-01-01') TO ('2028-04-01');

CREATE TABLE IF NOT EXISTS chat_messages_y2028_q2
    PARTITION OF chat_messages
    FOR VALUES FROM ('2028-04-01') TO ('2028-07-01');
