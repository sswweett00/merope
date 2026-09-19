package infra

import (
	"context"
	"database/sql"
	"time"
	"strings"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/messaging/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresMessagingRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresMessagingRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresMessagingRepository {
	return &PostgresMessagingRepository{queries: queries, pool: pool}
}

func (r *PostgresMessagingRepository) CreateRoom(ctx context.Context, name string, isGroup bool, userIDs []string) (*domain.ChatRoom, error) {
	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return nil, fmt.Errorf("begin room transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	var dbRoom domain.ChatRoom
	err = tx.QueryRow(ctx,
		"INSERT INTO chat_rooms (name, is_group, is_e2ee_enabled) VALUES ($1, $2, $3) RETURNING id, name, is_group, is_e2ee_enabled, created_at",
		name, isGroup, false).Scan(&dbRoom.ID, &dbRoom.Name, &dbRoom.IsGroup, &dbRoom.IsE2EEEnabled, &dbRoom.CreatedAt)
	if err != nil {
		return nil, err
	}

	seen := make(map[string]struct{}, len(userIDs))
	for _, uid := range userIDs {
		uid = strings.TrimSpace(uid)
		if uid == "" {
			return nil, fmt.Errorf("chat member id is required")
		}
		if _, exists := seen[uid]; exists {
			continue
		}
		seen[uid] = struct{}{}

		var memberID pgtype.UUID
		if err := memberID.Scan(uid); err != nil {
			return nil, fmt.Errorf("invalid chat member id: %w", err)
		}
		if _, err := tx.Exec(ctx, "INSERT INTO chat_members (room_id, user_id, role) VALUES ($1, $2, $3)", dbRoom.ID, memberID, "member"); err != nil {
			return nil, fmt.Errorf("add chat member: %w", err)
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, fmt.Errorf("commit room transaction: %w", err)
	}
	return &dbRoom, nil
}

func (r *PostgresMessagingRepository) SendMessage(ctx context.Context, msg *domain.ChatMessage) (*domain.ChatMessage, error) {
	var rid, aid, pid pgtype.UUID
	_ = rid.Scan(msg.RoomID)
	_ = aid.Scan(msg.SenderID)
	if msg.ParentID != nil {
		_ = pid.Scan(*msg.ParentID)
	}

	var encPayload sql.NullString
	if msg.EncryptedPayload != nil && *msg.EncryptedPayload != "" {
		encPayload = sql.NullString{String: *msg.EncryptedPayload, Valid: true}
	}

	dbMsg, err := r.queries.CreateChatMessage(ctx, db.CreateChatMessageParams{
		RoomID:          rid,
		AuthorID:        aid,
		ParentID:        pid,
		Content:         msg.Content,
		MessageType:     msg.MessageType,
		VoiceUrl:        pgtype.Text{String: msg.VoiceURL, Valid: msg.VoiceURL != ""},
		IsEncrypted:     msg.IsEncrypted,
	})
	if err != nil {
		return nil, err
	}

	var pID *string
	if dbMsg.ParentID.Valid {
		s := util.UUIDToString(dbMsg.ParentID)
		pID = &s
	}
	var enc *string
	if encPayload.Valid {
		enc = &encPayload.String
	}

	return &domain.ChatMessage{
		ID:               util.UUIDToString(dbMsg.ID),
		RoomID:           util.UUIDToString(dbMsg.RoomID),
		SenderID:         util.UUIDToString(dbMsg.AuthorID),
		ParentID:         pID,
		Content:          dbMsg.Content,
		EncryptedPayload: enc,
		MessageType:      dbMsg.MessageType,
		IsEdited:         dbMsg.IsEdited,
		IsEncrypted:      dbMsg.IsEncrypted,
		CreatedAt:        dbMsg.CreatedAt.Time,
		UpdatedAt:        dbMsg.UpdatedAt.Time,
	}, nil
}

func (r *PostgresMessagingRepository) UpdateMessage(ctx context.Context, messageID, senderID, content string) (*domain.ChatMessage, error) {
	var mid, aid pgtype.UUID
	_ = mid.Scan(messageID)
	_ = aid.Scan(senderID)

	dbMsg, err := r.queries.UpdateChatMessage(ctx, db.UpdateChatMessageParams{
		ID:       mid,
		AuthorID: aid,
		Content:  content,
	})
	if err != nil {
		return nil, err
	}

	var pID *string
	if dbMsg.ParentID.Valid {
		s := util.UUIDToString(dbMsg.ParentID)
		pID = &s
	}

	return &domain.ChatMessage{
		ID:          util.UUIDToString(dbMsg.ID),
		RoomID:      util.UUIDToString(dbMsg.RoomID),
		SenderID:    util.UUIDToString(dbMsg.AuthorID),
		ParentID:    pID,
		Content:     dbMsg.Content,
		MessageType: dbMsg.MessageType,
		IsEdited:    dbMsg.IsEdited,
		IsEncrypted: dbMsg.IsEncrypted,
		CreatedAt:   dbMsg.CreatedAt.Time,
		UpdatedAt:   dbMsg.UpdatedAt.Time,
	}, nil
}

func (r *PostgresMessagingRepository) mapMessage(dbMsg *db.ChatMessage) *domain.ChatMessage {
	var pID *string
	if dbMsg.ParentID.Valid {
		s := util.UUIDToString(dbMsg.ParentID)
		pID = &s
	}
	return &domain.ChatMessage{
		ID:          util.UUIDToString(dbMsg.ID),
		RoomID:      util.UUIDToString(dbMsg.RoomID),
		SenderID:    util.UUIDToString(dbMsg.AuthorID),
		ParentID:    pID,
		Content:     dbMsg.Content,
		MessageType: dbMsg.MessageType,
		IsEdited:    dbMsg.IsEdited,
		IsEncrypted: dbMsg.IsEncrypted,
		CreatedAt:   dbMsg.CreatedAt.Time,
		UpdatedAt:   dbMsg.UpdatedAt.Time,
	}
}

func (r *PostgresMessagingRepository) GetMessages(ctx context.Context, roomID string, limit, offset int32) ([]*domain.ChatMessage, error) {
	var rid pgtype.UUID
	_ = rid.Scan(roomID)

	rows, err := r.queries.GetChatMessages(ctx, db.GetChatMessagesParams{
		RoomID: rid,
		Limit:  limit,
		Offset: offset,
	})
	if err != nil {
		return nil, err
	}

	res := make([]*domain.ChatMessage, len(rows))
	for i, row := range rows {
		res[i] = &domain.ChatMessage{
			ID:           util.UUIDToString(row.ID),
			RoomID:       util.UUIDToString(row.RoomID),
			SenderID:     util.UUIDToString(row.AuthorID),
			SenderName:   row.SenderName,
			SenderAvatar: row.SenderAvatar.String,
			Content:      row.Content,
			MessageType:  row.MessageType,
			CreatedAt:    row.CreatedAt.Time,
		}
	}
	return res, nil
}

func (r *PostgresMessagingRepository) GetUserRooms(ctx context.Context, userID string) ([]*domain.ChatRoom, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)

	rows, err := r.pool.Query(ctx,
		`SELECT DISTINCT cr.id, cr.name, cr.is_group, cr.is_e2ee_enabled, cr.created_at,
		 COALESCE(ra.is_archived, false) as is_archived,
		 rm.muted_until
		 FROM chat_rooms cr
		 JOIN chat_members cm ON cr.id = cm.room_id
		 LEFT JOIN room_archives ra ON cr.id = ra.room_id AND ra.user_id = $1
		 LEFT JOIN room_mutes rm ON cr.id = rm.room_id AND rm.user_id = $1
		 WHERE cm.user_id = $1
		 ORDER BY cr.created_at DESC`,
		uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var rooms []*domain.ChatRoom
	for rows.Next() {
		var room domain.ChatRoom
		var mutedUntil pgtype.Timestamptz
		err := rows.Scan(&room.ID, &room.Name, &room.IsGroup, &room.IsE2EEEnabled,
			&room.CreatedAt, &room.IsArchived, &mutedUntil)
		if err != nil {
			continue
		}
		if mutedUntil.Valid {
			room.MutedUntil = &mutedUntil.Time
		}
		rooms = append(rooms, &room)
	}
	return rooms, nil
}

func (r *PostgresMessagingRepository) CacheUserRooms(ctx context.Context, userID string, rooms []*domain.ChatRoom) error {
	// PostgreSQL is the source of truth, no need to cache in itself
	return nil
}

func (r *PostgresMessagingRepository) DeleteMessage(ctx context.Context, messageID, senderID string) error {
	var mid, aid pgtype.UUID
	_ = mid.Scan(messageID)
	_ = aid.Scan(senderID)

	_, err := r.pool.Exec(ctx,
		"UPDATE chat_messages SET is_deleted = true, updated_at = NOW() WHERE id = $1 AND author_id = $2",
		mid, aid)
	return err
}

func (r *PostgresMessagingRepository) SearchMessages(ctx context.Context, roomID, query string) ([]*domain.ChatMessage, error) {
	var rid pgtype.UUID
	_ = rid.Scan(roomID)

	rows, err := r.pool.Query(ctx,
		`SELECT id, room_id, author_id, sender_name, sender_avatar, content, message_type,
		 is_edited, is_encrypted, created_at, updated_at
		 FROM chat_messages
		 WHERE room_id = $1 AND is_deleted = false AND content ILIKE '%' || $2 || '%'
		 ORDER BY created_at DESC LIMIT 50`,
		rid, query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var messages []*domain.ChatMessage
	for rows.Next() {
		var msg domain.ChatMessage
		var senderAvatar pgtype.Text
		err := rows.Scan(&msg.ID, &msg.RoomID, &msg.SenderID, &msg.SenderName, &senderAvatar,
			&msg.Content, &msg.MessageType, &msg.IsEdited, &msg.IsEncrypted, &msg.CreatedAt, &msg.UpdatedAt)
		if err != nil {
			continue
		}
		if senderAvatar.Valid {
			msg.SenderAvatar = senderAvatar.String
		}
		messages = append(messages, &msg)
	}
	return messages, nil
}

func (r *PostgresMessagingRepository) PinMessage(ctx context.Context, roomID, messageID string, pinned bool) error {
	var rid, mid pgtype.UUID
	_ = rid.Scan(roomID)
	_ = mid.Scan(messageID)

	_, err := r.pool.Exec(ctx,
		"UPDATE chat_messages SET is_pinned = $1 WHERE id = $2 AND room_id = $3",
		pinned, mid, rid)
	return err
}

func (r *PostgresMessagingRepository) MarkRead(ctx context.Context, messageID, userID string) error {
	var mid, uid pgtype.UUID
	_ = mid.Scan(messageID)
	_ = uid.Scan(userID)

	_, err := r.pool.Exec(ctx,
		`INSERT INTO message_reads (message_id, user_id, read_at)
		 VALUES ($1, $2, NOW())
		 ON CONFLICT (message_id, user_id) DO UPDATE SET read_at = NOW()`,
		mid, uid)
	return err
}

func (r *PostgresMessagingRepository) AddReaction(ctx context.Context, messageID, userID, emoji string) error {
	var mid, uid pgtype.UUID
	_ = mid.Scan(messageID)
	_ = uid.Scan(userID)

	_, err := r.pool.Exec(ctx,
		`INSERT INTO message_reactions (message_id, user_id, emoji)
		 VALUES ($1, $2, $3)
		 ON CONFLICT (message_id, user_id) DO UPDATE SET emoji = $3`,
		mid, uid, emoji)
	return err
}

func (r *PostgresMessagingRepository) RemoveReaction(ctx context.Context, messageID, userID, emoji string) error {
	var mid, uid pgtype.UUID
	_ = mid.Scan(messageID)
	_ = uid.Scan(userID)

	_, err := r.pool.Exec(ctx,
		"DELETE FROM message_reactions WHERE message_id = $1 AND user_id = $2 AND emoji = $3",
		mid, uid, emoji)
	return err
}

func (r *PostgresMessagingRepository) MuteRoom(ctx context.Context, userID, roomID string, until *string) error {
	var uid, rid pgtype.UUID
	_ = uid.Scan(userID)
	_ = rid.Scan(roomID)

	if until == nil {
		_, err := r.pool.Exec(ctx,
			"DELETE FROM room_mutes WHERE user_id = $1 AND room_id = $2", uid, rid)
		return err
	}

	_, err := r.pool.Exec(ctx,
		`INSERT INTO room_mutes (user_id, room_id, muted_until)
		 VALUES ($1, $2, $3)
		 ON CONFLICT (user_id, room_id) DO UPDATE SET muted_until = $3`,
		uid, rid, *until)
	return err
}

func (r *PostgresMessagingRepository) ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error {
	var uid, rid pgtype.UUID
	_ = uid.Scan(userID)
	_ = rid.Scan(roomID)

	_, err := r.pool.Exec(ctx,
		`INSERT INTO room_archives (user_id, room_id, is_archived)
		 VALUES ($1, $2, $3)
		 ON CONFLICT (user_id, room_id) DO UPDATE SET is_archived = $3`,
		uid, rid, archived)
	return err
}

func (r *PostgresMessagingRepository) CreateFolder(ctx context.Context, userID, name string, roomIDs []string) (*domain.ChatFolder, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)

	var folderID pgtype.UUID
	err := r.pool.QueryRow(ctx,
		"INSERT INTO chat_folders (user_id, name) VALUES ($1, $2) RETURNING id",
		uid, name).Scan(&folderID)
	if err != nil {
		return nil, err
	}

	for _, roomID := range roomIDs {
		var rid pgtype.UUID
		_ = rid.Scan(roomID)
		_, _ = r.pool.Exec(ctx,
			"INSERT INTO folder_rooms (folder_id, room_id) VALUES ($1, $2)",
			folderID, rid)
	}

	return &domain.ChatFolder{
		ID:        util.UUIDToString(folderID),
		UserID:    userID,
		Name:      name,
		RoomIDs:   roomIDs,
		CreatedAt: time.Now(),
	}, nil
}

func (r *PostgresMessagingRepository) GetFolders(ctx context.Context, userID string) ([]*domain.ChatFolder, error) {
	var uid pgtype.UUID
	_ = uid.Scan(userID)

	rows, err := r.pool.Query(ctx,
		`SELECT cf.id, cf.user_id, cf.name, cf.created_at,
		 ARRAY_AGG(fr.room_id) as room_ids
		 FROM chat_folders cf
		 LEFT JOIN folder_rooms fr ON cf.id = fr.folder_id
		 WHERE cf.user_id = $1
		 GROUP BY cf.id, cf.user_id, cf.name, cf.created_at`,
		uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var folders []*domain.ChatFolder
	for rows.Next() {
		var folder domain.ChatFolder
		var roomIDs []string
		err := rows.Scan(&folder.ID, &folder.UserID, &folder.Name, &folder.CreatedAt, &roomIDs)
		if err != nil {
			continue
		}
		folder.RoomIDs = roomIDs
		folders = append(folders, &folder)
	}
	return folders, nil
}

func (r *PostgresMessagingRepository) GetRoomMedia(ctx context.Context, roomID string) ([]string, error) {
	var rid pgtype.UUID
	_ = rid.Scan(roomID)

	rows, err := r.pool.Query(ctx,
		`SELECT DISTINCT file_url
		 FROM chat_messages
		 WHERE room_id = $1 AND file_url IS NOT NULL AND file_url != '' AND is_deleted = false
		 ORDER BY created_at DESC
		 LIMIT 100`,
		rid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var mediaURLs []string
	for rows.Next() {
		var url string
		err := rows.Scan(&url)
		if err != nil {
			continue
		}
		mediaURLs = append(mediaURLs, url)
	}
	return mediaURLs, nil
}

func (r *PostgresMessagingRepository) SetE2EEStatus(ctx context.Context, roomID string, enabled bool) error {
	_, err := r.pool.Exec(ctx, "UPDATE chat_rooms SET is_e2ee_enabled = $2 WHERE id = $1", roomID, enabled)
	return err
}

func (r *PostgresMessagingRepository) GetE2EEStatus(ctx context.Context, roomID string) (bool, error) {
	var enabled bool
	err := r.pool.QueryRow(ctx, "SELECT is_e2ee_enabled FROM chat_rooms WHERE id = $1", roomID).Scan(&enabled)
	if err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return enabled, nil
}

func (r *PostgresMessagingRepository) GetRoomMembers(ctx context.Context, roomID string) ([]*domain.ChatRoomMember, error) {
	rows, err := r.pool.Query(ctx,
		"SELECT u.id, u.username, u.email FROM users u JOIN chat_members cm ON u.id = cm.user_id WHERE cm.room_id = $1",
		roomID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	members := []*domain.ChatRoomMember{}
	for rows.Next() {
		var m domain.ChatRoomMember
		err := rows.Scan(&m.ID, &m.Username, &m.Email)
		if err != nil {
			continue
		}
		members = append(members, &m)
	}
	return members, nil
}

func (r *PostgresMessagingRepository) RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error {
	_, err := r.pool.Exec(ctx,
		"INSERT INTO e2ee_key_rotations (room_id, user_id, public_key_id, device_id) VALUES ($1, $2, $3, $4)",
		roomID, userID, publicKeyID, deviceID)
	return err
}

func (r *PostgresMessagingRepository) GetKeyRotations(ctx context.Context, roomID string) ([]*domain.E2EEKeyRotation, error) {
	rows, err := r.pool.Query(ctx,
		"SELECT id, room_id, user_id, public_key_id, device_id, rotated_at FROM e2ee_key_rotations WHERE room_id = $1 ORDER BY rotated_at ASC",
		roomID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	rotations := []*domain.E2EEKeyRotation{}
	for rows.Next() {
		var rot domain.E2EEKeyRotation
		err := rows.Scan(&rot.ID, &rot.RoomID, &rot.UserID, &rot.PublicKeyID, &rot.DeviceID, &rot.RotatedAt)
		if err != nil {
			continue
		}
		rotations = append(rotations, &rot)
	}
	return rotations, nil
}
