package transport

import (
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"

	"local/merope/internal/core/errors"
	"local/merope/internal/core/util"
	"local/merope/internal/modules/messaging/domain"
)

type UnreadHandler struct {
	pool *pgxpool.Pool
}

func NewUnreadHandler(pool *pgxpool.Pool) *UnreadHandler {
	return &UnreadHandler{pool: pool}
}

func (h *UnreadHandler) Get(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	roomID := strings.TrimSpace(c.Params("id"))
	if userID == "" || roomID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid user or room"})
	}

	var uid, rid pgtype.UUID
	if err := uid.Scan(userID); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid user id"})
	}
	if err := rid.Scan(roomID); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid room id"})
	}

	rows, err := h.pool.Query(c.Context(), `
		SELECT cm.id, cm.room_id, cm.author_id,
		       u.username, COALESCE(u.avatar_url, ''),
		       cm.content, cm.message_type, cm.encrypted_payload,
		       cm.is_encrypted, cm.is_burn_on_read, cm.expires_at,
		       cm.created_at, cm.updated_at
		FROM chat_messages cm
		JOIN chat_members member ON member.room_id = cm.room_id AND member.user_id = $2
		JOIN users u ON u.id = cm.author_id
		LEFT JOIN message_reads mr ON mr.message_id = cm.id AND mr.user_id = $2
		WHERE cm.room_id = $1
		  AND cm.author_id <> $2
		  AND mr.message_id IS NULL
		  AND COALESCE(cm.is_deleted, false) = false
		ORDER BY cm.created_at ASC
		LIMIT 100`, rid, uid)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.ErrInternal, "message": "Unable to load unread messages"})
	}
	defer rows.Close()

	messages := make([]fiber.Map, 0, 100)
	for rows.Next() {
		var id, room, author pgtype.UUID
		var username, avatar, content, messageType string
		var encryptedPayload pgtype.Text
		var isEncrypted, burnOnRead bool
		var expiresAt pgtype.Timestamptz
		var createdAt, updatedAt pgtype.Timestamptz

		if err := rows.Scan(&id, &room, &author, &username, &avatar, &content, &messageType,
			&encryptedPayload, &isEncrypted, &burnOnRead, &expiresAt, &createdAt, &updatedAt); err != nil {
			continue
		}

		msg := &domain.ChatMessage{
			ID:           util.UUIDToString(id),
			RoomID:       util.UUIDToString(room),
			SenderID:     util.UUIDToString(author),
			SenderName:   username,
			SenderAvatar: avatar,
			Content:      content,
			MessageType:  messageType,
			IsEncrypted:  isEncrypted,
			IsBurnOnRead: burnOnRead,
			CreatedAt:    createdAt.Time,
			UpdatedAt:    updatedAt.Time,
		}
		if encryptedPayload.Valid {
			value := encryptedPayload.String
			msg.EncryptedPayload = &value
		}
		if expiresAt.Valid {
			value := expiresAt.Time
			msg.ExpiresAt = &value
		}
		messages = append(messages, serializeMessage(msg))
	}

	return c.JSON(fiber.Map{"messages": messages})
}
