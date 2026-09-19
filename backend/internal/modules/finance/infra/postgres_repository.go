package infra

import (
	"context"
	"fmt"
	"math"
	"strings"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/finance/domain"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
)

type PostgresFinanceRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresFinanceRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresFinanceRepository {
	return &PostgresFinanceRepository{queries: queries, pool: pool}
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
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	if senderID == receiverID {
		return fmt.Errorf("sender and receiver must differ")
	}
	if r.pool == nil {
		return fmt.Errorf("postgres pool is required")
	}
	sid, err := parseFinanceUUID(senderID)
	if err != nil { return err }
	rid, err := parseFinanceUUID(receiverID)
	if err != nil { return err }

	tx, err := r.pool.Begin(ctx)
	if err != nil { return fmt.Errorf("begin transfer transaction: %w", err) }
	defer tx.Rollback(ctx)

	var remaining int64
	if err := tx.QueryRow(ctx,
		`UPDATE wallets
		 SET balance = balance - $2, updated_at = NOW()
		 WHERE user_id = $1 AND balance >= $2
		 RETURNING balance`,
		sid, amount,
	).Scan(&remaining); err != nil {
		if err == pgx.ErrNoRows {
			return fmt.Errorf("insufficient balance or sender wallet not found")
		}
		return err
	}

	if _, err := tx.Exec(ctx,
		`UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE user_id = $1`,
		rid, amount,
	); err != nil {
		return fmt.Errorf("credit receiver wallet: %w", err)
	}

	if _, err := tx.Exec(ctx,
		`INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, tx_type, status, reference)
		 VALUES ($1, $2, $3, $4, 'completed', $5)`,
		sid, rid, amount, tType, transactionReference(entityType, entityID),
	); err != nil {
		return fmt.Errorf("record transfer: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit transfer transaction: %w", err)
	}
	_ = remaining
	return nil
}

func (r *PostgresFinanceRepository) CreateEscrow(ctx context.Context, escrow *domain.EscrowRecord) error {
	if escrow == nil || escrow.Amount <= 0 {
		return fmt.Errorf("invalid escrow")
	}
	if escrow.BuyerID == escrow.SellerID {
		return fmt.Errorf("buyer and seller must differ")
	}
	if r.pool == nil {
		return fmt.Errorf("postgres pool is required")
	}
	bid, err := parseFinanceUUID(escrow.BuyerID)
	if err != nil { return err }
	sid, err := parseFinanceUUID(escrow.SellerID)
	if err != nil { return err }

	amountDB, err := toDBAmount(escrow.Amount)
	if err != nil { return err }

	tx, err := r.pool.Begin(ctx)
	if err != nil { return fmt.Errorf("begin escrow transaction: %w", err) }
	defer tx.Rollback(ctx)

	var reserved int64
	if err := tx.QueryRow(ctx,
		`UPDATE wallets
		 SET balance = balance - $2, updated_at = NOW()
		 WHERE user_id = $1 AND balance >= $2
		 RETURNING balance`,
		bid, amountDB,
	).Scan(&reserved); err != nil {
		if err == pgx.ErrNoRows {
			return fmt.Errorf("insufficient balance or buyer wallet not found")
		}
		return fmt.Errorf("reserve escrow funds: %w", err)
	}

	var escrowID pgtype.UUID
	var createdAt, releaseAt pgtype.Timestamptz
	err = tx.QueryRow(ctx,
		`INSERT INTO escrow_records (buyer_id, seller_id, amount, status, description, release_at)
		 VALUES ($1, $2, $3, 'held', $4, $5)
		 RETURNING id, created_at, release_at`,
		bid, sid, amountDB, escrow.Description, escrow.ReleaseAt,
	).Scan(&escrowID, &createdAt, &releaseAt)
	if err != nil {
		return fmt.Errorf("create escrow record: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit escrow transaction: %w", err)
	}
	escrow.ID = util.UUIDToString(escrowID)
	escrow.CreatedAt = createdAt.Time
	if releaseAt.Valid {
		escrow.ReleaseAt = &releaseAt.Time
	}
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

func parseFinanceUUID(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}

func transactionReference(entityType, entityID *string) string {
	if entityType == nil || entityID == nil || strings.TrimSpace(*entityID) == "" {
		return ""
	}
	return strings.TrimSpace(*entityType) + ":" + strings.TrimSpace(*entityID)
}

func (r *PostgresFinanceRepository) ReleaseEscrow(ctx context.Context, escrowID string) error {
	if r.pool == nil { return fmt.Errorf("postgres pool is required") }
	eid, err := parseFinanceUUID(escrowID)
	if err != nil { return err }

	tx, err := r.pool.Begin(ctx)
	if err != nil { return fmt.Errorf("begin escrow release transaction: %w", err) }
	defer tx.Rollback(ctx)

	var buyerID, sellerID pgtype.UUID
	var amount int32
	if err := tx.QueryRow(ctx,
		`UPDATE escrow_records
		 SET status = 'released', updated_at = NOW()
		 WHERE id = $1 AND status = 'held'
		 RETURNING buyer_id, seller_id, amount`,
		eid,
	).Scan(&buyerID, &sellerID, &amount); err != nil {
		if err == pgx.ErrNoRows { return fmt.Errorf("escrow is not releasable") }
		return err
	}

	if _, err := tx.Exec(ctx,
		`UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE user_id = $1`,
		sellerID, amount,
	); err != nil { return fmt.Errorf("credit seller wallet: %w", err) }

	if _, err := tx.Exec(ctx,
		`INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, tx_type, status, reference)
		 VALUES ($1, $2, $3, 'escrow_release', 'completed', $4)`,
		buyerID, sellerID, amount, escrowID,
	); err != nil { return fmt.Errorf("record escrow release: %w", err) }

	return tx.Commit(ctx)
}

func (r *PostgresFinanceRepository) RefundEscrow(ctx context.Context, escrowID string) error {
	if r.pool == nil { return fmt.Errorf("postgres pool is required") }
	eid, err := parseFinanceUUID(escrowID)
	if err != nil { return err }

	tx, err := r.pool.Begin(ctx)
	if err != nil { return fmt.Errorf("begin escrow refund transaction: %w", err) }
	defer tx.Rollback(ctx)

	var buyerID, sellerID pgtype.UUID
	var amount int32
	if err := tx.QueryRow(ctx,
		`UPDATE escrow_records
		 SET status = 'refunded', updated_at = NOW()
		 WHERE id = $1 AND status = 'held'
		 RETURNING buyer_id, seller_id, amount`,
		eid,
	).Scan(&buyerID, &sellerID, &amount); err != nil {
		if err == pgx.ErrNoRows { return fmt.Errorf("escrow is not refundable") }
		return err
	}

	if _, err := tx.Exec(ctx,
		`UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE user_id = $1`,
		buyerID, amount,
	); err != nil { return fmt.Errorf("refund buyer wallet: %w", err) }

	if _, err := tx.Exec(ctx,
		`INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, tx_type, status, reference)
		 VALUES ($1, $2, $3, 'escrow_refund', 'completed', $4)`,
		sellerID, buyerID, amount, escrowID,
	); err != nil { return fmt.Errorf("record escrow refund: %w", err) }

	return tx.Commit(ctx)
}

var _ domain.RuntimeFinanceRepository = (*PostgresFinanceRepository)(nil)
