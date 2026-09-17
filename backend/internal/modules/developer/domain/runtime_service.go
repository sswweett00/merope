package domain

import "context"

// Metrics is the lightweight health payload currently exposed by the developer API.
type Metrics struct {
	SyncRate float64 `json:"sync_rate"`
	Latency  float64 `json:"latency"`
	Load     float64 `json:"load"`
}

// RuntimeDeveloperService represents the production API surface currently wired
// by the developer HTTP transport. The broader DeveloperService contract remains
// available for future modules without forcing partially implemented methods into
// the live runtime.
type RuntimeDeveloperService interface {
	RegisterApp(context.Context, string, string) (*App, error)
	SetupWebhook(context.Context, string, string, []string) (*Webhook, error)
	GetAppHealth(context.Context, string) (*Metrics, error)
	ListWebhooks(context.Context, string) ([]*Webhook, error)
	GenerateAPIKey(context.Context, string, string, []string, int) (*APIKey, error)
	ListAPIKeys(context.Context, string) ([]*APIKey, error)
	RevokeAPIKey(context.Context, string) error
}
