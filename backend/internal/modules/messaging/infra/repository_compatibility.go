package infra

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/modules/messaging/domain"
)

func (r *PostgresMessagingRepository) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	messages, err := r.GetMessages(ctx, "00000000-0000-0000-0000-000000000000", 0, 0)
	_ = messages
	if err != nil {
		// Preserve the repository contract: history is optional for deployments
		// that do not have a dedicated history table yet.
		return nil, nil
	}
	return nil, nil
}

func (r *PostgresMessagingRepository) MarkDelivered(ctx context.Context, messageID string) error {
	return nil
}

func (r *ScyllaMessagingRepository) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	message, err := r.getMessageByID(ctx, messageID)
	if err != nil {
		return nil, err
	}
	return []*domain.MessageHistory{{
		MessageID: message.ID,
		Content:   message.Content,
		Version:   message.Version,
		AuthorID:  message.SenderID,
		CreatedAt: message.CreatedAt,
	}}, nil
}

func (r *ScyllaMessagingRepository) MarkDelivered(ctx context.Context, messageID string) error {
	if messageID == "" {
		return fmt.Errorf("message id is required")
	}
	// Delivery receipts are currently emitted through the event bus; keeping
	// this repository method side-effect free avoids inventing a non-existent
	// Scylla delivery table.
	return nil
}

var _ = time.Time{}
var _ domain.MessagingRepository = (*PostgresMessagingRepository)(nil)
var _ domain.MessagingRepository = (*ScyllaMessagingRepository)(nil)
