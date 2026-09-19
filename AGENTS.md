# Merope — Agent Knowledge

## Project Overview
High-Performance, Modular, Server-Authoritative Real-Time Communication Platform.
Status: **Production Hardening**

## Technology Stack

### Frontend
Developed exclusively with **Flutter**.
- **Core**: Flutter (Stable), Dart, Material 3, Impeller Rendering Engine
- **State & Navigation**: Riverpod, GoRouter, Freezed
- **Storage**: Drift (SQLite) for non-authoritative local cache/state, flutter_secure_storage
- **Networking**: Dio, WebSocket, gRPC
- **Media & RTC**: flutter_webrtc, media_kit
- **Performance**: Isolate, Custom Render Objects (as needed)
- **Goals**: 60–120 FPS, minimum RAM usage, instant startup, low battery consumption, zero-lag large lists, fluid media rendering.

### Backend
Developed exclusively with **Go**.
- **Core**: Go, Fiber
- **Persistence**: PostgreSQL, Redis, MinIO (S3-compatible)
- **Messaging**: NATS JetStream
- **Processing**: FFmpeg, WebRTC, Elasticsearch (optional)
- **Transport**: gRPC, WebSocket
- **Goals**: Ultra-low latency, minimum RAM usage, maximum parallelism, lock-free data structures where possible, Worker Pool architecture, Event-Driven Architecture, Zero-Copy approach, Streaming-based processing.

## Software Architecture
Designed for massive scale (billions of contents, hundreds of millions of users). Scalable from a single server to horizontal clusters without major code refactors.

### Core Principles
- Clean Architecture & SOLID
- Feature First & Domain Driven Design (DDD)
- Event Driven Design & Streaming Architecture
- Repository Pattern & Service Layer
- CQRS (where appropriate)
- Dependency Injection (Manual in Go, Riverpod in Flutter)
- Immutable Data & Stateless API design
- Backpressure support

## Performance Goals

### Capacity
- **Users**: 500M+ registered, 100M+ DAU, 10M+ concurrent.
- **Content**: Billions of posts, comments, messages, photos, videos, and live recordings.
- **Real-time**: Millions of active WebSocket connections, low-latency messaging, real-time notifications, and state synchronization.

## Code Quality Standards
- Readable, modular, testable, independent, reusable, and extensible.
- Strict decoupling: No module should be tightly coupled to another.

## Flutter Performance Rules
Each screen must implement:
- Lazy Loading & Infinite Scroll
- Virtual Scrolling & Widget Reuse/Caching
- Automatic Image Cache & Video Prefetch
- Pagination & Incremental Rendering
- Skeleton Loading & Deferred Loading
- Memory Pooling
- Isolate-based heavy processing
- Minimum Rebuilds (Const widgets, RepaintBoundary, RenderObject optimizations)

## Go Performance Rules
- Goroutine, Worker, Object, Buffer, and Connection Pooling
- Lock-Free Queues (where appropriate)
- Zero Allocation targets
- Streaming JSON & Batch/Incremental Processing
- Context Cancellation & Timeout Management
- Backpressure, Rate Limiting, and Adaptive Queues
- Circuit Breaker & Graceful Shutdown/Restart

## Database Design
- Optimized for high read/write volume and low latency at scale.
- **Strategies**: Composite/Partial/Covering Indexes, Partitioning, Sharding-ready schemas, Read Replicas, Cache-first reading, controlled denormalization.

## Media System
Supports Photo, Video, Live Stream, Audio, GIF, and generic Files.
- **Features**: Adaptive quality, stream-based loading, multi-resolution, fast previews/thumbnails, and low bandwidth usage.

## Key Paths
- `lib/` — Flutter app source
- `lib/app/` — App-level widgets and router config
- `lib/core/` — Auth, security, sync, theme, media, plugins
- `lib/features/` — Feature modules (auth, messages, social, video, etc.)
- `lib/shared/` — Design system widgets and utilities
- `backend/` — Go HTTP/WebSocket API service
- `backend/cmd/api/` — Entry point
- `backend/internal/modules/` — Domain modules (identity, social, content, etc.)
- `backend/internal/platform/` — Infrastructure (Postgres, NATS, S3, ClickHouse)
- `backend/proto/` — Protobuf definitions

## Dependency Injection Pattern
- **Go**: Manual DI via constructor parameters (service → repo → db).
- **Flutter**: Riverpod providers, code-generated with `riverpod_generator`.

## Code Generation
- **Flutter**: `dart run build_runner build`
- **Go**: `go generate ./...` and `sqlc generate` for DB queries

## Environment Configuration
- **Backend**: `.env.example` in `backend/` for template.
- **Flutter**: Platform channels for env vars; use `String.fromEnvironment()` for compile-time config.

## Running

### Backend
```bash
cd backend
cp .env.example .env
go run ./cmd/api/main.go
```

### Frontend
```bash
flutter pub get
flutter run
```

## Known Issues / Notes
- `go 1.25.0` is the standard for backend.
- AI features have been removed for a clean communication experience.
- The server is authoritative: clients must not implement offline write-behind or deferred mutation replay.
- All modules are fully integrated with services and transport layers.
