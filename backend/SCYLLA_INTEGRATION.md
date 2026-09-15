# ScyllaDB Integration Architecture — Merope

## 1. Executive Summary

Merope is a high-performance real-time communication platform with three critical high-write, high-read paths:

1. **Real-time Chat Messaging** — sub-ms read latency for room history, high write throughput for message bursts
2. **Comment System (Signal Nodes)** — high concurrency reads on popular media, hierarchical comment threading
3. **Social Timeline Feed** — fan-out writes from broadcasters to followers, paged reads for the home feed

PostgreSQL remains the **source of truth** and the fallback for complex queries (search, analytics, reports). ScyllaDB handles the **hot-path reads** and mirrors writes asynchronously using a **dual-write pattern** with PostgreSQL-first semantics.

## 2. Why ScyllaDB?

| Requirement | PostgreSQL | ScyllaDB |
|---|---|---|
| Sub-ms p95 read latency | 5-20ms (with connection pooling) | <1ms (native protocol) |
| 100K+ writes/sec on a single table | Not feasible (MVCC, WAL) | Native (LSM-Tree) |
| Time-series pagination | OFFSET is O(n) | Clustering key scans are O(1) |
| Horizontal scale-out | Requires read replicas + Citus | Linear with node count |
| TTL-based ephemeral data | Requires cron jobs | `USING TTL` at write time |
| High-availability | Streaming replication | Eventually consistent + NTS |

For Merope's hot paths (chat history, comment threads, timeline scroll), ScyllaDB delivers:
- **Sub-millisecond p95 reads** via native driver protocol
- **Linear write scalability** to 1M+ ops/sec per node
- **Zero maintenance for TTL data** (typing indicators, presence)

## 3. Write Path Architecture: Dual-Write Pattern

```
Client Request
    │
    ▼
PostgreSQL (source of truth)
    │
    ├──► ACK to client
    │
    └──► [Async] ScyllaDB (hot-read cache)
            │
            └──► NATS JetStream event (for cross-service fan-out)
```

### Write Modes

| Mode | Behavior | Use Case |
|---|---|---|
| `postgres_first` (default) | Write PostgreSQL → ACK → mirror to ScyllaDB (logged on failure) | Chat messages, comments, reactions, timeline |

### Failure Handling

- **ScyllaDB write failures are non-fatal** in all modes. The service layer uses direct repository calls with `log.Printf` for mirror failures. Failures are logged but never block the HTTP response.
- **Read fallback**: Every hot-path read first queries ScyllaDB. If the query returns empty or errors, it falls back to PostgreSQL.
- **Consistency window**: ~100ms between PostgreSQL commit and ScyllaDB mirror. Acceptable for chat/social where eventual consistency is the norm.

## 4. ScyllaDB Schema Design

### Design Principles Applied

1. **Query-first modeling** — Every table is shaped by its read pattern, not the other way around
2. **Every partition has a natural partition key** — No ALLOW FILTERING
3. **Time-bucketed clustering** — `created_at DESC` for newest-first, with `message_id` as tie-breaker
4. **Bounded partitions** — TimeWindowCompactionStrategy prevents partitions from growing unbounded
5. **Denormalization over JOINs** — Flattened data structures (author_name embedded in message)
6. **Minimal data per partition** — `LIMIT 100` enforced at query time

### Table-by-Table Schema

#### `chat_messages_by_room`
**Query**: "Get latest 50 messages from room X"

```cql
PRIMARY KEY ((room_id), created_at DESC, message_id ASC)
```

- **Partition key**: `room_id` — messages for a single room
- **Clustering**: `created_at DESC` (newest first for infinite scroll), `message_id ASC` (tie-break for same millisecond)
- **Compaction**: `TimeWindowCompactionStrategy` (1-hour windows) — enables fast time-range compaction
- **gc_grace_seconds = 0** — messages are immutable; TTL works immediately
- **Cache**: No `CACHING` directive (chat messages are ephemeral, not worth caching)

#### `chat_message_by_id`
**Query**: "Get message X for reaction/edit/delete"

```cql
PRIMARY KEY (message_id)
```

- Single partition per message
- Used for LWT-style updates to reactions and edits
- Enables point lookups for React.js hydration

#### `signal_comments_by_signal`
**Query**: "Get all comments for signal X, newest first"

```cql
PRIMARY KEY ((signal_id), created_at DESC, node_id ASC)
```

- **Partition key**: `signal_id` — all comments for a post
- **level** field supports nested comments (reply = level 1, reply-to-reply = level 2)
- **LIMIT 100** enforced at query time to prevent hot partitions on viral content
- TimeWindowCompactionStrategy (1-hour)

#### `reactions_by_target`
**Query**: "Get all reactions for signal X, grouped by type"

```cql
PRIMARY KEY ((target_id), reaction_type, user_id)
```

- **Partition key**: `target_id` (could be signal_id or message_id)
- **Clustering**: `reaction_type ASC, user_id ASC`
- Each row = one user's one reaction
- Use `DELETE` for reaction toggle (removes row) and `UPDATE created_at` for add
- Zero TTL — reactions persist indefinitely

#### `user_timeline`
**Query**: "Get home feed for user X, newest first"

```cql
PRIMARY KEY ((user_id), created_at DESC, signal_id ASC)
```

- **Partition key**: `user_id` — the fan-out table
- **CLUSTERING ORDER**: DESC for newest-first timeline rendering
- Written by background worker when a signal is broadcast
- Read by the Feed API endpoint

**Fan-out strategy**: On signal broadcast, a NATS event is published:
1. Content service creates signal in PostgreSQL
2. ScyllaDB repository gets follower IDs from PostgreSQL
3. Writes one row per follower in `user_timeline`
4. Done asynchronously (goroutine with 5s timeout)

#### `typing_indicator`
**Query**: "Who is typing in room X?"

```cql
PRIMARY KEY ((room_id), user_id)
TTL = 8 seconds
```

- **Partition key**: `room_id`
- **Clustering**: `user_id`
- TTL automatically expires stop-typing events
- Written on every typing event (fire-and-forget)

#### `presence_by_user`
**Query**: "Is user X online?"

```cql
PRIMARY KEY (user_id)
```

- Optional TTL for heartbeat-based presence
- Updated on WebSocket connect/disconnect and periodic heartbeat

#### `signal_by_id`
**Query**: "Get signal X details"

```cql
PRIMARY KEY (signal_id)
```

- Single-row lookup for signal metadata
- Updated in parallel with PostgreSQL on signal status changes

## 5. Data Modeling: Query-to-Table Mapping

| Query | Table | Access Pattern |
|---|---|---|
| Get room chat history | `chat_messages_by_room` | `SELECT ... WHERE room_id = ? LIMIT 50` |
| Get single message | `chat_message_by_id` | `SELECT ... WHERE message_id = ?` |
| Add reaction to message | `reactions_by_target` | `UPDATE WHERE target_id = ? AND reaction_type = ? AND user_id = ?` |
| Remove reaction | `reactions_by_target` | `DELETE WHERE target_id = ? AND reaction_type = ? AND user_id = ?` |
| Get signal comments | `signal_comments_by_signal` | `SELECT ... WHERE signal_id = ? LIMIT 100` |
| Get user home feed | `user_timeline` | `SELECT ... WHERE user_id = ? LIMIT 20` |
| Check if user is typing | `typing_indicator` | `SELECT ... WHERE room_id = ?` |
| Get user presence | `presence_by_user` | `SELECT ... WHERE user_id = ?` |
| Get signal metadata | `signal_by_id` | `SELECT ... WHERE signal_id = ?` |

## 6. Best Practices Implemented

### 6.1 Partition Sizing
- `chat_messages_by_room`: A discussion room with 10K messages/hour = 240K rows/day. Each partition stores ~1 hour of data. After compaction, each partition is ~10MB. Well within ScyllaDB's 100MB/partition sweet spot.
- `signal_comments_by_signal`: Viral signals cap at `LIMIT 100` in application code. Each row is ~200 bytes including clustering overhead. 100 rows = 20KB. Trivial.
- `user_timeline`: Each user's timeline = 20 rows × ~500 bytes = 10KB. 1M users = 10GB total. Efficient with compaction.

### 6.2 Connection Management
```go
cluster := gocql.NewCluster(cfg.Hosts...)
cluster.PoolConfig = gocql.PoolConfig{
    MaxConnsPerHost: 100,
    MinConnsPerHost: 2,
}
```
- 100 connections per host matches the Go routine-based concurrency model
- `noRetry` policy: Retries are handled at the application layer (dual-write with PostgreSQL fallback)

### 6.3 Batch Writes
All multi-row writes (e.g., chat message + lookup) use `LoggedBatch`:
```go
batch := session.NewBatch(gocql.LoggedBatch)
batch.Query(msgStmt, ...)
batch.Query(lookupStmt, ...)
_ = session.ExecuteBatch(batch)
```
Logged batches guarantee atomicity within a partition without the overhead of LWT.

### 6.4 Consistency Levels
- **Default**: `LOCAL_QUORUM` — ensures strong consistency within the local DC
- **User-facing reads**: `LOCAL_QUORUM` — readers always see their own writes
- **Timeline fan-out**: `LOCAL_QUORUM` — 2/3 replicas must confirm
- **Ephemeral writes** (typing, presence): `ONE` — data expires in 8 seconds, no need for quorum

### 6.5 Hot-Partition Avoidance
- Chat messages: Time bucketed by hour via TWC compaction. Loads are naturally spread across time.
- Timeline: Written by background worker, not synchronously by the broadcaster. Smoothing effect.

## 7. Production Deployment Topology

```
                    ┌──────────────────────────────┐
                    │   Merope API (Go + Fiber)   │
                    │   - Dual-write to PG+Scylla  │
                    │   - Read → Scylla → PG fallback│
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │      ScyllaDB Cluster        │
                    │  3-node RF=3 (same DC)      │
                    │  - chat_messages_by_room    │
                    │  - signal_comments_by_signal│
                    │  - user_timeline            │
                    │  - reactions_by_target      │
                    │  - typing_indicator (TTL 8s)│
                    │  - presence_by_user         │
                    └──────────────────────────────┘
```

### Node Sizing (Production)
| Node | vCPU | RAM | Storage |
|---|---|---|---|
| ScyllaDB 1 | 8 | 64GB | 2TB NVMe |
| ScyllaDB 2 | 8 | 64GB | 2TB NVMe |
| ScyllaDB 3 | 8 | 64GB | 2TB NVMe |

- **Spare capacity**: Each node must run at <70% utilization. ScyllaDB performance degrades sharply above 70%.
- **Network**: 10GbE minimum between nodes (ScyllaDB is network-heavy for replication)
- **OS tuning**: `numa` balancing disabled, `transparent_hugepage` disabled, dedicated SSDs.

## 8. Migration Strategy

### Phase 1: Schema + Infrastructure (Week 1)
1. Deploy ScyllaDB cluster with `schema.cql`
2. Add `gocql/gocql` to `go.mod`
3. Create `backend/internal/platform/scylla/` package
4. Deploy with `scyllaClient = nil` fallback (no behavior change)

### Phase 2: Write Mirroring (Week 2)
1. Enable ScyllaDB mirroring in `postgres_first` mode
2. All writes to chat messages, comments, reactions mirrored to ScyllaDB
3. PostgreSQL remains source of truth
4. Monitor ScyllaDB write latency and error rate

### Phase 3: Read Routing (Week 3)
1. Route chat history reads from ScyllaDB
2. Route comment thread reads from ScyllaDB
3. Fallback to PostgreSQL if ScyllaDB returns empty or errors
4. Measure p95 improvement (target: <5ms)

### Phase 4: Fan-out Optimization (Week 4)
1. Enable `user_timeline` fan-out via background goroutines
2. Timeline reads fully cached in ScyllaDB
3. Decommission O(N+1) PostgreSQL queries for feed

### Rollback Plan
- Set `SCYLLA_HOSTS=""` in environment → all reads/writes go to PostgreSQL
- No data loss — PostgreSQL remains source of truth
- ScyllaDB TTL ensures data auto-expires

## 9. Monitoring & Observability

| Metric | Tool | Alert Threshold |
|---|---|---|
| ScyllaDB read latency p95 | Prometheus | > 5ms |
| ScyllaDB write latency p95 | Prometheus | > 10ms |
| ScyllaDB connection errors | Prometheus | > 0.1% |
| Dual-write error rate | Application logs | > 0.01% |
| Fallback rate (ScyllaDB → PostgreSQL) | Application metrics | > 5% |
| ScyllaDB node disk usage | Prometheus | > 70% |
| ScyllaDB pending compactions | Prometheus | > 10 |

## 10. Files Added/Modified

### New Files
| File | Purpose |
|---|---|
| `backend/internal/platform/scylla/scylla.go` | ScyllaDB client wrapper (connection, pool config) |
| `backend/internal/platform/scylla/retry.go` | No-retry policy (retries handled at app layer) |
| `backend/internal/platform/scylla/schema.cql` | CQL schema for all 8 tables |
| `backend/internal/modules/messaging/infra/scylla_repository.go` | Chat message ScyllaDB repository |
| `backend/internal/modules/content/infra/scylla_repository.go` | Comment/reaction ScyllaDB repository |
| `backend/internal/modules/social/infra/scylla_repository.go` | Timeline/presence ScyllaDB repository |
| `backend/internal/modules/messaging/service/high_performance_messaging.go` | Dual-write messaging service |
| `backend/internal/modules/content/service/high_performance_content.go` | Dual-write content service |

### Modified Files
| File | Change |
|---|---|
| `backend/cmd/api/main.go` | Added ScyllaDB init + conditional high-perf service wiring |
| `backend/go.mod` | Added `github.com/gocql/gocql v1.7.0` |
| `backend/internal/core/config/config.go` | Added `Scylla` config section + `SCYLLA_TIMEOUT` env tag |
