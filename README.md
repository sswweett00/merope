# Merope

High-Performance, Modular, Offline-First Real-Time Communication Platform.

## Prerequisites

- Flutter SDK (>=3.2.0 <4.0.0)
- Dart SDK (>=3.2.0)
- Go (>=1.21)
- Docker & Docker Compose
- Android Studio / Xcode (for mobile builds)

## Project Structure

- `lib/` — Flutter mobile/desktop application
- `backend/` — Go HTTP/WebSocket API service
- `proto/` — Protobuf definitions for gRPC

## Getting Started

### Backend

```bash
cd backend
cp .env.example .env  # create your environment variables
go mod tidy
go run ./cmd/api/main.go
```

### Frontend

```bash
flutter pub get
flutter run
```

## Running with Docker

```bash
docker-compose up -d
```

This starts Postgres, Redis, NATS, MinIO, ClickHouse, Traefik, and the API.

## Architecture

- **Frontend**: Flutter + Riverpod + GoRouter + Drift (offline-first)
- **Backend**: Go + Fiber + gRPC + WebSocket
- **Database**: PostgreSQL (primary), ClickHouse (analytics)
- **Storage**: MinIO (S3-compatible)
- **Messaging**: NATS JetStream
- **Cache**: Redis
