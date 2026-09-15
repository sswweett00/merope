package service

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/core/events"
	idDomain "local/merope/internal/modules/identity/domain"
	"local/merope/internal/modules/lumia/domain"
)

type lumiaService struct {
	repo      domain.LumiaRepository
	idService idDomain.IdentityService
	bus       events.Publisher
}

func NewLumiaService(repo domain.LumiaRepository, idService idDomain.IdentityService, bus events.Publisher) domain.LumiaService {
	return &lumiaService{repo: repo, idService: idService, bus: bus}
}

func (s *lumiaService) TipSignal(ctx context.Context, senderID, signalID string, amount int) error {
	fmt.Printf("Lumia Apex: Starting transaction for tip (Sender: %s, Amount: %d)\n", senderID, amount)
	drop := &domain.EnergyDrop{SenderID: senderID, Amount: amount, Type: "signal_tip", CreatedAt: time.Now()}
	if err := s.repo.AddEnergyDrop(ctx, drop); err != nil {
		return fmt.Errorf("failed to record tip: %w", err)
	}

	if s.bus != nil {
		_ = s.bus.Publish(ctx, "lumia.xp.award_requested", events.Event{Type: "LUMIA_XP_AWARD_REQUESTED", Payload: map[string]interface{}{"user_id": senderID, "xp": amount / 2, "signal_id": signalID}})
		_ = s.bus.Publish(ctx, "lumia.signal.tipped", events.Event{Type: "SIGNAL_TIPPED", Payload: map[string]interface{}{"sender_id": senderID, "signal_id": signalID, "amount": amount, "timestamp": time.Now(), "atomic": false}})
	}
	return nil
}

func (s *lumiaService) StartLive(ctx context.Context, hostID, title string) (*domain.Broadcast, error) {
	b := &domain.Broadcast{HostID: hostID, Title: title, IsLive: true, StartedAt: time.Now()}
	return b, s.repo.CreateBroadcast(ctx, b)
}

func (s *lumiaService) DropEnergy(ctx context.Context, senderID, broadcastID string, amount int) error {
	drop := &domain.EnergyDrop{BroadcastID: broadcastID, SenderID: senderID, Amount: amount, Type: "flash", CreatedAt: time.Now()}
	return s.repo.AddEnergyDrop(ctx, drop)
}

func (s *lumiaService) GetLiveBroadcasts(ctx context.Context) ([]*domain.Broadcast, error) {
	return s.repo.GetLiveBroadcasts(ctx)
}
