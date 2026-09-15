# Production Operations Runbook

## Release gate

A release is eligible only when backend build, lint, vet, tests, race tests, Flutter analysis/tests, migrations, and rollback notes are all green.

## Dependency policy

PostgreSQL is the canonical write store. Redis is a disposable acceleration layer. NATS/JetStream transports durable domain events and must not become the source of truth. ScyllaDB and ClickHouse are projections and must be rebuildable.

## Startup checks

1. Validate required environment variables.
2. Establish PostgreSQL connectivity and verify migration level.
3. Validate required NATS/Redis connectivity for enabled features.
4. Start HTTP and websocket listeners only after required dependencies pass.
5. Expose liveness independently from readiness.

## Failure handling

Database unavailable: fail readiness and stop accepting traffic for mutations.

Redis unavailable: continue on canonical paths where possible and disable only cache-dependent optimizations.

Event broker unavailable: accept a mutation only when its database transaction and outbox write succeed; replay the outbox after broker recovery.

Projection unavailable: keep the canonical transaction path healthy and mark the projection degraded instead of reporting global health as green.

Poison event: retry with bounded exponential backoff, preserve the event, and move it to an operator-visible dead-letter state after the configured attempt budget.

## Operational signals

Monitor request rate, p50/p95/p99 latency, 4xx/5xx rate, websocket disconnects, database pool saturation, slow queries, Redis errors, outbox lag, consumer lag, notification delivery failures, moderation backlog, feed cache hit ratio, and media-processing queue depth.

## Data maintenance

Expired idempotency keys, old consumed-event records, stale device registrations, expired stories, notification history, and old audit records require retention policies. Cleanup must be batched and rate-limited so maintenance cannot starve foreground traffic.

Partitioned content and message tables require future partition creation before the current partition closes. Partition creation is an operational calendar item, not an afterthought.

## Incident procedure

Preserve request IDs and event IDs from the first alert. Confirm whether the failure is canonical-state, eventing, projection, or edge related. Prefer disabling optional projections over weakening transactional guarantees. After recovery, replay outbox events and verify consumer dedupe before re-enabling traffic gradually.
