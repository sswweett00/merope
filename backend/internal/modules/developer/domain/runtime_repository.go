package domain

import "context"

type RuntimeDeveloperRepository interface {
	CreateApp(context.Context, *App) error
	CreateWebhook(context.Context, *Webhook) error
	GetMetrics(context.Context, string) (*Metrics, error)
	GetWebhooksByAppID(context.Context, string) ([]*Webhook, error)
	CreateAPIKey(context.Context, *APIKey) error
	GetAPIKeyByHash(context.Context, string) (*APIKey, error)
	GetAPIKeysByAppID(context.Context, string) ([]*APIKey, error)
	UpdateAPIKeyUsage(context.Context, string) error
	RevokeAPIKey(context.Context, string) error
}
