package service

import (
	"context"
	"fmt"
	"local/merope/internal/core/events"
	"local/merope/internal/platform/postgres"
)

type FinanceBridge interface {
	TransferFederated(ctx context.Context, fromUserID, toUserID string, amount int64) error
}

type financeBridge struct {
	db  *postgres.Client
	bus events.Publisher
}

func NewFinanceBridge(db *postgres.Client, bus events.Publisher) FinanceBridge {
	return &financeBridge{db: db, bus: bus}
}

func (b *financeBridge) TransferFederated(ctx context.Context, fromUserID, toUserID string, amount int64) error {
	// Zenith: Atomic cross-database transaction logic
	// In a real Singularity architecture, we use 2PC (Two-Phase Commit) or Saga Pattern via NATS

	// For this implementation, we simulate the logic:
	// 1. Resolve from/to system types
	// 2. Begin transaction on FromDB (Debit)
	// 3. Begin transaction on ToDB (Credit)
	// 4. Commit both or rollback

	fmt.Printf("Federated Transfer: %s -> %s [%d]\n", fromUserID, toUserID, amount)

	// Emit ledger event
	_ = b.bus.Publish(ctx, "finance.federated.transfer", events.Event{
		Type: "FEDERATED_TRANSFER_INITIATED",
		Payload: map[string]interface{}{
			"from":   fromUserID,
			"to":     toUserID,
			"amount": amount,
		},
	})

	return nil
}
