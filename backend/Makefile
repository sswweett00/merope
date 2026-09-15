docker:
	docker compose -f ../docker-compose.full.yml up -d --build

k6-bench:
	cd backend/internal/o11y/loadtest/k6 && k6 run k6_loadtest.js

protocol-tests:
	cd backend && grpcurl -plaintext localhost:8080 list
