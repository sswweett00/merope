package infra

import (
	"context"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/community/domain"
)

type postgresCommunityRepository struct {
	queries *db.Queries
}

func NewPostgresCommunityRepository(queries *db.Queries) domain.CommunityRepository {
	return &postgresCommunityRepository{queries: queries}
}

func (r *postgresCommunityRepository) CreateCommunity(ctx context.Context, comm *domain.Community) error {
	var uid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(comm.OwnerID)); err != nil {
		return err
	}

	dbComm, err := r.queries.CreateCommunity(ctx, db.CreateCommunityParams{
		OwnerID:     uid,
		Name:        comm.Name,
		Description: pgtype.Text{String: comm.Description, Valid: comm.Description != ""},
		AvatarUrl:   pgtype.Text{String: comm.AvatarURL, Valid: comm.AvatarURL != ""},
		IsPrivate:   comm.IsPrivate,
	})
	if err != nil {
		return err
	}

	comm.ID = util.UUIDToString(dbComm.ID)
	comm.CreatedAt = dbComm.CreatedAt.Time
	if comm.UpdatedAt.IsZero() {
		comm.UpdatedAt = comm.CreatedAt
	}

	tags := comm.Tags
	if tags == nil {
		tags = []string{}
	}
	rules := comm.Rules
	if rules == nil {
		rules = []string{}
	}
	category := strings.TrimSpace(comm.Category)
	if category == "" {
		category = "general"
	}

	_, err = r.queries.Exec(ctx, `
UPDATE communities
SET slug = $2,
    banner_url = $3,
    is_verified = $4,
    category = $5,
    tags = $6,
    rules = $7,
    updated_at = NOW()
WHERE id = $1`, dbComm.ID, comm.Slug, comm.BannerURL, comm.IsVerified, category, tags, rules)
	if err != nil {
		return err
	}
	comm.Category = category
	comm.Tags = tags
	comm.Rules = rules
	return nil
}

func (r *postgresCommunityRepository) JoinCommunity(ctx context.Context, commID, userID, role string) error {
	var cid, uid pgtype.UUID
	if err := cid.Scan(strings.TrimSpace(commID)); err != nil {
		return err
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return err
	}
	return r.queries.JoinCommunity(ctx, db.JoinCommunityParams{
		CommunityID: cid,
		UserID:      uid,
		Role:        role,
	})
}

func (r *postgresCommunityRepository) CreateEvent(ctx context.Context, event *domain.Event) error {
	var uid, cid pgtype.UUID
	if err := uid.Scan(strings.TrimSpace(event.CreatorID)); err != nil {
		return err
	}
	if event.CommunityID != nil && strings.TrimSpace(*event.CommunityID) != "" {
		if err := cid.Scan(strings.TrimSpace(*event.CommunityID)); err != nil {
			return err
		}
	}

	dbEvent, err := r.queries.CreateEvent(ctx, db.CreateEventParams{
		ProposerID:  uid,
		CommunityID: cid,
		Title:       event.Title,
		Description: event.Description,
		EndsAt:      pgtype.Timestamptz{Time: event.EndTime, Valid: !event.EndTime.IsZero()},
	})
	if err != nil {
		return err
	}
	if event.ID == "" {
		event.ID = util.UUIDToString(dbEvent.ID)
	}
	if event.CreatedAt.IsZero() {
		event.CreatedAt = dbEvent.CreatedAt.Time
	}
	return nil
}

func (r *postgresCommunityRepository) RSVP(ctx context.Context, eventID, userID, status string) error {
	var eid, uid pgtype.UUID
	if err := eid.Scan(strings.TrimSpace(eventID)); err != nil {
		return err
	}
	if err := uid.Scan(strings.TrimSpace(userID)); err != nil {
		return err
	}
	return r.queries.RsvpEvent(ctx, db.RsvpEventParams{EventID: eid, UserID: uid})
}
