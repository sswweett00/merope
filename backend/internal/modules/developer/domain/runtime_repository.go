package domain

import "context"

type RuntimeDeveloperRepository interface {
	CreateApp(context.Context, *App) error
	GetApp(context.Context, string) (*App, error)
	GetAppsByOwner(context.Context, string, int32, int32) ([]*App, error)
	UpdateApp(context.Context, *App) error
	DeleteApp(context.Context, string) error
	VerifyApp(context.Context, string) error

	CreateWebhook(context.Context, *Webhook) error
	GetWebhook(context.Context, string) (*Webhook, error)
	GetWebhooksByAppID(context.Context, string) ([]*Webhook, error)
	UpdateWebhook(context.Context, *Webhook) error
	DeleteWebhook(context.Context, string) error
	RecordWebhookDelivery(context.Context, string, bool, int, string) error
	GetWebhookStats(context.Context, string) (*WebhookStats, error)

	CreateAPIKey(context.Context, *APIKey) error
	GetAPIKey(context.Context, string) (*APIKey, error)
	GetAPIKeyByHash(context.Context, string) (*APIKey, error)
	GetAPIKeysByAppID(context.Context, string) ([]*APIKey, error)
	UpdateAPIKey(context.Context, *APIKey) error
	UpdateAPIKeyUsage(context.Context, string) error
	RevokeAPIKey(context.Context, string) error

	CreateBot(context.Context, *Bot) error
	GetBot(context.Context, string) (*Bot, error)
	GetBotsByAppID(context.Context, string) ([]*Bot, error)
	UpdateBot(context.Context, *Bot) error
	DeleteBot(context.Context, string) error

	GetMetrics(context.Context, string, string) (*DeveloperMetrics, error)
	RecordAPIRequest(context.Context, string, string, string, int32, bool, int64, string) error
}
