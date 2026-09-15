# Merope Social API Contract

All endpoints are server-authoritative. Mutating endpoints should accept `Idempotency-Key` and return a stable semantic result for duplicate delivery.

## Authentication

- `POST /api/v10/auth/register`
- `POST /api/v10/auth/login`
- `POST /api/v10/auth/refresh`
- `POST /api/v10/auth/logout`
- `GET /api/v10/auth/me`
- `GET /api/v10/auth/sessions`
- `DELETE /api/v10/auth/sessions/:id`

## Profiles

- `GET /api/v10/social/profile/:id`
- `PUT /api/v10/profile`
- `GET /api/v10/profile/:id/followers`
- `GET /api/v10/profile/:id/following`
- `GET /api/v10/profile/:id/mutuals`
- `PUT /api/v10/profile/privacy`

## Social graph

- `POST /api/v10/social/follow/:id`
- `POST /api/v10/social/unfollow/:id`
- `POST /api/v10/social/block/:id`
- `DELETE /api/v10/social/block/:id`
- `POST /api/v10/social/mute/:id`
- `DELETE /api/v10/social/mute/:id`
- `GET /api/v10/social/follow-requests`
- `POST /api/v10/social/follow-requests/:id/accept`
- `POST /api/v10/social/follow-requests/:id/reject`
- `GET /api/v10/social/suggestions`

## Content

- `POST /api/v10/content/posts`
- `GET /api/v10/content/posts/:id`
- `PUT /api/v10/content/posts/:id`
- `DELETE /api/v10/content/posts/:id`
- `GET /api/v10/content/posts/:id/comments`
- `POST /api/v10/content/posts/:id/comments`
- `PUT /api/v10/content/comments/:id`
- `DELETE /api/v10/content/comments/:id`
- `POST /api/v10/content/posts/:id/react`
- `DELETE /api/v10/content/posts/:id/react`
- `POST /api/v10/content/posts/:id/repost`
- `DELETE /api/v10/content/posts/:id/repost`
- `POST /api/v10/content/posts/:id/bookmark`
- `DELETE /api/v10/content/posts/:id/bookmark`
- `GET /api/v10/content/bookmarks`
- `GET /api/v10/content/hashtags/:tag`
- `GET /api/v10/content/trending`

## Feeds and discovery

- `GET /api/v10/feed/home`
- `GET /api/v10/feed/following`
- `GET /api/v10/feed/explore`
- `GET /api/v10/feed/media`
- `GET /api/v10/search?q=...`
- `GET /api/v10/search/users?q=...`
- `GET /api/v10/search/posts?q=...`
- `GET /api/v10/search/hashtags?q=...`

Feed responses use opaque cursors. Offset pagination is forbidden for high-volume timelines.

## Stories

- `POST /api/v10/stories`
- `GET /api/v10/stories`
- `GET /api/v10/stories/:id`
- `DELETE /api/v10/stories/:id`
- `POST /api/v10/stories/:id/view`
- `GET /api/v10/stories/:id/viewers`

## Notifications

- `GET /api/v10/notifications`
- `GET /api/v10/notifications/unread-count`
- `POST /api/v10/notifications/:id/read`
- `POST /api/v10/notifications/read-all`
- `GET /api/v10/notifications/preferences`
- `PUT /api/v10/notifications/preferences`
- `POST /api/v10/notifications/devices`
- `DELETE /api/v10/notifications/devices/:id`

## Messaging

- `GET /api/v10/messaging/rooms`
- `POST /api/v10/messaging/rooms`
- `POST /api/v10/messaging/rooms/group`
- `GET /api/v10/messaging/rooms/:id/history`
- `POST /api/v10/messaging/rooms/:id/messages`
- `PUT /api/v10/messaging/messages/:id`
- `DELETE /api/v10/messaging/messages/:id`
- `POST /api/v10/messaging/messages/:id/react`
- `POST /api/v10/messaging/rooms/:id/read`

Message mutations must verify room membership, sender ownership and moderation state. Conversation ordering is server-defined.

## Moderation

- `POST /api/v10/moderation/reports`
- `GET /api/v10/moderation/reports/me`
- `POST /api/v10/moderation/appeals`
- Admin/moderator-only queues provide case assignment, action history and immutable audit records.

## Media

- `POST /api/v10/media/upload-url`
- `POST /api/v10/media/complete`
- `GET /api/v10/media/:id`
- `DELETE /api/v10/media/:id`

Media uploads must be scoped, size-limited, content-sniffed, malware-scanned and processed before public delivery.

## Realtime

WebSocket channels:

- `user:{user_id}` — notifications, presence and account events.
- `room:{room_id}` — message events.
- `feed:{user_id}` — feed invalidation and high-confidence realtime updates.
- `story:{story_id}` — story/viewer updates when enabled.

Every event contains `event_id`, `type`, `schema_version`, `occurred_at`, `aggregate_id`, `aggregate_version` and `payload`.
