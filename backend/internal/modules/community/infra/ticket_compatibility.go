package infra

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) CreateTicket(ctx context.Context, eventID, userID, code string) error {
	userUUID, err := parseUUID(userID)
	if err != nil {
		return err
	}
	if code == "" {
		return fmt.Errorf("ticket code is required")
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO transactions (sender_wallet_id, amount, tx_type, status, reference)
VALUES ($1, 0, 'event_ticket', 'completed', $2)`, userUUID, code)
	return err
}

func (r *postgresCommunityRepository) GetTicket(ctx context.Context, ticketID string) (*domain.Ticket, error) {
	id, err := parseUUID(ticketID)
	if err != nil {
		return nil, err
	}
	var ticket domain.Ticket
	var rowID, userID pgtype.UUID
	var reference, status string
	var createdAt time.Time
	if err := r.queries.QueryRow(ctx, `
SELECT id, sender_wallet_id, reference, status, created_at
FROM transactions
WHERE id = $1 AND tx_type = 'event_ticket'`, id).Scan(&rowID, &userID, &reference, &status, &createdAt); err != nil {
		return nil, err
	}
	ticket.ID = util.UUIDToString(rowID)
	ticket.UserID = util.UUIDToString(userID)
	ticket.TicketCode = reference
	ticket.Status = status
	ticket.PurchasedAt = createdAt
	ticket.Metadata = map[string]interface{}{}
	return &ticket, nil
}

func (r *postgresCommunityRepository) GetUserTickets(ctx context.Context, userID string) ([]*domain.Ticket, error) {
	uid, err := parseUUID(userID)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries.Query(ctx, `
SELECT id, sender_wallet_id, reference, status, created_at
FROM transactions
WHERE sender_wallet_id = $1 AND tx_type = 'event_ticket'
ORDER BY created_at DESC`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make([]*domain.Ticket, 0)
	for rows.Next() {
		var ticket domain.Ticket
		var id, ownerID pgtype.UUID
		if err := rows.Scan(&id, &ownerID, &ticket.TicketCode, &ticket.Status, &ticket.PurchasedAt); err != nil {
			return nil, err
		}
		ticket.ID = util.UUIDToString(id)
		ticket.UserID = util.UUIDToString(ownerID)
		ticket.Metadata = map[string]interface{}{}
		result = append(result, &ticket)
	}
	return result, rows.Err()
}

func (r *postgresCommunityRepository) ValidateTicket(ctx context.Context, ticketCode string) (*domain.Ticket, error) {
	if ticketCode == "" {
		return nil, fmt.Errorf("ticket code is required")
	}
	var ticket domain.Ticket
	var id, ownerID pgtype.UUID
	if err := r.queries.QueryRow(ctx, `
SELECT id, sender_wallet_id, reference, status, created_at
FROM transactions
WHERE reference = $1 AND tx_type = 'event_ticket'
ORDER BY created_at DESC
LIMIT 1`, ticketCode).Scan(&id, &ownerID, &ticket.TicketCode, &ticket.Status, &ticket.PurchasedAt); err != nil {
		return nil, err
	}
	ticket.ID = util.UUIDToString(id)
	ticket.UserID = util.UUIDToString(ownerID)
	ticket.Metadata = map[string]interface{}{}
	return &ticket, nil
}

func (r *postgresCommunityRepository) CancelTicket(ctx context.Context, ticketID string) error {
	id, err := parseUUID(ticketID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `
UPDATE transactions
SET status = 'cancelled'
WHERE id = $1 AND tx_type = 'event_ticket'`, id)
	return err
}
