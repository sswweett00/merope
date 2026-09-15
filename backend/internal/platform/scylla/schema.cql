-- ============================================================
-- ScyllaDB Schema for Merope High-Performance Components
-- Critical Paths: Real-time Chat, Comments (Nodes), Reactions, Timeline
--
-- Design Principles:
--   1. Query-first modeling - every table is shaped by its reads
--   2. No ALLOW FILTERING - all queries use partition keys
--   3. Bounded partitions - time-bucketed to avoid hot partitions
--   4. Denormalization over joins - ScyllaDB has no JOINs
--   5. TTL for ephemeral data (presence, typing indicators)
-- ============================================================

CREATE KEYSPACE IF NOT EXISTS merope_high_perf
WITH REPLICATION = {
  'class': 'NetworkTopologyStrategy',
  'datacenter1': 3
};

USE merope_high_perf;

-- ============================================================
-- TABLE 1: chat_messages_by_room
-- Query: Get latest N messages from a room for infinite scroll
-- Partition: room_id
-- Clustering: created_at DESC (newest first), message_id ASC (tie-break)
--
-- Write: INSERT per message
-- Reads: Paginated by created_at pagination token
-- ============================================================
CREATE TABLE IF NOT EXISTS chat_messages_by_room (
  room_id      uuid,
  created_at   bigint,           -- epoch milliseconds for efficient range scans
  message_id   uuid,
  sender_id    uuid,
  sender_name  text,
  sender_avatar text,
  content      text,
  message_type text,             -- text, voice, image, video, file
  voice_url    text,
  file_url     text,
  is_edited    boolean,
  is_pinned    boolean,
  is_encrypted boolean,
  encrypted_payload text,
  parent_id    uuid,             -- for threaded replies
  reactions    map<text, list<text>>,  -- emoji -> [user_ids]
  version      int,
  PRIMARY KEY ((room_id), created_at, message_id)
) WITH CLUSTERING ORDER BY (created_at DESC, message_id ASC)
  AND compaction = { 'class': 'TimeWindowCompactionStrategy', 'compaction_window_unit': 'HOURS', 'compaction_window_size': 1 }
  AND gc_grace_seconds = 0;

-- ============================================================
-- TABLE 2: chat_message_by_id
-- Query: Find message by ID (for reactions, edits, deletes, replies)
-- Partition: message_id
-- ============================================================
CREATE TABLE IF NOT EXISTS chat_message_by_id (
  message_id  uuid PRIMARY KEY,
  room_id     uuid,
  sender_id   uuid,
  sender_name text,
  sender_avatar text,
  content     text,
  message_type text,
  voice_url   text,
  file_url    text,
  is_edited   boolean,
  is_pinned   boolean,
  is_encrypted boolean,
  encrypted_payload text,
  parent_id   uuid,
  reactions   map<text, list<text>>,
  version     int,
  created_at  bigint,
  updated_at  bigint
);

-- ============================================================
-- TABLE 3: signal_comments_by_signal
-- Query: Get all comments for a signal, ordered newest first
-- Supports nested comments via parent_id
-- Partition: signal_id
-- Clustering: created_at DESC (newest first), node_id ASC
-- ============================================================
CREATE TABLE IF NOT EXISTS signal_comments_by_signal (
  signal_id   uuid,
  created_at  bigint,
  node_id     uuid,
  author_id   uuid,
  author_name text,
  author_avatar text,
  parent_id   uuid,              -- NULL for top-level, non-NULL for replies
  content     text,
  level       int,               -- nesting depth (0=top, 1=reply, 2=reply-to-reply)
  PRIMARY KEY ((signal_id), created_at, node_id)
) WITH CLUSTERING ORDER BY (created_at DESC, node_id ASC)
  AND compaction = { 'class': 'TimeWindowCompactionStrategy', 'compaction_window_unit': 'HOURS', 'compaction_window_size': 1 }
  AND gc_grace_seconds = 0;

-- ============================================================
-- TABLE 4: reactions_by_target
-- Query: Check if current user reacted, get reaction counts
-- Partition: target_id (signal_id or message_id)
-- Clustering: reaction_type ASC, user_id ASC
--
-- Each row = one user's reaction on one target.
-- LWT UPDATES for atomic reaction toggling (add/remove/toggle)
-- ============================================================
CREATE TABLE IF NOT EXISTS reactions_by_target (
  target_id    uuid,
  reaction_type text,            -- heart, wow, laugh, upvote, downvote
  user_id      uuid,
  created_at   bigint,
  PRIMARY KEY ((target_id), reaction_type, user_id)
) WITH compaction = { 'class': 'TimeWindowCompactionStrategy', 'compaction_window_unit': 'DAYS', 'compaction_window_size': 1 }
  AND gc_grace_seconds = 0;

-- ============================================================
-- TABLE 5: user_timeline
-- Query: Get user's home feed (latest signals from followed users)
-- Partition: user_id
-- Clustering: created_at DESC, signal_id ASC
--
-- This is the fan-out table. Written when someone creates a signal
-- that targets their followers' timelines.
-- ============================================================
CREATE TABLE IF NOT EXISTS user_timeline (
  user_id     uuid,
  created_at  bigint,
  signal_id   uuid,
  author_id   uuid,
  author_name text,
  author_avatar text,
  content_text text,
  media_urls  list<text>,
  visibility  text,
  resonance_score double,
  wave_amplitude int,
  is_pinned   boolean,
  PRIMARY KEY ((user_id), created_at, signal_id)
) WITH CLUSTERING ORDER BY (created_at DESC, signal_id ASC)
  AND compaction = { 'class': 'TimeWindowCompactionStrategy', 'compaction_window_unit': 'HOURS', 'compaction_window_size': 1 }
  AND gc_grace_seconds = 0;

-- ============================================================
-- TABLE 6: presence_by_user
-- Query: Check online status + last activity
-- TTL: 60 seconds for active status (auto-expires)
-- Partition: user_id
-- ============================================================
CREATE TABLE IF NOT EXISTS presence_by_user (
  user_id      uuid PRIMARY KEY,
  status       text,             -- online, offline, away
  last_seen    bigint,
  device_type  text
);

-- ============================================================
-- TABLE 7: typing_indicator
-- Query: Show "X is typing..." in chat room
-- TTL: 8 seconds (auto-expires on stop-typing)
-- Partition: room_id
-- Clustering: user_id (allows checking who else is typing)
-- ============================================================
CREATE TABLE IF NOT EXISTS typing_indicator (
  room_id      uuid,
  user_id      uuid,
  user_name    text,
  updated_at   bigint,
  PRIMARY KEY ((room_id), user_id)
) WITH default_time_to_live = 8;

-- ============================================================
-- TABLE 8: signal_by_id
-- Query: Get signal details by ID
-- Partition: signal_id
-- ============================================================
CREATE TABLE IF NOT EXISTS signal_by_id (
  signal_id    uuid PRIMARY KEY,
  author_id    uuid,
  author_name  text,
  author_avatar text,
  content_text text,
  media_urls   list<text>,
  visibility   text,
  is_pinned    boolean,
  is_archived  boolean,
  is_draft     boolean,
  reactions    map<text, int>,  -- reaction_type -> count
  resonance_score double,
  wave_amplitude int,
  created_at   bigint
);

-- ============================================================
-- TABLE 9: user_rooms
-- Query: Get all rooms a user is part of (cached from PG)
-- Partition: user_id
-- Clustering: created_at DESC
-- ============================================================
CREATE TABLE IF NOT EXISTS user_rooms (
  user_id       uuid,
  room_id       uuid,
  name          text,
  is_group      boolean,
  is_e2ee       boolean,
  is_archived   boolean,
  created_at    bigint,
  PRIMARY KEY ((user_id), created_at, room_id)
) WITH CLUSTERING ORDER BY (created_at DESC, room_id ASC);
