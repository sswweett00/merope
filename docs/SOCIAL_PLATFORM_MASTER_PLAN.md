# Merope Social Platform — Master Product & Engineering Plan

Merope is a server-authoritative social platform. The product target is a complete social graph + media + realtime + creator + messaging + safety + discovery stack with PostgreSQL as transactional truth, NATS for durable events, Redis for disposable state, ClickHouse for analytics, and object storage for media.

## Product surface

### Identity and profiles
- Signup, login, refresh rotation, logout, MFA, recovery and session/device management.
- Public/private accounts, verified profiles, profile links, pronouns, bio, avatar, banner, profile tabs.
- Username history, handle reservation, impersonation protection and account deletion/export.
- Privacy controls for discoverability, mentions, tags, DMs, activity status and read receipts.

### Social graph
- Follow, follow requests, unfollow, block, unblock, mute and restrict.
- Mutuals, close-friends/circles, suggested accounts and relationship state.
- Graph events emitted transactionally to the outbox for fan-out, recommendations and notifications.

### Publishing
- Text, image, video, audio, document and link posts.
- Threads/replies, quote posts, reposts, polls, mentions, hashtags, location and content warnings.
- Drafts, scheduled posts, expiration, pinning, editing and deletion/tombstoning.
- Audience controls: public, followers, circle, mentioned users and private.
- Media preprocessing, thumbnails, transcoding, metadata extraction and signed delivery URLs.

### Engagement
- Reactions with configurable reaction types.
- Likes, comments, threaded replies, reposts, quotes, bookmarks, collections and share tracking.
- Server-side counters with eventual analytics projections and exact transactional mutation semantics.
- Idempotent mutations to prevent double likes, double votes and duplicate posts.

### Feeds and discovery
- Home feed, following feed, profile feed, hashtag feed, topic feed and media feed.
- Candidate generation from follows, graph proximity, engagement and trends.
- Ranking pipeline with freshness, relationship affinity, quality, diversity, safety and negative feedback penalties.
- Cursor pagination; no client-side write queue or conflict resolution.
- Explore, trending topics, suggested users, suggested communities and search.

### Stories and short-form media
- 24-hour stories with media, text, polls, stickers, links and viewer lists.
- Story privacy and per-story audience overrides.
- Reels/short video feed with autoplay-safe delivery, moderation states and engagement analytics.

### Communities
- Communities/groups, roles, moderators, membership requests, channels, rules, announcements and pinned content.
- Community discovery, invitations, moderation queues and member sanctions.

### Messaging
- Direct and group conversations, attachments, replies, reactions, edits, deletes, read markers and typing/presence.
- E2EE key distribution primitives already present in the repository; production rollout must include audited client crypto and key rotation.
- Server-authoritative history with per-conversation ordering and idempotent send keys.
- Durable event -> realtime fan-out -> client refresh architecture.

### Notifications
- In-app notification center with unread counts and batching.
- Push notification abstraction for APNs/FCM.
- Notification preferences, quiet hours, mention priority and digest settings.

### Creator and business features
- Professional profiles, creator analytics, audience insights and content performance.
- Subscriptions, tips, paid content/boosts where legally applicable.
- Moderation roles, branded pages, API applications and webhooks.

### Safety and trust
- Report, block, mute, restrict, appeal and moderation cases.
- Content safety pipeline: text/media classification, spam/bot signals, rate limits and risk scoring.
- Human-review queues with evidence snapshots, immutable decision history and moderator audit logs.
- Anti-abuse controls for follows, reactions, comments, DMs and account creation.

## Backend architecture

1. HTTP handlers validate transport input and authentication.
2. Domain services enforce business invariants and resource authorization.
3. PostgreSQL transaction writes canonical state plus an outbox event in the same transaction.
4. NATS JetStream distributes durable domain events.
5. Workers fan out notifications, projections, analytics and high-throughput read models.
6. Redis stores sessions, rate limits, cache and short-lived coordination only.
7. ClickHouse receives immutable analytics events asynchronously.
8. ScyllaDB, if enabled by measured workload, is a projection/read-optimized store with explicit ownership and rebuild procedures.

## Consistency rules

- Server timestamp and server-generated IDs are canonical.
- Per-conversation ordering is monotonic and authoritative.
- Mutations accept an `Idempotency-Key` for retryable operations.
- A duplicate idempotency key must return the original semantic result, not execute the mutation twice.
- Events contain a unique event ID, aggregate ID, aggregate version, occurred-at timestamp and schema version.
- Consumers record processed event IDs and are safe to retry.
- Read models can be rebuilt from canonical Postgres state and/or durable event history.

## Feed ranking model

Each candidate receives a normalized score from:
- relationship affinity;
- freshness decay;
- predicted engagement;
- author quality and follow strength;
- content quality and diversity;
- topic affinity;
- negative feedback;
- safety/risk penalties;
- repeated-content and creator-frequency penalties.

The ranking service must expose reason codes for observability and experimentation. Ranking configuration is versioned so a feed can be reproduced for debugging.

## Search

- PostgreSQL full-text search for baseline user/content search.
- Trigram indexes for typo tolerance.
- Hashtag and mention search.
- Optional external search engine can be introduced only when measurements show PostgreSQL is insufficient.
- Search results respect privacy, blocks, moderation state and tenancy.

## Media pipeline

Upload flow:
1. Client requests a scoped upload URL.
2. Object lands in a quarantine namespace.
3. Worker validates MIME, size and content signature.
4. Malware/safety analysis runs.
5. Image/video/audio derivatives are generated.
6. Canonical media metadata is committed.
7. Delivery URLs are signed and time-limited.

Never trust extension or client-declared MIME type as the security boundary.

## Notification pipeline

Domain event -> preference filter -> deduplication/batching -> channel fan-out -> delivery receipt. Push delivery is best effort; notification state is persisted and queryable from the API.

## Moderation workflow

Report -> triage -> automated signals -> moderator decision -> enforcement -> appeal -> final audit. Every state transition is immutable and attributable.

## Reliability targets

- API availability: 99.9% target for the initial production tier.
- p95 authenticated read latency: <250 ms under expected load.
- p95 mutation latency excluding media processing: <350 ms.
- Realtime fan-out p95: <500 ms under normal load.
- No acknowledged mutation is lost after transactional commit.
- Notification and analytics processing are asynchronous and replayable.

## Delivery phases

### Phase A — Core correctness
Authentication, authorization, social graph, post lifecycle, comments, reactions, bookmarks, idempotency, transactional outbox, notification persistence and moderation primitives.

### Phase B — Realtime
WebSocket protocol, per-conversation ordering, presence, typing indicators, durable event consumers, reconnect semantics and delivery metrics.

### Phase C — Discovery
Home/feed ranking, explore, hashtags, search, suggested users, trending topics and feedback-aware ranking.

### Phase D — Media and creator stack
Signed uploads, media processing, stories, short video, creator analytics, professional profiles and monetization primitives.

### Phase E — Scale and operations
Read projections, ClickHouse dashboards, load testing, autoscaling, connection draining, disaster recovery, backup verification and security review.

## Definition of done

A feature is complete only when it has:
- domain invariant checks;
- resource-level authorization;
- idempotent mutation semantics where retry is possible;
- migration/query coverage;
- unit and integration tests;
- observability metrics/logs/traces;
- failure-mode handling;
- API contract documentation;
- Flutter state and error handling;
- accessibility and localization considerations;
- moderation/privacy implications reviewed.
