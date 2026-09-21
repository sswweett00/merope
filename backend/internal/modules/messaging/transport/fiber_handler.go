package transport

import (
	"strconv"
	"time"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/core/errors"
	"local/merope/internal/core/pool"
	"local/merope/internal/modules/messaging/domain"
)

type MessagingHandler struct {
	service domain.MessagingService
}

func NewMessagingHandler(service domain.MessagingService) *MessagingHandler {
	return &MessagingHandler{service: service}
}

func (h *MessagingHandler) CreateDirectChat(c *fiber.Ctx) error {
	userA := c.Locals("user_id").(string)
	type request struct {
		UserID string `json:"user_id"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	room, err := h.service.StartDirectChat(c.Context(), userA, req.UserID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(room)
}

func (h *MessagingHandler) CreateGroupChat(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		Name    string   `json:"name"`
		UserIDs []string `json:"user_ids"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	room, err := h.service.CreateGroupChat(c.Context(), req.Name, append(req.UserIDs, userID))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(room)
}

func (h *MessagingHandler) GetE2EEPublicKey(c *fiber.Ctx) error {
	userID := c.Params("user_id")
	// In production, fetch from secure key store
	return c.JSON(fiber.Map{
		"user_id":    userID,
		"public_key": "merope-public-key-placeholder",
		"algorithm":  "x25519",
	})
}

func (h *MessagingHandler) UploadE2EEPublicKey(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		PublicKey string `json:"public_key"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}
	// In production, store in secure key store
	return c.JSON(fiber.Map{
		"user_id":    userID,
		"public_key": req.PublicKey,
		"status":     "stored",
	})
}

func (h *MessagingHandler) GetRooms(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	rooms, err := h.service.GetUserRooms(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.JSON(rooms)
}

func (h *MessagingHandler) SendMessage(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)
	roomID := c.Params("id")
	type request struct {
		Content          string  `json:"content"`
		EncryptedPayload *string `json:"encrypted_payload"`
		ParentID         *string `json:"parent_id"`
		Encrypt          bool    `json:"encrypt"`
		MessageType      string  `json:"message_type"`
		VoiceURL         string  `json:"voice_url"`
		FileURL          string  `json:"file_url"`
		BurnOnRead       bool    `json:"burn_on_read"`
		ExpiresInSeconds int     `json:"expires_in_seconds"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	// High-Performance Trace Construction using BufferPool
	auditBuf := pool.GetBuffer()
	auditBuf.WriteString("MSG_INCOMING|")
	auditBuf.WriteString(senderID)
	auditBuf.WriteByte('|')
	auditBuf.WriteString(roomID)
	// slog.Debug(auditBuf.String()) // Offloaded to high-speed logger in production
	pool.PutBuffer(auditBuf)

	mType := req.MessageType
	if mType == "" {
		mType = "text"
	}

	var expiresAt *time.Time
	if req.ExpiresInSeconds > 0 {
		t := time.Now().Add(time.Duration(req.ExpiresInSeconds) * time.Second)
		expiresAt = &t
	}

	msg := &domain.ChatMessage{
		RoomID:           roomID,
		SenderID:         senderID,
		Content:          req.Content,
		EncryptedPayload: req.EncryptedPayload,
		ParentID:         req.ParentID,
		IsEncrypted:      req.Encrypt,
		MessageType:      mType,
		VoiceURL:         req.VoiceURL,
		FileURL:          req.FileURL,
		IsBurnOnRead:     req.BurnOnRead,
		ExpiresAt:        expiresAt,
	}

	sent, err := h.service.SendMessage(c.Context(), msg)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(sent)
}

func (h *MessagingHandler) EditMessage(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)
	messageID := c.Params("msg_id")
	type request struct {
		Content string `json:"content"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	msg, err := h.service.EditMessage(c.Context(), messageID, senderID, req.Content)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(msg)
}

func (h *MessagingHandler) DeleteMessage(c *fiber.Ctx) error {
	senderID := c.Locals("user_id").(string)
	messageID := c.Params("msg_id")

	err := h.service.DeleteMessage(c.Context(), messageID, senderID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.SendStatus(fiber.StatusNoContent)
}

func (h *MessagingHandler) React(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	messageID := c.Params("msg_id")
	type request struct {
		Emoji string `json:"emoji"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	err := h.service.AddReaction(c.Context(), messageID, userID, req.Emoji)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *MessagingHandler) SendTypingIndicator(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	roomID := c.Params("id")
	if err := h.service.SendTypingIndicator(c.Context(), roomID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to publish typing state",
		})
	}
	return c.SendStatus(fiber.StatusNoContent)
}

func (h *MessagingHandler) MuteRoom(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	roomID := c.Params("id")
	type request struct {
		Minutes int `json:"minutes"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	err := h.service.MuteRoom(c.Context(), userID, roomID, req.Minutes)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *MessagingHandler) GetHistory(c *fiber.Ctx) error {
	roomID := c.Params("id")
	pageStr := c.Query("page", "0")
	page, _ := strconv.Atoi(pageStr)

	msgs, err := h.service.GetRoomHistory(c.Context(), roomID, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"messages": msgs})
}

func (h *MessagingHandler) GetMessageEdits(c *fiber.Ctx) error {
	messageID := c.Params("msg_id")

	history, err := h.service.GetMessageHistory(c.Context(), messageID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"history": history})
}

func (h *MessagingHandler) EnableE2EE(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	roomID := c.Params("id")

	if err := h.service.EnableE2EE(c.Context(), roomID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"room_id": roomID, "e2ee_enabled": true})
}

func (h *MessagingHandler) DisableE2EE(c *fiber.Ctx) error {
	roomID := c.Params("id")

	if err := h.service.DisableE2EE(c.Context(), roomID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *MessagingHandler) GetE2EEStatus(c *fiber.Ctx) error {
	roomID := c.Params("id")

	isE2EE, err := h.service.GetE2EEStatus(c.Context(), roomID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"room_id": roomID, "e2ee_enabled": isE2EE})
}

func (h *MessagingHandler) RecordKeyRotation(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	roomID := c.Params("id")
	type request struct {
		PublicKeyID string `json:"public_key_id"`
		DeviceID    string `json:"device_id"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	if err := h.service.RecordKeyRotation(c.Context(), roomID, userID, req.PublicKeyID, req.DeviceID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *MessagingHandler) MarkAsRead(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		MessageID string `json:"message_id"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}
	if err := h.service.MarkAsRead(c.Context(), req.MessageID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.SendStatus(fiber.StatusOK)
}
