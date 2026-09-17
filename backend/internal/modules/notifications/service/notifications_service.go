package service

import (
	"context"

	"local/merope/internal/core/events"
	"local/merope/internal/modules/notifications/domain"
)

type notificationsService struct {
	repo domain.RuntimeNotificationRepository
	bus  events.Publisher
}

func NewNotificationsService(repo domain.RuntimeNotificationRepository, bus events.Publisher) domain.RuntimeNotificationsService {
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
	if s.bus != nil {
		_ = s.bus.Publish(ctx, "notifications.new", events.Event{Type: "NEW_NOTIFICATION", Payload: n})
	}
	return nil
}

func (s *notificationsService) GetActivity(ctx context.Context, userID string, page int32) ([]*domain.Notification, error) {
	if page < 0 {
		page = 0
	}
	const pageSize int32 = 20
	return s.repo.GetForUser(ctx, userID, pageSize, page*pageSize)
}
