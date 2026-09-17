package domain

import "context"

type Metrics struct {
	SyncRate float64 `json:"sync_rate"`
	Latency  float64 `json:"latency"`
	Load     float64 `json:"load"`
}

type RuntimeDeveloperService interface {
	RegisterApp(context.Context, string, string, string) (*App, error)
	GetApp(context.Context, string) (*App, error)
	GetApps(context.Context, string) ([]*App, error)
	UpdateApp(context.Context, *App) error
	DeleteApp(context.Context, string) error
	VerifyApp(context.Context, string) error

	CreateAPIKey(context.Context, string, string, string, []string, int) (*APIKey, error)
	GetAPIKey(context.Context, string) (*APIKey, error)
	ListAPIKeys(context.Context, string) ([]*APIKey, error)
	UpdateAPIKey(context.Context, *APIKey) error
	RevokeAPIKey(context.Context, string) error

	CreateWebhook(context.Context, string, string, string, []string) (*Webhook, error)
	GetWebhook(context.Context, string) (*Webhook, error)
	ListWebhooks(context.Context, string) ([]*Webhook, error)
	UpdateWebhook(context.Context, *Webhook) error
	DeleteWebhook(context.Context, string) error
	TestWebhook(context.Context, string) error

	CreateBot(context.Context, string, string, string) (*Bot, error)
	GetBot(context.Context, string) (*Bot, error)
	ListBots(context.Context, string) ([]*Bot, error)
	UpdateBot(context.Context, *Bot) error
	DeleteBot(context.Context, string) error

	GetMetrics(context.Context, string, string) (*DeveloperMetrics, error)
	RunTestSuite(context.Context, string) (*TestSuiteResult, error)
}
