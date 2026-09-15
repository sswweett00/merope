package service

import (
	"context"
	"fmt"

	"local/merope/internal/core/events"
	"local/merope/internal/modules/messaging/domain"
)

// e2eeService implements E2EEService for end-to-end encrypted messaging.
type e2eeService struct {
	repo domain.E2EERepository
	bus  events.Publisher
}

// NewE2EEService creates a new E2EE service instance.
func NewE2EEService(repo domain.E2EERepository, bus events.Publisher) domain.E2EEService {
	return &e2eeService{repo: repo, bus: bus}
}

// EnableE2EE activates end-to-end encryption for a chat room and notifies all members.
func (s *e2eeService) EnableE2EE(ctx context.Context, roomID, initiatorID string) error {
	if err := s.repo.SetE2EEStatus(ctx, roomID, true); err != nil {
		return fmt.Errorf("failed to enable E2EE: %w", err)
	}

	members, err := s.repo.GetRoomMembers(ctx, roomID)
	if err != nil {
		return fmt.Errorf("failed to get room members: %w", err)
	}

	for _, member := range members {
		if member.ID == initiatorID {
			continue
		}
		_ = s.bus.Publish(ctx, "e2ee.key_bundle_requested", events.Event{
			Type: "E2EE_KEY_BUNDLE_REQUESTED",
			Payload: map[string]string{
				"room_id":       roomID,
				"requester_id":  initiatorID,
				"recipient_id":  member.ID,
			},
		})
	}

	return nil
}

// DisableE2EE deactivates end-to-end encryption for a chat room.
func (s *e2eeService) DisableE2EE(ctx context.Context, roomID string) error {
	return s.repo.SetE2EEStatus(ctx, roomID, false)
}

// RecordKeyRotation logs a new public key rotation for a user in a room.
func (s *e2eeService) RecordKeyRotation(ctx context.Context, roomID, userID, publicKeyID, deviceID string) error {
	return s.repo.RecordKeyRotation(ctx, roomID, userID, publicKeyID, deviceID)
}

// GetKeyRotations returns the key rotation history for a room.
func (s *e2eeService) GetKeyRotations(ctx context.Context, roomID string) ([]*domain.E2EEKeyRotation, error) {
	return s.repo.GetKeyRotations(ctx, roomID)
}

// IsRoomE2EE reports whether a room has end-to-end encryption enabled.
func (s *e2eeService) IsRoomE2EE(ctx context.Context, roomID string) (bool, error) {
	return s.repo.GetE2EEStatus(ctx, roomID)
}
