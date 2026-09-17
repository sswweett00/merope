package infra

import (
	"context"
	"time"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/community/domain"

	"github.com/jackc/pgx/v5/pgtype"
)

type postgresCommunityRepository struct {
	queries *db.Queries
}

func NewPostgresCommunityRepository(queries *db.Queries) domain.CommunityRepository {
	return &postgresCommunityRepository{queries: queries}
}

func (r *postgresCommunityRepository) CreateCommunity(ctx context.Context, comm *domain.Community) error {
	var uid pgtype.UUID
	_ = uid.Scan(comm.OwnerID)
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
	return nil
}

func (r *postgresCommunityRepository) JoinCommunity(ctx context.Context, commID, userID, role string) error {
	var cid, uid pgtype.UUID
	_ = cid.Scan(commID)
	_ = uid.Scan(userID)
	return r.queries.JoinCommunity(ctx, db.JoinCommunityParams{
		CommunityID: cid,
		UserID:      uid,
		Role:        role,
	})
}

func (r *postgresCommunityRepository) CreateEvent(ctx context.Context, event *domain.Event) error {
	var uid, cid pgtype.UUID
	_ = uid.Scan(event.CreatorID)
	if event.CommunityID != nil {
		_ = cid.Scan(*event.CommunityID)
	}

	dbEvent, err := r.queries.CreateEvent(ctx, db.CreateEventParams{
		ProposerID:  uid,
		CommunityID: cid,
		Title:       event.Title,
		Description: event.Description,
		EndsAt:      pgtype.Timestamptz{Time: event.EndTime, Valid: true},
	})
	if err != nil {
		return err
	}
	event.ID = util.UUIDToString(dbEvent.ID)
	event.CreatedAt = dbEvent.CreatedAt.Time
	return nil
}

func (r *postgresCommunityRepository) RSVP(ctx context.Context, eventID, userID, status string) error {
	var eid, uid pgtype.UUID
	_ = eid.Scan(eventID)
	_ = uid.Scan(userID)
	return r.queries.RsvpEvent(ctx, db.RsvpEventParams{
		EventID: eid,
		UserID:  uid,
	})
}

func (r *postgresCommunityRepository) CreateSubscription(ctx context.Context, subID, creatorID, tier string, expiresAt time.Time) error {
	var uid pgtype.UUID
	_ = uid.Scan(creatorID)
	_, err := r.queries.CreateSubscription(ctx, db.CreateSubscriptionParams{
		UserID: uid,
		Plan:   tier,
	})
	return err
}
