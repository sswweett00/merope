package domain

import (
	"context"
	"time"
)

type Notification struct {
	ID             string                 `json:"id"`
	ReceiverID     string                 `json:"receiverId"`
	SenderID       *string                `json:"senderId"`
	SenderUsername string                 `json:"senderUsername"`
	SenderAvatar   string                 `json:"senderAvatar"`
	Type           string                 `json:"type"`
	EntityType     string                 `json:"entityType"`
	EntityID       string                 `json:"entityId"`
	Title          string                 `json:"title"`
	Body           string                 `json:"body"`
	Data           map[string]interface{} `json:"data"`
	IsRead         bool                   `json:"isRead"`
	IsSeen         bool                   `json:"isSeen"`
	Priority       string                 `json:"priority"`
	CreatedAt      time.Time              `json:"createdAt"`
	ExpiresAt      *time.Time             `json:"expiresAt"`
	ActionURL      *string                `json:"actionUrl"`
	ActionText     *string                `json:"actionText"`
	Category       string                 `json:"category"`
	Tags           []string               `json:"tags"`
	Source         string                 `json:"source"`
	Metadata       NotificationMetadata   `json:"metadata"`
}

type NotificationMetadata struct {
	Icon           string
	ImageURL       string
	GroupID        *string
	IsGrouped      bool
	ParentID       *string
	Dismissable    bool
	SnoozeUntil    *time.Time
	RequiresAction bool
	ActionRequiredBy *time.Time
}

type NotificationPreference struct {
	UserID                string
	EmailEnabled          bool
	PushEnabled           bool
	SMSEnabled            bool
	InAppEnabled          bool
	DesktopEnabled        bool
	Frequency             string // instant, hourly, daily, weekly
	QuietHours           []QuietHour
	CategoryPreferences   map[string]bool
	EntityTypePreferences map[string]bool
	Keywords              []string
	DoNotDisturbUntil     *time.Time
}

type QuietHour struct {
	DayOfWeek int // 0-6 (Sunday-Saturday)
	StartTime string // "22:00"
	EndTime   string // "08:00"
}

type NotificationTemplate struct {
	ID          string
	Name        string
	Type        string
	EntityType  string
	Title       string
	Body        string
	IsEnabled    bool
	Language    string
	Variables   []string
	Platform    string // web, mobile, email, sms
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type NotificationRule struct {
	ID              string
	Name            string
	TriggerType      string // webhook, schedule, condition
	Conditions       map[string]interface{}
	Actions          []NotificationAction
	IsActive         bool
	Priority         int
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

type NotificationAction struct {
	Type            string // send, delay, transform, route
	Target          string // user, group, channel
	Parameters      map[string]interface{}
	Condition       string
	ExecuteAfter    *time.Duration
}

type NotificationStats struct {
	UserID         string
	TotalSent      int64
	TotalRead      int64
	TotalClicked   int64
	TotalDismissed int64
	CategoryBreakdown map[string]int64
	TypeBreakdown     map[string]int64
	ResponseRate    float64
	AverageResponseTime time.Duration
	LastActivityAt  time.Time
}

type NotificationRepository interface {
	// Basic Operations
	Create(ctx context.Context, n *Notification) error
	GetNotification(ctx context.Context, id string) (*Notification, error)
	GetForUser(ctx context.Context, userID string, filters map[string]interface{}, limit, offset int32) ([]*Notification, error)
	MarkAsRead(ctx context.Context, id, userID string) error
	MarkAsSeen(ctx context.Context, userID string) error
	MarkAllAsRead(ctx context.Context, userID string) error
	DeleteNotification(ctx context.Context, id string) error
	BulkDelete(ctx context.Context, ids []string) error
	
	// Preferences
	GetUserPreferences(ctx context.Context, userID string) (*NotificationPreference, error)
	UpdateUserPreferences(ctx context.Context, userID string, prefs *NotificationPreference) error
	GetDefaultPreferences() (*NotificationPreference, error)
	
	// Templates
	CreateTemplate(ctx context.Context, template *NotificationTemplate) error
	GetTemplate(ctx context.Context, id string) (*NotificationTemplate, error)
	GetTemplatesByType(ctx context.Context, nType, entityType string) ([]*NotificationTemplate, error)
	UpdateTemplate(ctx context.Context, id string, updates *NotificationTemplate) error
	DeleteTemplate(ctx context.Context, id string) error
	GetActiveTemplates(ctx context.Context) ([]*NotificationTemplate, error)
	
	// Rules
	CreateRule(ctx context.Context, rule *NotificationRule) error
	GetRule(ctx context.Context, id string) (*NotificationRule, error)
	GetActiveRules(ctx context.Context) ([]*NotificationRule, error)
	UpdateRule(ctx context.Context, id string, updates *NotificationRule) error
	DeleteRule(ctx context.Context, id string) error
	
	// Analytics
	GetNotificationStats(ctx context.Context, userID string, period string) (*NotificationStats, error)
	GetGlobalStats(ctx context.Context, period string) (*NotificationStats, error)
	GetDeliveryStats(ctx context.Context, notificationID string) (*DeliveryStats, error)
	
	// Batch Operations
	BulkCreate(ctx context.Context, notifications []*Notification) error
	BulkMarkAsRead(ctx context.Context, ids []string, userID string) error
	
	// Cleanup
	CleanupOldNotifications(ctx context.Context, olderThan time.Time) error
	CleanupExpiredNotifications(ctx context.Context) error
}

type DeliveryStats struct {
	NotificationID string
	TotalSent      int32
	Delivered      int32
	Opened        int32
	Clicked        int32
	Failed         int32
	ChannelBreakdown map[string]int32
	TimestampStats  []TimestampStat
}

type TimestampStat struct {
	Timestamp time.Time
	Count     int32
	Channel   string
}

type NotificationsService interface {
	// Core Notification Functions
	Notify(ctx context.Context, receiverID, senderID, nType, entityType, entityID string) error
	NotifyWithData(ctx context.Context, notification *Notification) error
	BulkNotify(ctx context.Context, receiverIDs []string, notification *Notification) error
	
	// Activity Feed
	GetActivity(ctx context.Context, userID string, page int32) ([]*Notification, error)
	GetUnreadCount(ctx context.Context, userID string) (int32, error)
	GetUnseenCount(ctx context.Context, userID string) (int32, error)
	
	// Preference Management
	UpdatePreferences(ctx context.Context, userID string, prefs *NotificationPreference) error
	GetPreferences(ctx context.Context, userID string) (*NotificationPreference, error)
	ResetPreferences(ctx context.Context, userID string) error
	SetDoNotDisturb(ctx context.Context, userID string, until time.Time) error
	
	// Template Management
	CreateTemplate(ctx context.Context, template *NotificationTemplate) error
	UpdateTemplate(ctx context.Context, templateID string, updates *NotificationTemplate) error
	DeleteTemplate(ctx context.Context, templateID string) error
	GetTemplates(ctx context.Context, filters map[string]interface{}) ([]*NotificationTemplate, error)
	
	// Rule Management
	CreateRule(ctx context.Context, rule *NotificationRule) error
	UpdateRule(ctx context.Context, ruleID string, updates *NotificationRule) error
	DeleteRule(ctx context.Context, ruleID string) error
	GetRules(ctx context.Context, filters map[string]interface{}) ([]*NotificationRule, error)
	
	// Advanced Features
	ScheduleNotification(ctx context.Context, notification *Notification, scheduledAt time.Time) error
	CancelScheduledNotification(ctx context.Context, scheduledID string) error
	ResendNotification(ctx context.Context, notificationID string) error
	GroupNotifications(ctx context.Context, userID, groupID string, name string) error
	
	// Notification Actions
	HandleNotificationAction(ctx context.Context, notificationID, action string, params map[string]interface{}) error
	DismissNotification(ctx context.Context, notificationID, userID string) error
	SnoozeNotification(ctx context.Context, notificationID, userID string, until time.Time) error
	
	// Analytics
	GetNotificationStats(ctx context.Context, userID string, period string) (*NotificationStats, error)
	GetDeliveryAnalytics(ctx context.Context, notificationID string) (*DeliveryStats, error)
	GetEngagementMetrics(ctx context.Context, userID string, period string) (*EngagementMetrics, error)
	
	// System Notifications
	SendSystemNotification(ctx context.Context, title, body string, priority string, targetUsers []string) error
	SendSecurityAlert(ctx context.Context, level string, details map[string]interface{}, affectedUsers []string) error
	SendFinancialAlert(ctx context.Context, userID string, alertType string, details map[string]interface{}) error
	
	// Real-time
	SubscribeToNotifications(ctx context.Context, userID string) (<-chan *Notification, error)
	UnsubscribeFromNotifications(ctx context.Context, userID string) error
	BroadcastToChannel(ctx context.Context, channel string, notification *Notification) error
	
	// Cleanup
	CleanupOldNotifications(ctx context.Context, olderThan time.Time) error
	CleanupExpiredNotifications(ctx context.Context) error
}

type EngagementMetrics struct {
	UserID            string
	Period            string
	OpenRate          float64
	ClickRate         float64
	ResponseRate      float64
	AverageResponseTime time.Duration
	BestTimeToSend     time.Time
	PreferredChannels  []string
	CategoryEngagement map[string]float64
	TypeEngagement      map[string]float64
}
