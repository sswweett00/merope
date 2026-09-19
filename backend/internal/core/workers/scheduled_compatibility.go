package workers

import (
	"context"
	"time"

	"local/merope/internal/core/events"
)

func (w *ScheduledWorkers) notificationDispatch(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			_ = w.bus.Publish(ctx, "notifications.dispatch.tick", events.Event{
				Type:    "NOTIFICATION_DISPATCH_TICK",
				Payload: map[string]interface{}{"triggered_at": time.Now().Unix()},
			})
		}
	}
}
