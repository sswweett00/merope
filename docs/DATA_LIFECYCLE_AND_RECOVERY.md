# Merope Data Lifecycle & Recovery

## Source of truth

PostgreSQL is the canonical source for account, social graph, content, messaging metadata, moderation and notification state. Redis, NATS consumers, search projections, analytics tables and Scylla projections are rebuildable or disposable.

## Retention

- Audit records: retain according to the deployment compliance policy and protect from application-level deletion.
- Outbox records: retain long enough to replay the longest supported consumer recovery window, then archive or delete after publication and verification.
- Consumed event records: retain for the replay protection window; cleanup must not run while an old consumer can legitimately replay events.
- Notifications and feed feedback: retain according to product policy; avoid indefinite accumulation of low-value interaction telemetry.
- Media: quarantine objects are short-lived and derivatives remain only while referenced by canonical content.

## Account deletion

Account deletion is a server transaction followed by durable domain events. The deletion workflow must revoke sessions, deactivate devices, remove private graph edges, redact or tombstone user-generated records according to product/legal policy, and enqueue downstream cleanup. Destructive work must be idempotent and resumable.

## Backups

Use automated PostgreSQL backups with point-in-time recovery. A backup is not considered production-ready until restoration has been exercised against an isolated environment and application-level integrity checks pass.

Recommended operational targets:

- RPO: <= 15 minutes for the primary transactional database.
- RTO: <= 60 minutes for a full-region database recovery.
- Restore verification: at least monthly and after major storage or schema changes.

## Migration safety

Schema migrations must be forward-compatible with the currently deployed application. Prefer additive changes first, dual-read/dual-write transitions where necessary, and destructive cleanup only after all readers and workers have moved to the new contract.

## Incident recovery

1. Stabilize writes if corruption is still propagating.
2. Identify the last known-good transaction/event boundary.
3. Restore or replay the canonical state.
4. Rebuild disposable projections from PostgreSQL/outbox history.
5. Verify authentication, social graph, feeds, messaging and moderation invariants.
6. Resume traffic gradually and watch error rate, queue depth and database saturation.
