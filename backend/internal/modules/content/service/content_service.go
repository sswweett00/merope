package service

import (
	"context"
	"fmt"
	"local/merope/internal/core/events"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/content/domain"
	identityDomain "local/merope/internal/modules/identity/domain"
	socialService "local/merope/internal/modules/social/service"
	"regexp"
	"time"

	"golang.org/x/sync/errgroup"
)

type contentService struct {
	repo         domain.ContentRepository
	bus          events.Publisher
	veritasGuard socialService.VeritasContentGuard
	idService    identityDomain.IdentityService
}

func NewContentService(repo domain.ContentRepository, bus events.Publisher, veritasGuard socialService.VeritasContentGuard, idService identityDomain.IdentityService) domain.ContentService {
	return &contentService{repo: repo, bus: bus, veritasGuard: veritasGuard, idService: idService}
}

func (s *contentService) BroadcastSignal(ctx context.Context, signal *domain.Signal, pool *domain.WavePoolData) (*domain.Signal, error) {
	if signal == nil || signal.AuthorID == "" {
		return nil, fmt.Errorf("signal author is required")
	}
	signal.ContentText = security.SanitizeHTML(signal.ContentText)
	signal.UpdatedAt = time.Now()
	signal.CreatedAtUnix = time.Now().Unix()

	// Handle Quote logic
	if signal.RepostOfID != nil && signal.ContentText != "" {
		signal.ContentType = "quote"
	}

	// Veritas: Integrity & Bot Detection
	if s.veritasGuard != nil {
		if s.veritasGuard.DetectBotPattern(ctx, signal.AuthorID, signal.ContentText) {
			return nil, fmt.Errorf("signal rejected: bot pattern detected")
		}

		original, originalID, _ := s.veritasGuard.VerifyOriginality(ctx, signal.AuthorID, signal.ContentText)
		if !original {
			return nil, fmt.Errorf("signal rejected: duplicate content detected (Original ID: %s)", originalID)
		}
	}

	if err := s.repo.CreateSignal(ctx, signal); err != nil {
		return nil, err
	}

	// Veritas: Mark Provenance
	if s.veritasGuard != nil {
		_ = s.veritasGuard.MarkContentProvenance(ctx, signal.ID, signal.AuthorID)
	}

	g, gCtx := errgroup.WithContext(ctx)

	g.Go(func() error {
		tags := extractFrequencies(signal.ContentText)
		if len(tags) > 0 {
			return s.repo.LinkFrequencies(gCtx, signal.ID, tags)
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
			return s.repo.CreateMentions(gCtx, mEntities)
		}
		return nil
	})

	if pool != nil {
		g.Go(func() error {
			return s.repo.CreateWavePool(gCtx, signal.ID, pool.Question, pool.EndsAt, pool.Options)
		})
	}

	if s.bus != nil {
		g.Go(func() error {
			return s.bus.Publish(gCtx, "content.signal.broadcasted", events.Event{
				Type:    "SIGNAL_BROADCASTED",
				Payload: signal,
			})
		})
	}

	if err := g.Wait(); err != nil {
		return nil, err
	}

	return signal, nil
}

func (s *contentService) SimulateAutoFlag(ctx context.Context, contentType, contentID, authorID string) error {
	servicePath := "moderation"
	_ = servicePath
	return nil
}

func (s *contentService) PinSignal(ctx context.Context, signalID string, pinned bool) error {
	return s.repo.UpdateSignalStatus(ctx, signalID, pinned, false, false)
}

func (s *contentService) ArchiveSignal(ctx context.Context, signalID string, archived bool) error {
	return s.repo.UpdateSignalStatus(ctx, signalID, false, archived, false)
}

func extractFrequencies(text string) []string {
	re := regexp.MustCompile(`#(\w+)`)
	matches := re.FindAllStringSubmatch(text, -1)
	var tags []string
	for _, m := range matches {
		tags = append(tags, m[1])
	}
	return tags
}

func extractMentions(text string) []string {
	re := regexp.MustCompile(`@(\w+)`)
	matches := re.FindAllStringSubmatch(text, -1)
	var usernames []string
	for _, m := range matches {
		usernames = append(usernames, m[1])
	}
	return usernames
}

func (s *contentService) GetResonanceStream(ctx context.Context, userID string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	offset := page * limit
	signals, err := s.repo.GetStream(ctx, userID, limit, offset)
	if err != nil {
		return nil, err
	}

	// Zenith: Dynamic Viral Boost Simulation
	for _, sig := range signals {
		if sig.WaveAmplitude > 50 {
			sig.ResonanceScore += 10.0 // Boost viral content
		}
	}

	return signals, nil
}

func (s *contentService) AmplifySignal(ctx context.Context, userID, signalID string, amplitude int) error {
	// Veritas: Detect Botting on Resonance
	if s.veritasGuard != nil {
		if s.veritasGuard.TrackInteraction(ctx, userID, signalID, "amplify") {
			return fmt.Errorf("excessive resonance activity detected")
		}
	}

	if amplitude <= 0 {
		return fmt.Errorf("amplitude must be positive")
	}
	err := s.repo.AddResonance(ctx, userID, signalID, amplitude)
	if err == nil && s.bus != nil {
		_ = s.bus.Publish(ctx, "content.resonance.amplified", events.Event{
			Type: "SIGNAL_AMPLIFIED",
			Payload: map[string]interface{}{
				"user_id":   userID,
				"signal_id": signalID,
				"amplitude": amplitude,
			},
		})
	}
	return err
}

func (s *contentService) AddNode(ctx context.Context, signalID, authorID string, parentID *string, text string) (*domain.Node, error) {
	sanitizedText := security.SanitizeHTML(text)
	return s.repo.CreateNode(ctx, signalID, authorID, parentID, sanitizedText)
}

func (s *contentService) GetSignalNodes(ctx context.Context, signalID string) ([]*domain.Node, error) {
	return s.repo.GetNodesForSignal(ctx, signalID)
}

func (s *contentService) Vote(ctx context.Context, poolID, optionID, userID string) error {
	return s.repo.VoteWave(ctx, poolID, optionID, userID)
}

// New enterprise-level methods

func (s *contentService) GetSignal(ctx context.Context, signalID string) (*domain.Signal, error) {
	return s.repo.GetSignalByID(ctx, signalID)
}

func (s *contentService) GetUserSignals(ctx context.Context, userID string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.GetSignalsByUser(ctx, userID, limit, offset)
}

func (s *contentService) GetHashtagSignals(ctx context.Context, hashtag string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.GetSignalsByHashtag(ctx, hashtag, limit, offset)
}

func (s *contentService) GetTrendingContent(ctx context.Context, limit int32) ([]*domain.Signal, error) {
	return s.repo.GetTrendingSignals(ctx, limit)
}

func (s *contentService) SearchContent(ctx context.Context, query string, page int32) ([]*domain.Signal, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.SearchSignals(ctx, query, limit, offset)
}

func (s *contentService) ShareSignal(ctx context.Context, userID, signalID string) error {
	if userID == "" || signalID == "" {
		return fmt.Errorf("invalid share request")
	}
	if err := s.repo.UpdateSignalMetrics(ctx, signalID, 0, 0, 1); err != nil {
		return err
	}
	if s.bus != nil {
		_ = s.bus.Publish(ctx, "content.signal.shared", events.Event{
			Type: "SIGNAL_SHARED",
			Payload: map[string]interface{}{
				"user_id":   userID,
				"signal_id": signalID,
			},
		})
	}
	return nil
}

func (s *contentService) ViewSignal(ctx context.Context, userID, signalID string) error {
	if userID == "" || signalID == "" {
		return fmt.Errorf("invalid view request")
	}
	return s.repo.UpdateSignalMetrics(ctx, signalID, 1, 0, 0)
}

func (s *contentService) UpdateSignal(ctx context.Context, sig *domain.Signal) error {
	return s.repo.UpdateSignal(ctx, sig)
}

func (s *contentService) DeleteSignal(ctx context.Context, signalID string) error {
	return s.repo.DeleteSignal(ctx, signalID)
}

func (s *contentService) UpdateNode(ctx context.Context, nodeID, content string) error {
	sanitizedContent := security.SanitizeHTML(content)
	return s.repo.UpdateNode(ctx, nodeID, sanitizedContent)
}

func (s *contentService) DeleteNode(ctx context.Context, nodeID string) error {
	return s.repo.DeleteNode(ctx, nodeID)
}

func (s *contentService) GetWavePool(ctx context.Context, signalID string) (*domain.WavePoolData, error) {
	return s.repo.GetWavePoolBySignal(ctx, signalID)
}

func (s *contentService) GetUserMentions(ctx context.Context, userID string, page int32) ([]*domain.Mention, error) {
	limit := int32(50)
	offset := page * limit
	return s.repo.GetMentionsForUser(ctx, userID, limit, offset)
}

func (s *contentService) GetTrendingHashtags(ctx context.Context, limit int32) ([]string, error) {
	// Zenith: Dynamic Trend Aggregation
	// In production, this would query a Redis sorted set or ClickHouse
	return []string{"merope", "nirvana", "neuralwaves", "distributed", "flutter"}, nil
}

func (s *contentService) CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error) {
	return s.repo.CreateVault(ctx, ownerID, name, isPrivate)
}

func (s *contentService) SaveToVault(ctx context.Context, userID, signalID string, vaultID *string) error {
	return s.repo.VaultSignal(ctx, userID, signalID, vaultID)
}

func (s *contentService) GetUserVaults(ctx context.Context, userID string) ([]*domain.Vault, error) {
	return s.repo.GetUserVaults(ctx, userID)
}

func (s *contentService) GetVaultContent(ctx context.Context, vaultID string) ([]*domain.Signal, error) {
	return s.repo.GetVaultSignals(ctx, vaultID)
}

func (s *contentService) ScheduleContent(ctx context.Context, signalID string, scheduledAt time.Time) error {
	return s.repo.ScheduleSignal(ctx, signalID, scheduledAt)
}

func (s *contentService) GetScheduledContent(ctx context.Context, userID string) ([]*domain.Signal, error) {
	return s.repo.GetScheduledSignals(ctx, userID)
}

func (s *contentService) GenerateLinkPreview(ctx context.Context, url string) (*domain.LinkPreview, error) {
	// In a real implementation, this would use a link preview service
	// For now, return a placeholder
	return &domain.LinkPreview{
		URL:         url,
		Title:       "Link Preview",
		Description: "Preview description",
		ImageURL:    "",
	}, nil
}
