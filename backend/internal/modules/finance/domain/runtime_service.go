package domain

import (
	"context"
	"time"
)

type RuntimeFinanceService interface {
	GetBalance(context.Context, string) (int64, error)
	TipUser(context.Context, string, string, int64) error
	UnlockContent(context.Context, string, string, int64) error
	InitiateEscrow(context.Context, string, string, int64, string) (*EscrowRecord, error)
	ReleaseEscrow(context.Context, string, string) error
	RefundEscrow(context.Context, string, string) error
}

// Keep time imported in this compatibility unit so future payment-method
// endpoints can share the same runtime contract package without churn.
var _ time.Duration
