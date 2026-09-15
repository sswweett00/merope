package service

import (
	"context"
	"fmt"
	"math"
	"sync"
	"time"

	"local/merope/internal/modules/identity/domain"
)

type IdentitySentinel interface {
	AssessRisk(ctx context.Context, userID, ip, ua string) (float64, error)
	RegisterDevice(ctx context.Context, userID, fingerprint string) error
	VerifyDeviceFingerprint(ctx context.Context, userID, fingerprint string) (bool, error)
	RecordAudit(ctx context.Context, userID, action, metadata string) error
}

type identitySentinel struct {
	mu             sync.RWMutex
	deviceRegistry map[string][]string
	repo           domain.IdentityRepository
}

func NewIdentitySentinel(repo domain.IdentityRepository) IdentitySentinel {
	return &identitySentinel{
		deviceRegistry: make(map[string][]string),
		repo:           repo,
	}
}

func (s *identitySentinel) AssessRisk(ctx context.Context, userID, ip, ua string) (float64, error) {
	risk := 0.0

	s.mu.RLock()
	devices := append([]string(nil), s.deviceRegistry[userID]...)
	s.mu.RUnlock()

	fingerprint := ip + "\x00" + ua
	if len(devices) > 0 {
		found := false
		for _, d := range devices {
			if d == fingerprint {
				found = true
				break
			}
		}
		if !found {
			risk += 0.3
			_ = s.RecordAudit(ctx, userID, "NEW_DEVICE_LOGIN", fmt.Sprintf("IP: %s, UA: %s", ip, ua))
		}
	}

	sessions, err := s.repo.GetSessions(ctx, userID)
	if err == nil && len(sessions) > 0 {
		var lastSession *domain.Session
		for _, sess := range sessions {
			if sess.IsActive && (lastSession == nil || sess.LastActiveAt.After(lastSession.LastActiveAt)) {
				lastSession = sess
			}
		}

		if lastSession != nil && lastSession.IPAddress != ip && time.Since(lastSession.LastActiveAt) < time.Hour {
			risk += 0.5
			_ = s.RecordAudit(ctx, userID, "IMPOSSIBLE_TRAVEL", fmt.Sprintf("Prev IP: %s, Current IP: %s", lastSession.IPAddress, ip))
		}
	}

	return math.Min(risk, 1.0), nil
}

func (s *identitySentinel) RecordAudit(ctx context.Context, userID, action, metadata string) error {
	return nil
}

func (s *identitySentinel) RegisterDevice(ctx context.Context, userID, fingerprint string) error {
	if userID == "" || fingerprint == "" {
		return fmt.Errorf("user id and fingerprint are required")
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	for _, existing := range s.deviceRegistry[userID] {
		if existing == fingerprint {
			return nil
		}
	}
	if len(s.deviceRegistry[userID]) >= 10 {
		s.deviceRegistry[userID] = s.deviceRegistry[userID][1:]
	}
	s.deviceRegistry[userID] = append(s.deviceRegistry[userID], fingerprint)
	return nil
}

func (s *identitySentinel) VerifyDeviceFingerprint(ctx context.Context, userID, fingerprint string) (bool, error) {
	if userID == "" || fingerprint == "" {
		return false, fmt.Errorf("user id and fingerprint are required")
	}
	s.mu.RLock()
	defer s.mu.RUnlock()
	for _, d := range s.deviceRegistry[userID] {
		if d == fingerprint {
			return true, nil
		}
	}
	return false, nil
}
