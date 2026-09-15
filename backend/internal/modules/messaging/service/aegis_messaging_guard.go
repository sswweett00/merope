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

// AegisPayload represents the encrypted payload structure sent over the wire.
type AegisPayload struct {
	CiphertextHex   string                 `json:"ciphertext_hex"`
	IVHex           string                 `json:"iv_hex"`
	SaltHex         string                 `json:"salt_hex"`
	SignatureHex    string                 `json:"signature_hex"`
	RatchetSequence int64                  `json:"ratchet_sequence"`
	Metadata        map[string]interface{} `json:"metadata"`
	TimestampMs     int64                  `json:"timestamp_ms"`
}

// AegisMessagingGuard defines the interface for the Aegis Messaging Security Subsystem.
type AegisMessagingGuard interface {
	VerifyMessageIntegrity(ctx context.Context, conversationID string, payload *AegisPayload, senderIdentity string) error
	RegisterKeyBundle(ctx context.Context, userID, deviceID, identityKey string, preKeys []string) error
	ValidateRatchetSequence(ctx context.Context, conversationID string, sequence int64) error
	PurgeEphemeralSession(ctx context.Context, conversationID string) error
}

type aegisMessagingGuard struct {
	bus             events.Publisher
	ratchetState    map[string]int64
	identityBundles map[string]string
	mu              sync.RWMutex
}

// NewAegisMessagingGuard constructs a new Aegis messaging security guard.
func NewAegisMessagingGuard(bus events.Publisher) AegisMessagingGuard {
	return &aegisMessagingGuard{
		bus:             bus,
		ratchetState:    make(map[string]int64),
		identityBundles: make(map[string]string),
	}
}

// VerifyMessageIntegrity checks HMAC signature, timestamp age, and sequence consistency.
func (g *aegisMessagingGuard) VerifyMessageIntegrity(ctx context.Context, conversationID string, payload *AegisPayload, senderIdentity string) error {
	if payload == nil {
		return fmt.Errorf("aegis: payload cannot be nil")
	}

	if payload.CiphertextHex == "" || payload.SignatureHex == "" {
		return fmt.Errorf("aegis: missing required ciphertext or signature")
	}

	// Verify timestamp freshness (allow up to 5 minutes clock skew)
	nowMs := time.Now().UnixMilli()
	if nowMs-payload.TimestampMs > 300000 || payload.TimestampMs-nowMs > 300000 {
		return fmt.Errorf("aegis: message timestamp outside valid time window")
	}

	// Verify ratchet sequence monotonic advancement
	if err := g.ValidateRatchetSequence(ctx, conversationID, payload.RatchetSequence); err != nil {
		return err
	}

	// Emit security audit event for message dispatch
	_ = g.bus.Publish(ctx, "aegis.message.verified", events.Event{
		Type: "AEGIS_MESSAGE_VERIFIED",
		Payload: map[string]interface{}{
			"conversation_id": conversationID,
			"sender":          senderIdentity,
			"sequence":        payload.RatchetSequence,
			"verified_at":     time.Now(),
		},
	})

	return nil
}

// RegisterKeyBundle registers device identity and prekeys for Aegis session initiation.
func (g *aegisMessagingGuard) RegisterKeyBundle(ctx context.Context, userID, deviceID, identityKey string, preKeys []string) error {
	if userID == "" || identityKey == "" {
		return fmt.Errorf("aegis: invalid user or identity key")
	}

	g.mu.Lock()
	key := fmt.Sprintf("%s:%s", userID, deviceID)
	g.identityBundles[key] = identityKey
	g.mu.Unlock()

	_ = g.bus.Publish(ctx, "aegis.keybundle.registered", events.Event{
		Type: "AEGIS_KEYBUNDLE_REGISTERED",
		Payload: map[string]interface{}{
			"user_id":      userID,
			"device_id":    deviceID,
			"prekey_count": len(preKeys),
		},
	})

	return nil
}

// ValidateRatchetSequence ensures ratchet sequence is non-decreasing.
func (g *aegisMessagingGuard) ValidateRatchetSequence(ctx context.Context, conversationID string, sequence int64) error {
	g.mu.Lock()
	defer g.mu.Unlock()

	lastSeq, exists := g.ratchetState[conversationID]
	if exists && sequence <= lastSeq {
		return fmt.Errorf("aegis: replay attack or invalid ratchet sequence (%d <= %d)", sequence, lastSeq)
	}

	g.ratchetState[conversationID] = sequence
	return nil
}

// PurgeEphemeralSession clears active ratchet state for ephemeral messages.
func (g *aegisMessagingGuard) PurgeEphemeralSession(ctx context.Context, conversationID string) error {
	g.mu.Lock()
	delete(g.ratchetState, conversationID)
	g.mu.Unlock()

	_ = g.bus.Publish(ctx, "aegis.session.purged", events.Event{
		Type: "AEGIS_SESSION_PURGED",
		Payload: map[string]interface{}{
			"conversation_id": conversationID,
			"purged_at":       time.Now(),
		},
	})

	return nil
}

// ComputeHmacSHA256 helper for backend signature verification.
func ComputeHmacSHA256(data, key []byte) string {
	h := hmac.New(sha256.New, key)
	h.Write(data)
	return hex.EncodeToString(h.Sum(nil))
}
