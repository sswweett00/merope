# Merope Security Threat Model

## Trust boundaries

- Client devices are untrusted and may be modified.
- Public HTTP/WebSocket inputs are hostile by default.
- PostgreSQL is trusted canonical state.
- Redis is treated as disposable acceleration state.
- NATS transports durable domain events but does not become the business source of truth.
- Object storage is treated as untrusted until uploaded media passes validation.

## High-risk abuse cases

### Credential attacks

Use strong password verification, login throttling, session revocation, refresh-token rotation and MFA support. Never expose credential or token material through logs or API errors.

### Authorization bypass

Every mutation must authorize the target resource at the domain layer. Route-level authentication alone is insufficient. Block, privacy and moderation state must be included in authorization decisions.

### Replay and duplicate mutation

Create, reaction, follow, bookmark, message and payment-like mutations must use idempotency semantics where duplicate delivery is possible. Reusing an idempotency key with a different request fingerprint must be rejected.

### Event replay

Consumers must persist processed event identifiers and make handlers idempotent. Event schemas require explicit versions so consumers can reject unsupported payloads safely.

### Media attacks

Do not trust file extensions or client MIME types. Validate content signatures, size, declared type and processing limits before exposing media publicly. Keep uploads quarantined until scanning and derivative generation complete.

### Enumeration

Profile, username, email, recovery and invitation endpoints must apply rate limits and avoid unnecessarily precise error messages that reveal whether an account exists.

### Abuse at scale

Rate limiting should combine principal-level controls with route-sensitive limits. Expensive operations such as feed generation, search, media processing, login and messaging need separate budgets.

## Security invariants

- Server time and IDs are authoritative.
- Clients cannot advance aggregate versions or moderation state.
- Internal dependency failures are not returned as raw stack traces.
- Audit records are append-oriented and access controlled.
- Sensitive configuration comes from the deployment secret store, not source control.
