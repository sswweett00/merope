package domain

import (
	"context"
	"time"
)

type Signal struct {
	ID              string         `json:"id"`
	AuthorID        string         `json:"author_id"`
	AuthorName      string         `json:"author_username"` // Flutter expects author_username
	AuthorAvatar    string         `json:"author_avatar_url"` // Flutter expects author_avatar_url
	ContentText     string         `json:"content_text"`
	MediaURLs       []string       `json:"media_urls"`
	Visibility      string         `json:"visibility"`
	IsPinned        bool           `json:"is_pinned"`
	IsArchived      bool           `json:"is_archived"`
	IsDraft         bool           `json:"is_draft"`
	LocationName    string         `json:"location_name"`
	Latitude        *float64       `json:"latitude"`
	Longitude       *float64       `json:"longitude"`
	ContentWarning  string         `json:"content_warning"`
	CreatedAt       time.Time      `json:"-"`
	CreatedAtUnix   int64          `json:"created_at"` // Flutter expects int
	UpdatedAt       time.Time      `json:"updated_at"`
	Reactions       map[string]int `json:"-"`
	LikeCount       int            `json:"like_count"`
	CommentCount    int            `json:"comment_count"`
	ShareCount      int            `json:"repost_count"`
	ViewCount       int            `json:"view_count"`
	ResonanceScore  float64        `json:"resonance_score"`
	WaveAmplitude   int            `json:"resonance_count"` // resonance_count
	IsLiked         bool           `json:"is_liked"`
	IsReposted      bool           `json:"is_reposted"`
	IsOwned         bool           `json:"is_owned"`
	ContentType     string         `json:"content_type"`
	LinkPreview     *LinkPreview   `json:"link_preview"`
	Mentions        []string       `json:"mentions"`
	Hashtags        []string       `json:"hashtags"`
	Effect          string         `json:"effect"`
	ScheduledAt     *time.Time     `json:"scheduled_at"`
	ExpiresAt       *time.Time     `json:"expires_at"`
	ReplyToID       *string        `json:"reply_to_id"`
	RepostOfID      *string        `json:"repost_of_id"`
	Quote           *string        `json:"quote"`
	Language        string         `json:"language"`
	Sensitivity     string         `json:"sensitivity"`

	// Apex Mechanics (v11.0)
	IsBoosted       bool           `json:"is_boosted"`
	BoostAmount     int            `json:"boost_amount"`
	BurnAt          *time.Time     `json:"burn_at"`
	Summary         string         `json:"neural_summary"`
}

type LinkPreview struct {
	URL         string
	Title       string
	Description string
	ImageURL    string
}

type Mention struct {
	ID         string
	UserID     string
	EntityType string // signal, collective
	EntityID   string
	CreatedAt  time.Time
}

type ContentRepository interface {
	CreateSignal(ctx context.Context, s *Signal) error
	GetStream(ctx context.Context, userID string, limit, offset int32) ([]*Signal, error)
	GetSignalByID(ctx context.Context, signalID string) (*Signal, error)
	GetSignalsByUser(ctx context.Context, userID string, limit, offset int32) ([]*Signal, error)
	GetSignalsByHashtag(ctx context.Context, hashtag string, limit, offset int32) ([]*Signal, error)
	GetTrendingSignals(ctx context.Context, limit int32) ([]*Signal, error)
	AddResonance(ctx context.Context, userID, signalID string, amplitude int) error
	UpdateSignalStatus(ctx context.Context, signalID string, pinned, archived, draft bool) error
	UpdateSignal(ctx context.Context, s *Signal) error
	DeleteSignal(ctx context.Context, signalID string) error
	UpdateSignalMetrics(ctx context.Context, signalID string, viewCount, commentCount, shareCount int) error
	SearchSignals(ctx context.Context, query string, limit, offset int32) ([]*Signal, error)

	// Mentions
	CreateMentions(ctx context.Context, mentions []*Mention) error
	GetMentionsForUser(ctx context.Context, userID string, limit, offset int32) ([]*Mention, error)

	// Resonance Nodes (Comments)
	CreateNode(ctx context.Context, signalID, authorID string, parentID *string, content string) (*Node, error)
	GetNodesForSignal(ctx context.Context, signalID string) ([]*Node, error)
	UpdateNode(ctx context.Context, nodeID, content string) error
	DeleteNode(ctx context.Context, nodeID string) error

	// Wave Pools (Polls)
	CreateWavePool(ctx context.Context, signalID, question string, endsAt time.Time, options []string) error
	VoteWave(ctx context.Context, poolID, optionID, userID string) error
	GetWaveResults(ctx context.Context, poolID string) (map[string]int, error)
	GetWavePoolBySignal(ctx context.Context, signalID string) (*WavePoolData, error)

	// Frequencies (Hashtags)
	LinkFrequencies(ctx context.Context, signalID string, tags []string) error
	GetTrendingFrequencies(ctx context.Context, limit int32) ([]string, error)

	// Vaults (Collections)
	CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error)
	VaultSignal(ctx context.Context, userID, signalID string, vaultID *string) error
	GetUserVaults(ctx context.Context, userID string) ([]*Vault, error)
	GetVaultSignals(ctx context.Context, vaultID string) ([]*Signal, error)

	// Scheduled Content
	ScheduleSignal(ctx context.Context, signalID string, scheduledAt time.Time) error
	GetScheduledSignals(ctx context.Context, userID string) ([]*Signal, error)

	// Link Previews
	StoreLinkPreview(ctx context.Context, signalID string, preview *LinkPreview) error
}

type Vault struct {
	ID        string
	OwnerID   string
	Name      string
	IsPrivate bool
	CreatedAt time.Time
	SignalCount int
}

type Node struct {
	ID           string
	SignalID     string
	AuthorID     string
	AuthorName   string
	AuthorAvatar string
	ParentID     *string
	Content      string
	CreatedAt    time.Time
}

type ContentService interface {
	BroadcastSignal(ctx context.Context, signal *Signal, pool *WavePoolData) (*Signal, error)
	GetResonanceStream(ctx context.Context, userID string, page int32) ([]*Signal, error)
	GetSignal(ctx context.Context, signalID string) (*Signal, error)
	GetUserSignals(ctx context.Context, userID string, page int32) ([]*Signal, error)
	GetHashtagSignals(ctx context.Context, hashtag string, page int32) ([]*Signal, error)
	GetTrendingContent(ctx context.Context, limit int32) ([]*Signal, error)
	SearchContent(ctx context.Context, query string, page int32) ([]*Signal, error)
	AmplifySignal(ctx context.Context, userID, signalID string, amplitude int) error
	PinSignal(ctx context.Context, signalID string, pinned bool) error
	ArchiveSignal(ctx context.Context, signalID string, archived bool) error
	ShareSignal(ctx context.Context, userID, signalID string) error
	ViewSignal(ctx context.Context, userID, signalID string) error
	UpdateSignal(ctx context.Context, s *Signal) error
	DeleteSignal(ctx context.Context, signalID string) error

	// Nodes
	AddNode(ctx context.Context, signalID, authorID string, parentID *string, text string) (*Node, error)
	GetSignalNodes(ctx context.Context, signalID string) ([]*Node, error)
	UpdateNode(ctx context.Context, nodeID, content string) error
	DeleteNode(ctx context.Context, nodeID string) error

	// Waves
	Vote(ctx context.Context, poolID, optionID, userID string) error
	GetWavePool(ctx context.Context, signalID string) (*WavePoolData, error)

	// Mentions
	GetUserMentions(ctx context.Context, userID string, page int32) ([]*Mention, error)

	// Hashtags
	GetTrendingHashtags(ctx context.Context, limit int32) ([]string, error)

	// Vaults
	CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error)
	SaveToVault(ctx context.Context, userID, signalID string, vaultID *string) error
	GetUserVaults(ctx context.Context, userID string) ([]*Vault, error)
	GetVaultContent(ctx context.Context, vaultID string) ([]*Signal, error)

	// Scheduled Content
	ScheduleContent(ctx context.Context, signalID string, scheduledAt time.Time) error
	GetScheduledContent(ctx context.Context, userID string) ([]*Signal, error)

	// Link Previews
	GenerateLinkPreview(ctx context.Context, url string) (*LinkPreview, error)
}

type WavePoolData struct {
	Question string
	Options  []string
	EndsAt   time.Time
}
