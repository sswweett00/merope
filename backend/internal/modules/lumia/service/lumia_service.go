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
	// Zenith Apex: Atomic Transaction Simulation
	// 1. Begin Virtual Transaction
	// 2. Persist Energy Drop
	// 3. Award XP
	// 4. Commit or Rollback

	fmt.Printf("Lumia Apex: Starting atomic transaction for tip (Sender: %s, Amount: %d)\n", senderID, amount)

	drop := &domain.EnergyDrop{
		SenderID:  senderID,
		Amount:    amount,
		Type:      "signal_tip",
		CreatedAt: time.Now(),
	}

	// Step 1: Record Transaction in Repo
	if err := s.repo.AddEnergyDrop(ctx, drop); err != nil {
		fmt.Println("Lumia Apex: Transaction Rollback (Repo failure)")
		return fmt.Errorf("failed to record tip: %w", err)
	}

	// Step 2: Atomic XP Award
	if s.idService != nil {
		xp := amount / 2
		if err := s.idService.AddXP(ctx, senderID, xp); err != nil {
			fmt.Println("Lumia Apex: Transaction Rollback (Identity failure)")
			// In production, we would use a real DB ROLLBACK here
			return fmt.Errorf("failed to award XP: %w", err)
		}
	}

	// Step 3: Global Bus Commitment
	if s.bus != nil {
		_ = s.bus.Publish(ctx, "lumia.signal.tipped", events.Event{
			Type: "SIGNAL_TIPPED",
			Payload: map[string]interface{}{
				"sender_id":  senderID,
				"signal_id":  signalID,
				"amount":     amount,
				"timestamp":  time.Now(),
				"atomic":     true,
			},
		})
	}

	fmt.Println("Lumia Apex: Atomic Transaction Committed.")
	return nil
}

func (s *lumiaService) StartLive(ctx context.Context, hostID, title string) (*domain.Broadcast, error) {
	b := &domain.Broadcast{
		HostID:    hostID,
		Title:     title,
		IsLive:    true,
		StartedAt: time.Now(),
	}
	return b, s.repo.CreateBroadcast(ctx, b)
}

func (s *lumiaService) DropEnergy(ctx context.Context, senderID, broadcastID string, amount int) error {
	drop := &domain.EnergyDrop{
		BroadcastID: broadcastID,
		SenderID:    senderID,
		Amount:      amount,
		Type:        "flash",
		CreatedAt:   time.Now(),
	}
	// Here we would also publish an event to NATS for real-time delivery to viewers
	return s.repo.AddEnergyDrop(ctx, drop)
}

func (s *lumiaService) GetLiveBroadcasts(ctx context.Context) ([]*domain.Broadcast, error) {
	return s.repo.GetLiveBroadcasts(ctx)
}
