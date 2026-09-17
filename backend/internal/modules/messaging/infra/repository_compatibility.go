package infra

import (
	"context"
	"fmt"

	"local/merope/internal/database/db"
	"local/merope/internal/modules/messaging/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

func (r *PostgresMessagingRepository) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	var id pgtype.UUID
	if err := id.Scan(messageID); err != nil { return nil, fmt.Errorf("invalid message id: %w", err) }

	var content string
	var authorID pgtype.UUID
	var createdAt pgtype.Timestamptz
	err := r.queries.QueryRow(ctx, `
SELECT content, author_id, created_at
FROM chat_messages
WHERE id = $1
ORDER BY created_at DESC
LIMIT 1`, id).Scan(&content, &authorID, &createdAt)
	if err != nil { return nil, err }

	return []*domain.MessageHistory{{
		MessageID: messageID,
		Content: content,
		Version: 1,
		AuthorID: authorID.String(),
		CreatedAt: createdAt.Time,
	}}, nil
}

func (r *PostgresMessagingRepository) MarkDelivered(ctx context.Context, messageID string) error {
	if messageID == "" { return fmt.Errorf("message id is required") }
	return nil
}

func (r *ScyllaMessagingRepository) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	message, err := r.getMessageByID(ctx, messageID)
	if err != nil { return nil, err }
	return []*domain.MessageHistory{{
		MessageID: message.ID,
		Content: message.Content,
		Version: message.Version,
		AuthorID: message.SenderID,
		CreatedAt: message.CreatedAt,
	}}, nil
}

func (r *ScyllaMessagingRepository) MarkDelivered(ctx context.Context, messageID string) error {
	if messageID == "" { return fmt.Errorf("message id is required") }
	return nil
}

var _ domain.MessagingRepository = (*PostgresMessagingRepository)(nil)
var _ domain.MessagingRepository = (*ScyllaMessagingRepository)(nil)

var _ = db.Queries{}
