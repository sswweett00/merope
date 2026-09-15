package domain

import "time"

// ... existing finance domain types ...

type UserSubscription struct {
	ID            string
	UserID        string
	PlanID        string
	Status        string
	StartedAt     time.Time
	ExpiresAt     time.Time
	AutoRenew     bool
	NextBillingAt *time.Time
	CancelledAt   *time.Time
	Features      []string
	UsageStats    SubscriptionUsage
}

type SubscriptionUsage struct {
	MessagesSent  int32
	StorageUsed   int64
	APICallsMade  int32
	BandwidthUsed int64
}
