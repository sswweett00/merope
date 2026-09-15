package domain

import (
	"context"
	"time"
)

type App struct {
	ID           string
	OwnerID      string
	Name         string
	Description  string
	ClientID     string
	ClientSecret string
	RedirectURI  string
	Scopes       []string
	GrantTypes   []string // authorization_code, client_credentials, refresh_token
	IsPublic     bool
	IsActive     bool
	IsVerified   bool
	IconURL      string
	HomepageURL  string
	TermsURL     string
	PrivacyURL   string
	CallbackURLs []string
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Stats        AppStats
	Settings     AppSettings
}

type AppStats struct {
	TotalUsers        int32
	ActiveUsers       int32
	TotalAPIRequests  int64
	WebhookDeliveries int64
	Failures          int32
	AvgLatency        float32
	LastUsedAt        time.Time
}

type AppSettings struct {
	EnableWebhooks       bool
	EnableRealtime       bool
	EnableBatchAPI       bool
	RateLimitPerMinute   int32
	RateLimitPerHour     int32
	MaxConcurrentCalls   int32
	RequireUserApproval  bool
	AutoApproveTokens    bool
	TokenExpiry          int32 // seconds
	RefreshTokenExpiry    int32 // seconds
}

type Webhook struct {
	ID          string
	AppID       string
	Name        string
	TargetURL   string
	Secret      string
	Events      []string
	IsActive    bool
	RetryPolicy WebhookRetryPolicy
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Stats       WebhookStats
}

type WebhookRetryPolicy struct {
	MaxRetries      int32
	RetryInterval   int32 // seconds
	BackoffStrategy string // linear, exponential
	Timeout         int32 // seconds
}

type WebhookStats struct {
	TotalDeliveries int64
	SuccessCount    int64
	FailureCount    int64
	AvgResponseTime float32
	LastDeliveredAt *time.Time
	LastFailedAt    *time.Time
}

type APIKey struct {
	ID           string
	AppID        string
	KeyHash      string
	KeyPrefix    string
	Name         string
	Description  string
	Scopes       []string
	RateLimitRPM int
	RateLimitRPH int
	IsActive     bool
	LastUsedAt   *time.Time
	ExpiresAt    *time.Time
	CreatedAt    time.Time
	RawKey       string
	IPWhitelist  []string
	UsageStats   APIKeyUsageStats
}

type APIKeyUsageStats struct {
	TotalRequests int64
	FailedRequests int64
	LastUsedIP   string
	UsageByDay   map[string]int64
}

type Bot struct {
	ID          string
	AppID       string
	Name        string
	Description string
	AvatarURL   string
	IsPublic    bool
	IsActive    bool
	IsOfficial  bool
	Permissions []string
	Capabilities []BotCapability
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Stats       BotStats
	Settings    BotSettings
}

type BotCapability struct {
	Type        string // messaging, commands, events, webhooks
	Permission  string
	Description string
	IsEnabled  bool
}

type BotStats struct {
	TotalUsers      int32
	ActiveUsers     int32
	MessagesSent    int64
	CommandsExecuted int64
	ErrorsOccurred  int32
	AvgResponseTime float32
	Uptime          float64
	LastActiveAt    time.Time
}

type BotSettings struct {
	AllowDirectMessages bool
	AllowGroupMessages  bool
	EnableCommands      bool
	EnableWebhooks      bool
	PrivacyMode         string // public, private, protected
	RateLimitPerUser    int32
	MaxCommandQueue     int32
}

type OAuthToken struct {
	ID           string
	AppID        string
	UserID       string
	TokenType    string // access_token, refresh_token
	TokenHash    string
	ExpiresAt    time.Time
	Scopes       []string
	CreatedAt    time.Time
	RevokedAt    *time.Time
	DeviceID     string
	IPAddress    string
	UserAgent    string
}

type DeveloperMetrics struct {
	AppID         string
	Period        string
	APIRequests   int64
	Errors        int32
	AvgLatency    float32
	P95Latency    float32
	P99Latency    float32
	SuccessRate   float64
	UniqueUsers   int32
	BandwidthUsed int64
	TopEndpoints  []EndpointStats
}

type EndpointStats struct {
	Path         string
	Method       string
	RequestCount int64
	AvgLatency   float32
	ErrorRate    float64
}

type APIQuota struct {
	AppID            string
	Period           string // daily, monthly
	RequestsMade     int64
	RequestsLimit    int64
	ResetAt          time.Time
	UsagePercentage  float64
}

type DeveloperRepository interface {
	// Apps
	CreateApp(ctx context.Context, app *App) error
	GetApp(ctx context.Context, appID string) (*App, error)
	GetAppByClientID(ctx context.Context, clientID string) (*App, error)
	GetAppsByOwner(ctx context.Context, ownerID string, limit, offset int32) ([]*App, error)
	UpdateApp(ctx context.Context, appID string, updates *App) error
	DeleteApp(ctx context.Context, appID string) error
	VerifyApp(ctx context.Context, appID string) error
	
	// Webhooks
	CreateWebhook(ctx context.Context, webhook *Webhook) error
	GetWebhook(ctx context.Context, webhookID string) (*Webhook, error)
	GetWebhooksByAppID(ctx context.Context, appID string) ([]*Webhook, error)
	UpdateWebhook(ctx context.Context, webhookID string, updates *Webhook) error
	DeleteWebhook(ctx context.Context, webhookID string) error
	TriggerWebhook(ctx context.Context, webhookID string, payload map[string]interface{}) error
	GetWebhookStats(ctx context.Context, webhookID string) (*WebhookStats, error)
	
	// API Keys
	CreateAPIKey(ctx context.Context, key *APIKey) error
	GetAPIKey(ctx context.Context, keyID string) (*APIKey, error)
	GetAPIKeyByHash(ctx context.Context, keyHash string) (*APIKey, error)
	GetAPIKeysByAppID(ctx context.Context, appID string) ([]*APIKey, error)
	UpdateAPIKey(ctx context.Context, keyID string, updates *APIKey) error
	RevokeAPIKey(ctx context.Context, keyID string) error
	UpdateAPIKeyUsage(ctx context.Context, keyID string) error
	GetAPIKeyStats(ctx context.Context, keyID string) (*APIKeyUsageStats, error)
	
	// Bots
	CreateBot(ctx context.Context, bot *Bot) error
	GetBot(ctx context.Context, botID string) (*Bot, error)
	GetBotsByAppID(ctx context.Context, appID string) ([]*Bot, error)
	UpdateBot(ctx context.Context, botID string, updates *Bot) error
	DeleteBot(ctx context.Context, botID string) error
	GetPublicBots(ctx context.Context, limit, offset int32) ([]*Bot, error)
	GetBotStats(ctx context.Context, botID string) (*BotStats, error)
	
	// OAuth
	CreateOAuthToken(ctx context.Context, token *OAuthToken) error
	GetOAuthToken(ctx context.Context, tokenID string) (*OAuthToken, error)
	GetValidAccessToken(ctx context.Context, appID, userID string) (*OAuthToken, error)
	RevokeOAuthToken(ctx context.Context, tokenID string) error
	RevokeUserTokens(ctx context.Context, appID, userID string) error
	GetUserTokens(ctx context.Context, userID string) ([]*OAuthToken, error)
	
	// Metrics
	GetMetrics(ctx context.Context, appID string) (*DeveloperMetrics, error)
	GetMetricsByPeriod(ctx context.Context, appID string, period string) (*DeveloperMetrics, error)
	GetEndpointStats(ctx context.Context, appID string, period string) ([]*EndpointStats, error)
	RecordAPIRequest(ctx context.Context, appID, endpoint string, duration int32, success bool) error
	
	// Quotas
	GetAPIQuota(ctx context.Context, appID string) (*APIQuota, error)
	UpdateAPIQuota(ctx context.Context, appID string) error
	CheckRateLimit(ctx context.Context, appID string) (bool, error)
	
	// Documentation
	GetAPIDocumentation(ctx context.Context, appID string) (*APIDocumentation, error)
	UpdateAPIDocumentation(ctx context.Context, appID string, docs *APIDocumentation) error
}

type APIDocumentation struct {
	AppID       string
	Version     string
	Title       string
	Description string
	Endpoints   []APIEndpointDoc
	Models      []APIModelDoc
	UpdatedAt   time.Time
}

type APIEndpointDoc struct {
	Path        string
	Method      string
	Description string
	Parameters  []APIParameterDoc
	Responses   []APIResponseDoc
	RequiresAuth bool
}

type APIParameterDoc struct {
	Name        string
	Type        string
	Required    bool
	Description string
	Default     *string
}

type APIResponseDoc struct {
	StatusCode int
	Type       string
	Description string
	Example    string
}

type APIModelDoc struct {
	Name       string
	Fields     []APIFieldDoc
	Example    string
}

type APIFieldDoc struct {
	Name        string
	Type        string
	Description string
	Required    bool
}

type DeveloperService interface {
	// App Management
	RegisterApp(ctx context.Context, ownerID, name, description string) (*App, error)
	GetApp(ctx context.Context, appID string) (*App, error)
	UpdateApp(ctx context.Context, appID string, updates *App) error
	DeleteApp(ctx context.Context, appID string) error
	VerifyApp(ctx context.Context, appID string) error
	GetOwnerApps(ctx context.Context, ownerID string) ([]*App, error)
	
	// Webhook Management
	SetupWebhook(ctx context.Context, appID, name, url string, events []string) (*Webhook, error)
	GetWebhooks(ctx context.Context, appID string) ([]*Webhook, error)
	UpdateWebhook(ctx context.Context, webhookID string, updates *Webhook) error
	DeleteWebhook(ctx context.Context, webhookID string) error
	TestWebhook(ctx context.Context, webhookID string) error
	GetWebhookStats(ctx context.Context, webhookID string) (*WebhookStats, error)
	
	// API Key Management
	GenerateAPIKey(ctx context.Context, appID, name, description string, scopes []string, ttlDays int) (*APIKey, error)
	ValidateAPIKey(ctx context.Context, keyHash string) (*APIKey, error)
	ListAPIKeys(ctx context.Context, appID string) ([]*APIKey, error)
	RevokeAPIKey(ctx context.Context, keyID string) error
	UpdateAPIKey(ctx context.Context, keyID string, updates *APIKey) error
	GetAPIKeyStats(ctx context.Context, keyID string) (*APIKeyUsageStats, error)
	
	// Bot Management
	CreateBot(ctx context.Context, appID, name, description string) (*Bot, error)
	GetBot(ctx context.Context, botID string) (*Bot, error)
	GetAppBots(ctx context.Context, appID string) ([]*Bot, error)
	UpdateBot(ctx context.Context, botID string, updates *Bot) error
	DeleteBot(ctx context.Context, botID string) error
	GetPublicBots(ctx context.Context, limit int32) ([]*Bot, error)
	GetBotStats(ctx context.Context, botID string) (*BotStats, error)
	
	// OAuth Management
	GenerateAccessToken(ctx context.Context, appID, userID string, scopes []string) (*OAuthToken, error)
	RefreshAccessToken(ctx context.Context, refreshToken string) (*OAuthToken, error)
	RevokeToken(ctx context.Context, tokenID string) error
	RevokeUserAccess(ctx context.Context, appID, userID string) error
	ValidateToken(ctx context.Context, token string) (*OAuthToken, error)
	
	// Metrics & Analytics
	GetAppHealth(ctx context.Context, appID string) (*DeveloperMetrics, error)
	GetAppMetrics(ctx context.Context, appID string, period string) (*DeveloperMetrics, error)
	GetEndpointUsage(ctx context.Context, appID string, period string) ([]*EndpointStats, error)
	GetAPIQuota(ctx context.Context, appID string) (*APIQuota, error)
	CheckRateLimit(ctx context.Context, appID string) (bool, error)
	
	// Documentation
	GetAPIDocumentation(ctx context.Context, appID string) (*APIDocumentation, error)
	UpdateAPIDocumentation(ctx context.Context, appID string, docs *APIDocumentation) error
	GenerateAPIDocs(ctx context.Context, appID string) (*APIDocumentation, error)
	
	// Developer Tools
	GenerateSDK(ctx context.Context, appID string, language string) ([]byte, error)
	GetAPIExplorer(ctx context.Context, appID string) (*APIExplorer, error)
	RunTestSuite(ctx context.Context, appID string) (*TestSuiteResult, error)
}

type APIExplorer struct {
	AppID     string
	Endpoints []APIEndpointDoc
	BaseURL   string
	TestData  map[string]interface{}
}

type TestSuiteResult struct {
	AppID        string
	TotalTests   int32
	PassedTests  int32
	FailedTests  int32
	SkippedTests int32
	Duration     time.Duration
	Results      []TestResult
	ExecutedAt   time.Time
}

type TestResult struct {
	TestName   string
	Status     string // passed, failed, skipped
	Duration   time.Duration
	Error      *string
	Response   map[string]interface{}
}
