package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/finance/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresFinanceRepository struct {
	queries *db.Queries
}

func NewPostgresFinanceRepository(queries *db.Queries) *PostgresFinanceRepository {
	return &PostgresFinanceRepository{queries: queries}
}

func (r *PostgresFinanceRepository) GetWallet(ctx context.Context, userID string) (*domain.Wallet, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)
	w, err := r.queries.GetWallet(ctx, uid)
	if err != nil {
		return nil, err
	}
	return &domain.Wallet{
		UserID:    util.UUIDToString(w.UserID),
		Balance:   w.Balance,
		UpdatedAt: w.UpdatedAt.Time,
	}, nil
}

func (r *PostgresFinanceRepository) Transfer(ctx context.Context, senderID, receiverID string, amount int32, tType string, entityType, entityID *string) error {
	var sid, rid pgtype.UUID
	_ = sid.Scan(senderID)
	_ = rid.Scan(receiverID)

	err := r.queries.UpdateWalletBalance(ctx, db.UpdateWalletBalanceParams{
		UserID:  sid,
		Balance: -amount,
	})
	if err != nil {
		return err
	}

	err = r.queries.UpdateWalletBalance(ctx, db.UpdateWalletBalanceParams{
		UserID:  rid,
		Balance: amount,
	})
	if err != nil {
		return err
	}

	_, err = r.queries.CreateTransaction(ctx, db.CreateTransactionParams{
		BuyerID:     sid,
		TotalAmount: amount,
	})
	return err
}

func (r *PostgresFinanceRepository) CreateEscrow(ctx context.Context, escrow *domain.EscrowRecord) error {
	var bid, sid pgtype.UUID
	_ = bid.Scan(escrow.BuyerID)
	_ = sid.Scan(escrow.SellerID)

	res, err := r.queries.CreateEscrowRecord(ctx, db.CreateEscrowRecordParams{
		BuyerID:     bid,
		SellerID:    sid,
		Amount:      escrow.Amount,
		Status:      escrow.Status,
		Description: pgtype.Text{String: escrow.Description, Valid: true},
	})
	if err != nil {
		return err
	}
	escrow.ID = util.UUIDToString(res.ID)
	return nil
}

func (r *PostgresFinanceRepository) GetEscrow(ctx context.Context, id string) (*domain.EscrowRecord, error) {
	var eid pgtype.UUID
	_ = eid.Scan(id)
	e, err := r.queries.GetEscrowRecord(ctx, eid)
	if err != nil {
		return nil, err
	}
	return &domain.EscrowRecord{
		ID:          util.UUIDToString(e.ID),
		BuyerID:     util.UUIDToString(e.BuyerID),
		SellerID:    util.UUIDToString(e.SellerID),
		Amount:      e.Amount,
		Status:      e.Status,
		Description: e.Description.String,
	}, nil
}

func (r *PostgresFinanceRepository) UpdateEscrowStatus(ctx context.Context, id, status string) error {
	var eid pgtype.UUID
	_ = eid.Scan(id)
	return r.queries.UpdateEscrowStatus(ctx, db.UpdateEscrowStatusParams{
		ID:     eid,
		Status: status,
	})
}
