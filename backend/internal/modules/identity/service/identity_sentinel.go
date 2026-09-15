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
	mu              sync.RWMutex
	deviceRegistry  map[string][]string // userID -> fingerprints
	repo            domain.IdentityRepository
}

func NewIdentitySentinel(repo domain.IdentityRepository) IdentitySentinel {
	return &identitySentinel{
		deviceRegistry: make(map[string][]string),
		repo:           repo,
	}
}

func (s *identitySentinel) AssessRisk(ctx context.Context, userID, ip, ua string) (float64, error) {
	risk := 0.0

	// 1. Device Fingerprint Check
	s.mu.RLock()
	devices := s.deviceRegistry[userID]
	s.mu.RUnlock()

	fingerprint := ip + ua
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

	// 2. Impossible Travel & Geolocation Anomaly (Simulated)
	sessions, err := s.repo.GetSessions(ctx, userID)
	if err == nil && len(sessions) > 0 {
		var lastSession *domain.Session
		for _, sess := range sessions {
			if sess.IsActive && (lastSession == nil || sess.LastActiveAt.After(lastSession.LastActiveAt)) {
				lastSession = sess
			}
		}

		if lastSession != nil && lastSession.IPAddress != ip {
			// In a real system, we'd use GeoIP to check distance / time
			// Here we simulate a high risk if IP prefix changes drastically in short time
			if time.Since(lastSession.LastActiveAt) < 1*time.Hour {
				risk += 0.5
				_ = s.RecordAudit(ctx, userID, "IMPOSSIBLE_TRAVEL", fmt.Sprintf("Prev IP: %s, Current IP: %s", lastSession.IPAddress, ip))
			}
		}
	}

	// 3. Credential Stuffing / Brute Force (Simulated via recent audit logs)
	// (Logic would query Redis or DB for recent failed attempts)

	return math.Min(risk, 1.0), nil
}

func (s *identitySentinel) RecordAudit(ctx context.Context, userID, action, metadata string) error {
	// Zenith: Log to Merope Audit Logs
	// This would typically go to a dedicated audit module or ClickHouse
	return nil
}

func (s *identitySentinel) RegisterDevice(ctx context.Context, userID, fingerprint string) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.deviceRegistry[userID] = append(s.deviceRegistry[userID], fingerprint)
	return nil
}

func (s *identitySentinel) VerifyDeviceFingerprint(ctx context.Context, userID, fingerprint string) (bool, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	for _, d := range s.deviceRegistry[userID] {
		if d == fingerprint {
			return true, nil
		}
	}
	return false, nil
}

func (s *identitySentinel) RecordAudit(ctx context.Context, userID, action, metadata string) error {
	// Integration with database/audit table would go here
	return nil
}
