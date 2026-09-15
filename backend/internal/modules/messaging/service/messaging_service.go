package service

import (
	"context"
	"encoding/json"
	"fmt"

	"local/merope/internal/core/events"
	"local/merope/internal/core/security"
	identityDomain "local/merope/internal/modules/identity/domain"
	"local/merope/internal/modules/messaging/domain"
)

type messagingService struct {
	repo       domain.MessagingRepository
	idService  identityDomain.IdentityService
	e2eeRepo   domain.E2EERepository
	e2eeSvc    domain.E2EEService
	bus        events.Publisher
	e2eeBus    events.Publisher
	aegisGuard AegisMessagingGuard
}

func NewMessagingService(repo domain.MessagingRepository, idService identityDomain.IdentityService, e2eeRepo domain.E2EERepository, e2eeSvc domain.E2EEService, bus events.Publisher, e2eeBus events.Publisher, aegisGuard AegisMessagingGuard) domain.MessagingService {
	return &messagingService{
		repo:       repo,
		idService:  idService,
		e2eeRepo:   e2eeRepo,
		e2eeSvc:    e2eeSvc,
		bus:        bus,
		e2eeBus:    e2eeBus,
		aegisGuard: aegisGuard,
	}
}

func (s *messagingService) StartDirectChat(ctx context.Context, userA, userB string) (*domain.ChatRoom, error) {
	return s.repo.CreateRoom(ctx, "", false, []string{userA, userB})
}

func (s *messagingService) CreateGroupChat(ctx context.Context, name string, userIDs []string) (*domain.ChatRoom, error) {
	sanitizedName := security.StripHTML(name)
	return s.repo.CreateRoom(ctx, sanitizedName, true, userIDs)
}

func (s *messagingService) SendMessage(ctx context.Context, msg *domain.ChatMessage) (*domain.ChatMessage, error) {
	msg.Content = security.SanitizeHTML(msg.Content)

	isE2EE, _ := s.e2eeRepo.GetE2EEStatus(ctx, msg.RoomID)
	if isE2EE && msg.EncryptedPayload != nil {
		msg.Content = ""
		msg.IsEncrypted = true

		if s.aegisGuard != nil {
			var payload map[string]interface{}
			if err := json.Unmarshal([]byte(*msg.EncryptedPayload), &payload); err == nil {
				if err := s.aegisGuard.VerifyMessageIntegrity(ctx, msg.RoomID, nil, msg.SenderID); err != nil {
					return nil, fmt.Errorf("aegis integrity check failed: %w", err)
				}
			}
		}
	} else if isE2EE && msg.EncryptedPayload == nil {
		return nil, fmt.Errorf("e2ee room requires encrypted payload")
	}

	sentMsg, err := s.repo.SendMessage(ctx, msg)
	if err != nil {
		return nil, err
	}

	if isE2EE {
		_ = s.e2eeBus.Publish(ctx, "e2ee.message.sent", events.Event{
			Type:    "E2EE_MESSAGE_SENT",
			Payload: sentMsg,
		})
	}

	_ = s.bus.Publish(ctx, "chat.message.sent", events.Event{
		Type:    "MESSAGE_SENT",
		Payload: sentMsg,
	})

	return sentMsg, nil
}

func (s *messagingService) EditMessage(ctx context.Context, messageID, senderID, content string) (*domain.ChatMessage, error) {
	sanitizedContent := security.SanitizeHTML(content)
	msg, err := s.repo.UpdateMessage(ctx, messageID, senderID, sanitizedContent)
	if err == nil {
		_ = s.bus.Publish(ctx, "chat.message.edited", events.Event{Type: "MESSAGE_EDITED", Payload: msg})
	}
	return msg, err
}

func (s *messagingService) DeleteMessage(ctx context.Context, messageID, senderID string) error {
	err := s.repo.DeleteMessage(ctx, messageID, senderID)
	if err == nil {
		_ = s.bus.Publish(ctx, "chat.message.deleted", events.Event{Type: "MESSAGE_DELETED", Payload: map[string]string{"message_id": messageID}})
	}
	return err
}

func (s *messagingService) AddReaction(ctx context.Context, messageID, userID, emoji string) error {
	err := s.repo.AddReaction(ctx, messageID, userID, emoji)
	if err == nil {
		_ = s.bus.Publish(ctx, "chat.reaction.added", events.Event{Type: "REACTION_ADDED", Payload: map[string]string{"message_id": messageID, "user_id": userID, "emoji": emoji}})
	}
	return err
}

func (s *messagingService) MuteRoom(ctx context.Context, userID, roomID string, durationMinutes int) error {
	var until *string
	if durationMinutes > 0 {
		t := fmt.Sprintf("NOW() + INTERVAL '%d minutes'", durationMinutes)
		until = &t
	}
	return s.repo.MuteRoom(ctx, userID, roomID, until)
}

func (s *messagingService) ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error {
	return s.repo.ArchiveRoom(ctx, userID, roomID, archived)
}

func (s *messagingService) SearchMessages(ctx context.Context, roomID, query string) ([]*domain.ChatMessage, error) {
	return s.repo.SearchMessages(ctx, roomID, query)
}

func (s *messagingService) ForwardMessage(ctx context.Context, messageID, fromUserID, toRoomID string) (*domain.ChatMessage, error) {
	messages, err := s.repo.GetMessages(ctx, toRoomID, 1, 0)
	if err != nil {
		return nil, fmt.Errorf("failed to get messages: %w", err)
	}
	var original *domain.ChatMessage
	for _, m := range messages {
		if m.ID == messageID {
			original = m
			break
		}
	}
	if original == nil {
		return nil, fmt.Errorf("message not found")
	}
	forwarded := &domain.ChatMessage{RoomID: toRoomID, SenderID: fromUserID, Content: original.Content, MessageType: original.MessageType, ForwardedFromID: &messageID}
	return s.repo.SendMessage(ctx, forwarded)
}

func (s *messagingService) PinMessage(ctx context.Context, roomID, messageID string) error {
	return s.repo.PinMessage(ctx, roomID, messageID, true)
}

func (s *messagingService) SendTypingIndicator(ctx context.Context, roomID, userID string) error {
	return s.bus.Publish(ctx, "chat.typing", events.Event{Type: "TYPING", Payload: map[string]string{"room_id": roomID, "user_id": userID}})
}

func (s *messagingService) MarkAsRead(ctx context.Context, messageID, userID string) error {
	err := s.repo.MarkRead(ctx, messageID, userID)
	if err == nil {
		_ = s.bus.Publish(ctx, "chat.read", events.Event{Type: "READ_RECEIPT", Payload: map[string]string{"message_id": messageID, "user_id": userID}})
	}
	return err
}

func (s *messagingService) MarkAsDelivered(ctx context.Context, messageID string) error {
	return s.repo.MarkDelivered(ctx, messageID)
}

func (s *messagingService) GetMessageHistory(ctx context.Context, messageID string) ([]*domain.MessageHistory, error) {
	return s.repo.GetMessageHistory(ctx, messageID)
}

func (s *messagingService) BurnMessage(ctx context.Context, messageID, userID string) error {
	return s.repo.DeleteMessage(ctx, messageID, userID)
}

func (s *messagingService) OrganizeChat(ctx context.Context, userID, folderName string, roomIDs []string) (*domain.ChatFolder, error) {
	return s.repo.CreateFolder(ctx, userID, folderName, roomIDs)
}

func (s *messagingService) GetGallery(ctx context.Context, roomID string) ([]string, error) {
	return s.repo.GetRoomMedia(ctx, roomID)
}

func (s *messagingService) GetRoomHistory(ctx context.Context, roomID string, page int32) ([]*domain.ChatMessage, error) {
	limit := int32(50)
	return s.repo.GetMessages(ctx, roomID, limit, page*limit)
}

func (s *messagingService) GetUserRooms(ctx context.Context, userID string) ([]*domain.ChatRoom, error) {
	return s.repo.GetUserRooms(ctx, userID)
}

func (s *messagingService) EnableE2EE(ctx context.Context, roomID, userID string) error {
	return s.e2eeSvc.EnableE2EE(ctx, roomID, userID)
}

func (s *messagingService) DisableE2EE(ctx context.Context, roomID string) error {
	return s.e2eeSvc.DisableE2EE(ctx, roomID)
}

func (s *messagingService) GetE2EEStatus(ctx context.Context, roomID string) (bool, error) {
	return s.e2eeSvc.IsRoomE2EE(ctx, roomID)
}

func (s *messagingService) RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error {
	return s.e2eeSvc.RecordKeyRotation(ctx, roomID, userID, publicKeyID, deviceID)
}

func (s *messagingService) UpdateFlowState(ctx context.Context, state *domain.FlowState) error {
	return s.bus.Publish(ctx, "flow.state.updated", events.Event{Type: "FLOW_STATE_UPDATED", Payload: state})
}

func (s *messagingService) GetFlowState(ctx context.Context, userID string) (*domain.FlowState, error) {
	return nil, nil
}
