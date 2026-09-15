package transport

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"local/merope/internal/core/errors"
	"local/merope/internal/core/pool"
	"local/merope/internal/modules/messaging/domain"
)

type MessagingContractHandler struct {
	service domain.MessagingService
}

func NewMessagingContractHandler(service domain.MessagingService) *MessagingContractHandler {
	return &MessagingContractHandler{service: service}
}

func (h *MessagingContractHandler) GetRooms(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	rooms, err := h.service.GetUserRooms(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to load conversations"})
	}

	conversations := make([]fiber.Map, 0, len(rooms))
	for _, room := range rooms {
		if room == nil {
			continue
		}
		lastActivity := room.CreatedAt.UnixMilli()
		conversations = append(conversations, fiber.Map{
			"id":                     room.ID,
			"title":                  room.Name,
			"other_user_name":       room.Name,
			"other_user_id":         "",
			"other_user_avatar":     "",
			"description":            "",
			"participants":           []string{},
			"unread_count":           0,
			"last_message":           "",
			"last_message_timestamp": lastActivity,
			"lastActivity":           lastActivity,
			"is_group":               room.IsGroup,
			"is_e2ee_enabled":        room.IsE2EEEnabled,
			"is_archived":            room.IsArchived,
		})
	}
	return c.JSON(fiber.Map{"conversations": conversations, "rooms": conversations})
}

func (h *MessagingContractHandler) GetHistory(c *fiber.Ctx) error {
	roomID := strings.TrimSpace(c.Params("id"))
	if roomID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid room id"})
	}

	page := int32(0)
	cursor := strings.TrimSpace(c.Query("cursor"))
	if cursor != "" {
		parsed, err := strconv.ParseInt(cursor, 10, 32)
		if err != nil || parsed < 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid cursor"})
		}
		page = int32(parsed)
	} else if raw := c.Query("page"); raw != "" {
		parsed, err := strconv.ParseInt(raw, 10, 32)
		if err != nil || parsed < 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid page"})
		}
		page = int32(parsed)
	}

	messages, err := h.service.GetRoomHistory(c.Context(), roomID, page)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to load messages"})
	}
	encoded := make([]fiber.Map, 0, len(messages))
	for _, msg := range messages {
		encoded = append(encoded, serializeMessage(msg))
	}

	hasMore := len(messages) == 50
	nextCursor := ""
	if hasMore {
		nextCursor = strconv.FormatInt(int64(page+1), 10)
	}
	return c.JSON(fiber.Map{"messages": encoded, "next_cursor": nextCursor, "has_more": hasMore})
}

func (h *MessagingContractHandler) SendMessage(c *fiber.Ctx) error {
	senderID, _ := c.Locals("user_id").(string)
	roomID := strings.TrimSpace(c.Params("id"))
	if senderID == "" || roomID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Invalid sender or room"})
	}

	type request struct {
		Content          string  `json:"content"`
		EncryptedPayload *string `json:"encrypted_payload"`
		ParentID         *string `json:"parent_id"`
		Encrypt          bool    `json:"encrypt"`
		IsEncrypted      bool    `json:"is_encrypted"`
		MessageType      string  `json:"message_type"`
		VoiceURL         string  `json:"voice_url"`
		FileURL          string  `json:"file_url"`
		BurnOnRead       bool    `json:"burn_on_read"`
		ExpiresInSeconds int     `json:"expires_in_seconds"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrBadRequest, "message": "Invalid request body"})
	}

	if len(req.Content) > 64*1024 || (req.EncryptedPayload != nil && len(*req.EncryptedPayload) > 1024*1024) {
		return c.Status(fiber.StatusRequestEntityTooLarge).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Message payload is too large"})
	}
	mType := strings.TrimSpace(req.MessageType)
	if mType == "" {
		mType = "text"
	}
	var expiresAt *time.Time
	if req.ExpiresInSeconds > 0 {
		if req.ExpiresInSeconds > 30*24*60*60 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code": errors.ErrValidation, "message": "Message expiry is too long"})
		}
		t := time.Now().Add(time.Duration(req.ExpiresInSeconds) * time.Second)
		expiresAt = &t
	}

	buf := pool.GetBuffer()
	buf.WriteString("MSG_INCOMING|")
	buf.WriteString(senderID)
	buf.WriteByte('|')
	buf.WriteString(roomID)
	pool.PutBuffer(buf)

	msg := &domain.ChatMessage{
		RoomID:           roomID,
		SenderID:         senderID,
		Content:          req.Content,
		EncryptedPayload: req.EncryptedPayload,
		ParentID:         req.ParentID,
		IsEncrypted:      req.Encrypt || req.IsEncrypted,
		MessageType:      mType,
		VoiceURL:         req.VoiceURL,
		FileURL:          req.FileURL,
		IsBurnOnRead:     req.BurnOnRead,
		ExpiresAt:        expiresAt,
	}

	sent, err := h.service.SendMessage(c.Context(), msg)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to send message"})
	}
	return c.Status(fiber.StatusCreated).JSON(serializeMessage(sent))
}

func serializeMessage(msg *domain.ChatMessage) fiber.Map {
	if msg == nil {
		return fiber.Map{}
	}
	reactions := make([]string, 0, len(msg.Reactions))
	for emoji := range msg.Reactions {
		reactions = append(reactions, emoji)
	}
	return fiber.Map{
		"id":                msg.ID,
		"room_id":           msg.RoomID,
		"channel_id":        msg.RoomID,
		"author_id":         msg.SenderID,
		"author_username":   msg.SenderName,
		"author_name":       msg.SenderName,
		"author_avatar_url": msg.SenderAvatar,
		"author_avatar":     msg.SenderAvatar,
		"content":            msg.Content,
		"encrypted_payload":  msg.EncryptedPayload,
		"type":              msg.MessageType,
		"message_type":      msg.MessageType,
		"parent_id":         msg.ParentID,
		"forwarded_from_id": msg.ForwardedFromID,
		"voice_url":         msg.VoiceURL,
		"file_url":          msg.FileURL,
		"effect":            msg.Effect,
		"sticker_id":        msg.StickerID,
		"is_edited":         msg.IsEdited,
		"is_pinned":         msg.IsPinned,
		"is_encrypted":      msg.IsEncrypted,
		"is_deleted":        msg.IsDeleted,
		"is_burn_on_read":   msg.IsBurnOnRead,
		"expires_at":        unixMilliPtr(msg.ExpiresAt),
		"scheduled_at":      unixMilliPtr(msg.ScheduledAt),
		"status":            msg.Status,
		"reactions":        reactions,
		"version":           msg.Version,
		"timestamp":         msg.CreatedAt.UnixMilli(),
		"created_at":        msg.CreatedAt.UnixMilli(),
		"updated_at":        msg.UpdatedAt.UnixMilli(),
		"blocks":             []fiber.Map{},
	}
}

func unixMilliPtr(t *time.Time) interface{} {
	if t == nil {
		return nil
	}
	return t.UnixMilli()
}

func (h *MessagingContractHandler) String() string {
	return fmt.Sprintf("MessagingContractHandler{%T}", h.service)
}
