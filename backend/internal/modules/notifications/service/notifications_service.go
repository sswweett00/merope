package service

import (
	"context"
	"local/merope/internal/core/events"
	"local/merope/internal/modules/notifications/domain"
)

type notificationsService struct {
	repo domain.NotificationsRepository
	bus  events.Publisher
}

func NewNotificationsService(repo domain.NotificationsRepository, bus events.Publisher) domain.NotificationsService {
	return &notificationsService{repo: repo, bus: bus}
}

func (s *notificationsService) Notify(ctx context.Context, receiverID, senderID, nType, entityType, entityID string) error {
	n := &domain.Notification{
		ReceiverID: receiverID,
		SenderID:   &senderID,
		Type:       nType,
		EntityType: entityType,
		EntityID:   entityID,
	}
	if err := s.repo.Create(ctx, n); err != nil {
		return err
	}

	// Real-time notification via NATS
	_ = s.bus.Publish(ctx, "notifications.new", events.Event{
		Type:    "NEW_NOTIFICATION",
		Payload: n,
	})

	return nil
}

func (s *notificationsService) GetActivity(ctx context.Context, userID string, page int32) ([]*domain.Notification, error) {
	limit := int32(20)
	offset := page * limit
	return s.repo.GetForUser(ctx, userID, limit, offset)
}
