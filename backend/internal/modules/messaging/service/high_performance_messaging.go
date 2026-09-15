package service

import (
	"context"
	"fmt"
	"log/slog"
	"time"

	"local/merope/internal/core/events"
	"local/merope/internal/core/security"
	"local/merope/internal/core/worker"
	"local/merope/internal/modules/messaging/domain"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

var tracer = otel.Tracer("messaging-service")

type HighPerformanceMessagingService struct {
	pgRepo       domain.MessagingRepository
	scyllaRepo   domain.MessagingRepository
	bus          events.Publisher
	orchestrator *worker.Orchestrator
	scyllaCB     *worker.CircuitBreaker
	e2eeRepo     domain.E2EERepository
	e2eeSvc      domain.E2EEService
}

func NewHighPerformanceService(
	pgRepo domain.MessagingRepository,
	scyllaRepo domain.MessagingRepository,
	bus events.Publisher,
	orchestrator *worker.Orchestrator,
	e2eeRepo domain.E2EERepository,
	e2eeSvc domain.E2EEService,
) domain.MessagingService {
	return &HighPerformanceMessagingService{
		pgRepo:       pgRepo,
		scyllaRepo:   scyllaRepo,
		bus:          bus,
		orchestrator: orchestrator,
		scyllaCB:     worker.NewCircuitBreaker(5, 30*time.Second),
		e2eeRepo:     e2eeRepo,
		e2eeSvc:      e2eeSvc,
	}
}

// SendMessage writes to PostgreSQL and offloads ScyllaDB/NATS to workers
func (s *HighPerformanceMessagingService) SendMessage(ctx context.Context, msg *domain.ChatMessage) (*domain.ChatMessage, error) {
	ctx, span := tracer.Start(ctx, "SendMessage", trace.WithAttributes(
		attribute.String("room_id", msg.RoomID),
		attribute.String("sender_id", msg.SenderID),
	))
	defer span.End()

	msg.Content = security.SanitizeHTML(msg.Content)

	sentMsg, err := s.pgRepo.SendMessage(ctx, msg)
	if err != nil {
		span.RecordError(err)
		return nil, err
	}

	s.orchestrator.SubmitRealTime(func(ctx context.Context) error {
		// Scylla Mirroring with Circuit Breaker
		_ = s.scyllaCB.Execute(func() error {
			_, mirrorErr := s.scyllaRepo.SendMessage(ctx, sentMsg)
			return mirrorErr
		})

		if pubErr := s.bus.Publish(ctx, "chat.message.sent", events.Event{
			Type:    "MESSAGE_SENT",
			Payload: sentMsg,
		}); pubErr != nil {
			slog.Error("NATS publish failed", "subject", "chat.message.sent", "error", pubErr)
		}
		return nil
	})

	return sentMsg, nil
}

func (s *HighPerformanceMessagingService) StartDirectChat(ctx context.Context, userA, userB string) (*domain.ChatRoom, error) {
	return s.pgRepo.CreateRoom(ctx, "", false, []string{userA, userB})
}

func (s *HighPerformanceMessagingService) CreateGroupChat(ctx context.Context, name string, userIDs []string) (*domain.ChatRoom, error) {
	sanitizedName := security.StripHTML(name)
	return s.pgRepo.CreateRoom(ctx, sanitizedName, true, userIDs)
}

func (s *HighPerformanceMessagingService) EditMessage(ctx context.Context, messageID, senderID, content string) (*domain.ChatMessage, error) {
	ctx, span := tracer.Start(ctx, "EditMessage")
	defer span.End()

	sanitizedContent := security.SanitizeHTML(content)
	msg, err := s.pgRepo.UpdateMessage(ctx, messageID, senderID, sanitizedContent)
	if err != nil {
		return nil, err
	}

	s.orchestrator.SubmitBackground(func(ctx context.Context) error {
		_ = s.scyllaCB.Execute(func() error {
			_, mirrorErr := s.scyllaRepo.UpdateMessage(ctx, messageID, senderID, sanitizedContent)
			return mirrorErr
		})

		if pubErr := s.bus.Publish(ctx, "chat.message.edited", events.Event{
			Type:    "MESSAGE_EDITED",
			Payload: msg,
		}); pubErr != nil {
			slog.Error("NATS publish failed", "subject", "chat.message.edited", "error", pubErr)
		}
		return nil
	})

	return msg, nil
}

func (s *HighPerformanceMessagingService) DeleteMessage(ctx context.Context, messageID, senderID string) error {
	err := s.pgRepo.DeleteMessage(ctx, messageID, senderID)
	if err != nil {
		return err
	}

	s.orchestrator.SubmitBackground(func(ctx context.Context) error {
		_ = s.scyllaCB.Execute(func() error {
			return s.scyllaRepo.DeleteMessage(ctx, messageID, senderID)
		})

		if pubErr := s.bus.Publish(ctx, "chat.message.deleted", events.Event{
			Type: "MESSAGE_DELETED",
			Payload: map[string]string{
				"message_id": messageID,
			},
		}); pubErr != nil {
			slog.Error("NATS publish failed", "subject", "chat.message.deleted", "error", pubErr)
		}
		return nil
	})

	return nil
}

func (s *HighPerformanceMessagingService) ForwardMessage(ctx context.Context, messageID, fromUserID, toRoomID string) (*domain.ChatMessage, error) {
	messages, err := s.pgRepo.GetMessages(ctx, toRoomID, 1, 0)
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

	forwarded := &domain.ChatMessage{
		RoomID:          toRoomID,
		SenderID:        fromUserID,
		Content:         original.Content,
		MessageType:     original.MessageType,
		ForwardedFromID: &messageID,
	}

	return s.SendMessage(ctx, forwarded)
}

func (s *HighPerformanceMessagingService) PinMessage(ctx context.Context, roomID, messageID string) error {
	if err := s.pgRepo.PinMessage(ctx, roomID, messageID, true); err != nil {
		return err
	}
	s.orchestrator.SubmitBackground(func(ctx context.Context) error {
		_ = s.scyllaCB.Execute(func() error {
			return s.scyllaRepo.PinMessage(ctx, roomID, messageID, true)
		})
		return nil
	})
	return nil
}

func (s *HighPerformanceMessagingService) SendTypingIndicator(ctx context.Context, roomID, userID string) error {
	return s.bus.Publish(ctx, "chat.typing", events.Event{
		Type: "TYPING",
		Payload: map[string]string{
			"room_id": roomID,
			"user_id": userID,
		},
	})
}

func (s *HighPerformanceMessagingService) MarkAsRead(ctx context.Context, messageID, userID string) error {
	err := s.pgRepo.MarkRead(ctx, messageID, userID)
	if err == nil {
		s.orchestrator.SubmitRealTime(func(ctx context.Context) error {
			return s.bus.Publish(ctx, "chat.read", events.Event{
				Type: "READ_RECEIPT",
				Payload: map[string]string{
					"message_id": messageID,
					"user_id":    userID,
				},
			})
		})
	}
	return err
}

func (s *HighPerformanceMessagingService) MarkAsDelivered(ctx context.Context, messageID string) error {
	err := s.pgRepo.MarkDelivered(ctx, messageID)
	if err == nil {
		s.orchestrator.SubmitRealTime(func(ctx context.Context) error {
			return s.bus.Publish(ctx, "chat.delivered", events.Event{
				Type: "DELIVERY_RECEIPT",
				Payload: map[string]string{
					"message_id": messageID,
				},
			})
		})
	}
	return err
}

func (s *HighPerformanceMessagingService) AddReaction(ctx context.Context, messageID, userID, emoji string) error {
	err := s.pgRepo.AddReaction(ctx, messageID, userID, emoji)
	if err != nil {
		return err
	}

	s.orchestrator.SubmitRealTime(func(ctx context.Context) error {
		_ = s.scyllaCB.Execute(func() error {
			return s.scyllaRepo.AddReaction(ctx, messageID, userID, emoji)
		})

		if pubErr := s.bus.Publish(ctx, "chat.reaction.added", events.Event{
			Type: "REACTION_ADDED",
			Payload: map[string]string{
				"message_id": messageID,
				"user_id":    userID,
				"emoji":      emoji,
			},
		}); pubErr != nil {
			slog.Error("NATS publish failed", "subject", "chat.reaction.added", "error", pubErr)
		}
		return nil
	})
	return nil
}

func (s *HighPerformanceMessagingService) MuteRoom(ctx context.Context, userID, roomID string, durationMinutes int) error {
	var until *string
	if durationMinutes > 0 {
		t := fmt.Sprintf("NOW() + INTERVAL '%d minutes'", durationMinutes)
		until = &t
	}
	return s.pgRepo.MuteRoom(ctx, userID, roomID, until)
}

func (s *HighPerformanceMessagingService) ArchiveRoom(ctx context.Context, userID, roomID string, archived bool) error {
	return s.pgRepo.ArchiveRoom(ctx, userID, roomID, archived)
}

func (s *HighPerformanceMessagingService) SearchMessages(ctx context.Context, roomID, query string) ([]*domain.ChatMessage, error) {
	return s.pgRepo.SearchMessages(ctx, roomID, query)
}

func (s *HighPerformanceMessagingService) GetRoomHistory(ctx context.Context, roomID string, page int32) ([]*domain.ChatMessage, error) {
	limit := int32(50)
	if page > 1 {
		return s.pgRepo.GetMessages(ctx, roomID, limit, (page-1)*limit)
	}

	messages, err := s.scyllaRepo.GetMessages(ctx, roomID, limit, 0)
	if err != nil || len(messages) == 0 {
		return s.pgRepo.GetMessages(ctx, roomID, limit, 0)
	}
	return messages, nil
}

func (s *HighPerformanceMessagingService) OrganizeChat(ctx context.Context, userID, folderName string, roomIDs []string) (*domain.ChatFolder, error) {
	return s.pgRepo.CreateFolder(ctx, userID, folderName, roomIDs)
}

func (s *HighPerformanceMessagingService) GetGallery(ctx context.Context, roomID string) ([]string, error) {
	return s.pgRepo.GetRoomMedia(ctx, roomID)
}

func (s *HighPerformanceMessagingService) CreateFolder(ctx context.Context, userID, folderName string, roomIDs []string) (*domain.ChatFolder, error) {
	return s.pgRepo.CreateFolder(ctx, userID, folderName, roomIDs)
}

func (s *HighPerformanceMessagingService) GetFolders(ctx context.Context, userID string) ([]*domain.ChatFolder, error) {
	return s.pgRepo.GetFolders(ctx, userID)
}

func (s *HighPerformanceMessagingService) GetUserRooms(ctx context.Context, userID string) ([]*domain.ChatRoom, error) {
	rooms, err := s.pgRepo.GetUserRooms(ctx, userID)
	if err != nil {
		return nil, err
	}

	// Cache user rooms in ScyllaDB for fast access
	s.orchestrator.SubmitBackground(func(ctx context.Context) error {
		_ = s.scyllaCB.Execute(func() error {
			return s.scyllaRepo.CacheUserRooms(ctx, userID, rooms)
		})
		return nil
	})

	return rooms, nil
}

func (s *HighPerformanceMessagingService) EnableE2EE(ctx context.Context, roomID, userID string) error {
	return s.e2eeSvc.EnableE2EE(ctx, roomID, userID)
}

func (s *HighPerformanceMessagingService) DisableE2EE(ctx context.Context, roomID string) error {
	return s.e2eeSvc.DisableE2EE(ctx, roomID)
}

func (s *HighPerformanceMessagingService) GetE2EEStatus(ctx context.Context, roomID string) (bool, error) {
	return s.e2eeSvc.IsRoomE2EE(ctx, roomID)
}

func (s *HighPerformanceMessagingService) RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error {
	return s.e2eeSvc.RecordKeyRotation(ctx, roomID, userID, publicKeyID, deviceID)
}
