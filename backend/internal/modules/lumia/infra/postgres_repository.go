package infra

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/lumia/domain"
)

type PostgresLumiaRepository struct {
	queries *db.Queries
}

func NewPostgresLumiaRepository(queries *db.Queries) *PostgresLumiaRepository {
	return &PostgresLumiaRepository{queries: queries}
}

func (r *PostgresLumiaRepository) CreateBroadcast(ctx context.Context, b *domain.Broadcast) error {
	var uid pgtype.UUID
	if err := uid.Scan(b.HostID); err != nil {
		return err
	}
	row, err := r.queries.CreateBroadcast(ctx, db.CreateBroadcastParams{HostID: uid, Title: b.Title, IsLive: b.IsLive})
	if err != nil {
		return err
	}
	b.ID = util.UUIDToString(row.ID)
	return nil
}

func (r *PostgresLumiaRepository) EndBroadcast(ctx context.Context, id string) error {
	var bid pgtype.UUID
	if err := bid.Scan(id); err != nil { return err }
	return r.queries.EndBroadcast(ctx, bid)
}

func (r *PostgresLumiaRepository) AddEnergyDrop(ctx context.Context, drop *domain.EnergyDrop) error {
	var bid, sid pgtype.UUID
	if drop.BroadcastID != "" {
		if err := bid.Scan(drop.BroadcastID); err != nil { return err }
	}
	if err := sid.Scan(drop.SenderID); err != nil { return err }
	_, err := r.queries.AddEnergyDrop(ctx, db.AddEnergyDropParams{BroadcastID: bid, SenderID: sid, Amount: int32(drop.Amount), DropType: drop.Type})
	return err
}

func (r *PostgresLumiaRepository) GetLiveBroadcasts(ctx context.Context) ([]*domain.Broadcast, error) {
	rows, err := r.queries.GetActiveBroadcasts(ctx)
	if err != nil { return nil, err }
	res := make([]*domain.Broadcast, len(rows))
	for i, row := range rows {
		res[i] = &domain.Broadcast{ID: util.UUIDToString(row.ID), HostID: util.UUIDToString(row.HostID), Title: row.Title, ViewerCount: int(row.ViewerCount), IsLive: row.IsLive, StartedAt: row.StartedAt.Time}
	}
	return res, nil
}
