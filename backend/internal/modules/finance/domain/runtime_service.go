package domain

import "context"

type RuntimeFinanceService interface {
	GetBalance(context.Context, string) (int64, error)
	GetTransactions(context.Context, string, int32, int32) ([]*Transaction, error)
	GetEscrow(context.Context, string) (*EscrowRecord, error)
	TipUser(context.Context, string, string, int64) error
	TransferFunds(context.Context, string, string, int64) error
	UnlockContent(context.Context, string, string, int64) error
	InitiateEscrow(context.Context, string, string, int64, string) (*EscrowRecord, error)
	ReleaseEscrow(context.Context, string, string) error
	RefundEscrow(context.Context, string, string) error
}
