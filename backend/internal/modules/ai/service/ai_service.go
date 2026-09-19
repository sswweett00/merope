package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"sync"
	"time"

	"github.com/google/uuid"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"

	"local/merope/internal/core/events"
	"local/merope/internal/core/observability"
	"local/merope/internal/modules/ai/domain"
	"local/merope/internal/platform/nats"
	"local/merope/internal/platform/redis"
)

type aiService struct {
	repo        domain.AIRepository
	redis       *redis.Client
	nats        *nats.Client
	classifier  *ContentClassifier
	rateLimiter *RateLimiter
	cacheTTL    time.Duration
	batchSize   int
	trace       trace.Tracer
}

type RateLimiter struct {
	mu     sync.RWMutex
	limits map[string]*rateBucket
	rate   int
	window time.Duration
}

type rateBucket struct {
	count    int
	lastSeen time.Time
}

func NewAIRepositoryService(repo domain.AIRepository, redisClient *redis.Client, natsClient *nats.Client) domain.AIService {
	return NewAIRepositoryServiceWithConfig(repo, redisClient, natsClient, Config{
		CacheTTL:   30 * time.Minute,
		BatchSize:  50,
		RateLimit:  100,
		RateWindow: time.Minute,
	})
}

type Config struct {
	CacheTTL   time.Duration
	BatchSize  int
	RateLimit  int
	RateWindow time.Duration
}

func NewAIRepositoryServiceWithConfig(repo domain.AIRepository, redisClient *redis.Client, natsClient *nats.Client, cfg Config) domain.AIService {
	return &aiService{
		repo:        repo,
		redis:       redisClient,
		nats:        natsClient,
		classifier:  NewContentClassifier(),
		rateLimiter: NewRateLimiter(cfg.RateLimit, cfg.RateWindow),
		cacheTTL:    cfg.CacheTTL,
		batchSize:   cfg.BatchSize,
		trace:       observability.Tracer,
	}
}

func NewRateLimiter(rate int, window time.Duration) *RateLimiter {
	return &RateLimiter{
		limits: make(map[string]*rateBucket),
		rate:   rate,
		window: window,
	}
}

func (l *RateLimiter) Allow(userID string) bool {
	l.mu.Lock()
	defer l.mu.Unlock()

	now := time.Now()
	bucket, exists := l.limits[userID]
	if !exists {
		l.limits[userID] = &rateBucket{count: 1, lastSeen: now}
		return true
	}

	if now.Sub(bucket.lastSeen) > l.window {
		bucket.count = 1
		bucket.lastSeen = now
		return true
	}

	if bucket.count >= l.rate {
		return false
	}

	bucket.count++
	bucket.lastSeen = now
	return true
}

func (s *aiService) contentHash(text, mediaURL string) string {
	h := sha256.New()
	h.Write([]byte(text))
	h.Write([]byte(mediaURL))
	return hex.EncodeToString(h.Sum(nil))
}

func (s *aiService) AnalyzeContent(ctx context.Context, targetID, contentType, text, mediaURL string) (*domain.ContentAnalysis, error) {
	ctx, span := s.trace.Start(ctx, "ai.AnalyzeContent")
	defer span.End()

	if !s.rateLimiter.Allow(targetID) {
		return nil, ErrRateLimited
	}

	cacheKey := "ai:analysis:" + s.contentHash(targetID, contentType+text+mediaURL)
	if s.redis != nil {
		cached, err := s.redis.Conn.Get(ctx, cacheKey).Result()
		if err == nil && cached != "" {
			var cachedAnalysis domain.ContentAnalysis
			if err := json.Unmarshal([]byte(cached), &cachedAnalysis); err == nil {
				span.SetAttributes(attribute.String("cache.hit", "true"))
				return &cachedAnalysis, nil
			}
		}
	}

	analysis, err := s.classifier.Classify(ctx, targetID, contentType, text, mediaURL)
	if err != nil {
		return nil, err
	}

	if analysis.Confidence < 0.3 {
		analysis.Confidence = 0.3
	}

	if err := s.repo.StoreAnalysis(ctx, analysis); err != nil {
		return nil, err
	}

	if s.redis != nil {
		data, _ := json.Marshal(analysis)
		_ = s.redis.Conn.Set(ctx, cacheKey, data, s.cacheTTL).Err()
	}

	if s.nats != nil {
		_ = s.nats.Publish(ctx, "ai.analysis.completed", events.Event{
			Type:    "ai.analysis.completed",
			Payload: analysis,
		})
	}

	return analysis, nil
}

func (s *aiService) AnalyzeBatch(ctx context.Context, tasks []domain.ContentTask) ([]*domain.ContentAnalysis, error) {
	ctx, span := s.trace.Start(ctx, "ai.AnalyzeBatch")
	defer span.End()

	results := make([]*domain.ContentAnalysis, 0, len(tasks))

	chunks := chunkTasks(tasks, s.batchSize)
	var mu sync.Mutex
	var wg sync.WaitGroup

	for _, chunk := range chunks {
		wg.Add(1)
		go func(taskChunk []domain.ContentTask) {
			defer wg.Done()
			for _, task := range taskChunk {
				analysis, err := s.AnalyzeContent(ctx, task.TargetID, task.ContentType, task.Text, task.MediaURL)
				if err != nil {
					continue
				}
				mu.Lock()
				results = append(results, analysis)
				mu.Unlock()
			}
		}(chunk)
	}

	wg.Wait()
	return results, nil
}

func (s *aiService) GetRecommendations(ctx context.Context, req *domain.RecommendationRequest) (*domain.RecommendationResponse, error) {
	ctx, span := s.trace.Start(ctx, "ai.GetRecommendations")
	defer span.End()

	if !s.rateLimiter.Allow(req.UserID) {
		return nil, ErrRateLimited
	}

	var cached string
	if s.redis != nil {
		cacheKey := "ai:recs:" + req.UserID + ":" + req.ContentType
		cached, _ = s.redis.Conn.Get(ctx, cacheKey).Result()
		if cached != "" {
			var resp domain.RecommendationResponse
			if err := json.Unmarshal([]byte(cached), &resp); err == nil {
				span.SetAttributes(attribute.String("cache.hit", "true"))
				return &resp, nil
			}
		}
	}

	vector, err := s.repo.GetUserVector(ctx, req.UserID)
	if err != nil {
		return nil, err
	}

	items := s.generateRecommendations(ctx, req, vector)

	excludeSet := make(map[string]bool)
	for _, id := range req.ExcludeIDs {
		excludeSet[id] = true
	}

	filtered := make([]*domain.RecommendationItem, 0, len(items))
	for i := range items {
		if !excludeSet[items[i].TargetID] {
			item := items[i]
			filtered = append(filtered, &item)
		}
	}

	if len(filtered) > req.Limit {
		filtered = filtered[:req.Limit]
	}

	resp := &domain.RecommendationResponse{
		Items: filtered,
	}
	if len(filtered) == req.Limit && len(items) > req.Limit {
		resp.NextCursor = uuid.New().String()
	}

	if s.redis != nil {
		cacheKey := "ai:recs:" + req.UserID + ":" + req.ContentType
		data, _ := json.Marshal(resp)
		_ = s.redis.Conn.Set(ctx, cacheKey, data, s.cacheTTL).Err()
	}

	return resp, nil
}

func (s *aiService) GetTrendingTopics(ctx context.Context, window time.Duration) ([]domain.TrendTopic, error) {
	ctx, span := s.trace.Start(ctx, "ai.GetTrendingTopics")
	defer span.End()

	topics, err := s.repo.GetTrendTopics(ctx, window)
	if err != nil {
		return nil, err
	}

	if len(topics) == 0 {
		topics, err = s.repo.GetTrendTopics(ctx, 24*time.Hour)
	}

	return topics, nil
}

func (s *aiService) ClassifyEntity(ctx context.Context, text string) ([]domain.EntityMention, error) {
	ctx, span := s.trace.Start(ctx, "ai.ClassifyEntity")
	defer span.End()

	return s.classifier.ExtractEntities(ctx, text), nil
}

func (s *aiService) generateRecommendations(ctx context.Context, req *domain.RecommendationRequest, vector *domain.UserProfileVector) []domain.RecommendationItem {
	if vector == nil {
		return s.fallbackRecommendations(req)
	}

	items := s.exploitInterests(ctx, vector, req)
	diversified := s.injectDiversity(items, req.Limit)

	return diversified
}

func (s *aiService) exploitInterests(ctx context.Context, vector *domain.UserProfileVector, req *domain.RecommendationRequest) []domain.RecommendationItem {
	var items []domain.RecommendationItem
	for _, interest := range vector.Interests {
		score := vector.EngagementVector[interest]
		if score < 0.1 {
			score = 0.5
		}
		items = append(items, domain.RecommendationItem{
			TargetID:    interest,
			Score:       score,
			Reason:      "interest_match",
			ContentType: req.ContentType,
			CreatedAt:   time.Now(),
		})
	}
	return items
}

func (s *aiService) injectDiversity(items []domain.RecommendationItem, limit int) []domain.RecommendationItem {
	if len(items) <= limit {
		return items
	}

	diversified := make([]domain.RecommendationItem, 0, limit)
	exploreCount := limit / 5
	if exploreCount < 1 {
		exploreCount = 1
	}

	for i := 0; i < limit && i < len(items); i++ {
		if i < exploreCount {
			diversified = append(diversified, items[i])
		} else {
			diversified = append(diversified, items[i])
		}
	}

	return diversified[:min(limit, len(diversified))]
}

func (s *aiService) fallbackRecommendations(req *domain.RecommendationRequest) []domain.RecommendationItem {
	return []domain.RecommendationItem{
		{
			TargetID:    "trending",
			Score:       0.8,
			Reason:      "fallback_trending",
			ContentType: req.ContentType,
			CreatedAt:   time.Now(),
		},
	}
}

func chunkTasks(tasks []domain.ContentTask, size int) [][]domain.ContentTask {
	if size <= 0 {
		size = 50
	}
	var chunks [][]domain.ContentTask
	for i := 0; i < len(tasks); i += size {
		end := i + size
		if end > len(tasks) {
			end = len(tasks)
		}
		chunks = append(chunks, tasks[i:end])
	}
	return chunks
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

var ErrRateLimited = errors.New("rate limit exceeded")
