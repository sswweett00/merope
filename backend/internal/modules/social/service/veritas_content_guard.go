package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"strings"
	"sync"
	"time"

	"local/merope/internal/core/events"
)

// VeritasContentGuard defines the interface for the Social & Content Integrity Subsystem.
type VeritasContentGuard interface {
	VerifyOriginality(ctx context.Context, userID, content string) (bool, string, error)
	MarkContentProvenance(ctx context.Context, postID, ownerID string) error
	DetectBotPattern(ctx context.Context, userID, content string) bool
	TrackInteraction(ctx context.Context, userID, targetID, action string) bool // Detect social botting
}

type veritasContentGuard struct {
	bus           events.Publisher
	fingerprints  map[string]string // fingerprint -> postID
	userPostTimes map[string][]time.Time
	interactions  map[string][]time.Time // userID -> interaction timestamps
	mu            sync.RWMutex
}

// NewVeritasContentGuard creates a new Veritas Content Guard engine.
func NewVeritasContentGuard(bus events.Publisher) VeritasContentGuard {
	return &veritasContentGuard{
		bus:           bus,
		fingerprints:  make(map[string]string),
		userPostTimes: make(map[string][]time.Time),
		interactions:  make(map[string][]time.Time),
	}
}

// VerifyOriginality checks if the content has been posted before (deduplication).
func (g *veritasContentGuard) VerifyOriginality(ctx context.Context, userID, content string) (bool, string, error) {
	fingerprint := g.computeFingerprint(content)

	g.mu.RLock()
	originalPostID, exists := g.fingerprints[fingerprint]
	g.mu.RUnlock()

	if exists {
		return false, originalPostID, nil
	}

	// Register new fingerprint
	g.mu.Lock()
	g.fingerprints[fingerprint] = "pending" // Post ID will be assigned after storage
	g.mu.Unlock()

	return true, "", nil
}

// MarkContentProvenance tags content with owner and timestamp for integrity.
func (g *veritasContentGuard) MarkContentProvenance(ctx context.Context, postID, ownerID string) error {
	_ = g.bus.Publish(ctx, "veritas.provenance.marked", events.Event{
		Type: "VERITAS_PROVENANCE_MARKED",
		Payload: map[string]interface{}{
			"post_id":   postID,
			"owner_id":  ownerID,
			"marked_at": time.Now(),
		},
	})
	return nil
}

// DetectBotPattern checks for high-frequency posting or repetitive content patterns.
func (g *veritasContentGuard) DetectBotPattern(ctx context.Context, userID, content string) bool {
	g.mu.Lock()
	defer g.mu.Unlock()

	now := time.Now()
	g.userPostTimes[userID] = append(g.userPostTimes[userID], now)

	// Keep only last 1 minute of history
	var validTimes []time.Time
	for _, t := range g.userPostTimes[userID] {
		if now.Sub(t) < time.Minute {
			validTimes = append(validTimes, t)
		}
	}
	g.userPostTimes[userID] = validTimes

	// Rule 1: High frequency posting (> 10 per minute)
	if len(validTimes) > 10 {
		g.publishAlert(ctx, userID, "high_frequency_posting", len(validTimes))
		return true
	}

	// Rule 2: Link Spam Detection
	if strings.Count(content, "http") > 3 {
		g.publishAlert(ctx, userID, "link_spam", 1)
		return true
	}

	return false
}

func (g *veritasContentGuard) TrackInteraction(ctx context.Context, userID, targetID, action string) bool {
	g.mu.Lock()
	defer g.mu.Unlock()

	now := time.Now()
	g.interactions[userID] = append(g.interactions[userID], now)

	// Keep only last 5 minutes of history
	var validInteractions []time.Time
	for _, t := range g.interactions[userID] {
		if now.Sub(t) < 5*time.Minute {
			validInteractions = append(validInteractions, t)
		}
	}
	g.interactions[userID] = validInteractions

	// Rule 3: Social Botting (Fast follow/like > 50 in 5 mins)
	if len(validInteractions) > 50 {
		g.publishAlert(ctx, userID, "social_botting", len(validInteractions))
		return true
	}

	return false
}

func (g *veritasContentGuard) publishAlert(ctx context.Context, userID, pattern string, score int) {
	_ = g.bus.Publish(ctx, "veritas.bot.detected", events.Event{
		Type: "VERITAS_BOT_DETECTED",
		Payload: map[string]interface{}{
			"user_id":     userID,
			"pattern":     pattern,
			"score":       score,
			"detected_at": time.Now(),
		},
	})
}

func (g *veritasContentGuard) computeFingerprint(content string) string {
	normalized := strings.ToLower(strings.Join(strings.Fields(content), ""))
	hash := sha256.Sum256([]byte(normalized))
	return hex.EncodeToString(hash[:])
}
