package domain

import (
	"context"
	"time"
)

type ChatRoom struct {
	ID            string     `json:"id"`
	Name          string     `json:"name"`
	IsGroup       bool       `json:"is_group"`
	IsE2EEEnabled bool       `json:"is_e2ee_enabled"`
	CreatedAt     time.Time  `json:"created_at"`
	IsArchived    bool       `json:"is_archived"`
	MutedUntil    *time.Time `json:"muted_until"`
}

type ChatMessage struct {
	ID               string              `json:"id"`
	RoomID           string              `json:"room_id"`
	SenderID         string              `json:"sender_id"`
	SenderName       string              `json:"sender_name"`
	SenderAvatar     string              `json:"sender_avatar"`
	ParentID         *string             `json:"parent_id"`
	ForwardedFromID  *string             `json:"forwarded_from_id"`
	Content          string              `json:"content"`
	EncryptedPayload *string             `json:"encrypted_payload"`
	MessageType      string              `json:"type"` // text, image, etc. Flutter expects 'type'
	VoiceURL         string              `json:"voice_url"`
	FileURL          string              `json:"file_url"`
	Effect           string              `json:"effect"`
	StickerID        string              `json:"sticker_id"`
	IsEdited         bool                `json:"is_edited"`
	IsPinned         bool                `json:"is_pinned"`
	IsEncrypted      bool                `json:"is_encrypted"`
	IsDeleted        bool                `json:"is_deleted"`
	IsBurnOnRead     bool                `json:"is_burn_on_read"`
	ExpiresAt        *time.Time          `json:"expires_at"`
	ScheduledAt      *time.Time          `json:"scheduled_at"`
	Status           string              `json:"status"` // pending, sent, delivered, read
	Reactions        map[string][]string `json:"reactions"`
	Version          int32               `json:"version"`
	CreatedAt        time.Time           `json:"timestamp"` // Flutter MessageModel uses 'timestamp' for created_at (int)
	UpdatedAt        time.Time           `json:"updated_at"`
}

type MessageHistory struct {
	ID        string
	MessageID string
	Content   string
	Version   int32
	AuthorID  string
	CreatedAt time.Time
}

type FlowState struct {
	UserID    string
	DeviceID  string
	RoomID    string
	Draft     string
	ActiveAt  time.Time
}

type ChatFolder struct {
	ID        string
	UserID    string
	Name      string
	RoomIDs   []string
	CreatedAt time.Time
}

type E2EEKeyRotation struct {
	ID         string
	RoomID     string
	UserID     string
	PublicKeyID string
	DeviceID   string
	RotatedAt  time.Time
}

type MessagingRepository interface {
	CreateRoom(ctx context.Context, name string, isGroup bool, userIDs []string) (*ChatRoom, error)
	SendMessage(ctx context.Context, msg *ChatMessage) (*ChatMessage, error)
	UpdateMessage(ctx context.Context, messageID, senderID, content string) (*ChatMessage, error)
	DeleteMessage(ctx context.Context, messageID, senderID string) error
	GetMessages(ctx context.Context, roomID string, limit, offset int32) ([]*ChatMessage, error)
	SearchMessages(ctx context.Context, roomID, query string) ([]*ChatMessage, error)
	GetUserRooms(ctx context.Context, userID string) ([]*ChatRoom, error)
	CacheUserRooms(ctx context.Context, userID string, rooms []*ChatRoom) error

	AddReaction(ctx context.Context, messageID, userID, emoji string) error
	RemoveReaction(ctx context.Context, messageID, userID, emoji string) error

	MuteRoom(ctx context.Context, userID, roomID string, until *string) error
	ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error
	PinMessage(ctx context.Context, roomID, messageID string, pinned bool) error
	MarkRead(ctx context.Context, messageID, userID string) error
	MarkDelivered(ctx context.Context, messageID string) error

	// History
	GetMessageHistory(ctx context.Context, messageID string) ([]*MessageHistory, error)

	CreateFolder(ctx context.Context, userID, name string, roomIDs []string) (*ChatFolder, error)
	GetFolders(ctx context.Context, userID string) ([]*ChatFolder, error)
	GetRoomMedia(ctx context.Context, roomID string) ([]string, error)

	// E2EE
	GetRoomMembers(ctx context.Context, roomID string) ([]*ChatRoomMember, error)
	SetE2EEStatus(ctx context.Context, roomID string, enabled bool) error
	GetE2EEStatus(ctx context.Context, roomID string) (bool, error)
	RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error
	GetKeyRotations(ctx context.Context, roomID string) ([]*E2EEKeyRotation, error)
}

type ChatRoomMember struct {
	ID       string
	Username string
	Email    string
}

type E2EERepository interface {
	SetE2EEStatus(ctx context.Context, roomID string, enabled bool) error
	GetE2EEStatus(ctx context.Context, roomID string) (bool, error)
	GetRoomMembers(ctx context.Context, roomID string) ([]*ChatRoomMember, error)
	RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error
	GetKeyRotations(ctx context.Context, roomID string) ([]*E2EEKeyRotation, error)
}

type E2EEService interface {
	EnableE2EE(ctx context.Context, roomID, initiatorID string) error
	DisableE2EE(ctx context.Context, roomID string) error
	RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error
	GetKeyRotations(ctx context.Context, roomID string) ([]*E2EEKeyRotation, error)
	IsRoomE2EE(ctx context.Context, roomID string) (bool, error)
}

type MessagingService interface {
	StartDirectChat(ctx context.Context, userA, userB string) (*ChatRoom, error)
	CreateGroupChat(ctx context.Context, name string, userIDs []string) (*ChatRoom, error)
	SendMessage(ctx context.Context, msg *ChatMessage) (*ChatMessage, error)
	EditMessage(ctx context.Context, messageID, senderID, content string) (*ChatMessage, error)
	DeleteMessage(ctx context.Context, messageID, senderID string) error
	ForwardMessage(ctx context.Context, messageID, fromUserID, toRoomID string) (*ChatMessage, error)
	PinMessage(ctx context.Context, roomID, messageID string) error

	SendTypingIndicator(ctx context.Context, roomID, userID string) error
	MarkAsRead(ctx context.Context, messageID, userID string) error
	MarkAsDelivered(ctx context.Context, messageID string) error
	AddReaction(ctx context.Context, messageID, userID, emoji string) error

	MuteRoom(ctx context.Context, userID, roomID string, durationMinutes int) error
	ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error

	// History & Sparks
	GetMessageHistory(ctx context.Context, messageID string) ([]*MessageHistory, error)
	BurnMessage(ctx context.Context, messageID, userID string) error

	OrganizeChat(ctx context.Context, userID, folderName string, roomIDs []string) (*ChatFolder, error)
	GetGallery(ctx context.Context, roomID string) ([]string, error)
	SearchMessages(ctx context.Context, roomID, query string) ([]*ChatMessage, error)
	GetRoomHistory(ctx context.Context, roomID string, page int32) ([]*ChatMessage, error)
	GetUserRooms(ctx context.Context, userID string) ([]*ChatRoom, error)

	// E2EE
	EnableE2EE(ctx context.Context, roomID, userID string) error
	DisableE2EE(ctx context.Context, roomID string) error
	GetE2EEStatus(ctx context.Context, roomID string) (bool, error)
	RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error

	// Flow
	UpdateFlowState(ctx context.Context, state *FlowState) error
	GetFlowState(ctx context.Context, userID string) (*FlowState, error)
}
