package security

import (
	"context"
	"fmt"
	"time"
)

type CompliancePolicy interface {
	ValidateDataRetention(ctx context.Context, createdAt time.Time, retentionDays int) bool
	AuditAction(ctx context.Context, userID, action, resource string) error
}

type compliancePolicy struct {
	strictMode bool
}

func NewCompliancePolicy(strictMode bool) CompliancePolicy {
	return &compliancePolicy{strictMode: strictMode}
}

func (p *compliancePolicy) ValidateDataRetention(ctx context.Context, createdAt time.Time, retentionDays int) bool {
	deadline := createdAt.Add(time.Duration(retentionDays) * 24 * time.Hour)
	return time.Now().Before(deadline)
}

func (p *compliancePolicy) AuditAction(ctx context.Context, userID, action, resource string) error {
	// Enterprise grade audit trail compliance
	fmt.Printf("[AUDIT COMPLIANCE] User: %s | Action: %s | Resource: %s | Time: %v\n", userID, action, resource, time.Now())
	return nil
}
