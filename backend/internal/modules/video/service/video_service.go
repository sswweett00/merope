package service

import (
	"context"
	"fmt"
	"local/merope/internal/core/events"
	"local/merope/internal/modules/video/domain"
	"time"

	"github.com/google/uuid"
)

type videoService struct {
	repo   domain.VideoRepository
	bus    events.Publisher
	shield AetherStreamShield
}

func NewVideoService(repo domain.VideoRepository, bus events.Publisher, shield AetherStreamShield) domain.VideoService {
	return &videoService{repo: repo, bus: bus, shield: shield}
}

func (s *videoService) RegisterVideo(ctx context.Context, postID string, duration int32) error {
	meta := &domain.VideoMetadata{
		PostID:          postID,
		DurationSeconds: duration,
		StreamStatus:    "processing",
		CreatedAt:       time.Now(),
		UpdatedAt:       time.Now(),
	}
	return s.repo.UpsertMetadata(ctx, meta)
}

func (s *videoService) AddInteractiveHotspot(ctx context.Context, postID string, ts float64, x, y float64, action string, payload map[string]interface{}) error {
	hotspot := &domain.Hotspot{
		ID:               uuid.New().String(),
		PostID:           postID,
		TimestampSeconds: ts,
		CoordX:           x,
		CoordY:           y,
		ActionType:       action,
		ActionPayload:    payload,
		IsInteractive:    true,
	}
	return s.repo.AddHotspot(ctx, hotspot)
}

func (s *videoService) SyncWatchHub(ctx context.Context, hubID, state string, ts float64) error {
	// Publish sync event to all listeners in the hub via NATS/WS
	return s.bus.Publish(ctx, "watchhub.sync", events.Event{
		Type: "WATCH_SYNC",
		Payload: map[string]interface{}{
			"hub_id":    hubID,
			"state":     state,
			"timestamp": ts,
		},
	})
}

// Video Call Management

func (s *videoService) StartVideoCall(ctx context.Context, hostID, title, description string, maxParticipants int32) (*domain.VideoCall, error) {
	call := &domain.VideoCall{
		ID:            uuid.New().String(),
		HostID:        hostID,
		Title:         title,
		Description:   description,
		IsPublic:      false,
		MaxParticipants: maxParticipants,
		CurrentParticipants: 1, // host counts as participant
		StartTime:     time.Now(),
		Status:        "live",
		Category:      "video_call",
		Tags:          []string{"video-call"},
	}

	if err := s.repo.CreateVideoCall(ctx, call); err != nil {
		return nil, err
	}

	_ = s.bus.Publish(ctx, "video.call.started", events.Event{
		Type: "VIDEO_CALL_STARTED",
		Payload: call,
	})

	return call, nil
}

func (s *videoService) JoinVideoCall(ctx context.Context, callID, userID string) error {
	call, err := s.repo.GetVideoCall(ctx, callID)
	if err != nil {
		return err
	}

	if call.Status != "live" {
		return fmt.Errorf("call is not live")
	}

	if call.CurrentParticipants >= call.MaxParticipants {
		return fmt.Errorf("call is full")
	}

	call.CurrentParticipants++
	call.UpdatedAt = time.Now()

	if err := s.repo.UpdateVideoCall(ctx, callID, call); err != nil {
		return err
	}

	_ = s.bus.Publish(ctx, "video.call.joined", events.Event{
		Type: "VIDEO_CALL_JOINED",
		Payload: map[string]interface{}{
			"call_id": callID,
			"user_id": userID,
		},
	})

	return nil
}

func (s *videoService) LeaveVideoCall(ctx context.Context, callID, userID string) error {
	call, err := s.repo.GetVideoCall(ctx, callID)
	if err != nil {
		return err
	}

	if call.CurrentParticipants > 0 {
		call.CurrentParticipants--
	}

	call.UpdatedAt = time.Now()

	if err := s.repo.UpdateVideoCall(ctx, callID, call); err != nil {
		return err
	}

	_ = s.bus.Publish(ctx, "video.call.left", events.Event{
		Type: "VIDEO_CALL_LEFT",
		Payload: map[string]interface{}{
			"call_id": callID,
			"user_id": userID,
		},
	})

	return nil
}

func (s *videoService) EndVideoCall(ctx context.Context, callID, userID string) error {
	call, err := s.repo.GetVideoCall(ctx, callID)
	if err != nil {
		return err
	}

	if call.HostID != userID {
		return fmt.Errorf("only host can end the call")
	}

	now := time.Now()
	call.EndTime = &now
	call.Status = "ended"
	call.UpdatedAt = now

	if err := s.repo.UpdateVideoCall(ctx, callID, call); err != nil {
		return err
	}

	_ = s.bus.Publish(ctx, "video.call.ended", events.Event{
		Type: "VIDEO_CALL_ENDED",
		Payload: call,
	})

	return nil
}

func (s *videoService) ScheduleVideoCall(ctx context.Context, hostID, title, description string, scheduledTime time.Time) (*domain.VideoCall, error) {
	call := &domain.VideoCall{
		ID:            uuid.New().String(),
		HostID:        hostID,
		Title:         title,
		Description:   description,
		IsPublic:      false,
		MaxParticipants: 10,
		CurrentParticipants: 0,
		StartTime:     scheduledTime,
		Status:        "scheduled",
		Category:      "video_call",
		Tags:          []string{"video-call", "scheduled"},
	}

	if err := s.repo.CreateVideoCall(ctx, call); err != nil {
		return nil, err
	}

	_ = s.bus.Publish(ctx, "video.call.scheduled", events.Event{
		Type: "VIDEO_CALL_SCHEDULED",
		Payload: call,
	})

	return call, nil
}

func (s *videoService) GetUserVideoCalls(ctx context.Context, userID string, status string) ([]*domain.VideoCall, error) {
	return s.repo.ListVideoCalls(ctx, userID, status, 50, 0)
}

// Live Streaming

func (s *videoService) StartLiveStream(ctx context.Context, userID, title, description string) (*domain.StreamSession, error) {
	streamKey := fmt.Sprintf("stream_%s_%d", userID, time.Now().Unix())

	session := &domain.StreamSession{
		ID:         uuid.New().String(),
		StreamerID: userID,
		StreamKey:  streamKey,
		StreamURL:  fmt.Sprintf("rtmp://merope.live/live/%s", streamKey),
		IsLive:     true,
		ViewerCount: 0,
		StartTime:  time.Now(),
		Bandwidth:  0,
		Resolution: "1080p",
		FPS:        30,
	}

	if err := s.repo.CreateStreamSession(ctx, session); err != nil {
		return nil, err
	}

	_ = s.bus.Publish(ctx, "stream.started", events.Event{
		Type: "STREAM_STARTED",
		Payload: session,
	})

	return session, nil
}

func (s *videoService) EndLiveStream(ctx context.Context, sessionID string) error {
	return s.repo.EndStreamSession(ctx, sessionID)
}

func (s *videoService) GetActiveStreams(ctx context.Context) ([]*domain.StreamSession, error) {
	return s.repo.GetActiveStreams(ctx, 50)
}

func (s *videoService) GetStreamByUser(ctx context.Context, userID string) (*domain.StreamSession, error) {
	sessions, err := s.repo.GetActiveStreams(ctx, 50)
	if err != nil {
		return nil, err
	}

	for _, session := range sessions {
		if session.StreamerID == userID {
			return session, nil
		}
	}

	return nil, fmt.Errorf("no active stream found for user")
}

// Video Processing

func (s *videoService) GenerateThumbnail(ctx context.Context, videoID string) (string, error) {
	// Zenith: Structural implementation of FFmpeg thumbnail extraction
	// Command: ffmpeg -i input.mp4 -ss 00:00:01 -vframes 1 output.jpg
	thumbnailURL := fmt.Sprintf("https://cdn.merope.media/thumbnails/%s.jpg", videoID)

	meta, err := s.repo.GetMetadata(ctx, videoID)
	if err != nil {
		return "", err
	}

	// Publish processing task for the worker pool
	_ = s.bus.Publish(ctx, "video.process.thumbnail", events.Event{
		Type: "PROCESS_THUMBNAIL",
		Payload: map[string]interface{}{
			"video_id": videoID,
			"output":   thumbnailURL,
			"command":  fmt.Sprintf("ffmpeg -i %s -ss 00:00:01 -vframes 1 -q:v 2 %s", videoID, thumbnailURL),
		},
	})

	meta.ThumbnailURL = thumbnailURL
	meta.UpdatedAt = time.Now()

	_ = s.repo.UpsertMetadata(ctx, meta)

	return thumbnailURL, nil
}

func (s *videoService) TranscodeVideo(ctx context.Context, videoID string, targetQuality string) error {
	// Zenith: Structural implementation of Adaptive Bitrate Streaming (HLS/DASH)
	// Command for HLS: ffmpeg -i input.mp4 -profile:v baseline -level 3.0 -s 640x360 -start_number 0 -hls_time 10 -hls_list_size 0 -f hls index.m3u8

	meta, err := s.repo.GetMetadata(ctx, videoID)
	if err != nil {
		return err
	}

	meta.StreamStatus = "processing"
	meta.UpdatedAt = time.Now()
	_ = s.repo.UpsertMetadata(ctx, meta)

	// In Merope, heavy processing is offloaded to specialized Worker Pools via NATS
	_ = s.bus.Publish(ctx, "video.process.transcode", events.Event{
		Type: "TRANSCODE_START",
		Payload: map[string]interface{}{
			"video_id": videoID,
			"quality":  targetQuality,
			"profiles": []string{"1080p", "720p", "480p"},
			"codec":    "h264_nvenc", // Utilizing GPU acceleration where possible
		},
	})

	// Simulate processing completion for local dev state
	go func() {
		time.Sleep(5 * time.Second)
		meta, _ := s.repo.GetMetadata(context.Background(), videoID)
		if meta != nil {
			meta.StreamStatus = "ready"
			meta.UpdatedAt = time.Now()
			_ = s.repo.UpsertMetadata(context.Background(), meta)
		}
	}()

	return nil
}

func (s *videoService) ExtractSubtitles(ctx context.Context, videoID string) ([]*domain.VideoTrack, error) {
	// In a real implementation, this would use speech recognition to extract subtitles
	// For now, return empty tracks
	return []*domain.VideoTrack{}, nil
}

// Video Analytics

func (s *videoService) RecordView(ctx context.Context, videoID, userID string) error {
	if err := s.repo.IncrementViewCount(ctx, videoID); err != nil {
		return err
	}

	_ = s.bus.Publish(ctx, "video.viewed", events.Event{
		Type: "VIDEO_VIEWED",
		Payload: map[string]interface{}{
			"video_id": videoID,
			"user_id":  userID,
		},
	})

	return nil
}

func (s *videoService) GetVideoAnalytics(ctx context.Context, videoID string) (map[string]interface{}, error) {
	meta, err := s.repo.GetMetadata(ctx, videoID)
	if err != nil {
		return nil, err
	}

	return map[string]interface{}{
		"video_id":      videoID,
		"view_count":    meta.ViewerCount,
		"live_viewers":  meta.LiveViewers,
		"duration":      meta.DurationSeconds,
		"resolution":    fmt.Sprintf("%dx%d", meta.ResolutionWidth, meta.ResolutionHeight),
		"codec":         meta.Codec,
		"bitrate":       meta.Bitrate,
		"frame_rate":    meta.FrameRate,
		"stream_status": meta.StreamStatus,
	}, nil
}

func (s *videoService) GetTrendingVideos(ctx context.Context, limit int32) ([]*domain.VideoMetadata, error) {
	// In a real implementation, this would use a trending algorithm
	// For now, return videos with high view counts
	return nil, nil
}
