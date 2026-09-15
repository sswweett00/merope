# Security Architecture

## Trust boundaries

The mobile/web client is untrusted. All authorization decisions, ownership checks, visibility rules, rate limits, timestamps, IDs, and mutation ordering are server authoritative.

PostgreSQL is the canonical state boundary. Redis and event projections cannot grant permissions that PostgreSQL does not authorize.

## Authentication

Access tokens are short-lived. Refresh sessions are revocable and bound to server-side session state. Logout and suspicious-session handling must invalidate refresh capability before relying on client state.

## Authorization

Authorization follows `actor -> action -> target -> policy`. A valid JWT alone is never sufficient for object access. Privacy, block, mute, restrict, tenant, room membership, and moderation state are evaluated before returning protected objects.

## Mutation safety

High-value mutations accept an idempotency key. The server binds the key to the authenticated actor, route and canonical request hash. A reused key with a different payload is rejected rather than silently creating a second operation.

## Input and output safety

Validate request size and collection depth before decoding expensive payloads. Treat user content as untrusted HTML/text/media metadata. Storage errors, SQL details, stack traces, provider responses, and internal identifiers must never be exposed in public API errors.

## Event safety

Every domain event has a stable event ID and schema version. Consumers record processed IDs before acknowledging irreversible work. Event payloads must not contain secrets, access tokens, raw passwords, or provider credentials.

## Abuse controls

Rate limits should be evaluated at more than one dimension: account, IP, device/session, route, and behavioral risk class. Repeated failures should increase friction without permanently locking legitimate traffic based on one weak signal.

## Media security

Uploads enter quarantine first. Validate declared MIME against detected content, enforce byte limits, reject executable content where unsupported, scan before publication, and generate derivatives from the quarantined object rather than trusting a client-provided filename or content type.

## Auditability

Security-sensitive actions such as login, session creation/revocation, permission changes, moderation actions, recovery, device registration, API key changes, and suspicious activity must produce structured audit events with request IDs and actor context.
