package infra

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/gocql/gocql"
	"github.com/google/uuid"

	"local/merope/internal/modules/messaging/domain"
	"local/merope/internal/platform/scylla"
)

type ScyllaMessagingRepository struct {
	client *scylla.Client
}

func NewScyllaMessagingRepository(client *scylla.Client) *ScyllaMessagingRepository {
	return &ScyllaMessagingRepository{client: client}
}

func (r *ScyllaMessagingRepository) CreateRoom(ctx context.Context, name string, isGroup bool, userIDs []string) (*domain.ChatRoom, error) {
	return nil, errors.New("room creation uses PostgreSQL as source of truth")
}

func (r *ScyllaMessagingRepository) SendMessage(ctx context.Context, msg *domain.ChatMessage) (*domain.ChatMessage, error) {
	roomUUID, err := uuid.Parse(msg.RoomID)
	if err != nil {
		return nil, fmt.Errorf("invalid room_id: %w", err)
	}

	msgUUID, err := uuid.Parse(msg.ID)
	if err != nil {
		return nil, fmt.Errorf("invalid message_id: %w", err)
	}

	senderUUID, err := uuid.Parse(msg.SenderID)
	if err != nil {
		return nil, fmt.Errorf("invalid sender_id: %w", err)
	}

	now := time.Now().UnixMilli()
	var parentUUID *uuid.UUID
	if msg.ParentID != nil && *msg.ParentID != "" {
		parsed, err := uuid.Parse(*msg.ParentID)
		if err == nil {
			parentUUID = &parsed
		}
	}

	var encPayload interface{}
	if msg.EncryptedPayload != nil {
		encPayload = *msg.EncryptedPayload
	} else {
		encPayload = ""
	}

	batch := r.client.Session.NewBatch(gocql.LoggedBatch)
	batch.SetConsistency(gocql.LocalQuorum)

	batch.Query(
		`INSERT INTO chat_messages_by_room (room_id, created_at, message_id, sender_id, sender_name, sender_avatar, content, message_type, voice_url, file_url, is_edited, is_pinned, is_encrypted, encrypted_payload, parent_id, reactions, version)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		roomUUID, now, msgUUID, senderUUID, msg.SenderName, msg.SenderAvatar, msg.Content, msg.MessageType, msg.VoiceURL, msg.FileURL, false, false, msg.IsEncrypted, encPayload, parentUUID, map[string][]string{}, 1,
	)

	batch.Query(
		`INSERT INTO chat_message_by_id (message_id, room_id, sender_id, sender_name, sender_avatar, content, message_type, voice_url, file_url, is_edited, is_pinned, is_encrypted, encrypted_payload, parent_id, reactions, version, created_at, updated_at)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		msgUUID, roomUUID, senderUUID, msg.SenderName, msg.SenderAvatar, msg.Content, msg.MessageType, msg.VoiceURL, msg.FileURL, false, false, msg.IsEncrypted, encPayload, parentUUID, map[string][]string{}, 1, now, now,
	)

	if err := r.client.Session.ExecuteBatch(batch); err != nil {
		return nil, fmt.Errorf("failed to write chat message to ScyllaDB: %w", err)
	}

	return msg, nil
}

func (r *ScyllaMessagingRepository) UpdateMessage(ctx context.Context, messageID, senderID, content string) (*domain.ChatMessage, error) {
	mid, err := uuid.Parse(messageID)
	if err != nil {
		return nil, fmt.Errorf("invalid message_id: %w", err)
	}

	now := time.Now().UnixMilli()
	err = r.client.Exec(ctx,
		`UPDATE chat_message_by_id SET content = ?, is_edited = true, updated_at = ? WHERE message_id = ?`,
		content, now, mid,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to update message in ScyllaDB: %w", err)
	}

	return r.getMessageByID(ctx, messageID)
}

func (r *ScyllaMessagingRepository) DeleteMessage(ctx context.Context, messageID, senderID string) error {
	mid, err := uuid.Parse(messageID)
	if err != nil {
		return fmt.Errorf("invalid message_id: %w", err)
	}

	return r.client.Exec(ctx,
		`UPDATE chat_message_by_id SET content = '', is_edited = true, updated_at = ? WHERE message_id = ?`,
		time.Now().UnixMilli(), mid,
	)
}

func (r *ScyllaMessagingRepository) GetMessages(ctx context.Context, roomID string, limit, offset int32) ([]*domain.ChatMessage, error) {
	roomUUID, err := uuid.Parse(roomID)
	if err != nil {
		return nil, fmt.Errorf("invalid room_id: %w", err)
	}

	if limit <= 0 || limit > 100 {
		limit = 50
	}

	messages := make([]*domain.ChatMessage, 0, limit)

	q := r.client.Session.Query(
		`SELECT created_at, message_id, sender_id, sender_name, sender_avatar, content, message_type, voice_url, file_url, is_edited, is_pinned, is_encrypted, encrypted_payload, parent_id, reactions, version
		 FROM chat_messages_by_room
		 WHERE room_id = ?
		 LIMIT ?`,
		roomUUID, limit,
	).WithContext(ctx).Iter()

	var createdAt int64
	var messageID, senderID uuid.UUID
	var senderName, senderAvatar, content, msgType, voiceURL, fileURL, encryptedPayload string
	var isEdited, isPinned, isEncrypted bool
	var parentID uuid.UUID
	var reactions map[string][]string
	var version int

	for q.Scan(
		&createdAt, &messageID, &senderID, &senderName, &senderAvatar,
		&content, &msgType, &voiceURL, &fileURL,
		&isEdited, &isPinned, &isEncrypted, &encryptedPayload,
		&parentID, &reactions, &version,
	) {
		var pid *string
		if !isUUIDZero(parentID) {
			s := parentID.String()
			pid = &s
		}

		var encPayload *string
		if encryptedPayload != "" {
			encPayload = &encryptedPayload
		}

		messages = append(messages, &domain.ChatMessage{
			ID:               messageID.String(),
			RoomID:           roomID,
			SenderID:         senderID.String(),
			SenderName:       senderName,
			SenderAvatar:     senderAvatar,
			ParentID:         pid,
			Content:          content,
			EncryptedPayload: encPayload,
			MessageType:      msgType,
			VoiceURL:         voiceURL,
			FileURL:          fileURL,
			IsEdited:         isEdited,
			IsPinned:         isPinned,
			IsEncrypted:      isEncrypted,
			Reactions:        reactions,
			Version:          int32(version),
			CreatedAt:        time.UnixMilli(createdAt),
			UpdatedAt:        time.UnixMilli(createdAt),
		})
	}

	if err := q.Close(); err != nil {
		return nil, fmt.Errorf("failed to iterate chat messages: %w", err)
	}

	return messages, nil
}

func (r *ScyllaMessagingRepository) GetUserRooms(ctx context.Context, userID string) ([]*domain.ChatRoom, error) {
	uid, err := uuid.Parse(userID)
	if err != nil {
		return nil, fmt.Errorf("invalid user_id: %w", err)
	}

	var rooms []*domain.ChatRoom
	q := r.client.Session.Query(
		`SELECT room_id, name, is_group, is_e2ee, is_archived, created_at FROM user_rooms WHERE user_id = ?`,
		uid,
	).WithContext(ctx).Iter()

	var roomID uuid.UUID
	var name string
	var isGroup, isE2EE, isArchived bool
	var createdAt int64

	for q.Scan(&roomID, &name, &isGroup, &isE2EE, &isArchived, &createdAt) {
		rooms = append(rooms, &domain.ChatRoom{
			ID:            roomID.String(),
			Name:          name,
			IsGroup:       isGroup,
			IsE2EEEnabled: isE2EE,
			IsArchived:    isArchived,
			CreatedAt:     time.UnixMilli(createdAt),
		})
	}

	if err := q.Close(); err != nil {
		return nil, fmt.Errorf("failed to iterate user rooms: %w", err)
	}

	return rooms, nil
}

func (r *ScyllaMessagingRepository) CacheUserRooms(ctx context.Context, userID string, rooms []*domain.ChatRoom) error {
	uid, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}

	batch := r.client.Session.NewBatch(gocql.LoggedBatch)
	for _, room := range rooms {
		rid, err := uuid.Parse(room.ID)
		if err != nil {
			continue
		}
		batch.Query(
			`INSERT INTO user_rooms (user_id, room_id, name, is_group, is_e2ee, is_archived, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)`,
			uid, rid, room.Name, room.IsGroup, room.IsE2EEEnabled, room.IsArchived, room.CreatedAt.UnixMilli(),
		)
	}

	return r.client.Session.ExecuteBatch(batch)
}

func (r *ScyllaMessagingRepository) SearchMessages(ctx context.Context, roomID, query string) ([]*domain.ChatMessage, error) {
	return nil, errors.New("full-text search requires ClickHouse/Elasticsearch")
}

func (r *ScyllaMessagingRepository) PinMessage(ctx context.Context, roomID, messageID string, pinned bool) error {
	mid, err := uuid.Parse(messageID)
	if err != nil {
		return fmt.Errorf("invalid message_id: %w", err)
	}
	return r.client.Exec(ctx,
		`UPDATE chat_message_by_id SET is_pinned = ? WHERE message_id = ?`,
		pinned, mid,
	)
}

func (r *ScyllaMessagingRepository) MarkRead(ctx context.Context, messageID, userID string) error {
	return nil
}

func (r *ScyllaMessagingRepository) AddReaction(ctx context.Context, messageID, userID, emoji string) error {
	return r.toggleReaction(ctx, messageID, userID, emoji, true)
}

func (r *ScyllaMessagingRepository) RemoveReaction(ctx context.Context, messageID, userID, emoji string) error {
	return r.toggleReaction(ctx, messageID, userID, emoji, false)
}

func (r *ScyllaMessagingRepository) toggleReaction(ctx context.Context, messageID, userID, emoji string, add bool) error {
	mid, err := uuid.Parse(messageID)
	if err != nil {
		return fmt.Errorf("invalid message_id: %w", err)
	}
	uid, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}
	now := time.Now().UnixMilli()

	if add {
		return r.client.Exec(ctx,
			`UPDATE reactions_by_target SET created_at = ? WHERE target_id = ? AND reaction_type = ? AND user_id = ?`,
			now, mid, emoji, uid,
		)
	}
	return r.client.Exec(ctx,
		`DELETE FROM reactions_by_target WHERE target_id = ? AND reaction_type = ? AND user_id = ?`,
		mid, emoji, uid,
	)
}

func (r *ScyllaMessagingRepository) MuteRoom(ctx context.Context, userID, roomID string, until *string) error {
	return nil
}

func (r *ScyllaMessagingRepository) ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error {
	return nil
}

func (r *ScyllaMessagingRepository) CreateFolder(ctx context.Context, userID, name string, roomIDs []string) (*domain.ChatFolder, error) {
	return nil, errors.New("folders use PostgreSQL")
}

func (r *ScyllaMessagingRepository) GetFolders(ctx context.Context, userID string) ([]*domain.ChatFolder, error) {
	return nil, nil
}

func (r *ScyllaMessagingRepository) GetRoomMedia(ctx context.Context, roomID string) ([]string, error) {
	return nil, nil
}

func (r *ScyllaMessagingRepository) GetMessageByID(ctx context.Context, messageID string) (*domain.ChatMessage, error) {
	return r.getMessageByID(ctx, messageID)
}

func (r *ScyllaMessagingRepository) getMessageByID(ctx context.Context, messageID string) (*domain.ChatMessage, error) {
	mid, err := uuid.Parse(messageID)
	if err != nil {
		return nil, err
	}

	var (
		roomID, senderID                                                                uuid.UUID
		senderName, senderAvatar, content, msgType, voiceURL, fileURL, encryptedPayload string
		isEdited, isPinned, isEncrypted                                                 bool
		parentID                                                                        uuid.UUID
		reactions                                                                       map[string][]string
		version                                                                         int
		createdAt, updatedAt                                                            int64
	)

	err = r.client.Session.Query(
		`SELECT room_id, sender_id, sender_name, sender_avatar, content, message_type, voice_url, file_url, is_edited, is_pinned, is_encrypted, encrypted_payload, parent_id, reactions, version, created_at, updated_at
		 FROM chat_message_by_id
		 WHERE message_id = ?`, mid,
	).WithContext(ctx).Scan(
		&roomID, &senderID, &senderName, &senderAvatar, &content, &msgType, &voiceURL, &fileURL,
		&isEdited, &isPinned, &isEncrypted, &encryptedPayload,
		&parentID, &reactions, &version, &createdAt, &updatedAt,
	)

	if err == gocql.ErrNotFound {
		return nil, fmt.Errorf("message not found: %s", messageID)
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get message: %w", err)
	}

	var pid *string
	if !isUUIDZero(parentID) {
		s := parentID.String()
		pid = &s
	}

	var encPayload *string
	if encryptedPayload != "" {
		encPayload = &encryptedPayload
	}

	return &domain.ChatMessage{
		ID:               messageID,
		RoomID:           roomID.String(),
		SenderID:         senderID.String(),
		SenderName:       senderName,
		SenderAvatar:     senderAvatar,
		ParentID:         pid,
		Content:          content,
		EncryptedPayload: encPayload,
		MessageType:      msgType,
		VoiceURL:         voiceURL,
		FileURL:          fileURL,
		IsEdited:         isEdited,
		IsPinned:         isPinned,
		IsEncrypted:      isEncrypted,
		Reactions:        reactions,
		Version:          int32(version),
		CreatedAt:        time.UnixMilli(createdAt),
		UpdatedAt:        time.UnixMilli(updatedAt),
	}, nil
}

func (r *ScyllaMessagingRepository) SetE2EEStatus(ctx context.Context, roomID string, enabled bool) error {
	return nil
}

func (r *ScyllaMessagingRepository) GetE2EEStatus(ctx context.Context, roomID string) (bool, error) {
	return false, nil
}

func (r *ScyllaMessagingRepository) GetRoomMembers(ctx context.Context, roomID string) ([]*domain.ChatRoomMember, error) {
	return nil, nil
}

func (r *ScyllaMessagingRepository) RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error {
	return nil
}

func (r *ScyllaMessagingRepository) GetKeyRotations(ctx context.Context, roomID string) ([]*domain.E2EEKeyRotation, error) {
	return nil, nil
}

func isUUIDZero(id uuid.UUID) bool {
	var zero uuid.UUID
	return id == zero
}
