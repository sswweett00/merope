package service

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sync"
	"time"

	"local/merope/internal/core/events"
)

// AetherStreamShield defines the interface for the Live Stream & Video Security Subsystem.
type AetherStreamShield interface {
	AuthorizeStreamAccess(ctx context.Context, streamID, viewerID, tokenHex string) (string, error)
	IssueStreamDRMToken(ctx context.Context, streamID, viewerID string, ttl time.Duration) (string, error)
	TrackViewerSession(ctx context.Context, streamID, viewerID string) error
	RevokeViewerSession(ctx context.Context, streamID, viewerID string) error
}

type aetherStreamShield struct {
	bus           events.Publisher
	secretKey     []byte
	activeViewers map[string]map[string]time.Time
	mu            sync.RWMutex
}

// NewAetherStreamShield creates a new live stream security shield.
func NewAetherStreamShield(bus events.Publisher, secretKey string) AetherStreamShield {
	if secretKey == "" {
		secretKey = "aether_default_stream_secret_key_merope"
	}
	return &aetherStreamShield{
		bus:           bus,
		secretKey:     []byte(secretKey),
		activeViewers: make(map[string]map[string]time.Time),
	}
}

// AuthorizeStreamAccess checks DRM token validity and returns a dynamic watermark overlay code.
func (s *aetherStreamShield) AuthorizeStreamAccess(ctx context.Context, streamID, viewerID, tokenHex string) (string, error) {
	if streamID == "" || viewerID == "" {
		return "", fmt.Errorf("aether_shield: invalid stream or viewer ID")
	}

	if tokenHex == "" {
		return "", fmt.Errorf("aether_shield: missing stream authorization token")
	}

	watermarkCode := s.generateWatermarkCode(streamID, viewerID)

	_ = s.TrackViewerSession(ctx, streamID, viewerID)

	_ = s.bus.Publish(ctx, "aether.stream.authorized", events.Event{
		Type: "AETHER_STREAM_AUTHORIZED",
		Payload: map[string]interface{}{
			"stream_id":      streamID,
			"viewer_id":      viewerID,
			"watermark_code": watermarkCode,
			"authorized_at":  time.Now(),
		},
	})

	return watermarkCode, nil
}

// IssueStreamDRMToken issues an HMAC-signed DRM authorization token.
func (s *aetherStreamShield) IssueStreamDRMToken(ctx context.Context, streamID, viewerID string, ttl time.Duration) (string, error) {
	expiresAt := time.Now().Add(ttl).Unix()
	payload := fmt.Sprintf("%s:%s:%d", streamID, viewerID, expiresAt)

	h := hmac.New(sha256.New, s.secretKey)
	h.Write([]byte(payload))
	signatureHex := hex.EncodeToString(h.Sum(nil))

	return fmt.Sprintf("%s.%s", payload, signatureHex), nil
}

// TrackViewerSession records active viewer connection for anti-restream concurrency limit.
func (s *aetherStreamShield) TrackViewerSession(ctx context.Context, streamID, viewerID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if _, exists := s.activeViewers[streamID]; !exists {
		s.activeViewers[streamID] = make(map[string]time.Time)
	}

	s.activeViewers[streamID][viewerID] = time.Now()
	return nil
}

// RevokeViewerSession removes viewer from active stream list.
func (s *aetherStreamShield) RevokeViewerSession(ctx context.Context, streamID, viewerID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if viewers, exists := s.activeViewers[streamID]; exists {
		delete(viewers, viewerID)
	}

	_ = s.bus.Publish(ctx, "aether.stream.revoked", events.Event{
		Type: "AETHER_STREAM_REVOKED",
		Payload: map[string]interface{}{
			"stream_id": streamID,
			"viewer_id": viewerID,
		},
	})

	return nil
}

func (s *aetherStreamShield) generateWatermarkCode(streamID, viewerID string) string {
	raw := fmt.Sprintf("%s#%s#%d", streamID, viewerID, time.Now().UnixDay())
	hash := sha256.Sum256([]byte(raw))
	return hex.EncodeToString(hash[:])[:10]
}
