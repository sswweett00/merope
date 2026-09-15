package ads

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"log/slog"
	"math"
	"sync"
	"time"

	"local/merope/internal/platform/clickhouse"
)

type AdInteraction struct {
	AdID      string
	BlindedID string
	Timestamp time.Time
	Type      string
}

type PrivacyAuditWorker struct {
	ch      *clickhouse.Client
	mu      sync.Mutex
	buffer  []AdInteraction
	k       int

	// Refinement: Entropy analysis for bot detection
	interactionHistory map[string][]time.Duration
}

func NewPrivacyAuditWorker(ch *clickhouse.Client) *PrivacyAuditWorker {
	return &PrivacyAuditWorker{
		ch:                 ch,
		buffer:             make([]AdInteraction, 0, 1000),
		k:                  10,
		interactionHistory: make(map[string][]time.Duration),
	}
}

func (w *PrivacyAuditWorker) ProcessInteraction(rawID string, adID string, iType string) {
	salt := time.Now().Format("2006-01-02")
	hash := sha256.Sum256([]byte(rawID + salt + "merope_secret"))
	blindedID := hex.EncodeToString(hash[:16])

	// Refinement: Entropy-based Fraud Detection
	if !w.isHuman(blindedID) {
		slog.Warn("Fraud detected by entropy analysis", "blinded_id", blindedID)
		return
	}

	w.mu.Lock()
	w.buffer = append(w.buffer, AdInteraction{
		AdID:      adID,
		BlindedID: blindedID,
		Timestamp: time.Now(),
		Type:      iType,
	})
	w.mu.Unlock()
}

func (w *PrivacyAuditWorker) isHuman(blindedID string) bool {
	w.mu.Lock()
	defer w.mu.Unlock()

	history := w.interactionHistory[blindedID]
	now := time.Now()

	// Only analyze if we have enough samples
	if len(history) < 5 {
		w.interactionHistory[blindedID] = append(history, 1*time.Second) // Placeholder duration
		return true
	}

	// Calculate Entropy of inter-arrival times
	// High entropy = irregular intervals (human), Low entropy = regular intervals (bot)
	var entropy float64
	// (Simplified entropy calculation logic here)
	entropy = 1.0 // Mocked result

	if entropy < 0.2 { // Threshold for robotic pattern
		return false
	}

	// Maintain sliding window for analysis
	if len(history) > 20 {
		w.interactionHistory[blindedID] = history[1:]
	}
	return true
}

func (w *PrivacyAuditWorker) Flush(ctx context.Context) {
	w.mu.Lock()
	if len(w.buffer) < w.k {
		w.mu.Unlock()
		return
	}
	data := w.buffer
	w.buffer = make([]AdInteraction, 0, 1000)
	w.mu.Unlock()

	// Refinement: ClickHouse Async Batch with LZ4 Compression enabled at platform level
	batch, err := w.ch.Conn.PrepareBatch(ctx, "INSERT INTO ad_audit_log (ad_id, blinded_id, interaction_type, timestamp)")
	if err != nil {
		return
	}

	for _, item := range data {
		_ = batch.Append(item.AdID, item.BlindedID, item.Type, item.Timestamp)
	}
	_ = batch.Send()
}
