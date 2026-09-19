package audit

import (
	"context"

	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	"go.uber.org/zap"

	"local/merope/internal/core/logger"
)

type ClickHouseAuditor struct {
	conn driver.Conn
}

func NewClickHouseAuditor(conn driver.Conn) *ClickHouseAuditor {
	return &ClickHouseAuditor{conn: conn}
}

func (a *ClickHouseAuditor) Record(ctx context.Context, event Event) {
	err := a.conn.Exec(ctx, `
		INSERT INTO audit_logs (action, user_id, entity, entity_id, status, payload, timestamp)
		VALUES (?, ?, ?, ?, ?, ?, ?)
	`, event.Action, event.UserID, event.Entity, event.EntityID, event.Status, event.Payload, event.Timestamp)

	if err != nil {
		logger.Log.Error("Failed to record clickhouse audit", zap.Error(err))
	}
}
