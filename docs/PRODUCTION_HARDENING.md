# Merope Production Hardening Plan

## Target state

Merope is a server-authoritative realtime communication platform. The backend is the source of truth for all durable state and the client never performs offline-first write-behind synchronization.

## 1. Repository and build hygiene

- Keep generated caches, local build output and large binary artifacts out of Git.
- Keep reproducible dependency lockfiles where supported.
- Pin CI toolchains and cache only package-manager artifacts.
- Run formatting, static analysis, tests and build checks on every main change.

## 2. Backend reliability

- PostgreSQL remains the transactional source of truth.
- Redis is disposable state only.
- NATS JetStream carries durable asynchronous events and realtime fan-out.
- Every critical event has an idempotency key and a deterministic consumer identity.
- Workers expose retry, backoff and dead-letter behavior.
- Startup fails when mandatory dependencies cannot initialize.
- Readiness fails when mandatory dependencies become unavailable.
- Graceful shutdown drains HTTP, realtime and messaging workloads before closing infrastructure clients.

## 3. Authentication and authorization

- Access JWTs are short-lived.
- Refresh tokens are revocable server-side state and must rotate on use.
- JWT signing configuration is validated at startup.
- Do not use client-provided HMAC secrets as proof of device identity.
- Device binding, when required, must use a registered public/private key pair or a platform attestation primitive.
- Authorization is resource-scoped: authenticated is not equivalent to authorized.
- Message, room, post, comment and profile mutations verify ownership/membership before mutation.
- API keys are random, hashed at rest, scoped, expiring and revocable.

## 4. Realtime and messaging correctness

- Assign a server message ID, conversation sequence and created-at timestamp transactionally.
- Persist the message before publishing the durable event.
- Publish an outbox event in the same PostgreSQL transaction.
- Consume events idempotently.
- WebSocket delivery is best-effort fan-out; clients can re-read authoritative history from the API.
- Ordering is defined per conversation, not globally.
- Duplicate sends must be collapsed through a client-supplied idempotency key.

## 5. Client architecture

- Network/API state is authoritative.
- Local storage is limited to non-authoritative presentation/cache data and secure credentials.
- No background operation queue, replay queue or conflict resolver exists on the client.
- Network errors are explicit UI states.
- Mutations transition UI state only after server acknowledgement.
- WebSocket events update active views, but canonical state is refreshed through the server API when required.

## 6. Data architecture

- PostgreSQL owns transactional truth.
- ScyllaDB is used only for measured high-throughput projections/workloads with explicit ownership boundaries.
- Redis data must be reconstructable.
- ClickHouse receives analytics asynchronously and is never used for transactional authorization.
- Object storage access uses scoped credentials and signed URLs.

## 7. Security controls

- TLS-only production traffic.
- Strict CORS allow-list.
- Security headers.
- Request body and upload size limits.
- Per-IP, per-user and per-account rate limits for authentication and abuse-sensitive endpoints.
- Constant-time secret comparisons where applicable.
- Structured audit events for authentication, authorization failures, account changes and administrative actions.
- No SQL string sanitization helpers; parameterized queries only.
- No internal error details in 5xx API responses.
- Secrets are provided only through the runtime secret store/environment and never committed.

## 8. Observability

- Structured JSON logs with request ID and trace ID.
- OpenTelemetry traces around HTTP, PostgreSQL, Redis, NATS and external storage.
- Prometheus metrics for request latency, errors, active WebSockets, queue depth, consumer lag, DB pool saturation and rate-limit rejects.
- Alerts for readiness failures, sustained 5xx rate, queue growth, NATS disconnects and PostgreSQL saturation.

## 9. Testing gates

### Unit

- Auth/JWT and refresh token rotation.
- Permission checks.
- Rate limiting.
- Message ordering and idempotency.
- Repository query behavior.

### Integration

- PostgreSQL migrations and transaction boundaries.
- Redis sessions/blacklists/rate limits.
- NATS streams and idempotent consumers.
- Object storage uploads and signed URLs.

### End-to-end

- Register/login/refresh/logout.
- Create room -> send -> receive over WebSocket.
- Duplicate send with the same idempotency key.
- Unauthorized room/message mutations.
- Dependency outage/readiness behavior.

### Load

- HTTP API p95/p99 latency.
- WebSocket concurrent sessions.
- Messages/sec per conversation and globally.
- Consumer lag and recovery after broker restart.

## 10. Deployment

- Multi-stage, non-root containers.
- Immutable image tags.
- Readiness/liveness probes.
- Rolling deployment with connection draining.
- Backward-compatible database migrations.
- Automated rollback on failed health checks.
- Backups with restore drills.
- Disaster recovery runbook with defined RPO/RTO.

## Definition of production-ready

A release is production-ready when CI is green, integration and end-to-end tests pass, migrations are reversible or forward-safe, secrets are externalized, readiness probes are meaningful, core security controls are enforced, critical paths are observable, and the system has been load-tested against its expected traffic profile.
