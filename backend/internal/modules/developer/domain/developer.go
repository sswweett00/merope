package domain

import (
	"context"
	"time"
)

type App struct {
	ID           string   `json:"id"`
	OwnerID      string   `json:"owner_id"`
	Name         string   `json:"name"`
	Description  string   `json:"description"`
	ClientID     string   `json:"client_id"`
	ClientSecret string   `json:"client_secret,omitempty"`
	RedirectURI  string   `json:"redirect_uri"`
	Scopes       []string `json:"scopes"`
	GrantTypes   []string `json:"grant_types"`
	IsPublic     bool     `json:"is_public"`
	IsActive     bool     `json:"is_active"`
	IsVerified   bool     `json:"is_verified"`
	IconURL      string   `json:"icon_url"`
	HomepageURL  string   `json:"homepage_url"`
	TermsURL     string   `json:"terms_url"`
	PrivacyURL   string   `json:"privacy_url"`
	CallbackURLs []string `json:"callback_urls"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	Stats        AppStats `json:"stats"`
	Settings     AppSettings `json:"settings"`
}

type AppStats struct {
	TotalUsers        int32 `json:"total_users"`
	ActiveUsers       int32 `json:"active_users"`
	TotalAPIRequests  int64 `json:"total_api_requests"`
	WebhookDeliveries int64 `json:"webhook_deliveries"`
	Failures          int32 `json:"failures"`
	AvgLatency        float32 `json:"avg_latency"`
	LastUsedAt        time.Time `json:"last_used_at"`
}

type AppSettings struct {
	EnableWebhooks      bool  `json:"enable_webhooks"`
	EnableRealtime      bool  `json:"enable_realtime"`
	EnableBatchAPI      bool  `json:"enable_batch_api"`
	RateLimitPerMinute  int32 `json:"rate_limit_per_minute"`
	RateLimitPerHour    int32 `json:"rate_limit_per_hour"`
	MaxConcurrentCalls  int32 `json:"max_concurrent_calls"`
	RequireUserApproval bool  `json:"require_user_approval"`
	AutoApproveTokens   bool  `json:"auto_approve_tokens"`
	TokenExpiry         int32 `json:"token_expiry"`
	RefreshTokenExpiry  int32 `json:"refresh_token_expiry"`
}

type Webhook struct {
	ID          string `json:"id"`
	AppID       string `json:"app_id"`
	Name        string `json:"name"`
	TargetURL   string `json:"target_url"`
	Secret      string `json:"secret,omitempty"`
	Events      []string `json:"events"`
	IsActive    bool `json:"is_active"`
	RetryPolicy WebhookRetryPolicy `json:"retry_policy"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	Stats       WebhookStats `json:"stats"`
}

type WebhookRetryPolicy struct {
	MaxRetries      int32 `json:"max_retries"`
	RetryInterval   int32 `json:"retry_interval"`
	BackoffStrategy string `json:"backoff_strategy"`
	Timeout         int32 `json:"timeout"`
}

type WebhookStats struct {
	TotalDeliveries int64 `json:"total_deliveries"`
	SuccessCount    int64 `json:"success_count"`
	FailureCount    int64 `json:"failure_count"`
	AvgResponseTime float32 `json:"avg_response_time"`
	LastDeliveredAt *time.Time `json:"last_delivered_at,omitempty"`
	LastFailedAt    *time.Time `json:"last_failed_at,omitempty"`
}

type APIKey struct {
	ID           string `json:"id"`
	AppID        string `json:"app_id"`
	KeyHash      string `json:"key_hash,omitempty"`
	KeyPrefix    string `json:"key_prefix"`
	Name         string `json:"name"`
	Description  string `json:"description"`
	Scopes       []string `json:"scopes"`
	RateLimitRPM int `json:"rate_limit_rpm"`
	RateLimitRPH int `json:"rate_limit_rph"`
	IsActive     bool `json:"is_active"`
	LastUsedAt   *time.Time `json:"last_used_at,omitempty"`
	ExpiresAt    *time.Time `json:"expires_at,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
	RawKey       string `json:"raw_key,omitempty"`
	IPWhitelist  []string `json:"ip_whitelist"`
	UsageStats   APIKeyUsageStats `json:"usage_stats"`
}

type APIKeyUsageStats struct {
	TotalRequests  int64 `json:"total_requests"`
	FailedRequests int64 `json:"failed_requests"`
	LastUsedIP     string `json:"last_used_ip"`
	UsageByDay     map[string]int64 `json:"usage_by_day"`
}

type Bot struct {
	ID           string `json:"id"`
	AppID        string `json:"app_id"`
	Name         string `json:"name"`
	Description  string `json:"description"`
	AvatarURL    string `json:"avatar_url"`
	IsPublic     bool `json:"is_public"`
	IsActive     bool `json:"is_active"`
	IsOfficial   bool `json:"is_official"`
	Permissions  []string `json:"permissions"`
	Capabilities []BotCapability `json:"capabilities"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	Stats        BotStats `json:"stats"`
	Settings     BotSettings `json:"settings"`
}

type BotCapability struct {
	Type        string `json:"type"`
	Permission  string `json:"permission"`
	Description string `json:"description"`
	IsEnabled   bool `json:"is_enabled"`
}

type BotStats struct {
	TotalUsers       int32 `json:"total_users"`
	ActiveUsers      int32 `json:"active_users"`
	MessagesSent     int64 `json:"messages_sent"`
	CommandsExecuted int64 `json:"commands_executed"`
	ErrorsOccurred   int32 `json:"errors_occurred"`
	AvgResponseTime  float32 `json:"avg_response_time"`
	Uptime           float64 `json:"uptime"`
	LastActiveAt     time.Time `json:"last_active_at"`
}

type BotSettings struct {
	AllowDirectMessages bool `json:"allow_direct_messages"`
	AllowGroupMessages  bool `json:"allow_group_messages"`
	EnableCommands      bool `json:"enable_commands"`
	EnableWebhooks      bool `json:"enable_webhooks"`
	PrivacyMode         string `json:"privacy_mode"`
	RateLimitPerUser    int32 `json:"rate_limit_per_user"`
	MaxCommandQueue     int32 `json:"max_command_queue"`
}

type OAuthToken struct {
	ID        string `json:"id"`
	AppID     string `json:"app_id"`
	UserID    string `json:"user_id"`
	TokenType string `json:"token_type"`
	TokenHash string `json:"token_hash,omitempty"`
	ExpiresAt time.Time `json:"expires_at"`
	Scopes    []string `json:"scopes"`
	CreatedAt time.Time `json:"created_at"`
	RevokedAt *time.Time `json:"revoked_at,omitempty"`
	DeviceID  string `json:"device_id"`
	IPAddress string `json:"ip_address"`
	UserAgent string `json:"user_agent"`
}

type DeveloperMetrics struct {
	AppID         string `json:"app_id"`
	Period        string `json:"period"`
	APIRequests   int64 `json:"api_requests"`
	Errors        int32 `json:"errors"`
	AvgLatency    float32 `json:"avg_latency"`
	P95Latency    float32 `json:"p95_latency"`
	P99Latency    float32 `json:"p99_latency"`
	SuccessRate   float64 `json:"success_rate"`
	UniqueUsers   int32 `json:"unique_users"`
	BandwidthUsed int64 `json:"bandwidth_used"`
	TopEndpoints  []EndpointStats `json:"top_endpoints"`
}

type EndpointStats struct {
	Path         string `json:"path"`
	Method       string `json:"method"`
	RequestCount int64 `json:"request_count"`
	AvgLatency   float32 `json:"avg_latency"`
	ErrorRate    float64 `json:"error_rate"`
}

type APIQuota struct {
	AppID           string `json:"app_id"`
	Period          string `json:"period"`
	RequestsMade    int64 `json:"requests_made"`
	RequestsLimit   int64 `json:"requests_limit"`
	ResetAt         time.Time `json:"reset_at"`
	UsagePercentage float64 `json:"usage_percentage"`
}

type APIDocumentation struct {
	AppID       string `json:"app_id"`
	Version     string `json:"version"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Endpoints   []APIEndpointDoc `json:"endpoints"`
	Models      []APIModelDoc `json:"models"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type APIEndpointDoc struct {
	Path         string `json:"path"`
	Method       string `json:"method"`
	Description  string `json:"description"`
	Parameters   []APIParameterDoc `json:"parameters"`
	Responses    []APIResponseDoc `json:"responses"`
	RequiresAuth bool `json:"requires_auth"`
}

type APIParameterDoc struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Required    bool `json:"required"`
	Description string `json:"description"`
	Default     *string `json:"default,omitempty"`
}

type APIResponseDoc struct {
	StatusCode  int `json:"status_code"`
	Type        string `json:"type"`
	Description string `json:"description"`
	Example     string `json:"example"`
}

type APIModelDoc struct {
	Name    string `json:"name"`
	Fields  []APIFieldDoc `json:"fields"`
	Example string `json:"example"`
}

type APIFieldDoc struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description"`
	Required    bool `json:"required"`
}

// Repository and service contracts remain transport-agnostic. JSON tags above
// define the public wire contract consumed by the Flutter application.
type DeveloperRepository interface {
	CreateApp(context.Context, *App) error
	GetApp(context.Context, string) (*App, error)
	GetAppByClientID(context.Context, string) (*App, error)
	GetAppsByOwner(context.Context, string, int32, int32) ([]*App, error)
	UpdateApp(context.Context, string, *App) error
	DeleteApp(context.Context, string) error
	VerifyApp(context.Context, string) error
	CreateWebhook(context.Context, *Webhook) error
	GetWebhook(context.Context, string) (*Webhook, error)
	GetWebhooksByAppID(context.Context, string) ([]*Webhook, error)
	UpdateWebhook(context.Context, string, *Webhook) error
	DeleteWebhook(context.Context, string) error
	TriggerWebhook(context.Context, string, map[string]interface{}) error
	GetWebhookStats(context.Context, string) (*WebhookStats, error)
	CreateAPIKey(context.Context, *APIKey) error
	GetAPIKey(context.Context, string) (*APIKey, error)
	GetAPIKeyByHash(context.Context, string) (*APIKey, error)
	GetAPIKeysByAppID(context.Context, string) ([]*APIKey, error)
	UpdateAPIKey(context.Context, string, *APIKey) error
	RevokeAPIKey(context.Context, string) error
	UpdateAPIKeyUsage(context.Context, string) error
	GetAPIKeyStats(context.Context, string) (*APIKeyUsageStats, error)
	CreateBot(context.Context, *Bot) error
	GetBot(context.Context, string) (*Bot, error)
	GetBotsByAppID(context.Context, string) ([]*Bot, error)
	UpdateBot(context.Context, string, *Bot) error
	DeleteBot(context.Context, string) error
	GetPublicBots(context.Context, int32, int32) ([]*Bot, error)
	GetBotStats(context.Context, string) (*BotStats, error)
	CreateOAuthToken(context.Context, *OAuthToken) error
	GetOAuthToken(context.Context, string) (*OAuthToken, error)
	GetValidAccessToken(context.Context, string, string) (*OAuthToken, error)
	RevokeOAuthToken(context.Context, string) error
	RevokeUserTokens(context.Context, string, string) error
	GetUserTokens(context.Context, string) ([]*OAuthToken, error)
	GetMetrics(context.Context, string) (*DeveloperMetrics, error)
	GetMetricsByPeriod(context.Context, string, string) (*DeveloperMetrics, error)
	GetEndpointStats(context.Context, string, string) ([]*EndpointStats, error)
	RecordAPIRequest(context.Context, string, string, int32, bool) error
	GetAPIQuota(context.Context, string) (*APIQuota, error)
	UpdateAPIQuota(context.Context, string) error
	CheckRateLimit(context.Context, string) (bool, error)
	GetAPIDocumentation(context.Context, string) (*APIDocumentation, error)
	UpdateAPIDocumentation(context.Context, string, *APIDocumentation) error
}

type DeveloperService interface {
	RegisterApp(context.Context, string, string, string) (*App, error)
	GetApp(context.Context, string) (*App, error)
	UpdateApp(context.Context, string, *App) error
	DeleteApp(context.Context, string) error
	VerifyApp(context.Context, string) error
	GetOwnerApps(context.Context, string) ([]*App, error)
	SetupWebhook(context.Context, string, string, string, []string) (*Webhook, error)
	GetWebhooks(context.Context, string) ([]*Webhook, error)
	UpdateWebhook(context.Context, string, *Webhook) error
	DeleteWebhook(context.Context, string) error
	TestWebhook(context.Context, string) error
	GetWebhookStats(context.Context, string) (*WebhookStats, error)
	GenerateAPIKey(context.Context, string, string, string, []string, int) (*APIKey, error)
	ValidateAPIKey(context.Context, string) (*APIKey, error)
	ListAPIKeys(context.Context, string) ([]*APIKey, error)
	RevokeAPIKey(context.Context, string) error
	UpdateAPIKey(context.Context, string, *APIKey) error
	GetAPIKeyStats(context.Context, string) (*APIKeyUsageStats, error)
	CreateBot(context.Context, string, string, string) (*Bot, error)
	GetBot(context.Context, string) (*Bot, error)
	GetAppBots(context.Context, string) ([]*Bot, error)
	UpdateBot(context.Context, string, *Bot) error
	DeleteBot(context.Context, string) error
	GetPublicBots(context.Context, int32) ([]*Bot, error)
	GetBotStats(context.Context, string) (*BotStats, error)
	GenerateAccessToken(context.Context, string, string, []string) (*OAuthToken, error)
	RefreshAccessToken(context.Context, string) (*OAuthToken, error)
	RevokeToken(context.Context, string) error
	RevokeUserAccess(context.Context, string, string) error
	ValidateToken(context.Context, string) (*OAuthToken, error)
	GetAppHealth(context.Context, string) (*DeveloperMetrics, error)
	GetAppMetrics(context.Context, string, string) (*DeveloperMetrics, error)
	GetEndpointUsage(context.Context, string, string) ([]*EndpointStats, error)
	GetAPIQuota(context.Context, string) (*APIQuota, error)
	CheckRateLimit(context.Context, string) (bool, error)
	GetAPIDocumentation(context.Context, string) (*APIDocumentation, error)
	UpdateAPIDocumentation(context.Context, string, *APIDocumentation) error
	GenerateAPIDocs(context.Context, string) (*APIDocumentation, error)
	GenerateSDK(context.Context, string, string) ([]byte, error)
	GetAPIExplorer(context.Context, string) (*APIExplorer, error)
	RunTestSuite(context.Context, string) (*TestSuiteResult, error)
}

type APIExplorer struct {
	AppID     string `json:"app_id"`
	Endpoints []APIEndpointDoc `json:"endpoints"`
	BaseURL   string `json:"base_url"`
	TestData  map[string]interface{} `json:"test_data"`
}

type TestSuiteResult struct {
	AppID        string `json:"app_id"`
	TotalTests   int32 `json:"total_tests"`
	PassedTests  int32 `json:"passed_tests"`
	FailedTests  int32 `json:"failed_tests"`
	SkippedTests int32 `json:"skipped_tests"`
	Duration     time.Duration `json:"duration"`
	Results      []TestResult `json:"results"`
	ExecutedAt   time.Time `json:"executed_at"`
}

type TestResult struct {
	TestName string `json:"test_name"`
	Status   string `json:"status"`
	Duration time.Duration `json:"duration"`
	Error    *string `json:"error,omitempty"`
	Response map[string]interface{} `json:"response,omitempty"`
}
