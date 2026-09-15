# Production Improvement Backlog

This backlog turns the social-platform architecture into a staged implementation program. Priority is correctness first, then scale, then product breadth.

## P0 — correctness and reliability

- Transactional outbox publisher with retry, lease ownership, backoff, and dead-letter handling.
- Durable idempotency for every externally visible mutation using method/path/actor/body hashing.
- Event-consumer deduplication using `consumed_events` and bounded retention.
- Transactional block semantics: remove active graph edges and enforce a deny edge atomically.
- Cursor-only pagination for high-volume feeds, comments, notifications, and messages.
- Request IDs propagated through HTTP logs, database work, event envelopes, and websocket sessions.
- Strong server-side validation limits for body size, attachment count, text size, and collection depth.
- Consistent internal error mapping so storage and upstream details never reach clients.

## P1 — social product depth

- Follow requests and privacy-aware graph reads.
- Mute, restrict, block, close-friends/circle audiences, and per-content visibility checks.
- Posts, replies, quote posts, reposts, polls, mentions, hashtags, bookmarks, collections, drafts, scheduling, expiration, and edit history.
- Stories with viewer privacy, expiry, reactions, and read receipts.
- Real-time rooms with ordering, typing, presence, reconnect cursors, and replay safety.
- Notification fanout with preferences, quiet hours, unread counters, device registration, and provider abstraction.
- Media upload quarantine, MIME/content verification, derivative generation, signed delivery URLs, and lifecycle cleanup.

## P1 — discovery and ranking

- Candidate generation from follows, topic affinity, trending content, profile affinity, and controlled exploration.
- Versioned ranking configuration with deterministic tie-breaking.
- Negative-feedback features for hide, mute, block, report, and “not interested”.
- Diversity controls for author, topic, media type, and repeated-content suppression.
- Search using PostgreSQL FTS/trigram first, with a replaceable external index boundary for future scale.

## P2 — trust, safety, and governance

- Report queues, moderation actions, appeals, reviewer roles, audit trails, and policy-version tracking.
- Spam/risk scoring and rate limits by account, route, device, IP, and behavior class.
- Content safety states that can be applied independently of content lifecycle state.
- Account/session/device management, suspicious-login events, and recovery controls.

## P2 — operations and performance

- OpenTelemetry traces around database, Redis, NATS, S3, and external providers.
- Prometheus metrics for request latency, error rate, queue depth, event lag, feed cache hit rate, notification delivery, and moderation throughput.
- Readiness checks that reflect required dependencies while allowing explicitly optional projections to degrade.
- Background worker supervision with graceful shutdown, bounded concurrency, jittered retries, and poison-message isolation.
- Load and soak tests for feed reads, message sends, notifications, and event processing.
- PostgreSQL index review, partition maintenance, vacuum/analyze policy, connection-pool sizing, and slow-query capture.

## Definition of done

A feature is production-ready only when its API contract, authorization rules, persistence semantics, idempotency behavior, failure mode, observability, migration, tests, and rollback path are defined together.
