package audit

import (
	"context"
	"time"
)

type Event struct {
	Action    string    `json:"action"`
	UserID    string    `json:"user_id"`
	Entity    string    `json:"entity"`
	EntityID  string    `json:"entity_id"`
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Payload   any       `json:"payload,omitempty"`
}

type Auditor interface {
	Record(ctx context.Context, event Event)
}

func New(p any) Auditor {
	return &nopAuditor{}
}

type nopAuditor struct{}

func (n *nopAuditor) Record(ctx context.Context, event Event) {}
