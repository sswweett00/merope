package service

import (
	"context"
	"fmt"
	"log"

	"local/merope/internal/core/events"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/content/domain"
	socialService "local/merope/internal/modules/social/service"

	"golang.org/x/sync/errgroup"
)

type ContentMirrorRepository interface {
	UpdateSignalStatus(context.Context, string, bool, bool, bool) error
	GetStream(context.Context, string, int32, int32) ([]*domain.Signal, error)
	AddResonance(context.Context, string, string, int) error
	RemoveResonance(context.Context, string, string) error
	CreateNode(context.Context, string, string, *string, string) (*domain.Node, error)
	GetNodesForSignal(context.Context, string) ([]*domain.Node, error)
}

type HighPerformanceContentService struct {
	pgRepo     domain.ContentRepository
	scyllaRepo ContentMirrorRepository
	bus          events.Publisher
	veritasGuard socialService.VeritasContentGuard
}

func NewHighPerformanceContentService(pgRepo domain.ContentRepository, scyllaRepo ContentMirrorRepository, bus events.Publisher, veritasGuard socialService.VeritasContentGuard) domain.ContentService {
	return &HighPerformanceContentService{pgRepo: pgRepo, scyllaRepo: scyllaRepo, bus: bus, veritasGuard: veritasGuard}
}

func (s *HighPerformanceContentService) BroadcastSignal(ctx context.Context, signal *domain.Signal, pool *domain.WavePoolData) (*domain.Signal, error) {
	if signal == nil || signal.AuthorID == "" {
		return nil, fmt.Errorf("signal author is required")
	}
	signal.ContentText = security.SanitizeHTML(signal.ContentText)
	visibility, err := normalizeVisibility(signal.Visibility)
	if err != nil {
		return nil, err
	}
	signal.Visibility = visibility
	if s.veritasGuard != nil {
		if s.veritasGuard.DetectBotPattern(ctx, signal.AuthorID, signal.ContentText) {
			return nil, fmt.Errorf("signal rejected: bot pattern detected")
		}
		original, originalID, _ := s.veritasGuard.VerifyOriginality(ctx, signal.AuthorID, signal.ContentText)
		if !original {
			return nil, fmt.Errorf("signal rejected: duplicate content detected (Original ID: %s)", originalID)
		}
	}
	if err := s.pgRepo.CreateSignal(ctx, signal); err != nil { return nil, err }
	if s.veritasGuard != nil {
		_ = s.veritasGuard.MarkContentProvenance(ctx, signal.ID, signal.AuthorID)
	}

	g, gCtx := errgroup.WithContext(ctx)
	g.Go(func() error {
		tags := extractFrequencies(signal.ContentText)
		if len(tags) > 0 { return s.pgRepo.LinkFrequencies(gCtx, signal.ID, tags) }
		return nil
	})
	g.Go(func() error {
		mentions := extractMentions(signal.ContentText)
		if len(mentions) == 0 { return nil }
		mEntities := make([]*domain.Mention, 0, len(mentions))
		for _, m := range mentions { mEntities = append(mEntities, &domain.Mention{UserID: m, EntityType: "signal", EntityID: signal.ID}) }
		return s.pgRepo.CreateMentions(gCtx, mEntities)
	})
	if pool != nil { g.Go(func() error { return s.pgRepo.CreateWavePool(gCtx, signal.ID, pool.Question, pool.EndsAt, pool.Options) }) }
	g.Go(func() error { return s.bus.Publish(gCtx, "content.signal.broadcasted", events.Event{Type: "SIGNAL_BROADCASTED", Payload: signal}) })
	if err := g.Wait(); err != nil { return nil, err }
	return signal, nil
}

func (s *HighPerformanceContentService) PinSignal(ctx context.Context, signalID string, pinned bool) error {
	if err := s.pgRepo.UpdateSignalStatus(ctx, signalID, pinned, false, false); err != nil { return err }
	if s.scyllaRepo != nil {
		if err := s.scyllaRepo.UpdateSignalStatus(ctx, signalID, pinned, false, false); err != nil { log.Printf("[ScyllaDB] Failed to mirror pin status for signal %s: %v", signalID, err) }
	}
	return nil
}

func (s *HighPerformanceContentService) ArchiveSignal(ctx context.Context, signalID string, archived bool) error {
	if err := s.pgRepo.UpdateSignalStatus(ctx, signalID, false, archived, false); err != nil { return err }
	if s.scyllaRepo != nil {
		if err := s.scyllaRepo.UpdateSignalStatus(ctx, signalID, false, archived, false); err != nil { log.Printf("[ScyllaDB] Failed to mirror archive status for signal %s: %v", signalID, err) }
	}
	return nil
}

func (s *HighPerformanceContentService) GetResonanceStream(ctx context.Context, userID string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	if page > 1 { return s.pgRepo.GetStream(ctx, userID, limit, (page-1)*limit) }
	if s.scyllaRepo != nil {
		messages, err := s.scyllaRepo.GetStream(ctx, userID, limit, 0)
		if err == nil && len(messages) > 0 { return messages, nil }
	}
	return s.pgRepo.GetStream(ctx, userID, limit, 0)
}

func (s *HighPerformanceContentService) AmplifySignal(ctx context.Context, userID, signalID string, amplitude int) error {
	err := s.pgRepo.AddResonance(ctx, userID, signalID, amplitude)
	if err != nil { return err }
	if s.scyllaRepo != nil {
		if mirrorErr := s.scyllaRepo.AddResonance(ctx, userID, signalID, amplitude); mirrorErr != nil { log.Printf("[ScyllaDB] Failed to mirror resonance for signal %s: %v", signalID, mirrorErr) }
	}
	if pubErr := s.bus.Publish(ctx, "content.resonance.amplified", events.Event{Type: "SIGNAL_AMPLIFIED", Payload: map[string]interface{}{"user_id": userID, "signal_id": signalID, "amplitude": amplitude}}); pubErr != nil { log.Printf("[NATS] Failed to publish resonance amplified event: %v", pubErr) }
	return nil
}

func (s *HighPerformanceContentService) AddNode(ctx context.Context, signalID, authorID string, parentID *string, text string) (*domain.Node, error) {
	sanitizedText := security.SanitizeHTML(text)
	node, err := s.pgRepo.CreateNode(ctx, signalID, authorID, parentID, sanitizedText)
	if err != nil { return nil, err }
	if s.scyllaRepo != nil {
		if _, mirrorErr := s.scyllaRepo.CreateNode(ctx, signalID, authorID, parentID, sanitizedText); mirrorErr != nil { log.Printf("[ScyllaDB] Failed to mirror comment on signal %s: %v", signalID, mirrorErr) }
	}
	return node, nil
}

func (s *HighPerformanceContentService) GetSignalNodes(ctx context.Context, signalID string) ([]*domain.Node, error) {
	if s.scyllaRepo != nil {
		nodes, err := s.scyllaRepo.GetNodesForSignal(ctx, signalID)
		if err == nil && len(nodes) > 0 { return nodes, nil }
	}
	return s.pgRepo.GetNodesForSignal(ctx, signalID)
}

func (s *HighPerformanceContentService) Vote(ctx context.Context, poolID, optionID, userID string) error { return s.pgRepo.VoteWave(ctx, poolID, optionID, userID) }


func (s *HighPerformanceContentService) RemoveResonance(ctx context.Context, userID, signalID string) error {
	if userID == "" || signalID == "" {
		return fmt.Errorf("invalid resonance removal request")
	}
	if err := s.pgRepo.RemoveResonance(ctx, userID, signalID); err != nil {
		return err
	}
	if s.scyllaRepo != nil {
		if err := s.scyllaRepo.RemoveResonance(ctx, userID, signalID); err != nil {
			log.Printf("[ScyllaDB] Failed to mirror resonance removal for signal %s: %v", signalID, err)
		}
	}
	if s.bus != nil {
		if err := s.bus.Publish(ctx, "content.resonance.removed", events.Event{
			Type: "SIGNAL_RESONANCE_REMOVED",
			Payload: map[string]interface{}{"user_id": userID, "signal_id": signalID},
		}); err != nil {
			log.Printf("[NATS] Failed to publish resonance removal for signal %s: %v", signalID, err)
		}
	}
	return nil
}
