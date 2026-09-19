# Merope

High-performance, server-authoritative, real-time communication platform.

Merope is designed for production workloads where the server is the source of truth. The client does not implement offline-first synchronization or local write-behind replication. Network failures are surfaced explicitly and writes are accepted only when the authoritative backend confirms them.

## Stack

- **Client:** Flutter + Riverpod + GoRouter
- **Transport:** HTTPS/REST + WebSocket + gRPC where appropriate
- **Backend:** Go + Fiber
- **Primary data:** PostgreSQL
- **High-throughput workloads:** ScyllaDB where measured workload justifies it
- **Realtime/eventing:** NATS JetStream
- **Cache/session/rate limiting:** Redis
- **Analytics:** ClickHouse
- **Object storage:** MinIO / S3-compatible storage
- **Observability:** OpenTelemetry + Prometheus + structured logging
- **Authorization:** JWT + RBAC/Casbin

## Production principles

1. PostgreSQL is the authoritative transactional store.
2. NATS is used for durable asynchronous events and realtime fan-out; it is not a source of truth.
3. Redis is disposable state only: cache, rate limits, sessions, and short-lived coordination data.
4. ScyllaDB is an optional projection/high-throughput store and must never silently diverge from the primary data model.
5. Clients do not queue writes for later replay. Failed writes return an explicit error and must be retried by the UI/service layer only after the server is available.
6. Every mutating API must be idempotent where duplicate delivery is possible.
7. Internal infrastructure failures are never leaked through API error bodies.

## Repository layout

- `lib/` — Flutter application
- `packages/` — reusable Flutter packages
- `backend/` — Go API, realtime, workers and persistence
- `deploy/` — deployment/runtime configuration
- `proto/` — protobuf contracts

## Backend startup

```bash
cd backend
cp .env.example .env
go mod download
go run ./cmd/api
```

Required production configuration includes `DATABASE_URL`, `JWT_SECRET`, object-storage credentials and the public CORS origin allow-list.

## Frontend startup

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Local infrastructure

```bash
docker compose -f docker-compose.full.yml up -d
```

The local stack provides PostgreSQL, Redis, NATS, MinIO, ClickHouse and the API.

## Operational checks

Use `/health/live` for process liveness and `/health/ready` for dependency readiness. Readiness must fail when mandatory dependencies are unavailable.

## Security

- TLS is mandatory in production.
- JWT access tokens are short-lived and revocable.
- Refresh tokens are server-side state, not self-contained authorization.
- Passwords are hashed with a memory-hard password hashing algorithm.
- Resource-level authorization is required in addition to authentication.
- API keys must be cryptographically random, hashed at rest, scoped and revocable.
- Client-side anti-debug/emulator checks are treated only as defense-in-depth, never as authentication.

## Testing and CI

CI runs Dart analysis/format/tests and Go lint/vet/build/tests, including Go race detection. Security and production-gate workflows also run on pushes to `main`. Production changes should add integration coverage for PostgreSQL, Redis, NATS and the critical realtime/auth flows.
