.PHONY: help dev docker-build docker-up docker-down docker-clean test lint proto codegen migrate init-db clean

help:
	@echo "Merope — Development Commands"
	@echo ""
	@echo "  make dev         Start full local dev environment (Docker + API)"
	@echo "  make docker-up   Start all Docker services"
	@echo "  make docker-down Stop Docker services"
	@echo "  make docker-logs View Docker logs"
	@echo "  make docker-clean Remove Docker volumes"
	@echo "  make init-db     Initialize databases (run after docker-up)"
	@echo "  make proto       Regenerate protobuf Go bindings"
	@echo "  make codegen     Run all codegen (proto + sqlc)"
	@echo "  make migrate     Apply database migrations"
	@echo "  make test        Run Go tests"
	@echo "  make lint        Lint Go backend code"
	@echo "  make flutter-analyze Run Flutter analysis"
	@echo "  make clean       Clean build artifacts"

dev: docker-up init-db
	@echo "Starting Merope API..."
	cd backend && go run ./cmd/api/main.go

docker-build:
	docker compose -f docker-compose.full.yml build

docker-up:
	docker compose -f docker-compose.full.yml up -d postgres redis nats minio clickhouse scylla elasticsearch
	@echo "Waiting for services..."
	@sleep 5
	@bash scripts/dev-init.sh

docker-down:
	docker compose -f docker-compose.full.yml down

docker-logs:
	docker compose -f docker-compose.full.yml logs -f --tail=100 --tail-follow merope-api

docker-clean:
	docker compose -f docker-compose.full.yml down -v
	docker system prune -f

init-db:
	@bash scripts/dev-init.sh

proto:
	cd backend && protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		proto/*.proto

codegen: proto
	cd backend && sqlc generate

migrate:
	cd backend && goose -dir db/migrations postgres "$$DATABASE_URL" up

test:
	cd backend && go test ./...

lint:
	cd backend && golangci-lint run ./...

flutter-analyze:
	dart analyze
	dart format --set-exit-if-changed .

clean:
	rm -rf backend/build backend/.gocache
	rm -rf build/ .dart_tool/
	rm -rf backend/.scannerwork

build-prod:
	docker compose -f docker-compose.full.yml build
	docker compose -f docker-compose.full.yml push
