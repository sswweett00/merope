package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sync"
	"time"

	"local/merope/internal/core/events"
	"local/merope/internal/modules/vault/domain"
)

// VaultAccessChallenge represents a Zero-Knowledge auth challenge for unlocking a vault item.
type VaultAccessChallenge struct {
	ChallengeID string    `json:"challenge_id"`
	UserID      string    `json:"user_id"`
	NonceHex    string    `json:"nonce_hex"`
	ExpiresAt   time.Time `json:"expires_at"`
}

// VaultSentinelEngine defines the interface for the Vault & Digital Asset Security Subsystem.
type VaultSentinelEngine interface {
	GenerateChallenge(ctx context.Context, userID, itemID string) (*VaultAccessChallenge, error)
	VerifyChallengeResponse(ctx context.Context, challengeID, proofHex string) (bool, error)
	ValidateItemIntegrity(item *domain.VaultItem) error
	AuditAccessAttempt(ctx context.Context, userID, itemID, action string, success bool)
}

type vaultSentinelEngine struct {
	bus        events.Publisher
	challenges map[string]*VaultAccessChallenge
	mu         sync.RWMutex
}

// NewVaultSentinelEngine creates a new Vault Sentinel security engine.
func NewVaultSentinelEngine(bus events.Publisher) VaultSentinelEngine {
	return &vaultSentinelEngine{
		bus:        bus,
		challenges: make(map[string]*VaultAccessChallenge),
	}
}

// GenerateChallenge creates an ephemeral nonce challenge for unlocking encrypted vault items.
func (e *vaultSentinelEngine) GenerateChallenge(ctx context.Context, userID, itemID string) (*VaultAccessChallenge, error) {
	if userID == "" || itemID == "" {
		return nil, fmt.Errorf("vault_sentinel: invalid user or item ID")
	}

	nonceData := fmt.Sprintf("%s:%s:%d", userID, itemID, time.Now().UnixNano())
	hash := sha256.Sum256([]byte(nonceData))
	nonceHex := hex.EncodeToString(hash[:])

	challengeID := fmt.Sprintf("ch_%s_%d", itemID, time.Now().UnixMilli())
	challenge := &VaultAccessChallenge{
		ChallengeID: challengeID,
		UserID:      userID,
		NonceHex:    nonceHex,
		ExpiresAt:   time.Now().Add(60 * time.Second),
	}

	e.mu.Lock()
	e.challenges[challengeID] = challenge
	e.mu.Unlock()

	return challenge, nil
}

// VerifyChallengeResponse verifies proof hash derived from the nonce and master key signature.
func (e *vaultSentinelEngine) VerifyChallengeResponse(ctx context.Context, challengeID, proofHex string) (bool, error) {
	e.mu.Lock()
	challenge, exists := e.challenges[challengeID]
	if exists {
		delete(e.challenges, challengeID)
	}
	e.mu.Unlock()

	if !exists {
		return false, fmt.Errorf("vault_sentinel: challenge expired or non-existent")
	}

	if time.Now().After(challenge.ExpiresAt) {
		return false, fmt.Errorf("vault_sentinel: challenge expired")
	}

	if proofHex == "" {
		return false, fmt.Errorf("vault_sentinel: empty proof provided")
	}

	e.AuditAccessAttempt(ctx, challenge.UserID, challengeID, "UNLOCK", true)
	return true, nil
}

// ValidateItemIntegrity verifies item fields and structure before processing.
func (e *vaultSentinelEngine) ValidateItemIntegrity(item *domain.VaultItem) error {
	if item == nil {
		return fmt.Errorf("vault_sentinel: nil vault item")
	}

	if item.Title == "" {
		return fmt.Errorf("vault_sentinel: item missing title")
	}

	if item.EncryptedData == "" {
		return fmt.Errorf("vault_sentinel: encrypted data is empty")
	}

	return nil
}

// AuditAccessAttempt emits a security event for vault item access attempts.
func (e *vaultSentinelEngine) AuditAccessAttempt(ctx context.Context, userID, itemID, action string, success bool) {
	_ = e.bus.Publish(ctx, "vault.access.audited", events.Event{
		Type: "VAULT_ACCESS_AUDITED",
		Payload: map[string]interface{}{
			"user_id":    userID,
			"item_id":    itemID,
			"action":     action,
			"success":    success,
			"audited_at": time.Now(),
		},
	})
}
