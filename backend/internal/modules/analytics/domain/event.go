package domain

import (
	"context"
	"time"
)

type UserEvent struct {
	EventID      string                 `json:"event_id"`
	UserID       string                 `json:"user_id"`
	SessionID    string                 `json:"session_id"`
	EventType    string                 `json:"event_type"` // e.g., "page_view", "post_created", "purchase", "login"
	EventCategory string                 `json:"event_category"` // engagement, conversion, retention, error
	Payload      map[string]interface{} `json:"payload"`
	DeviceInfo   DeviceInfo             `json:"device_info"`
	IPAddress    string                 `json:"ip_address"`
	UserAgent    string                 `json:"user_agent"`
	Referrer     string                 `json:"referrer"`
	CreatedAt    time.Time              `json:"created_at"`
	ProcessedAt  *time.Time             `json:"processed_at"`
}

type DeviceInfo struct {
	DeviceType   string // mobile, tablet, desktop, tv
	OS           string
	OSVersion    string
	Browser      string
	BrowserVersion string
	ScreenWidth  int32
	ScreenHeight int32
	DeviceID     string
	AppVersion   string
}

type UserSession struct {
	SessionID      string
	UserID         string
	StartTime      time.Time
	EndTime        *time.Time
	Duration       int32 // seconds
	PageViews      int32
	Events         int32
	DeviceID       string
	IPAddress      string
	Source         string // organic, direct, referral, social, email, paid
	Campaign       *string
	Referrer       string
	ExitPage       *string
	ExitReason     string // timeout, logout, error, navigate
	IsBounce       bool
	ConversionValue float64
	Metadata       map[string]interface{}
}

type UserMetrics struct {
	UserID            string
	Period            string // daily, weekly, monthly
	TotalSessions     int32
	TotalTimeSpent    int32 // seconds
	AvgSessionDuration float32
	PageViews         int32
	UniquePageViews   int32
	ConversionRate    float64
	BounceRate        float64
	EngagementScore   float64
	RetentionRate     float64
	ChurnRisk         float64
	LifetimeValue     float64
	LastActiveAt      time.Time
	FirstSeenAt       time.Time
	CohortGroup       string
	Segments          []string
}

type ContentMetrics struct {
	ContentID        string
	ContentType      string // post, video, audio, image, product
	Period           string
	Views            int64
	UniqueViews      int64
	EngagementRate   float64
	AvgWatchTime     float32 // for video/audio
	CompletionRate   float32
	Shares           int32
	Comments         int32
	Likes            int32
	Dislikes         int32
	Saves            int32
	ClickThroughRate float64
	ConversionRate   float64
	TrendingScore    float64
	ViralCoefficient float64
	TopCountries     []CountryStat
	TopDevices       []DeviceStat
	TopReferrers     []ReferrerStat
	FirstPublishedAt time.Time
	LastEngagedAt    time.Time
}

type CountryStat struct {
	CountryCode string
	Views       int64
	Percentage  float64
}

type DeviceStat struct {
	DeviceType string
	Views      int64
	Percentage float64
}

type ReferrerStat struct {
	Referrer   string
	Views      int64
	Percentage float64
}

type FunnelMetrics struct {
	FunnelID      string
	Name          string
	Period        string
	Steps         []FunnelStep
	TotalUsers    int64
	ConversionRate float64
	DropOffRate   float64
	AvgTimeInFunnel float32
	CreatedAt     time.Time
}

type FunnelStep struct {
	StepName       string
	StepOrder      int32
	Users          int64
	ConversionRate float64
	DropOffUsers   int64
	DropOffRate    float64
	AvgTimeToStep float32
}

type CohortAnalysis struct {
	CohortID    string
	Name        string
	Period      string
	CohortDate  time.Time
	Periods     []CohortPeriod
	TotalUsers  int64
	CreatedAt   time.Time
}

type CohortPeriod struct {
	PeriodNumber int32
	Users       int64
	RetentionRate float64
	Percentage  float64
}

type ABTest struct {
	TestID         string
	Name           string
	Description    string
	Status         string // draft, running, paused, completed
	VariantA       TestVariant
	VariantB       TestVariant
	StartDate      time.Time
	EndDate        *time.Time
	TotalUsers     int64
	Winner         *string
	Confidence     float64
	Significance   float64
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type TestVariant struct {
	Name        string
	Description string
	Allocation  float64 // percentage
	Users       int64
	ConversionRate float64
	Metrics     map[string]float64
	ExposureURL string
}

type GrowthMetric struct {
	MetricID     string
	MetricName   string
	MetricType   string // user_growth, revenue, engagement, retention
	Period       string
	Value        float64
	Change       float64
	ChangePercent float64
	Target       float64
	GoalAchieved bool
	Trend        string // up, down, stable
	RecordedAt   time.Time
}

type RecommendationEngine struct {
	EngineID    string
	Name        string
	Type        string // collaborative, content_based, hybrid
	IsActive    bool
	ModelVersion string
	Accuracy    float64
	UpdatedAt   time.Time
}

type Recommendation struct {
	UserID        string
	ItemID        string
	ItemType      string
	Score         float64
	Reason        string
	Algorithm     string
	GeneratedAt   time.Time
	ExpiresAt     *time.Time
	IsAccepted   bool
	Feedback      *string
}

type UserSegment struct {
	SegmentID    string
	Name         string
	Description  string
	Rules        []SegmentRule
	UserCount    int32
	IsActive     bool
	AutoUpdate   bool
	LastUpdated  time.Time
	CreatedAt    time.Time
}

type SegmentRule struct {
	Field       string
	Operator    string // equals, contains, greater_than, less_than, in_range
	Value       interface{}
	Condition   string // and, or
}

type EventRepository interface {
	// Event Tracking
	TrackEvent(ctx context.Context, event *UserEvent) error
	BulkTrackEvents(ctx context.Context, events []*UserEvent) error
	GetEvent(ctx context.Context, eventID string) (*UserEvent, error)
	GetUserEvents(ctx context.Context, userID string, filters map[string]interface{}, limit, offset int32) ([]*UserEvent, error)
	GetSessionEvents(ctx context.Context, sessionID string) ([]*UserEvent, error)
	
	// Session Management
	CreateSession(ctx context.Context, session *UserSession) error
	UpdateSession(ctx context.Context, sessionID string, updates *UserSession) error
	GetSession(ctx context.Context, sessionID string) (*UserSession, error)
	GetUserSessions(ctx context.Context, userID string, limit, offset int32) ([]*UserSession, error)
	GetActiveSessions(ctx context.Context, limit int32) ([]*UserSession, error)
	EndSession(ctx context.Context, sessionID string, reason string) error
	
	// User Metrics
	GetUserMetrics(ctx context.Context, userID string, period string) (*UserMetrics, error)
	AggregateUserMetrics(ctx context.Context, userID string, period string) (*UserMetrics, error)
	GetTopUsersByMetric(ctx context.Context, metric string, limit int32) ([]*UserMetrics, error)
	
	// Content Metrics
	GetContentMetrics(ctx context.Context, contentID string, period string) (*ContentMetrics, error)
	AggregateContentMetrics(ctx context.Context, contentID string, period string) (*ContentMetrics, error)
	GetTrendingContent(ctx context.Context, contentType string, limit int32) ([]*ContentMetrics, error)
	GetViralContent(ctx context.Context, limit int32) ([]*ContentMetrics, error)
	
	// Funnel Analysis
	CreateFunnel(ctx context.Context, funnel *FunnelMetrics) error
	GetFunnel(ctx context.Context, funnelID string) (*FunnelMetrics, error)
	GetActiveFunnels(ctx context.Context) ([]*FunnelMetrics, error)
	UpdateFunnelMetrics(ctx context.Context, funnelID string) error
	
	// Cohort Analysis
	CreateCohort(ctx context.Context, cohort *CohortAnalysis) error
	GetCohort(ctx context.Context, cohortID string) (*CohortAnalysis, error)
	GetCohorts(ctx context.Context, limit, offset int32) ([]*CohortAnalysis, error)
	GenerateCohortReport(ctx context.Context, cohortID string) (*CohortAnalysis, error)
	
	// A/B Testing
	CreateABTest(ctx context.Context, test *ABTest) error
	GetABTest(ctx context.Context, testID string) (*ABTest, error)
	GetActiveABTests(ctx context.Context) ([]*ABTest, error)
	UpdateABTest(ctx context.Context, testID string, updates *ABTest) error
	GetUserVariant(ctx context.Context, testID, userID string) (string, error)
	RecordConversion(ctx context.Context, testID, userID, variant string) error
	
	// Growth Metrics
	RecordGrowthMetric(ctx context.Context, metric *GrowthMetric) error
	GetGrowthMetrics(ctx context.Context, metricType string, period string) ([]*GrowthMetric, error)
	GetGrowthOverview(ctx context.Context, period string) (map[string][]*GrowthMetric, error)
	
	// Recommendations
	GenerateRecommendations(ctx context.Context, userID string, count int32) ([]*Recommendation, error)
	GetRecommendations(ctx context.Context, userID string) ([]*Recommendation, error)
	RecordRecommendationFeedback(ctx context.Context, recommendationID string, feedback string) error
	
	// User Segmentation
	CreateSegment(ctx context.Context, segment *UserSegment) error
	GetSegment(ctx context.Context, segmentID string) (*UserSegment, error)
	GetSegments(ctx context.Context, isActive bool) ([]*UserSegment, error)
	UpdateSegment(ctx context.Context, segmentID string) error
	GetSegmentUsers(ctx context.Context, segmentID string, limit, offset int32) ([]string, error)
	AddUserToSegment(ctx context.Context, segmentID, userID string) error
	RemoveUserFromSegment(ctx context.Context, segmentID, userID string) error
	
	// Analytics & Reporting
	GetRealtimeStats(ctx context.Context) (*RealtimeStats, error)
	GetDailyStats(ctx context.Context, date time.Time) (*DailyStats, error)
	GetWeeklyStats(ctx context.Context, startDate, endDate time.Time) (*WeeklyStats, error)
	GetCustomReport(ctx context.Context, reportConfig *ReportConfig) (*ReportResult, error)
	
	// Data Export
	ExportEvents(ctx context.Context, filters map[string]interface{}, format string) ([]byte, error)
	ExportMetrics(ctx context.Context, metricType string, period string, format string) ([]byte, error)
}

type RealtimeStats struct {
	ActiveUsers      int32
	OnlineUsers      int32
	EventsPerSecond  float64
	PageViewsPerHour int32
	TopContent      []string
	TopCountries    []string
	Timestamp       time.Time
}

type DailyStats struct {
	Date               time.Time
	NewUsers          int32
	ActiveUsers       int32
	TotalEvents       int64
	PageViews         int64
	SessionDuration   float32
	BounceRate        float64
	ConversionRate    float64
	Revenue           float64
}

type WeeklyStats struct {
	StartDate         time.Time
	EndDate           time.Time
	NewUsers          int32
	ActiveUsers       int32
	GrowthRate        float64
	RetentionRate     float64
	TotalEvents       int64
	PageViews         int64
	AvgSessionDuration float32
	Revenue           float64
	DayBreakdown      []DailyStats
}

type ReportConfig struct {
	Name        string
	Type        string // funnel, cohort, retention, growth
	Filters     map[string]interface{}
	GroupBy     []string
	Aggregations []string
	Period      string
}

type ReportResult struct {
	Config      *ReportConfig
	Data        map[string]interface{}
	GeneratedAt time.Time
	Metadata    map[string]interface{}
}

type EventService interface {
	// Event Tracking
	Track(ctx context.Context, event *UserEvent) error
	TrackBatch(ctx context.Context, events []*UserEvent) error
	
	// Session Management
	StartSession(ctx context.Context, userID string) (*UserSession, error)
	EndSession(ctx context.Context, sessionID string, reason string) error
	UpdateSession(ctx context.Context, sessionID string, updates *UserSession) error
	
	// Metrics & Analytics
	GetUserMetrics(ctx context.Context, userID string, period string) (*UserMetrics, error)
	GetContentMetrics(ctx context.Context, contentID string, period string) (*ContentMetrics, error)
	GetRealtimeStats(ctx context.Context) (*RealtimeStats, error)
	GetDailyStats(ctx context.Context, date time.Time) (*DailyStats, error)
	GetWeeklyStats(ctx context.Context, startDate, endDate time.Time) (*WeeklyStats, error)
	
	// Funnel Analysis
	CreateFunnel(ctx context.Context, name string, steps []string) (*FunnelMetrics, error)
	GetFunnel(ctx context.Context, funnelID string) (*FunnelMetrics, error)
	TrackFunnelEvent(ctx context.Context, funnelID, stepName, userID string) error
	
	// Cohort Analysis
	CreateCohort(ctx context.Context, name string, cohortDate time.Time) (*CohortAnalysis, error)
	GetCohort(ctx context.Context, cohortID string) (*CohortAnalysis, error)
	GenerateCohortReport(ctx context.Context, cohortID string) (*CohortAnalysis, error)
	
	// A/B Testing
	CreateABTest(ctx context.Context, name, description string, variantA, variantB TestVariant) (*ABTest, error)
	GetABTest(ctx context.Context, testID string) (*ABTest, error)
	GetUserVariant(ctx context.Context, testID, userID string) (string, error)
	RecordConversion(ctx context.Context, testID, userID string) error
	CompleteABTest(ctx context.Context, testID string) error
	
	// Growth Tracking
	RecordGrowthMetric(ctx context.Context, metricName, metricType string, value float64) error
	GetGrowthMetrics(ctx context.Context, metricType string, period string) ([]*GrowthMetric, error)
	GetGrowthOverview(ctx context.Context, period string) (map[string][]*GrowthMetric, error)
	
	// Recommendations
	GetRecommendations(ctx context.Context, userID string, count int32) ([]*Recommendation, error)
	RecordRecommendationFeedback(ctx context.Context, recommendationID string, feedback string) error
	
	// User Segmentation
	CreateSegment(ctx context.Context, name, description string, rules []SegmentRule) (*UserSegment, error)
	GetSegment(ctx context.Context, segmentID string) (*UserSegment, error)
	GetSegmentUsers(ctx context.Context, segmentID string, limit, offset int32) ([]string, error)
	UpdateSegmentUsers(ctx context.Context, segmentID string) error
	
	// Reporting
	GenerateCustomReport(ctx context.Context, config *ReportConfig) (*ReportResult, error)
	ExportData(ctx context.Context, exportType string, filters map[string]interface{}, format string) ([]byte, error)
	
	// Real-time
	SubscribeToRealtimeStats(ctx context.Context) (<-chan *RealtimeStats, error)
	UnsubscribeFromRealtimeStats(ctx context.Context) error
}
