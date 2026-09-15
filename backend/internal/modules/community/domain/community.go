package domain

import (
	"context"
	"time"
)

type Community struct {
	ID          string
	OwnerID     string
	Name        string
	Slug        string
	Description string
	AvatarURL   string
	BannerURL   string
	IsPrivate   bool
	IsVerified  bool
	MemberCount int32
	PostCount   int32
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Category    string
	Tags        []string
	Rules       []string
	Settings    CommunitySettings
	Stats       CommunityStats
}

type CommunitySettings struct {
	AllowGuestPosts      bool
	RequireModeration    bool
	EnableVoiceChat      bool
	EnableVideoChat      bool
	EnableScreenShare    bool
	MaxMembers          int32
	AutoDeleteAfterDays  int32
	ContentFilterLevel  string // none, low, medium, high
	Language             string
	Timezone             string
}

type CommunityStats struct {
	DailyActiveUsers    int32
	WeeklyActiveUsers   int32
	MonthlyActiveUsers  int32
	TotalPosts          int32
	TotalComments       int32
	TotalEvents         int32
	AvgEngagementScore  float64
	ReportCount         int32
	WarningCount        int32
}

type CommunityMember struct {
	ID            string
	CommunityID   string
	UserID        string
	Role          string // owner, admin, moderator, member, guest
	JoinedAt      time.Time
	IsActive      bool
	LastActiveAt  time.Time
	PostCount     int32
	CommentCount  int32
	Reputation    int32
	Badges        []string
	Preferences   MemberPreferences
}

type MemberPreferences struct {
	NotificationsEnabled bool
	EmailDigest          string // none, daily, weekly
	MuteUntil            *time.Time
	HideActivity         bool
}

type Event struct {
	ID           string
	CreatorID    string
	CommunityID  *string
	Title        string
	Description  string
	StartTime    time.Time
	EndTime      time.Time
	LocationName string
	Latitude     *float64
	Longitude    *float64
	LocationURL  string
	MaxAttendees int32
	CurrentAttendees int32
	IsPublic     bool
	IsRecurring bool
	RecurrencePattern string // daily, weekly, monthly
	ImageURL     string
	Status       string // draft, published, cancelled, completed
	CreatedAt    time.Time
	UpdatedAt    time.Time
	TicketInfo   EventTicketInfo
}

type EventTicketInfo struct {
	IsRequired      bool
	Price           float64
	Currency        string
	AvailableTickets int32
	SoldTickets     int32
	EarlyBirdUntil *time.Time
}

type Collective struct {
	ID          string
	Name        string
	Slug        string
	Description string
	Icon        string
	BannerURL   string
	NodeCount   int
	Influence   float64 // Reputation score of the collective
	MemberCount int32
	IsOfficial  bool
	Category    string
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Stats       CollectiveStats
}

type CollectiveStats struct {
	TotalThreads    int32
	TotalReplies   int32
	ActiveMembers  int32
	WeeklyActivity int32
}

type Thread struct {
	ID           string
	CollectiveID string
	AuthorID     string
	Title        string
	Content      string
	Resonance    int // Net upvotes
	ViewCount    int32
	ReplyCount   int32
	IsPinned     bool
	IsLocked     bool
	IsAnnouncement bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Tags         []string
	Category     string
}

type ThreadReply struct {
	ID         string
	ThreadID   string
	AuthorID   string
	Content    string
	Resonance  int
	CreatedAt  time.Time
	UpdatedAt  time.Time
	IsEdited   bool
	ParentID   *string
}

type CommunityRepository interface {
	CreateCommunity(ctx context.Context, comm *Community) error
	GetCommunity(ctx context.Context, commID string) (*Community, error)
	GetCommunityBySlug(ctx context.Context, slug string) (*Community, error)
	UpdateCommunity(ctx context.Context, commID string, updates *Community) error
	DeleteCommunity(ctx context.Context, commID string) error
	ListCommunities(ctx context.Context, userID string, category string, limit, offset int32) ([]*Community, error)
	SearchCommunities(ctx context.Context, query string, limit, offset int32) ([]*Community, error)
	GetTrendingCommunities(ctx context.Context, limit int32) ([]*Community, error)
	
	// Members
	JoinCommunity(ctx context.Context, commID, userID, role string) error
	LeaveCommunity(ctx context.Context, commID, userID string) error
	GetCommunityMembers(ctx context.Context, commID string, role string, limit, offset int32) ([]*CommunityMember, error)
	UpdateMemberRole(ctx context.Context, commID, userID, role string) error
	RemoveMember(ctx context.Context, commID, userID string) error
	GetMemberStats(ctx context.Context, commID, userID string) (*CommunityStats, error)
	BanMember(ctx context.Context, commID, userID string, reason string, duration *time.Time) error
	UnbanMember(ctx context.Context, commID, userID string) error
	
	// Collectives
	CreateCollective(ctx context.Context, coll *Collective) error
	GetCollectives(ctx context.Context, limit, offset int32) ([]*Collective, error)
	GetCollective(ctx context.Context, collID string) (*Collective, error)
	UpdateCollective(ctx context.Context, collID string, updates *Collective) error
	DeleteCollective(ctx context.Context, collID string) error
	JoinCollective(ctx context.Context, collID, userID string) error
	LeaveCollective(ctx context.Context, collID, userID string) error
	CreateThread(ctx context.Context, thread *Thread) error
	GetThreads(ctx context.Context, collectiveID string, limit, offset int32) ([]*Thread, error)
	GetThread(ctx context.Context, threadID string) (*Thread, error)
	UpdateThread(ctx context.Context, threadID string, updates *Thread) error
	DeleteThread(ctx context.Context, threadID string) error
	ResonateThread(ctx context.Context, threadID string, delta int) error
	CreateThreadReply(ctx context.Context, reply *ThreadReply) error
	GetThreadReplies(ctx context.Context, threadID string, limit, offset int32) ([]*ThreadReply, error)
	PinThread(ctx context.Context, threadID string, pinned bool) error
	LockThread(ctx context.Context, threadID string, locked bool) error
	
	// Events
	CreateEvent(ctx context.Context, event *Event) error
	GetEvent(ctx context.Context, eventID string) (*Event, error)
	UpdateEvent(ctx context.Context, eventID string, updates *Event) error
	DeleteEvent(ctx context.Context, eventID string) error
	ListEvents(ctx context.Context, communityID *string, userID string, status string, limit, offset int32) ([]*Event, error)
	GetUpcomingEvents(ctx context.Context, userID string, limit int32) ([]*Event, error)
	RSVP(ctx context.Context, eventID, userID, status string) error
	GetAttendees(ctx context.Context, eventID string, limit, offset int32) ([]string, error)
	
	// Ticketing
	CreateTicket(ctx context.Context, eventID, userID, code string) error
	GetTicket(ctx context.Context, ticketID string) (*Ticket, error)
	GetUserTickets(ctx context.Context, userID string) ([]*Ticket, error)
	ValidateTicket(ctx context.Context, ticketCode string) (*Ticket, error)
	CancelTicket(ctx context.Context, ticketID string) error
	
	// Subscriptions
	CreateSubscription(ctx context.Context, subID, creatorID, tier string, expiresAt time.Time) error
	GetSubscription(ctx context.Context, subID string) (*Subscription, error)
	GetUserSubscriptions(ctx context.Context, userID string) ([]*Subscription, error)
	CancelSubscription(ctx context.Context, subID string) error
	UpdateSubscription(ctx context.Context, subID string, tier string) error
	
	// Moderation
	ReportContent(ctx context.Context, reporterID, contentType, contentID, reason string) error
	GetReports(ctx context.Context, communityID string, status string, limit, offset int32) ([]*ContentReport, error)
	ResolveReport(ctx context.Context, reportID string, resolution string) error
	GetCommunityGuidelines(ctx context.Context, communityID string) ([]*Guideline, error)
	UpdateGuidelines(ctx context.Context, communityID string, guidelines []*Guideline) error
	
	// Analytics
	UpdateCommunityStats(ctx context.Context, communityID string) error
	GetCommunityAnalytics(ctx context.Context, communityID string, period string) (*CommunityAnalytics, error)
	GetMemberActivity(ctx context.Context, communityID string, userID string, period string) (*MemberActivity, error)
}

type Ticket struct {
	ID         string
	EventID    string
	UserID     string
	TicketCode string
	Status     string // active, used, cancelled, expired
	PurchasedAt time.Time
	UsedAt     *time.Time
	ExpiresAt  *time.Time
	Metadata   map[string]interface{}
}

type Subscription struct {
	ID           string
	CreatorID    string
	SubscriberID string
	Tier         string
	Amount       float64
	Currency     string
	Status       string // active, cancelled, expired, past_due
	StartedAt    time.Time
	ExpiresAt    time.Time
	AutoRenew    bool
	Benefits     []string
}

type ContentReport struct {
	ID          string
	ReporterID  string
	ContentType string // post, comment, thread, event
	ContentID   string
	Reason      string
	Description string
	Status      string // pending, resolved, dismissed
	CreatedAt   time.Time
	ResolvedAt  *time.Time
	ResolvedBy  *string
	Resolution  string
}

type Guideline struct {
	ID          string
	CommunityID string
	Title       string
	Description string
	Order       int
	IsActive    bool
	CreatedAt   time.Time
}

type CommunityAnalytics struct {
	CommunityID    string
	Period         string
	MemberCount    int32
	NewMembers     int32
	ActiveMembers  int32
	PostCount      int32
	CommentCount   int32
	EventCount     int32
	EngagementRate float64
	AvgSessionTime float64
	TopContent     []string
}

type MemberActivity struct {
	UserID        string
	CommunityID   string
	Period        string
	PostsCreated  int32
	CommentsMade  int32
	EventsAttended int32
	ReactionsGiven int32
	TimeSpent     int32 // minutes
	LastActiveAt  time.Time
}

type CommunityService interface {
	CreateGroup(ctx context.Context, ownerID, name, desc string, isPrivate bool) (*Community, error)
	Join(ctx context.Context, commID, userID string) error
	Leave(ctx context.Context, commID, userID string) error
	
	// Event Management
	OrganizeEvent(ctx context.Context, event *Event) (*Event, error)
	AttendEvent(ctx context.Context, eventID, userID string) error
	CancelEvent(ctx context.Context, eventID string) error
	UpdateEvent(ctx context.Context, eventID string, updates *Event) error
	
	// Subscription Management
	SubscribeToCreator(ctx context.Context, subID, creatorID, tier string) error
	CancelSubscription(ctx context.Context, subID string) error
	UpdateSubscriptionTier(ctx context.Context, subID, tier string) error
	
	// Synergy Collectives
	FormCollective(ctx context.Context, name, desc, icon string) (*Collective, error)
	StartThread(ctx context.Context, collectiveID, authorID, title, content string) (*Thread, error)
	Resonate(ctx context.Context, threadID string, isPositive bool) error
	ReplyToThread(ctx context.Context, threadID, authorID, content string) (*ThreadReply, error)
	PinThread(ctx context.Context, threadID string, pinned bool) error
	LockThread(ctx context.Context, threadID string, locked bool) error
	
	// Member Management
	PromoteMember(ctx context.Context, commID, userID, role string) error
	DemoteMember(ctx context.Context, commID, userID, role string) error
	BanMember(ctx context.Context, commID, userID, reason string, duration *time.Time) error
	UnbanMember(ctx context.Context, commID, userID string) error
	
	// Moderation
	ReportContent(ctx context.Context, reporterID, contentType, contentID, reason string) error
	ResolveReport(ctx context.Context, reportID, resolution string) error
	SetCommunityGuidelines(ctx context.Context, communityID string, guidelines []*Guideline) error
	
	// Analytics
	GetCommunityAnalytics(ctx context.Context, communityID string, period string) (*CommunityAnalytics, error)
	GetMemberActivity(ctx context.Context, communityID, userID string, period string) (*MemberActivity, error)
	
	// Discovery
	SearchCommunities(ctx context.Context, query string, filters map[string]interface{}) ([]*Community, error)
	GetTrendingCommunities(ctx context.Context, limit int32) ([]*Community, error)
	GetRecommendedCommunities(ctx context.Context, userID string, limit int32) ([]*Community, error)
}
