package service

import (
	"context"
	"fmt"

	"local/merope/internal/modules/privacy/domain"
)

type privacyService struct {
	repo domain.RuntimePrivacyRepository
}

func NewPrivacyService(repo domain.RuntimePrivacyRepository) domain.RuntimePrivacyService {
	return &privacyService{repo: repo}
}

func (s *privacyService) SetGhostMode(ctx context.Context, sessionID string, active bool) error {
	return s.repo.SetGhostMode(ctx, sessionID, active)
}

func (s *privacyService) CheckVisibility(ctx context.Context, userID, viewerID string) (bool, error) {
	return s.repo.CheckVisibility(ctx, userID, viewerID)
}

func (s *privacyService) ListSessions(ctx context.Context, userID string) ([]*domain.ActiveSession, error) {
	return s.repo.GetActiveSessions(ctx, userID)
}

func (s *privacyService) LogoutSession(ctx context.Context, sessionID string) error {
	return s.repo.DeleteSession(ctx, sessionID)
}

func (s *privacyService) UpdateIdentityKeys(ctx context.Context, userID, deviceID string, pubKey []byte) error {
	return s.repo.UpsertIdentityKey(ctx, userID, deviceID, pubKey, nil)
}

func (s *privacyService) UploadPreKeys(ctx context.Context, userID, deviceID string, signedKey *domain.SignedPreKey, otKeys []domain.OneTimePreKey) error {
	if signedKey != nil {
		if err := s.repo.UpsertSignedPreKey(ctx, userID, deviceID, signedKey.ID, signedKey.PublicKey, signedKey.Signature); err != nil {
			return err
		}
	}
	if len(otKeys) > 0 {
		return s.repo.UploadOneTimePreKeys(ctx, userID, deviceID, otKeys)
	}
	return nil
}

func (s *privacyService) GetPreKeyBundle(ctx context.Context, userID, deviceID string) (*domain.PreKeyBundle, error) {
	identityKey, err := s.repo.GetIdentityKey(ctx, userID, deviceID)
	if err != nil {
		return nil, err
	}
	signedKey, err := s.repo.GetSignedPreKey(ctx, userID, deviceID)
	if err != nil {
		return nil, err
	}
	oneTimeKey, err := s.repo.TakeOneTimePreKey(ctx, userID, deviceID)
	if err != nil {
		return nil, err
	}

	if identityKey == nil {
		return nil, fmt.Errorf("identity key not found")
	}

	bundle := &domain.PreKeyBundle{
		UserID:         userID,
		DeviceID:       deviceID,
		IdentityKey:    identityKey.PublicKey,
		SignedPreKey:   signedKey,
		OneTimePreKeys: nil,
	}
	if oneTimeKey != nil {
		bundle.OneTimePreKeys = []*domain.OneTimePreKey{oneTimeKey}
	}
	return bundle, nil
}
