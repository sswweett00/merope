#!/bin/bash
set -euo pipefail

SERVICES=("postgres" "redis" "nats" "minio" "clickhouse" "scylla" "elasticsearch")
MAX_WAIT=300
INTERVAL=5

wait_service() {
    local service=$1
    local host=$2
    local port=$3
    local waited=0
    
    echo "Waiting for $service on $host:$port..."
    until [ $waited -ge $MAX_WAIT ]; do
        if nc -z "$host" "$port" >/dev/null 2>&1 || \
           curl -sf "http://$host:$port" >/dev/null 2>&1; then
            echo "$service is ready"
            return 0
        fi
        sleep $INTERVAL
        waited=$((waited + INTERVAL))
    done
    echo "$service did not start in time"
    return 1
}

echo "Starting Merope development environment..."

for svc in "${SERVICES[@]}"; do
    case $svc in
        postgres)  wait_service "$svc" "localhost" 5432 ;;
        redis)     wait_service "$svc" "localhost" 6379 ;;
        nats)      wait_service "$svc" "localhost" 4222 ;;
        minio)     wait_service "$svc" "localhost" 9000 ;;
        clickhouse) wait_service "$svc" "localhost" 8123 ;;
        scylla)    wait_service "$svc" "localhost" 9042 ;;
        elasticsearch) wait_service "$svc" "localhost" 9200 ;;
    esac
done

echo ""
echo "Initializing databases..."

echo "Running PostgreSQL migrations..."
for f in backend/db/migrations/*.sql; do
    [ -e "$f" ] || continue
    echo "Applying: $(basename $f)"
    PGPASSWORD=merope_secure_password psql -h localhost -U merope_user -d merope_db -f "$f" || echo "WARN: Migration failed for $f (may already be applied)"
done

echo "Creating ScyllaDB keyspace..."
cat << 'EOF' | cqlsh localhost 9042 2>/dev/null || true
CREATE KEYSPACE IF NOT EXISTS merope WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};
EOF

echo "Creating ScyllaDB tables..."
for f in backend/internal/platform/scylla/*.cql; do
    [ -e "$f" ] || continue
    echo "Applying: $(basename $f)"
    cqlsh localhost 9042 -f "$f" 2>/dev/null || true
done

echo "Creating ClickHouse tables..."
for f in backend/db/clickhouse_schema.sql; do
    [ -e "$f" ] || continue
    echo "Applying: $(basename $f)"
    curl -sS -X POST "http://localhost:8123" \
        --data-binary "@$f" 2>/dev/null || true
done

echo ""
echo "Initializing MinIO buckets..."
until curl -sf http://localhost:9000/minio/health/live >/dev/null 2>&1; do sleep 2; done
curl -sf -X PUT "http://localhost:9000/merope-media" \
    --user "merope_admin:merope_minio_secret_key" >/dev/null 2>&1 || true

echo ""
echo "Setting up Elasticsearch indices..."
curl -sS -X PUT "http://localhost:9200/merope_posts" \
    -H "Content-Type: application/json" \
    -d '{"settings":{"number_of_shards":3,"number_of_replicas":0},"mappings":{"properties":{"content":{"type":"text","analyzer":"english"},"user_id":{"type":"keyword"},"created_at":{"type":"date"},"post_type":{"type":"keyword"},"hashtags":{"type":"keyword"}}}}' \
    >/dev/null 2>&1 || true

curl -sS -X PUT "http://localhost:9200/merope_users" \
    -H "Content-Type: application/json" \
    -d '{"settings":{"number_of_shards":1,"number_of_replicas":0},"mappings":{"properties":{"username":{"type":"text"},"display_name":{"type":"text"},"bio":{"type":"text"},"created_at":{"type":"date"}}}}' \
    >/dev/null 2>&1 || true

echo ""
echo "All services initialized. Starting Merope backend..."
echo "Run: cd backend && go run ./cmd/api/main.go"
