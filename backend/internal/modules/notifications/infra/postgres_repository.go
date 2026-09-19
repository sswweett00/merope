package infra

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/notifications/domain"
)

type PostgresNotificationsRepository struct {
	queries *db.Queries
}

func NewPostgresNotificationsRepository(queries *db.Queries) *PostgresNotificationsRepository {
	return &PostgresNotificationsRepository{queries: queries}
}

func parseNotificationUUID(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}

func (r *PostgresNotificationsRepository) Create(ctx context.Context, n *domain.Notification) error {
	userID, err := parseNotificationUUID(n.ReceiverID)
	if err != nil {
		return err
	}

	var actorID *pgtype.UUID
	if n.SenderID != nil && strings.TrimSpace(*n.SenderID) != "" {
		id, parseErr := parseNotificationUUID(*n.SenderID)
		if parseErr != nil {
			return parseErr
		}
		actorID = &id
	}

	var entityID *pgtype.UUID
	if strings.TrimSpace(n.EntityID) != "" {
		id, parseErr := parseNotificationUUID(n.EntityID)
		if parseErr != nil {
			return parseErr
		}
		entityID = &id
	}

	payload := n.Data
	if payload == nil {
		payload = map[string]interface{}{}
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	var id pgtype.UUID
	if strings.TrimSpace(n.ID) != "" {
		id, err = parseNotificationUUID(n.ID)
		if err != nil {
			return err
		}
	} else {
		id = pgtype.UUID{Bytes: uuid.New(), Valid: true}
		n.ID = util.UUIDToString(id)
	}

	var createdAt pgtype.Timestamptz
	err = r.queries.QueryRow(ctx, `
INSERT INTO notifications (id, user_id, actor_id, type, entity_type, entity_id, payload, is_read)
VALUES ($1, $2, $3, $4, NULLIF($5, ''), $6, $7::jsonb, $8)
RETURNING created_at`, id, userID, actorID, n.Type, n.EntityType, entityID, payloadBytes, n.IsRead).Scan(&createdAt)
	if err != nil {
		return err
	}
	n.CreatedAt = createdAt.Time
	return nil
}

func (r *PostgresNotificationsRepository) GetForUser(ctx context.Context, userID string, limit, offset int32) ([]*domain.Notification, error) {
	uid, err := parseNotificationUUID(userID)
	if err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}

	rows, err := r.queries.Query(ctx, `
SELECT n.id, n.user_id, n.actor_id, COALESCE(u.username, ''), COALESCE(u.avatar_url, ''),
       n.type, COALESCE(n.entity_type, ''), n.entity_id, n.payload, n.is_read, n.created_at
FROM notifications n
LEFT JOIN users u ON u.id = n.actor_id
WHERE n.user_id = $1
ORDER BY n.created_at DESC, n.id DESC
LIMIT $2 OFFSET $3`, uid, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make([]*domain.Notification, 0)
	for rows.Next() {
		var id, receiverID pgtype.UUID
		var senderID *pgtype.UUID
		var senderUsername, senderAvatar, nType, entityType string
		var entityID *pgtype.UUID
		var payload []byte
		var isRead bool
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&id, &receiverID, &senderID, &senderUsername, &senderAvatar, &nType, &entityType, &entityID, &payload, &isRead, &createdAt); err != nil {
			return nil, err
		}

		data := map[string]interface{}{}
		if len(payload) != 0 {
			if unmarshalErr := json.Unmarshal(payload, &data); unmarshalErr != nil {
				return nil, fmt.Errorf("invalid notification payload: %w", unmarshalErr)
			}
		}

		n := &domain.Notification{
			ID:             util.UUIDToString(id),
			ReceiverID:     util.UUIDToString(receiverID),
			SenderUsername: senderUsername,
			SenderAvatar:   senderAvatar,
			Type:           nType,
			EntityType:     entityType,
			Data:           data,
			IsRead:         isRead,
			CreatedAt:      createdAt.Time,
			Category:       "social",
			Source:         "server",
		}
		if senderID != nil && senderID.Valid {
			value := util.UUIDToString(*senderID)
			n.SenderID = &value
		}
		if entityID != nil && entityID.Valid {
			n.EntityID = util.UUIDToString(*entityID)
		}
		result = append(result, n)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

func (r *PostgresNotificationsRepository) ClearForUser(ctx context.Context, userID string) error {
	uid, err := parseNotificationUUID(userID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `DELETE FROM notifications WHERE user_id = $1`, uid)
	return err
}

var _ domain.RuntimeNotificationRepository = (*PostgresNotificationsRepository)(nil)
