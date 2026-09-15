# Merope Professional Suite Implementation Plan

This plan introduces a series of advanced, production-ready features to the Merope platform, enhancing its scalability, security, and offline-first capabilities.

## User Review Required

> [!IMPORTANT]
> Some features (like Biometric Lock) require the `local_auth` package to be correctly configured for Android/iOS permissions. I will handle the Dart implementation, but platform-specific manifest changes might be needed if not already present.

## Proposed Changes

### 1. Go Backend: Distributed Sliding-Window Rate Limiter
Implement a Redis-backed rate limiter that prevents bursts at window boundaries using Lua scripts for atomicity.

#### [MODIFY] [rate_limit_redis.go](file:///home/kaan/StudioProjects/merope/backend/internal/core/middleware/rate_limit_redis.go)
- Implement a Lua script for the sliding window algorithm.
- Add support for tiered limits based on user role (Guest vs. Verified).

---

### 2. Go Backend: Graceful Orchestrator & Signal Handling
Upgrade the server lifecycle to ensure zero-downtime deployments and safe state persistence.

#### [MODIFY] [main.go](file:///home/kaan/StudioProjects/merope/backend/cmd/api/main.go)
- Implement a coordinated shutdown that drains WebSocket connections and waits for background workers to finish critical IO tasks.

---

### 3. Flutter: The "Chronos" Sync Engine
A repository-level background service that processes the `OperationLogs` table to sync local changes to the cloud.

#### [NEW] [sync_service.dart](file:///home/kaan/StudioProjects/merope/lib/core/data/sync_service.dart)
- Background processing of unsynced operations.
- Exponential backoff and connectivity awareness.

#### [MODIFY] [message_repository.dart](file:///home/kaan/StudioProjects/merope/lib/features/messages/repository/message_repository.dart)
- Update methods to write to `OperationLogs` alongside local data updates.

---

### 4. Flutter: Biometric Security Fabric
A professional-grade app lock system that protects the entire app or specific features (like the Vault).

#### [MODIFY] [biometric_provider.dart](file:///home/kaan/StudioProjects/merope/lib/core/security/biometric_provider.dart)
- Integrate `local_auth` for real biometric verification (FaceID/Fingerprint).
- Add "Auto-lock on background" logic.

---

### 5. Media: Adaptive Image Loading & BlurHash
Improve perceived performance by using BlurHash placeholders and adaptive quality.

#### [MODIFY] [pubspec.yaml](file:///home/kaan/StudioProjects/merope/pubspec.yaml)
- Add `flutter_blurhash` dependency.

#### [MODIFY] [merope_ui package] (Simulation)
- Update image widgets to support BlurHash strings received from the API.

---

### 6. Messaging: Read Receipts & Persistence
Full lifecycle for message states: Pending -> Sent -> Delivered -> Read.

#### [MODIFY] [messaging_service.go](file:///home/kaan/StudioProjects/merope/backend/internal/modules/messaging/service/messaging_service.go)
- Add delivery and read receipt processing via NATS events.

## Verification Plan

### Automated Tests
- **Go Benchmarks**: Test the Lua-based rate limiter under high contention.
- **Dart Tests**: Unit tests for the Sync Engine's retry logic.

### Manual Verification
- Verify that biometric lock triggers correctly when the app is backgrounded.
- Check that "Sent" icons update to "Delivered/Read" in the messaging UI.
- Test offline messaging by disabling network and observing `OperationLogs` being processed once reconnected.
