package domain

import "context"

type RuntimeFinanceRepository interface {
	GetWallet(context.Context, string) (*Wallet, error)
	GetUserTransactions(context.Context, string, int32, int32) ([]*Transaction, error)
	Transfer(context.Context, string, string, int64, string, *string, *string) error
	CreateEscrow(context.Context, *EscrowRecord) error
	GetEscrow(context.Context, string) (*EscrowRecord, error)
	UpdateEscrowStatus(context.Context, string, string) error
	ReleaseEscrow(context.Context, string) error
	RefundEscrow(context.Context, string) error
}
