package security

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/core/events"
)

// MeropeSecurityFabric orchestrates domain-specific security services and provides central auditing.
type MeropeSecurityFabric struct {
	bus      events.Publisher
	detector AnomalyDetector
}

func NewMeropeSecurityFabric(bus events.Publisher, detector AnomalyDetector) *MeropeSecurityFabric {
	return &MeropeSecurityFabric{
		bus:      bus,
		detector: detector,
	}
}

func (f *MeropeSecurityFabric) Inspect(ctx context.Context, userID, payload string) error {
	isAnomaly, reason := f.detector.AnalyzePayload(ctx, userID, payload)
	if isAnomaly {
		f.LogSecurityEvent(ctx, "fabric", "ANOMALY_DETECTED", 5, map[string]interface{}{
			"user_id": userID,
			"reason":  reason,
		})
		return fmt.Errorf("security violation: %s", reason)
	}
	return nil
}

// LogSecurityEvent records a high-level system security event to the audit log.
func (f *MeropeSecurityFabric) LogSecurityEvent(ctx context.Context, domain, eventType string, severity int, details map[string]interface{}) {
	_ = f.bus.Publish(ctx, "security.fabric.audit", events.Event{
		Type: "SECURITY_AUDIT_LOG",
		Payload: map[string]interface{}{
			"domain":    domain,
			"event":     eventType,
			"severity":  severity,
			"details":   details,
			"logged_at": time.Now(),
		},
	})
}

// SystemWideLockdown triggers a high-severity alert to all subsystems (hypothetical).
func (f *MeropeSecurityFabric) SystemWideLockdown(ctx context.Context, reason string) {
	_ = f.bus.Publish(ctx, "security.fabric.lockdown", events.Event{
		Type: "SYSTEM_LOCKDOWN",
		Payload: map[string]interface{}{
			"reason":       reason,
			"triggered_at": time.Now(),
		},
	})
}
