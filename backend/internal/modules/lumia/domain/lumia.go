package domain

import (
	"context"
	"time"
)

type Broadcast struct {
	ID          string
	HostID      string
	Title       string
	ViewerCount int
	IsLive      bool
	StartedAt   time.Time
}

type EnergyDrop struct {
	ID          string
	BroadcastID string
	SenderID    string
	Amount      int
	Type        string
	CreatedAt   time.Time
}

type LumiaRepository interface {
	CreateBroadcast(ctx context.Context, b *Broadcast) error
	EndBroadcast(ctx context.Context, id string) error
	AddEnergyDrop(ctx context.Context, drop *EnergyDrop) error
	GetLiveBroadcasts(ctx context.Context) ([]*Broadcast, error)
}

type LumiaService interface {
	StartLive(ctx context.Context, hostID, title string) (*Broadcast, error)
	DropEnergy(ctx context.Context, senderID, broadcastID string, amount int) error
	GetLiveBroadcasts(ctx context.Context) ([]*Broadcast, error)

	// Zenith: Advanced Mechanics
	TipSignal(ctx context.Context, senderID, signalID string, amount int) error
}
