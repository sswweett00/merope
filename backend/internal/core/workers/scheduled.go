package workers

import (
	"context"
	"time"

	"local/merope/internal/core/analytics"
	"local/merope/internal/core/events"
	"local/merope/internal/core/logger"
	ch "local/merope/internal/platform/clickhouse"
	"local/merope/internal/platform/redis"
)

type ScheduledWorkers struct {
	engine *analytics.AnalyticsEngine
	redis  *redis.Client
	bus    events.Publisher
	ch     *ch.Client
}

func NewScheduledWorkers(chClient *ch.Client, rds *redis.Client, bus events.Publisher) *ScheduledWorkers {
	engine := analytics.NewAnalyticsEngine(chClient, bus)
	return &ScheduledWorkers{engine: engine, redis: rds, bus: bus, ch: chClient}
}

func (w *ScheduledWorkers) Start(ctx context.Context) {
	go w.rankerRecalculation(ctx, 10*time.Minute)
	go w.trendRefresh(ctx, 5*time.Minute)
	go w.analyticsAggregation(ctx, 1*time.Hour)
	go w.sessionCleanup(ctx, 30*time.Minute)
	go w.notificationDispatch(ctx, 2*time.Minute)
}

func (w *ScheduledWorkers) rankerRecalculation(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			_ = w.bus.Publish(ctx, "analytics.ranks.recalculate", events.Event{Type: "RANK_RECALCULATION", Payload: map[string]interface{}{"triggered_at": time.Now().Unix()}})
		}
	}
}

func (w *ScheduledWorkers) trendRefresh(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if err := w.engine.RefreshTrendingTopics(ctx); err != nil {
				logger.Warn("trend refresh failed", "error", err)
			}
		}
	}
}

func (w *ScheduledWorkers) analyticsAggregation(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if err := w.engine.AggregateDailyStats(ctx, time.Now().UTC()); err != nil {
				logger.Warn("analytics aggregation failed", "error", err)
			}
		}
	}
}

func (w *ScheduledWorkers) sessionCleanup(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if w.redis == nil {
				continue
			}
			stats, err := w.redis.Info(ctx)
			if err == nil {
				_ = stats
			}
		}
	}
}

type PushNotificationDispatcher struct {
	enabled bool
	ch      *ch.Client
	bus     events.Publisher
}

func NewPushNotificationDispatcher(chClient *ch.Client, bus events.Publisher) *PushNotificationDispatcher {
	if chClient == nil {
		logger.Warn("ClickHouse not available, push dispatch events logged only")
		return &PushNotificationDispatcher{enabled: false}
	}
	return &PushNotificationDispatcher{enabled: true, ch: chClient, bus: bus}
}

func (d *PushNotificationDispatcher) Start(ctx context.Context) {
	go d.processPushQueue(ctx, 30*time.Second)
	go d.recordPushMetrics(ctx, 15*time.Minute)
}

func (d *PushNotificationDispatcher) processPushQueue(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if d.enabled {
				_ = d.bus.Publish(ctx, "push.queue.flush", events.Event{Type: "PUSH_QUEUE_FLUSH", Payload: map[string]interface{}{"timestamp": time.Now().Unix()}})
			}
		}
	}
}

func (d *PushNotificationDispatcher) recordPushMetrics(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if d.enabled {
				_ = d.bus.Publish(ctx, "push.metrics.record", events.Event{Type: "PUSH_METRICS_RECORD", Payload: map[string]interface{}{"timestamp": time.Now().Unix()}})
			}
		}
	}
}

func (d *PushNotificationDispatcher) Shutdown() {}
