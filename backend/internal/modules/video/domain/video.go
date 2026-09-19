package domain

import (
	"context"
	"time"
)

type VideoMetadata struct {
	PostID           string
	DurationSeconds  int32
	ResolutionWidth  int32
	ResolutionHeight int32
	IsSpatial        bool
	SpatialConfig    map[string]interface{}
	Codec            string
	Bitrate          int32
	FrameRate        float32
	FileSize         int64
	ThumbnailURL     string
	StreamURL        string
	StreamStatus     string // processing, ready, live, ended
	ViewerCount      int32
	LiveViewers      int32
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

type VideoTrack struct {
	ID           string
	PostID       string
	TrackType    string // audio, subtitle, video
	LanguageCode string
	MediaURL     string
	IsOriginal   bool
	Quality      string // low, medium, high, ultra
	Bandwidth    int32
}

type Hotspot struct {
	ID               string
	PostID           string
	TimestampSeconds float64
	CoordX           float64
	CoordY           float64
	ActionType       string
	ActionPayload    map[string]interface{}
	IsInteractive    bool
	Duration         float64
}

type VideoCall struct {
	ID                  string
	HostID              string
	Title               string
	Description         string
	IsPublic            bool
	MaxParticipants     int32
	CurrentParticipants int32
	StartTime           time.Time
	EndTime             *time.Time
	UpdatedAt           time.Time
	Status              string // scheduled, live, ended, cancelled
	RecordingURL        *string
	ThumbnailURL        string
	Category            string
	Tags                []string
}

type StreamSession struct {
	ID          string
	VideoID     string
	StreamerID  string
	StreamKey   string
	StreamURL   string
	IsLive      bool
	ViewerCount int32
	StartTime   time.Time
	EndTime     *time.Time
	Bandwidth   int32
	Resolution  string
	FPS         int32
}

type VideoRepository interface {
	UpsertMetadata(ctx context.Context, meta *VideoMetadata) error
	GetMetadata(ctx context.Context, postID string) (*VideoMetadata, error)
	AddTrack(ctx context.Context, track *VideoTrack) error
	GetTracks(ctx context.Context, postID string) ([]*VideoTrack, error)
	AddHotspot(ctx context.Context, hotspot *Hotspot) error
	GetHotspots(ctx context.Context, postID string) ([]*Hotspot, error)
	CreateBranch(ctx context.Context, parentID, childID, remixType string) error

	// Video Calls
	CreateVideoCall(ctx context.Context, call *VideoCall) error
	GetVideoCall(ctx context.Context, callID string) (*VideoCall, error)
	UpdateVideoCall(ctx context.Context, callID string, updates *VideoCall) error
	ListVideoCalls(ctx context.Context, userID string, status string, limit, offset int32) ([]*VideoCall, error)

	// Live Streaming
	CreateStreamSession(ctx context.Context, session *StreamSession) error
	GetStreamSession(ctx context.Context, sessionID string) (*StreamSession, error)
	UpdateStreamSession(ctx context.Context, sessionID string, updates *StreamSession) error
	EndStreamSession(ctx context.Context, sessionID string) error
	GetActiveStreams(ctx context.Context, limit int32) ([]*StreamSession, error)

	// Analytics
	IncrementViewCount(ctx context.Context, videoID string) error
	UpdateLiveViewers(ctx context.Context, videoID string, count int32) error
}

type VideoService interface {
	RegisterVideo(ctx context.Context, postID string, duration int32) error
	AddInteractiveHotspot(ctx context.Context, postID string, ts float64, x, y float64, action string, payload map[string]interface{}) error
	SyncWatchHub(ctx context.Context, hubID, state string, ts float64) error

	// Video Call Management
	StartVideoCall(ctx context.Context, hostID, title, description string, maxParticipants int32) (*VideoCall, error)
	JoinVideoCall(ctx context.Context, callID, userID string) error
	LeaveVideoCall(ctx context.Context, callID, userID string) error
	EndVideoCall(ctx context.Context, callID, userID string) error
	ScheduleVideoCall(ctx context.Context, hostID, title, description string, scheduledTime time.Time) (*VideoCall, error)
	GetUserVideoCalls(ctx context.Context, userID string, status string) ([]*VideoCall, error)

	// Live Streaming
	StartLiveStream(ctx context.Context, userID, title, description string) (*StreamSession, error)
	EndLiveStream(ctx context.Context, sessionID string) error
	GetActiveStreams(ctx context.Context) ([]*StreamSession, error)
	GetStreamByUser(ctx context.Context, userID string) (*StreamSession, error)

	// Video Processing
	GenerateThumbnail(ctx context.Context, videoID string) (string, error)
	TranscodeVideo(ctx context.Context, videoID string, targetQuality string) error
	ExtractSubtitles(ctx context.Context, videoID string) ([]*VideoTrack, error)

	// Video Analytics
	RecordView(ctx context.Context, videoID, userID string) error
	GetVideoAnalytics(ctx context.Context, videoID string) (map[string]interface{}, error)
	GetTrendingVideos(ctx context.Context, limit int32) ([]*VideoMetadata, error)
}
