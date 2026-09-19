package domain

import (
	"context"
	"time"
)

type Community struct {
	ID          string            `json:"id"`
	OwnerID     string            `json:"ownerId"`
	Name        string            `json:"name"`
	Slug        string            `json:"slug"`
	Description string            `json:"description"`
	AvatarURL   string            `json:"avatarUrl"`
	BannerURL   string            `json:"bannerUrl"`
	IsPrivate   bool              `json:"isPrivate"`
	IsVerified  bool              `json:"isVerified"`
	IsJoined    bool              `json:"isJoined"`
	UserRole    string            `json:"userRole"`
	MemberCount int32             `json:"memberCount"`
	PostCount   int32             `json:"postCount"`
	CreatedAt   time.Time         `json:"createdAt"`
	UpdatedAt   time.Time         `json:"updatedAt"`
	Category    string            `json:"category"`
	Tags        []string          `json:"tags"`
	Rules       []string          `json:"rules"`
	Settings    CommunitySettings `json:"settings"`
	Stats       CommunityStats    `json:"stats"`
}

type CommunitySettings struct {
	AllowGuestPosts     bool   `json:"allowGuestPosts"`
	RequireModeration   bool   `json:"requireModeration"`
	EnableVoiceChat     bool   `json:"enableVoiceChat"`
	EnableVideoChat     bool   `json:"enableVideoChat"`
	EnableScreenShare   bool   `json:"enableScreenShare"`
	MaxMembers          int32  `json:"maxMembers"`
	AutoDeleteAfterDays int32  `json:"autoDeleteAfterDays"`
	ContentFilterLevel  string `json:"contentFilterLevel"`
	Language            string `json:"language"`
	Timezone            string `json:"timezone"`
}

type CommunityStats struct {
	DailyActiveUsers   int32   `json:"dailyActiveUsers"`
	WeeklyActiveUsers  int32   `json:"weeklyActiveUsers"`
	MonthlyActiveUsers int32   `json:"monthlyActiveUsers"`
	TotalPosts         int32   `json:"totalPosts"`
	TotalComments      int32   `json:"totalComments"`
	TotalEvents        int32   `json:"totalEvents"`
	AvgEngagementScore float64 `json:"avgEngagementScore"`
	ReportCount        int32   `json:"reportCount"`
	WarningCount       int32   `json:"warningCount"`
}

type CommunityMember struct {
	ID            string            `json:"id"`
	CommunityID   string            `json:"communityId"`
	UserID        string            `json:"userId"`
	Username      string            `json:"username"`
	AvatarURL     *string           `json:"avatarUrl,omitempty"`
	Role          string            `json:"role"`
	JoinedAt      time.Time         `json:"joinedAt"`
	IsActive      bool              `json:"isActive"`
	LastActiveAt  time.Time         `json:"lastActiveAt"`
	PostCount     int32             `json:"postCount"`
	CommentCount  int32             `json:"commentCount"`
	Reputation    int32             `json:"reputation"`
	Badges        []string          `json:"badges"`
	Preferences   MemberPreferences `json:"preferences"`
}

type MemberPreferences struct {
	NotificationsEnabled bool       `json:"notificationsEnabled"`
	EmailDigest          string     `json:"emailDigest"`
	MuteUntil            *time.Time `json:"muteUntil,omitempty"`
	HideActivity         bool       `json:"hideActivity"`
}

type Event struct {
	ID                string          `json:"id"`
	CreatorID         string          `json:"creatorId"`
	CommunityID       *string         `json:"communityId,omitempty"`
	Title             string          `json:"title"`
	Description       string          `json:"description"`
	StartTime         time.Time       `json:"startTime"`
	EndTime           time.Time       `json:"endTime"`
	LocationName      string          `json:"locationName"`
	Latitude          *float64        `json:"latitude,omitempty"`
	Longitude         *float64        `json:"longitude,omitempty"`
	LocationURL       string          `json:"locationUrl"`
	MaxAttendees      int32           `json:"maxAttendees"`
	CurrentAttendees  int32           `json:"currentAttendees"`
	IsPublic          bool            `json:"isPublic"`
	IsRecurring       bool            `json:"isRecurring"`
	RecurrencePattern string          `json:"recurrencePattern"`
	ImageURL          string          `json:"imageUrl"`
	Status            string          `json:"status"`
	CreatedAt         time.Time       `json:"createdAt"`
	UpdatedAt         time.Time       `json:"updatedAt"`
	TicketInfo        EventTicketInfo `json:"ticketInfo"`
}

type EventTicketInfo struct {
	IsRequired       bool       `json:"isRequired"`
	Price            float64    `json:"price"`
	Currency         string     `json:"currency"`
	AvailableTickets int32      `json:"availableTickets"`
	SoldTickets      int32      `json:"soldTickets"`
	EarlyBirdUntil   *time.Time `json:"earlyBirdUntil,omitempty"`
}

type Collective struct {
	ID          string          `json:"id"`
	Name        string          `json:"name"`
	Slug        string          `json:"slug"`
	Description string          `json:"description"`
	Icon        string          `json:"icon"`
	BannerURL   string          `json:"bannerUrl"`
	NodeCount   int             `json:"nodeCount"`
	Influence   float64         `json:"influence"`
	MemberCount int32           `json:"memberCount"`
	IsOfficial  bool            `json:"isOfficial"`
	Category    string          `json:"category"`
	CreatedAt   time.Time       `json:"createdAt"`
	UpdatedAt   time.Time       `json:"updatedAt"`
	Stats       CollectiveStats `json:"stats"`
}

type CollectiveStats struct {
	TotalThreads   int32 `json:"totalThreads"`
	TotalReplies   int32 `json:"totalReplies"`
	ActiveMembers  int32 `json:"activeMembers"`
	WeeklyActivity int32 `json:"weeklyActivity"`
}

type Thread struct {
	ID             string    `json:"id"`
	CollectiveID   string    `json:"collectiveId"`
	AuthorID       string    `json:"authorId"`
	AuthorName     string    `json:"authorName"`
	AuthorAvatar   *string   `json:"authorAvatar,omitempty"`
	Title          string    `json:"title"`
	Content        string    `json:"content"`
	Resonance      int       `json:"resonance"`
	ViewCount      int32     `json:"viewCount"`
	ReplyCount     int32     `json:"replyCount"`
	IsPinned       bool      `json:"isPinned"`
	IsLocked       bool      `json:"isLocked"`
	IsAnnouncement bool      `json:"isAnnouncement"`
	CreatedAt      time.Time `json:"createdAt"`
	UpdatedAt      time.Time `json:"updatedAt"`
	Tags           []string  `json:"tags"`
	Category       string    `json:"category"`
}

type ThreadReply struct {
	ID          string    `json:"id"`
	ThreadID    string    `json:"threadId"`
	AuthorID    string    `json:"authorId"`
	AuthorName  string    `json:"authorName"`
	AuthorAvatar *string   `json:"authorAvatar,omitempty"`
	Content     string    `json:"content"`
	Resonance   int       `json:"resonance"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
	IsEdited    bool      `json:"isEdited"`
	ParentID    *string   `json:"parentId,omitempty"`
}

type CommunityRepository interface {
	CreateCommunity(context.Context, *Community) error
	GetCommunity(context.Context, string) (*Community, error)
	CanViewCommunity(context.Context, string, string) (bool, error)
	GetCommunityBySlug(context.Context, string) (*Community, error)
	UpdateCommunity(context.Context, string, *Community) error
	DeleteCommunity(context.Context, string) error
	ListCommunities(context.Context, string, string, int32, int32) ([]*Community, error)
	SearchCommunities(context.Context, string, int32, int32) ([]*Community, error)
	GetTrendingCommunities(context.Context, int32) ([]*Community, error)
	JoinCommunity(context.Context, string, string, string) error
	LeaveCommunity(context.Context, string, string) error
	GetCommunityMembers(context.Context, string, string, int32, int32) ([]*CommunityMember, error)
	UpdateMemberRole(context.Context, string, string, string) error
	RemoveMember(context.Context, string, string) error
	GetMemberStats(context.Context, string, string) (*CommunityStats, error)
	BanMember(context.Context, string, string, string, *time.Time) error
	UnbanMember(context.Context, string, string) error
	CreateCollective(context.Context, *Collective) error
	GetCollectives(context.Context, int32, int32) ([]*Collective, error)
	GetCollective(context.Context, string) (*Collective, error)
	UpdateCollective(context.Context, string, *Collective) error
	DeleteCollective(context.Context, string) error
	JoinCollective(context.Context, string, string) error
	LeaveCollective(context.Context, string, string) error
	CreateThread(context.Context, *Thread) error
	GetThreads(context.Context, string, int32, int32) ([]*Thread, error)
	GetThread(context.Context, string) (*Thread, error)
	UpdateThread(context.Context, string, *Thread) error
	DeleteThread(context.Context, string) error
	ResonateThread(context.Context, string, int) error
	CreateThreadReply(context.Context, *ThreadReply) error
	GetThreadReplies(context.Context, string, int32, int32) ([]*ThreadReply, error)
	PinThread(context.Context, string, bool) error
	LockThread(context.Context, string, bool) error
	CreateEvent(context.Context, *Event) error
	GetEvent(context.Context, string) (*Event, error)
	UpdateEvent(context.Context, string, *Event) error
	DeleteEvent(context.Context, string) error
	ListEvents(context.Context, *string, string, string, int32, int32) ([]*Event, error)
	GetUpcomingEvents(context.Context, string, int32) ([]*Event, error)
	RSVP(context.Context, string, string, string) error
	GetAttendees(context.Context, string, int32, int32) ([]string, error)
	CreateTicket(context.Context, string, string, string) error
	GetTicket(context.Context, string) (*Ticket, error)
	GetUserTickets(context.Context, string) ([]*Ticket, error)
	ValidateTicket(context.Context, string) (*Ticket, error)
	CancelTicket(context.Context, string) error
	CreateSubscription(context.Context, string, string, string, string, time.Time) error
	GetSubscription(context.Context, string) (*Subscription, error)
	GetUserSubscriptions(context.Context, string) ([]*Subscription, error)
	CancelSubscription(context.Context, string) error
	UpdateSubscription(context.Context, string, string) error
	ReportContent(context.Context, string, string, string, string) error
	GetReports(context.Context, string, string, int32, int32) ([]*ContentReport, error)
	ResolveReport(context.Context, string, string) error
	GetCommunityGuidelines(context.Context, string) ([]*Guideline, error)
	UpdateGuidelines(context.Context, string, []*Guideline) error
	UpdateCommunityStats(context.Context, string) error
	GetCommunityAnalytics(context.Context, string, string) (*CommunityAnalytics, error)
	GetMemberActivity(context.Context, string, string, string) (*MemberActivity, error)
}

type Ticket struct {
	ID string `json:"id"`; EventID string `json:"eventId"`; UserID string `json:"userId"`; TicketCode string `json:"ticketCode"`; Status string `json:"status"`; PurchasedAt time.Time `json:"purchasedAt"`; UsedAt *time.Time `json:"usedAt,omitempty"`; ExpiresAt *time.Time `json:"expiresAt,omitempty"`; Metadata map[string]interface{} `json:"metadata"`
}

type Subscription struct {
	ID string `json:"id"`; CreatorID string `json:"creatorId"`; SubscriberID string `json:"subscriberId"`; Tier string `json:"tier"`; Amount float64 `json:"amount"`; Currency string `json:"currency"`; Status string `json:"status"`; StartedAt time.Time `json:"startedAt"`; ExpiresAt time.Time `json:"expiresAt"`; AutoRenew bool `json:"autoRenew"`; Benefits []string `json:"benefits"`
}

type ContentReport struct { ID string `json:"id"`; ReporterID string `json:"reporterId"`; ContentType string `json:"contentType"`; ContentID string `json:"contentId"`; Reason string `json:"reason"`; Description string `json:"description"`; Status string `json:"status"`; CreatedAt time.Time `json:"createdAt"`; ResolvedAt *time.Time `json:"resolvedAt,omitempty"`; ResolvedBy *string `json:"resolvedBy,omitempty"`; Resolution string `json:"resolution"` }

type Guideline struct { ID string `json:"id"`; CommunityID string `json:"communityId"`; Title string `json:"title"`; Description string `json:"description"`; Order int `json:"order"`; IsActive bool `json:"isActive"`; CreatedAt time.Time `json:"createdAt"` }

type CommunityAnalytics struct { CommunityID string `json:"communityId"`; Period string `json:"period"`; MemberCount int32 `json:"memberCount"`; NewMembers int32 `json:"newMembers"`; ActiveMembers int32 `json:"activeMembers"`; PostCount int32 `json:"postCount"`; CommentCount int32 `json:"commentCount"`; EventCount int32 `json:"eventCount"`; EngagementRate float64 `json:"engagementRate"`; AvgSessionTime float64 `json:"avgSessionTime"`; TopContent []string `json:"topContent"` }

type MemberActivity struct { UserID string `json:"userId"`; CommunityID string `json:"communityId"`; Period string `json:"period"`; PostsCreated int32 `json:"postsCreated"`; CommentsMade int32 `json:"commentsMade"`; EventsAttended int32 `json:"eventsAttended"`; ReactionsGiven int32 `json:"reactionsGiven"`; TimeSpent int32 `json:"timeSpent"`; LastActiveAt time.Time `json:"lastActiveAt"` }

type CommunityService interface {
	CreateGroup(context.Context, string, string, string, bool) (*Community, error)
	Join(context.Context, string, string) error
	Leave(context.Context, string, string) error
	OrganizeEvent(context.Context, *Event) (*Event, error)
	AttendEvent(context.Context, string, string) error
	CancelEvent(context.Context, string) error
	UpdateEvent(context.Context, string, *Event) error
	SubscribeToCreator(context.Context, string, string, string, string) error
	CancelSubscription(context.Context, string) error
	UpdateSubscriptionTier(context.Context, string, string) error
	FormCollective(context.Context, string, string, string) (*Collective, error)
	StartThread(context.Context, string, string, string, string) (*Thread, error)
	Resonate(context.Context, string, bool) error
	ReplyToThread(context.Context, string, string, string) (*ThreadReply, error)
	PinThread(context.Context, string, bool) error
	LockThread(context.Context, string, bool) error
	PromoteMember(context.Context, string, string, string) error
	DemoteMember(context.Context, string, string, string) error
	BanMember(context.Context, string, string, string, *time.Time) error
	UnbanMember(context.Context, string, string) error
	ReportContent(context.Context, string, string, string, string) error
	ResolveReport(context.Context, string, string) error
	SetCommunityGuidelines(context.Context, string, []*Guideline) error
	GetCommunityAnalytics(context.Context, string, string) (*CommunityAnalytics, error)
	GetMemberActivity(context.Context, string, string, string) (*MemberActivity, error)
	SearchCommunities(context.Context, string, map[string]interface{}) ([]*Community, error)
	GetTrendingCommunities(context.Context, int32) ([]*Community, error)
	GetRecommendedCommunities(context.Context, string, int32) ([]*Community, error)
}
