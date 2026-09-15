package service

import (
	"context"

	"local/merope/internal/modules/privacy/domain"
)

type privacyService struct {
	repo domain.PrivacyRepository
}

func NewPrivacyService(repo domain.PrivacyRepository) domain.PrivacyService {
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

func (s *privacyService) Toggle2FA(ctx context.Context, userID string, enable bool) (string, error) {
	// Logic to enable/disable 2FA and return TOTP secret if enabling
	return "SECRET_STUB", nil
}

func (s *privacyService) UpdatePrivacy(ctx context.Context, userID string, ghost bool, lastSeen string) error {
	settings, _ := s.repo.GetSettings(ctx, userID)
	if settings == nil {
		settings = &domain.PrivacySettings{UserID: userID}
	}
	settings.IsGhostMode = ghost
	settings.LastSeenVisibility = lastSeen
	return s.repo.UpdateSettings(ctx, userID, settings)
}

func (s *privacyService) UpdateIdentityKeys(ctx context.Context, userID, deviceID string, pubKey []byte) error {
	return s.repo.UpsertIdentityKey(ctx, userID, deviceID, pubKey)
}

func (s *privacyService) UploadPreKeys(ctx context.Context, userID, deviceID string, signedKey *domain.SignedPreKey, otKeys []domain.OneTimePreKey) error {
	if signedKey != nil {
		err := s.repo.UpsertSignedPreKey(ctx, userID, deviceID, signedKey.ID, signedKey.PublicKey, signedKey.Signature)
		if err != nil {
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
	otKey, _ := s.repo.TakeOneTimePreKey(ctx, userID, deviceID)

	return &domain.PreKeyBundle{
		UserID:        userID,
		DeviceID:      deviceID,
		IdentityKey:   identityKey,
		SignedPreKey:  signedKey,
		OneTimePreKey: otKey,
	}, nil
}
