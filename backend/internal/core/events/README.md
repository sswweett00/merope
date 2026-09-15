# Event Reliability

The social platform uses PostgreSQL as the canonical source of truth. Durable domain events are stored in `outbox_events` and consumers deduplicate through `consumed_events`.

Publishers must tolerate retries, process only claimable records, and keep event payloads versioned. Consumers must be idempotent and safe to replay.
