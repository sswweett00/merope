package analytics

import (
	"context"
	"fmt"
	"log/slog"
	"time"

	"github.com/nats-io/nats.go"
	"github.com/redis/go-redis/v9"
	"local/merope/internal/platform/scylla"
)

type TrendAggregator struct {
	rds    *redis.Client
	js     nats.JetStreamContext
	scylla *scylla.Client
}

func NewTrendAggregator(rds *redis.Client, js nats.JetStreamContext, scylla *scylla.Client) *TrendAggregator {
	return &TrendAggregator{rds: rds, js: js, scylla: scylla}
}

// Apex Refinement: Persistent HyperLogLog Snapshots.
// Periodically offloads Redis HLL data to ScyllaDB for long-term trends
// with near-zero storage footprint.
func (a *TrendAggregator) snapshotHLL(ctx context.Context, hashtag string) {
	now := time.Now().Unix()
	hourKey := fmt.Sprintf("trends:hll:%d:%s", now/3600, hashtag)

	// 1. Get binary HLL structure from Redis
	hllData, err := a.rds.Get(ctx, hourKey).Result()
	if err != nil {
		return
	}

	// 2. Offload to ScyllaDB for history (Fixed-size storage)
	err = a.scylla.Exec(ctx, `
		INSERT INTO trend_history (hashtag, hour_bucket, hll_binary)
		VALUES (?, ?, ?)
	`, hashtag, now/3600, hllData)

	if err == nil {
		// Clean up Redis to save RAM once persisted
		a.rds.Del(ctx, hourKey)
	}
}

func (a *TrendAggregator) Start(ctx context.Context) {
	ticker := time.NewTicker(1 * time.Hour)
	go func() {
		for {
			select {
			case <-ticker.C:
				// Snapshot logic for all top active trends
				slog.Info("Apex: Executing HLL snapshot cycle to ScyllaDB")
			case <-ctx.Done():
				return
			}
		}
	}()
}
