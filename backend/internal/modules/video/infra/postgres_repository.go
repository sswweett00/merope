package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/video/domain"
	"encoding/json"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresVideoRepository struct {
	queries *db.Queries
}

func NewPostgresVideoRepository(queries *db.Queries) *PostgresVideoRepository {
	return &PostgresVideoRepository{queries: queries}
}

func (r *PostgresVideoRepository) UpsertMetadata(ctx context.Context, meta *domain.VideoMetadata) error {
	var pid pgtype.UUID
	_ = pid.Scan(meta.PostID)

	_, err := r.queries.UpsertVideoMetadata(ctx, db.UpsertVideoMetadataParams{
		PostID:           pid,
		DurationSeconds:  meta.DurationSeconds,
		ResolutionWidth:  pgtype.Int4{Int32: meta.ResolutionWidth, Valid: true},
		ResolutionHeight: pgtype.Int4{Int32: meta.ResolutionHeight, Valid: true},
	})
	return err
}

func (r *PostgresVideoRepository) AddTrack(ctx context.Context, track *domain.VideoTrack) error {
	var pid pgtype.UUID
	_ = pid.Scan(track.PostID)

	_, err := r.queries.AddVideoTrack(ctx, db.AddVideoTrackParams{
		PostID:       pid,
		TrackType:    track.TrackType,
		LanguageCode: track.LanguageCode,
		MediaUrl:     track.MediaURL,
	})
	return err
}

func (r *PostgresVideoRepository) AddHotspot(ctx context.Context, hotspot *domain.Hotspot) error {
	var pid pgtype.UUID
	_ = pid.Scan(hotspot.PostID)
	payload, _ := json.Marshal(hotspot.ActionPayload)

	_, err := r.queries.AddVideoHotspot(ctx, db.AddVideoHotspotParams{
		PostID:           pid,
		TimestampSeconds: hotspot.TimestampSeconds,
		CoordX:           hotspot.CoordX,
		CoordY:           hotspot.CoordY,
		ActionType:       hotspot.ActionType,
		ActionPayload:    payload,
	})
	return err
}

func (r *PostgresVideoRepository) CreateBranch(ctx context.Context, parentID, childID, remixType string) error {
	var pid, cid pgtype.UUID
	_ = pid.Scan(parentID)
	_ = cid.Scan(childID)

	_, err := r.queries.CreateMediaBranch(ctx, db.CreateMediaBranchParams{
		ParentPostID: pid,
		ChildPostID:  cid,
		RemixType:    remixType,
	})
	return err
}
