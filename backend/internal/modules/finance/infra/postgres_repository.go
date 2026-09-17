package infra

import (
	"context"
	"fmt"
	"math"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/finance/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresFinanceRepository struct {
	queries *db.Queries
}

func NewPostgresFinanceRepository(queries *db.Queries) *PostgresFinanceRepository {
	return &PostgresFinanceRepository{queries: queries}
}

func toDBAmount(amount int64) (int32, error) {
	if amount < math.MinInt32 || amount > math.MaxInt32 {
		return 0, fmt.Errorf("amount %d exceeds database amount range", amount)
	}
	return int32(amount), nil
}

func (r *PostgresFinanceRepository) GetWallet(ctx context.Context, userID string) (*domain.Wallet, error) {
	var uid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return nil, fmt.Errorf("invalid user id: %w", err)
	}
	w, err := r.queries.GetWallet(ctx, uid)
	if err != nil {
		return nil, err
	}
	return &domain.Wallet{
		UserID:  util.UUIDToString(w.UserID),
		Balance: int64(w.Balance),
		Currency: "TRY",
		UpdatedAt: w.UpdatedAt.Time,
	}, nil
}

func (r *PostgresFinanceRepository) Transfer(ctx context.Context, senderID, receiverID string, amount int64, tType string, entityType, entityID *string) error {
	amountDB, err := toDBAmount(amount)
	if err != nil {
		return err
	}
	var sid, rid pgtype.UUID
	if err := sid.Scan(senderID); err != nil {
		return fmt.Errorf("invalid sender id: %w", err)
	}
	if err := rid.Scan(receiverID); err != nil {
		return fmt.Errorf("invalid receiver id: %w", err)
	}

	if err := r.queries.UpdateWalletBalance(ctx, db.UpdateWalletBalanceParams{UserID: sid, Balance: -amountDB}); err != nil {
		return err
	}
	if err := r.queries.UpdateWalletBalance(ctx, db.UpdateWalletBalanceParams{UserID: rid, Balance: amountDB}); err != nil {
		return err
	}

	_, err = r.queries.CreateTransaction(ctx, db.CreateTransactionParams{BuyerID: sid, TotalAmount: amountDB})
	return err
}

func (r *PostgresFinanceRepository) CreateEscrow(ctx context.Context, escrow *domain.EscrowRecord) error {
	amountDB, err := toDBAmount(escrow.Amount)
	if err != nil {
		return err
	}
	var bid, sid pgtype.UUID
	if err := bid.Scan(escrow.BuyerID); err != nil {
		return fmt.Errorf("invalid buyer id: %w", err)
	}
	if err := sid.Scan(escrow.SellerID); err != nil {
		return fmt.Errorf("invalid seller id: %w", err)
	}

	res, err := r.queries.CreateEscrowRecord(ctx, db.CreateEscrowRecordParams{
		BuyerID: bid,
		SellerID: sid,
		Amount: amountDB,
		Status: escrow.Status,
		Description: pgtype.Text{String: escrow.Description, Valid: escrow.Description != ""},
	})
	if err != nil {
		return err
	}
	escrow.ID = util.UUIDToString(res.ID)
	return nil
}

func (r *PostgresFinanceRepository) GetEscrow(ctx context.Context, id string) (*domain.EscrowRecord, error) {
	var eid pgtype.UUID
	if err := eid.Scan(id); err != nil {
		return nil, fmt.Errorf("invalid escrow id: %w", err)
	}
	e, err := r.queries.GetEscrowRecord(ctx, eid)
	if err != nil {
		return nil, err
	}
	return &domain.EscrowRecord{
		ID: util.UUIDToString(e.ID),
		BuyerID: util.UUIDToString(e.BuyerID),
		SellerID: util.UUIDToString(e.SellerID),
		Amount: int64(e.Amount),
		Status: e.Status,
		Description: e.Description.String,
	}, nil
}

func (r *PostgresFinanceRepository) UpdateEscrowStatus(ctx context.Context, id, status string) error {
	var eid pgtype.UUID
	if err := eid.Scan(id); err != nil {
		return fmt.Errorf("invalid escrow id: %w", err)
	}
	return r.queries.UpdateEscrowStatus(ctx, db.UpdateEscrowStatusParams{ID: eid, Status: status})
}

var _ domain.RuntimeFinanceRepository = (*PostgresFinanceRepository)(nil)
