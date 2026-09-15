package service

import (
	"context"
	"log"

	"local/merope/internal/core/events"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/content/domain"

	"golang.org/x/sync/errgroup"
)

// HighPerformanceContentService routes writes to PostgreSQL (source of truth)
// and mirrors to ScyllaDB for high-performance reads.
type HighPerformanceContentService struct {
	pgRepo     domain.ContentRepository
	scyllaRepo domain.ContentRepository
	bus        events.Publisher
}

func NewHighPerformanceContentService(pgRepo domain.ContentRepository, scyllaRepo domain.ContentRepository, bus events.Publisher) domain.ContentService {
	return &HighPerformanceContentService{
		pgRepo:     pgRepo,
		scyllaRepo: scyllaRepo,
		bus:        bus,
	}
}

func (s *HighPerformanceContentService) BroadcastSignal(ctx context.Context, signal *domain.Signal, pool *domain.WavePoolData) (*domain.Signal, error) {
	signal.ContentText = security.SanitizeHTML(signal.ContentText)

	if err := s.pgRepo.CreateSignal(ctx, signal); err != nil {
		return nil, err
	}

	g, gCtx := errgroup.WithContext(ctx)

	g.Go(func() error {
		tags := extractFrequencies(signal.ContentText)
		if len(tags) > 0 {
			return s.pgRepo.LinkFrequencies(gCtx, signal.ID, tags)
		}
		return nil
	})

	g.Go(func() error {
		mentions := extractMentions(signal.ContentText)
		if len(mentions) > 0 {
			var mEntities []*domain.Mention
			for _, m := range mentions {
				mEntities = append(mEntities, &domain.Mention{
					UserID:     m,
					EntityType: "signal",
					EntityID:   signal.ID,
				})
			}
			return s.pgRepo.CreateMentions(gCtx, mEntities)
		}
		return nil
	})

	if pool != nil {
		g.Go(func() error {
			return s.pgRepo.CreateWavePool(gCtx, signal.ID, pool.Question, pool.EndsAt, pool.Options)
		})
	}

	g.Go(func() error {
		return s.bus.Publish(gCtx, "content.signal.broadcasted", events.Event{
			Type:    "SIGNAL_BROADCASTED",
			Payload: signal,
		})
	})

	if err := g.Wait(); err != nil {
		return nil, err
	}

	return signal, nil
}

func (s *HighPerformanceContentService) PinSignal(ctx context.Context, signalID string, pinned bool) error {
	if err := s.pgRepo.UpdateSignalStatus(ctx, signalID, pinned, false, false); err != nil {
		return err
	}
	if err := s.scyllaRepo.UpdateSignalStatus(ctx, signalID, pinned, false, false); err != nil {
		log.Printf("[ScyllaDB] Failed to mirror pin status for signal %s: %v", signalID, err)
	}
	return nil
}

func (s *HighPerformanceContentService) ArchiveSignal(ctx context.Context, signalID string, archived bool) error {
	if err := s.pgRepo.UpdateSignalStatus(ctx, signalID, false, archived, false); err != nil {
		return err
	}
	if err := s.scyllaRepo.UpdateSignalStatus(ctx, signalID, false, archived, false); err != nil {
		log.Printf("[ScyllaDB] Failed to mirror archive status for signal %s: %v", signalID, err)
	}
	return nil
}

func (s *HighPerformanceContentService) GetResonanceStream(ctx context.Context, userID string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	if page > 1 {
		return s.pgRepo.GetStream(ctx, userID, limit, (page-1)*limit)
	}

	messages, err := s.scyllaRepo.GetStream(ctx, userID, limit, 0)
	if err != nil || len(messages) == 0 {
		return s.pgRepo.GetStream(ctx, userID, limit, 0)
	}
	return messages, nil
}

func (s *HighPerformanceContentService) AmplifySignal(ctx context.Context, userID, signalID string, amplitude int) error {
	err := s.pgRepo.AddResonance(ctx, userID, signalID, amplitude)
	if err == nil {
		if mirrorErr := s.scyllaRepo.AddResonance(ctx, userID, signalID, amplitude); mirrorErr != nil {
			log.Printf("[ScyllaDB] Failed to mirror resonance for signal %s by user %s: %v", signalID, userID, mirrorErr)
		}
		if pubErr := s.bus.Publish(ctx, "content.resonance.amplified", events.Event{
			Type: "SIGNAL_AMPLIFIED",
			Payload: map[string]interface{}{
				"user_id":   userID,
				"signal_id": signalID,
				"amplitude": amplitude,
			},
		}); pubErr != nil {
			log.Printf("[NATS] Failed to publish resonance amplified event: %v", pubErr)
		}
	}
	return err
}

func (s *HighPerformanceContentService) AddNode(ctx context.Context, signalID, authorID string, parentID *string, text string) (*domain.Node, error) {
	sanitizedText := security.SanitizeHTML(text)

	node, err := s.pgRepo.CreateNode(ctx, signalID, authorID, parentID, sanitizedText)
	if err != nil {
		return nil, err
	}

	if _, mirrorErr := s.scyllaRepo.CreateNode(ctx, signalID, authorID, parentID, sanitizedText); mirrorErr != nil {
		log.Printf("[ScyllaDB] Failed to mirror comment on signal %s: %v", signalID, mirrorErr)
	}

	return node, nil
}

func (s *HighPerformanceContentService) GetSignalNodes(ctx context.Context, signalID string) ([]*domain.Node, error) {
	nodes, err := s.scyllaRepo.GetNodesForSignal(ctx, signalID)
	if err != nil || len(nodes) == 0 {
		return s.pgRepo.GetNodesForSignal(ctx, signalID)
	}
	return nodes, nil
}

func (s *HighPerformanceContentService) Vote(ctx context.Context, poolID, optionID, userID string) error {
	return s.pgRepo.VoteWave(ctx, poolID, optionID, userID)
}
