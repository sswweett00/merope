package security

import (
	"context"
	"math"
	"strings"
	"sync"
	"time"
)

type AnomalyDetector interface {
	AnalyzePayload(ctx context.Context, userID, payload string) (bool, string)
}

type anomalyDetector struct {
	mu            sync.Mutex
	requestCounts map[string][]time.Time
}

func NewAnomalyDetector() AnomalyDetector {
	return &anomalyDetector{
		requestCounts: make(map[string][]time.Time),
	}
}

func (d *anomalyDetector) AnalyzePayload(ctx context.Context, userID, payload string) (bool, string) {
	// Heuristic 1: SQL Injection / Script injection patterns (Expanded)
	lower := strings.ToLower(payload)
	maliciousPatterns := []string{
		"<script>", "javascript:", "onerror=", "onload=",
		"drop table", "truncate table", "delete from", "insert into",
		"or 1=1", "union select", "waitfor delay", "pg_sleep",
		"../", "/etc/passwd", ".bash_history", ".env",
	}

	for _, pattern := range maliciousPatterns {
		if strings.Contains(lower, pattern) {
			return true, "MALICIOUS_INJECTION_DETECTED"
		}
	}

	// Heuristic 2: Entropy check for potential bot/machine-generated noise
	if len(payload) > 1000 && calculateEntropy(payload) < 2.0 {
		return true, "LOW_ENTROPY_SUSPICIOUS_CONTENT"
	}

	// Heuristic 3: Rate limit / Flood detection
	d.mu.Lock()
	defer d.mu.Unlock()

	now := time.Now()
	times := d.requestCounts[userID]
	var recent []time.Time
	for _, t := range times {
		if now.Sub(t) < 10*time.Second {
			recent = append(recent, t)
		}
	}

	if len(recent) > 50 {
		return true, "ANOMALY_FLOOD_DETECTED"
	}

	recent = append(recent, now)
	d.requestCounts[userID] = recent

	return false, "OK"
}

func calculateEntropy(s string) float64 {
	// Simple character distribution entropy
	counts := make(map[rune]int)
	for _, r := range s {
		counts[r]++
	}
	var entropy float64
	total := float64(len(s))
	for _, count := range counts {
		p := float64(count) / total
		entropy -= p * math.Log2(p)
	}
	return entropy
}
