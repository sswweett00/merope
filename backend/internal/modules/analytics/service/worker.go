package service

import (
	"context"
	"encoding/json"
	"log/slog"

	"github.com/nats-io/nats.go"

	"local/merope/internal/modules/analytics/domain"
	"local/merope/internal/platform/clickhouse"
)

type Worker struct {
	conn *clickhouse.Client
	js   nats.JetStreamContext
}

func NewWorker(conn *clickhouse.Client, js nats.JetStreamContext) *Worker {
	return &Worker{conn: conn, js: js}
}

func (w *Worker) Start(ctx context.Context) error {
	_, err := w.js.Subscribe("analytics.events", func(msg *nats.Msg) {
		var event domain.UserEvent
		if err := json.Unmarshal(msg.Data, &event); err != nil {
			slog.Error("failed to unmarshal analytics event", "error", err)
			return
		}

		err := w.conn.Conn.Exec(ctx, `
			INSERT INTO user_events (event_id, user_id, event_type, payload, created_at)
			VALUES (?, ?, ?, ?, ?)
		`, event.EventID, event.UserID, event.EventType, event.Payload, event.CreatedAt)

		if err != nil {
			slog.Error("failed to insert event into clickhouse", "error", err)
		}
	})
	return err
}
