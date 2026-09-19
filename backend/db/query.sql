-- Merope Social OS v10.1 Singularity Final Queries

-- 1. Multi-Tenancy
-- name: GetTenantByDomain :one
SELECT * FROM tenants WHERE domain = $1;

-- name: CreateTenant :one
INSERT INTO tenants (name, domain, custom_config)
VALUES ($1, $2, $3)
RETURNING *;

-- 2. Identity & Profile
-- name: CreateUser :one
INSERT INTO users (tenant_id, username, email, password_hash, avatar_url)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetUser :one
SELECT * FROM users WHERE id = $1 LIMIT 1;

-- name: GetUserByIdentifier :one
SELECT * FROM users WHERE username = $1 OR email = $1 LIMIT 1;

-- name: UpdateUser :one
UPDATE users SET username = $2, email = $3, avatar_url = $4, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateUserMFA :exec
UPDATE users SET mfa_enabled = $2, mfa_secret = $3 WHERE id = $1;

-- name: IncrementFailedLogin :exec
UPDATE users SET failed_login_attempts = failed_login_attempts + 1, updated_at = NOW() WHERE id = $1;

-- name: ResetFailedLogin :exec
UPDATE users SET failed_login_attempts = 0, locked_until = NULL, updated_at = NOW() WHERE id = $1;

-- name: LockAccount :exec
UPDATE users SET locked_until = $2, updated_at = NOW() WHERE id = $1;

-- 3. Sessions & Ghost Mode
-- name: CreateSession :one
INSERT INTO sessions (user_id, device_id, ip_address, user_agent, is_ghost_mode)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetUserSessions :many
SELECT * FROM sessions WHERE user_id = $1 AND is_active = TRUE;

-- name: DeactivateSession :exec
UPDATE sessions SET is_active = FALSE WHERE id = $1 AND user_id = $2;

-- name: SetGhostMode :one
UPDATE sessions SET is_ghost_mode = $2 WHERE id = $1 RETURNING *;

-- 4. Social & Relationships
-- name: FollowUser :exec
INSERT INTO follows (follower_id, following_id) VALUES ($1, $2) ON CONFLICT DO NOTHING;

-- name: UnfollowUser :exec
DELETE FROM follows WHERE follower_id = $1 AND following_id = $2;

-- name: GetFollowers :many
SELECT u.* FROM users u JOIN follows f ON u.id = f.follower_id WHERE f.following_id = $1;

-- name: GetFollowing :many
SELECT u.* FROM users u JOIN follows f ON u.id = f.following_id WHERE f.follower_id = $1;

-- name: GetMutuals :many
SELECT u.* FROM users u
WHERE u.id IN (SELECT f1.following_id FROM follows f1 WHERE f1.follower_id = $1)
  AND u.id IN (SELECT f2.follower_id FROM follows f2 WHERE f2.following_id = $1);

-- name: GetUserCircles :many
SELECT c.id, c.owner_id, c.name, c.is_private, c.created_at
FROM circles c
JOIN circle_members cm ON c.id = cm.circle_id
WHERE cm.user_id = $1;

-- 5. Content & Posts
-- name: CreatePost :one
INSERT INTO posts (author_id, content_text, media_urls, visibility)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetFeed :many
SELECT p.*, u.username as author_username, u.avatar_url as author_avatar
FROM posts p
JOIN users u ON p.author_id = u.id
WHERE p.published_at <= NOW() AND p.is_archived = FALSE
  AND (p.author_id IN (SELECT f.following_id FROM follows f WHERE f.follower_id = $1 AND f.status = 'accepted') OR p.visibility = 'public')
ORDER BY p.published_at DESC
LIMIT $2 OFFSET $3;

-- 6. Comments & Reactions
-- name: CreateComment :one
INSERT INTO comments (post_id, author_id, parent_id, content)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetCommentsForPost :many
SELECT c.*, u.username as author_username, u.avatar_url as author_avatar
FROM comments c
JOIN users u ON c.author_id = u.id
WHERE c.post_id = $1
ORDER BY c.created_at ASC;

-- name: AddReaction :one
INSERT INTO reactions (user_id, target_id, reaction_type)
VALUES ($1, $2, $3)
ON CONFLICT (user_id, target_id) DO UPDATE SET reaction_type = EXCLUDED.reaction_type
RETURNING *;

-- 7. Polls
-- name: CreatePoll :one
INSERT INTO polls (post_id, question, ends_at) VALUES ($1, $2, $3) RETURNING *;

-- name: CreatePollOption :one
INSERT INTO poll_options (poll_id, option_text) VALUES ($1, $2) RETURNING *;

-- name: CastPollVote :exec
INSERT INTO poll_votes (poll_id, option_id, user_id) VALUES ($1, $2, $3)
ON CONFLICT (poll_id, user_id) DO UPDATE SET option_id = EXCLUDED.option_id;

-- name: GetPollResults :many
SELECT po.option_text, COUNT(pv.user_id) as vote_count
FROM poll_options po
LEFT JOIN poll_votes pv ON po.id = pv.option_id
WHERE po.poll_id = $1
GROUP BY po.id, po.option_text;

-- 8. Messaging
-- name: CreateChatRoom :one
INSERT INTO chat_rooms (name, is_group, is_e2ee_enabled) VALUES ($1, $2, $3) RETURNING *;

-- name: AddChatMember :exec
INSERT INTO chat_members (room_id, user_id, role) VALUES ($1, $2, $3);

-- name: GetChatMembers :many
SELECT u.id, u.username, u.email, u.avatar_url
FROM users u
JOIN chat_members cm ON u.id = cm.user_id
WHERE cm.room_id = $1;

-- name: CreateChatMessage :one
INSERT INTO chat_messages (room_id, author_id, parent_id, content, encrypted_payload, message_type, is_encrypted)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;

-- name: UpdateChatMessage :one
UPDATE chat_messages SET content = $3, is_edited = TRUE, updated_at = NOW()
WHERE id = $1 AND author_id = $2
RETURNING *;

-- name: UpdateChatRoomE2EE :exec
UPDATE chat_rooms SET is_e2ee_enabled = $2 WHERE id = $1;

-- name: GetChatRoomE2EEStatus :one
SELECT is_e2ee_enabled FROM chat_rooms WHERE id = $1;

-- name: CreateE2EEKeyRotation :exec
INSERT INTO e2ee_key_rotations (room_id, user_id, public_key_id, device_id)
VALUES ($1, $2, $3, $4);

-- name: GetE2EEKeyRotations :many
SELECT * FROM e2ee_key_rotations WHERE room_id = $1 ORDER BY rotated_at ASC;

-- name: GetChatMessages :many
SELECT m.*, u.username as sender_name, u.avatar_url as sender_avatar
FROM chat_messages m
JOIN users u ON m.author_id = u.id
WHERE m.room_id = $1
ORDER BY m.created_at DESC
LIMIT $2 OFFSET $3;

-- 9. Stories
-- name: CreateStory :one
INSERT INTO stories (author_id, media_url, media_type, expires_at)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetActiveStories :many
SELECT s.*, u.username as author_username, u.avatar_url as author_avatar
FROM stories s
JOIN users u ON s.author_id = u.id
WHERE s.expires_at > NOW() AND s.is_archived = FALSE;

-- name: RecordStoryView :exec
INSERT INTO story_views (story_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING;

-- 10. Communities & Events
-- name: CreateCommunity :one
INSERT INTO communities (owner_id, name, description, avatar_url, is_private)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: JoinCommunity :exec
INSERT INTO community_members (community_id, user_id, role) VALUES ($1, $2, $3);

-- name: CreateEvent :one
INSERT INTO community_proposals (community_id, proposer_id, title, description, ends_at)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: RsvpEvent :exec
INSERT INTO event_attendees (event_id, user_id, status) VALUES ($1, $2, 'going')
ON CONFLICT (event_id, user_id) DO UPDATE SET status = EXCLUDED.status, rsvp_at = NOW();

-- name: CreateEventTicket :one
INSERT INTO transactions (wallet_id, amount, currency, type, reference) VALUES ($1, 0, 'TRY', 'event_ticket', $2)
RETURNING id, wallet_id, amount, currency, type, reference, status, created_at;

-- name: CreateSubscription :one
INSERT INTO subscriptions (user_id, plan, active) VALUES ($1, $2, TRUE)
RETURNING id, user_id, plan, started_at, expires_at, active;

-- 11. Marketplace & Finance
-- name: CreateProduct :one
INSERT INTO products (seller_id, name, description, price, currency, category)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: GetProduct :one
SELECT * FROM products WHERE id = $1 LIMIT 1;

-- name: CreateOrder :one
INSERT INTO orders (buyer_id, total_amount, status)
VALUES ($1, $2, $3)
RETURNING *;

-- name: AddOrderItem :exec
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES ($1, $2, $3, $4);

-- name: GetWallet :one
SELECT * FROM wallets WHERE user_id = $1;

-- name: UpdateWalletBalance :exec
UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE user_id = $1;

-- name: CreateTransaction :one
INSERT INTO orders (buyer_id, total_amount, status) VALUES ($1, $2, 'completed')
RETURNING id, buyer_id, total_amount, status, created_at;

-- 12. Escrow
-- name: CreateEscrowRecord :one
INSERT INTO escrow_records (order_id, buyer_id, seller_id, amount, status, description, release_at)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;

-- name: GetEscrowRecord :one
SELECT * FROM escrow_records WHERE id = $1 LIMIT 1;

-- name: UpdateEscrowStatus :exec
UPDATE escrow_records SET status = $2 WHERE id = $1;

-- 13. Vault
-- name: AddVaultItem :one
INSERT INTO vault_items (user_id, title, encrypted_data, item_type) VALUES ($1, $2, $3, $4)
RETURNING id, user_id, title, encrypted_data, item_type, created_at;

-- name: GetUserVault :many
SELECT id, user_id, title, encrypted_data, item_type, created_at, updated_at
FROM vault_items WHERE user_id = $1 ORDER BY created_at DESC;

-- 14. Developer & Apps
-- name: CreateDeveloperApp :one
INSERT INTO developer_apps (owner_id, name, client_id, client_secret)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetDeveloperAppByClientID :one
SELECT * FROM developer_apps WHERE client_id = $1 LIMIT 1;

-- name: CreateBotWebhook :one
INSERT INTO bot_webhooks (bot_id, callback_url, events, secret_token)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: ListBotWebhooks :many
SELECT * FROM bot_webhooks WHERE bot_id = $1;

-- 15. Nearby
-- name: UpdateUserLocation :exec
INSERT INTO user_locations (user_id, location, is_ghost_mode, updated_at)
VALUES ($1, ST_SetSRID(ST_MakePoint($2::float8, $3::float8), 4326), $4, NOW())
ON CONFLICT (user_id) DO UPDATE SET
    location = EXCLUDED.location,
    is_ghost_mode = EXCLUDED.is_ghost_mode,
    updated_at = NOW();

-- name: GetNearbyUsers :many
SELECT u.id, u.username, u.avatar_url, ST_Distance(ul.location, ST_SetSRID(ST_MakePoint($1::float8, $2::float8), 4326)) as distance
FROM user_locations ul
JOIN users u ON ul.user_id = u.id
WHERE ul.is_ghost_mode = FALSE
  AND ST_DWithin(ul.location, ST_SetSRID(ST_MakePoint($1::float8, $2::float8), 4326), $3::float8)
ORDER BY distance ASC
LIMIT $4;

-- 16. E2EE
-- name: UpsertIdentityKey :exec
INSERT INTO identity_keys (user_id, device_id, public_key)
VALUES ($1, $2, $3)
ON CONFLICT (user_id, device_id) DO UPDATE SET public_key = EXCLUDED.public_key;

-- name: GetIdentityKey :one
SELECT public_key FROM identity_keys WHERE user_id = $1 AND device_id = $2;

-- name: UpsertSignedPreKey :exec
INSERT INTO signed_prekeys (user_id, device_id, key_id, public_key, signature)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (user_id, device_id, key_id) DO UPDATE SET public_key = EXCLUDED.public_key, signature = EXCLUDED.signature;

-- name: GetSignedPreKey :one
SELECT * FROM signed_prekeys WHERE user_id = $1 AND device_id = $2 ORDER BY created_at DESC LIMIT 1;

-- name: UpsertOneTimePreKey :exec
INSERT INTO onetime_prekeys (user_id, device_id, key_id, public_key)
VALUES ($1, $2, $3, $4)
ON CONFLICT (user_id, device_id, key_id) DO NOTHING;

-- name: TakeOneTimePreKey :one
DELETE FROM onetime_prekeys
WHERE id = (SELECT o.id FROM onetime_prekeys o WHERE o.user_id = $1 AND o.device_id = $2 LIMIT 1)
RETURNING *;

-- name: FlagSuspiciousAccount :exec
INSERT INTO reports (reporter_id, target_type, target_id, reason, status)
VALUES ('00000000-0000-0000-0000-000000000000', 'user', $1, $2, 'bot_flagged')
ON CONFLICT DO NOTHING;

-- name: GetSuspiciousAccounts :many
SELECT target_id as user_id, reason, created_at as detected_at
FROM reports
WHERE status = 'bot_flagged' AND target_type = 'user'
ORDER BY created_at DESC;

-- name: ResolveSuspiciousAccount :exec
UPDATE reports SET status = $2, resolved_at = NOW()
WHERE target_id = $1 AND status = 'bot_flagged' AND target_type = 'user';

-- 18. Feature Flags
-- name: GetFeatureFlag :one
SELECT is_enabled, rollout_percentage FROM feature_flags WHERE tenant_id = $1 AND key = $2;

-- 19. Privacy
-- name: GetProfileVisibility :one
SELECT EXISTS (
    SELECT 1 FROM follows WHERE follower_id = $2 AND following_id = $1 AND status = 'accepted'
) OR NOT (SELECT is_private FROM users WHERE id = $1) as is_visible;

-- 20. Video
-- name: UpsertVideoMetadata :one
INSERT INTO video_metadata (post_id, duration_seconds, resolution_width, resolution_height)
VALUES ($1, $2, $3, $4)
ON CONFLICT (post_id) DO UPDATE SET duration_seconds = EXCLUDED.duration_seconds
RETURNING *;

-- name: AddVideoTrack :one
INSERT INTO video_tracks (post_id, track_type, language_code, media_url)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: AddVideoHotspot :one
INSERT INTO video_hotspots (post_id, timestamp_seconds, coord_x, coord_y, action_type, action_payload)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: CreateMediaBranch :one
INSERT INTO media_tree (parent_post_id, child_post_id, remix_type)
VALUES ($1, $2, $3)
RETURNING *;

-- 21. Worker
-- name: GetPendingPosts :many
SELECT * FROM posts WHERE is_draft = TRUE AND published_at <= NOW();

-- 22. Blocks
-- name: BlockUser :exec
INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2) ON CONFLICT DO NOTHING;

-- name: UnblockUser :exec
DELETE FROM blocks WHERE blocker_id = $1 AND blocked_id = $2;

-- name: IsBlocked :one
SELECT EXISTS(SELECT 1 FROM blocks WHERE blocker_id = $1 AND blocked_id = $2);

-- 23. Follow Requests
-- name: SendFollowRequest :exec
INSERT INTO follow_requests (follower_id, following_id, status) VALUES ($1, $2, 'pending')
ON CONFLICT (follower_id, following_id) DO UPDATE SET status = 'pending', created_at = NOW();

-- name: RespondToFollowRequest :exec
UPDATE follow_requests SET status = $3 WHERE follower_id = $1 AND following_id = $2;

-- name: GetFollowRequestsByUser :many
SELECT fr.follower_id, fr.following_id, fr.status, fr.created_at,
       u.username, u.avatar_url, u.display_name
FROM follow_requests fr
JOIN users u ON fr.follower_id = u.id
WHERE fr.following_id = $1 AND fr.status = 'pending'
ORDER BY fr.created_at DESC;

-- 24. Discovery
-- name: GetSuggestedUsers :many
SELECT u.id, u.username, u.display_name, u.avatar_url, u.bio, u.is_private
FROM users u
WHERE u.id != $1
  AND u.id NOT IN (SELECT following_id FROM follows WHERE follower_id = $1)
  AND u.id NOT IN (SELECT blocked_id FROM blocks WHERE blocker_id = $1)
  AND u.is_private = FALSE
ORDER BY (
  SELECT COUNT(*) FROM follows f1
  JOIN follows f2 ON f1.follower_id = f2.following_id
  WHERE f1.following_id = u.id AND f2.follower_id = $1
) DESC
LIMIT $2;

-- name: SearchUsers :many
SELECT id, username, display_name, avatar_url,
       CASE
           WHEN COALESCE(is_private, FALSE) = FALSE
                OR id = $2
                OR EXISTS (
                    SELECT 1 FROM follows f
                    WHERE f.follower_id = $2
                      AND f.following_id = users.id
                      AND f.status = 'accepted'
                )
           THEN bio
           ELSE NULL
       END AS bio
FROM users
WHERE (username ILIKE '%' || $1 || '%' OR display_name ILIKE '%' || $1 || '%')
  AND id != $2
  AND NOT EXISTS (
      SELECT 1
      FROM blocks b
      WHERE (b.blocker_id = $2 AND b.blocked_id = users.id)
         OR (b.blocker_id = users.id AND b.blocked_id = $2)
  )
ORDER BY display_name
LIMIT $3;

-- 25. Circles
-- name: GetCircles :many
SELECT id, owner_id, name, is_private, created_at
FROM circles WHERE owner_id = $1 ORDER BY created_at DESC;

-- name: GetCircleMembers :many
SELECT cm.user_id, u.username, u.display_name, u.avatar_url, cm.role, cm.joined_at
FROM circle_members cm
JOIN users u ON cm.user_id = u.id
WHERE cm.circle_id = $1;

-- 26. Hashtags
-- name: GetHashtagTrends :many
SELECT h.tag, COUNT(ph.post_id) as post_count
FROM hashtags h
JOIN post_hashtags ph ON h.id = ph.hashtag_id
JOIN posts p ON ph.post_id = p.id
WHERE p.published_at >= NOW() - INTERVAL '24 hours'
GROUP BY h.tag
ORDER BY post_count DESC
LIMIT $1;

-- 27. Notifications
-- name: MarkNotificationRead :exec
UPDATE notifications SET is_read = TRUE WHERE id = $1 AND receiver_id = $2;

-- name: GetUnreadCount :one
SELECT COUNT(*) FROM notifications WHERE receiver_id = $1 AND is_read = FALSE;

-- 28. Social Timeline (ScyllaDB fan-out)
-- name: GetUserTimeline :many
SELECT p.id, p.author_id, p.content_text, p.media_urls, p.visibility,
       p.published_at, p.created_at, u.username, u.avatar_url
FROM posts p
JOIN users u ON p.author_id = u.id
WHERE p.author_id IN (
  SELECT following_id FROM follows WHERE follower_id = $1 AND status = 'accepted'
)
ORDER BY p.published_at DESC
LIMIT $2 OFFSET $3;

-- 29. Search
-- name: Search :many
SELECT 'post' as type, p.id as id, p.content_text as title,
       u.username as subtitle, COUNT(r.id)::float8 as score
FROM posts p
JOIN users u ON p.author_id = u.id
LEFT JOIN reactions r ON r.target_id = p.id
WHERE p.content_text ILIKE '%' || $1 || '%'
  AND p.is_archived = FALSE
GROUP BY p.id, u.username
ORDER BY score DESC
LIMIT $2;

-- name: SaveHistory :exec
INSERT INTO search_history (user_id, query) VALUES ($1, $2)
ON CONFLICT (user_id, query) DO UPDATE SET created_at = NOW();

-- name: GetHistory :many
SELECT id, user_id, query, created_at
FROM search_history
WHERE user_id = $1
ORDER BY created_at DESC
LIMIT $2;

-- name: AddInterest :exec
INSERT INTO search_interests (user_id, interest) VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: GetInterests :many
SELECT interest FROM search_interests WHERE user_id = $1 ORDER BY created_at DESC;

-- 30. Lumia Broadcasting
-- name: CreateBroadcast :one
INSERT INTO broadcasts (host_id, title, is_live) VALUES ($1, $2, $3)
RETURNING id, host_id, title, viewer_count, is_live, started_at, created_at;

-- name: EndBroadcast :exec
UPDATE broadcasts SET is_live = FALSE, ended_at = NOW() WHERE id = $1;

-- name: AddEnergyDrop :one
INSERT INTO energy_drops (broadcast_id, sender_id, amount, drop_type) VALUES ($1, $2, $3, $4)
RETURNING id, broadcast_id, sender_id, amount, drop_type, created_at;

-- name: GetActiveBroadcasts :many
SELECT b.*, u.username as host_username, u.avatar_url as host_avatar
FROM broadcasts b
JOIN users u ON b.host_id = u.id
WHERE b.is_live = TRUE
ORDER BY b.viewer_count DESC;

-- 31. Spark Matches
-- name: FindMatch :one
SELECT u.id as user_b_id,
       (SELECT COUNT(*) FROM UNNEST(uiv2.interests) AS i
        WHERE i = ANY(uiv1.interests))::float8 as score
FROM users u
JOIN user_interest_vectors uiv2 ON u.id = uiv2.user_id
JOIN user_interest_vectors uiv1 ON uiv1.user_id = $1
WHERE u.id != $1
ORDER BY score DESC
LIMIT 1;

-- name: GetResonanceScore :one
SELECT (SELECT COUNT(*) FROM UNNEST(uiv2.interests) AS i
        WHERE i = ANY(uiv1.interests))::float8 as score
FROM user_interest_vectors uiv1, user_interest_vectors uiv2
WHERE uiv1.user_id = $1 AND uiv2.user_id = $2;

-- 32. Developer API Keys
-- name: CreateAPIKey :one
INSERT INTO api_keys (app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, expires_at)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING id, app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, last_used_at, expires_at, created_at;

-- name: GetAPIKeyByHash :one
SELECT id, app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, last_used_at, expires_at, created_at
FROM api_keys WHERE key_hash = $1 AND is_active = TRUE;

-- name: GetAPIKeysByAppID :many
SELECT id, app_id, key_hash, key_prefix, name, scopes, rate_limit_rpm, is_active, last_used_at, expires_at, created_at
FROM api_keys WHERE app_id = $1 ORDER BY created_at DESC;

-- name: UpdateAPIKeyUsage :exec
UPDATE api_keys SET last_used_at = NOW() WHERE id = $1;

-- name: RevokeAPIKey :exec
UPDATE api_keys SET is_active = FALSE WHERE id = $1;

-- 33. Moderation Queue
-- name: EnqueueAutoReview :one
INSERT INTO moderation_queue (content_type, content_id, author_id, auto_score, auto_reasons)
VALUES ($1, $2, $3, $4, $5)
RETURNING id, content_type, content_id, author_id, auto_score, auto_reasons, status, assigned_to, resolution, reviewed_at, created_at;

-- name: GetModerationQueue :many
SELECT mq.*, u.username as author_username
FROM moderation_queue mq
LEFT JOIN users u ON mq.author_id = u.id
WHERE mq.status = $1
ORDER BY mq.auto_score DESC, mq.created_at DESC
LIMIT $2 OFFSET $3;

-- name: AssignModerator :exec
UPDATE moderation_queue SET assigned_to = $2, status = 'in_review' WHERE id = $1;

-- name: ResolveModeration :exec
UPDATE moderation_queue SET status = $2, resolution = $3, reviewed_at = NOW() WHERE id = $1;

-- name: GetModerationByAuthor :many
SELECT * FROM moderation_queue WHERE author_id = $1 ORDER BY created_at DESC LIMIT $2;
