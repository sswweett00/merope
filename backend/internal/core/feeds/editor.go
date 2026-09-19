package feeds

import (
	"context"
	"encoding/json"
	"math"
	"sort"
	"time"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"

	"local/merope/internal/core/observability"
	"local/merope/internal/core/util"
)

type FeedItem struct {
	ID          string
	AuthorID    string
	ContentType string
	Content     string
	Score       float64
	CreatedAt   time.Time
	SourceType  string
}

type FollowGraph interface {
	GetFollowers(ctx context.Context, userID string) ([]string, error)
}

type FeedRanker interface {
	Rank(ctx context.Context, userID string, items []FeedItem) []FeedItem
}

type FeedEngine struct {
	followGraph       FollowGraph
	ranker            FeedRanker
	redis             *RedisClient
	hotCache          *util.LRUCache[string, []FeedItem]
	fanoutQueue       chan fanoutTask
	batchSize         int
	workers           int
	timeDecayHalfLife time.Duration
	diversityWeight   float64
	exploreRatio      float64
	trace             trace.Tracer
}

type RedisClient struct {
	Conn interface {
		Get(ctx context.Context, key string) (string, error)
		Set(ctx context.Context, key string, value interface{}, ttl time.Duration) error
	}
}

type fanoutTask struct {
	authorID  string
	followers []string
	item      FeedItem
}

type FeedConfig struct {
	HotCacheSize      int
	FanoutWorkers     int
	BatchSize         int
	TimeDecayHalfLife time.Duration
	DiversityWeight   float64
	ExploreRatio      float64
}

func NewFeedEngine(followGraph FollowGraph, ranker FeedRanker, redisClient *RedisClient, cfg FeedConfig) *FeedEngine {
	if cfg.HotCacheSize <= 0 {
		cfg.HotCacheSize = 200
	}
	if cfg.FanoutWorkers <= 0 {
		cfg.FanoutWorkers = 10
	}
	if cfg.BatchSize <= 0 {
		cfg.BatchSize = 100
	}
	if cfg.TimeDecayHalfLife <= 0 {
		cfg.TimeDecayHalfLife = 6 * time.Hour
	}
	if cfg.DiversityWeight <= 0 {
		cfg.DiversityWeight = 0.2
	}
	if cfg.ExploreRatio <= 0 {
		cfg.ExploreRatio = 0.15
	}

	return &FeedEngine{
		followGraph:       followGraph,
		ranker:            ranker,
		redis:             redisClient,
		hotCache:          util.NewLRUCache[string, []FeedItem](cfg.HotCacheSize),
		fanoutQueue:       make(chan fanoutTask, 1000),
		batchSize:         cfg.BatchSize,
		workers:           cfg.FanoutWorkers,
		timeDecayHalfLife: cfg.TimeDecayHalfLife,
		diversityWeight:   cfg.DiversityWeight,
		exploreRatio:      cfg.ExploreRatio,
		trace:             observability.Tracer,
	}
}

func (e *FeedEngine) Start(ctx context.Context) {
	for i := 0; i < e.workers; i++ {
		go e.fanoutWorker(ctx)
	}
}

func (e *FeedEngine) Stop() {
	close(e.fanoutQueue)
}

func (e *FeedEngine) Publish(ctx context.Context, item FeedItem) error {
	ctx, span := e.trace.Start(ctx, "FeedEngine.Publish")
	defer span.End()

	followers, err := e.followGraph.GetFollowers(ctx, item.AuthorID)
	if err != nil {
		span.RecordError(err)
		return err
	}

	if len(followers) == 0 {
		return nil
	}

	chunkSize := e.batchSize
	chunks := chunkFollowers(followers, chunkSize)

	for _, chunk := range chunks {
		task := fanoutTask{
			authorID:  item.AuthorID,
			followers: chunk,
			item:      item,
		}
		select {
		case e.fanoutQueue <- task:
		case <-ctx.Done():
			return ctx.Err()
		}
	}

	return nil
}

func (e *FeedEngine) GetFeed(ctx context.Context, userID string, limit int, cursor string) ([]FeedItem, string, error) {
	ctx, span := e.trace.Start(ctx, "FeedEngine.GetFeed")
	defer span.End()

	if limit <= 0 {
		limit = 20
	}

	cacheKey := "feed:" + userID + ":" + cursor
	if cached, ok := e.hotCache.Get(cacheKey); ok {
		span.SetAttributes(attribute.Bool("cache.hit", true))
		return e.paginate(cached, limit, cursor)
	}

	if e.redis != nil {
		redisKey := "feed:hot:" + userID
		val, err := e.redis.Conn.Get(ctx, redisKey)
		if err == nil && val != "" {
			var cachedItems []FeedItem
			if err := json.Unmarshal([]byte(val), &cachedItems); err == nil {
				e.hotCache.Put(cacheKey, cachedItems)
				return e.paginate(cachedItems, limit, cursor)
			}
		}
	}

	span.AddEvent("cache_miss", trace.WithAttributes(attribute.String("user_id", userID)))

	return nil, "", nil
}

func (e *FeedEngine) ComputeRankedFeed(ctx context.Context, userID string, items []FeedItem) []FeedItem {
	ctx, span := e.trace.Start(ctx, "FeedEngine.ComputeRankedFeed")
	defer span.End()

	if len(items) == 0 {
		return items
	}

	now := time.Now()
	for i := range items {
		age := now.Sub(items[i].CreatedAt)
		decay := e.timeDecay(age)
		items[i].Score *= decay
	}

	sort.Slice(items, func(i, j int) bool {
		return items[i].Score > items[j].Score
	})

	diversified := e.injectDiversity(items)

	if e.redis != nil {
		redisKey := "feed:hot:" + userID
		data, _ := json.Marshal(diversified)
		_ = e.redis.Conn.Set(ctx, redisKey, data, 5*time.Minute)
	}

	if len(diversified) > 100 {
		diversified = diversified[:100]
	}

	e.hotCache.Put("feed:"+userID+":", diversified)

	return diversified
}

func (e *FeedEngine) timeDecay(age time.Duration) float64 {
	halfLife := e.timeDecayHalfLife
	if halfLife <= 0 {
		halfLife = 6 * time.Hour
	}
	return math.Exp(-math.Log(2) * float64(age) / float64(halfLife))
}

func (e *FeedEngine) injectDiversity(items []FeedItem) []FeedItem {
	if len(items) <= 1 {
		return items
	}

	exploreCount := int(float64(len(items)) * e.exploreRatio)
	if exploreCount < 1 {
		exploreCount = 1
	}

	diversified := make([]FeedItem, 0, len(items))
	seenAuthors := make(map[string]bool)
	exploreItems := []FeedItem{}

	for _, item := range items {
		if !seenAuthors[item.AuthorID] {
			seenAuthors[item.AuthorID] = true
			diversified = append(diversified, item)
		} else {
			exploreItems = append(exploreItems, item)
		}
	}

	for i := 0; i < exploreCount && i < len(exploreItems); i++ {
		diversified = append(diversified, exploreItems[i])
	}

	return diversified
}

func (e *FeedEngine) paginate(items []FeedItem, limit int, cursor string) ([]FeedItem, string, error) {
	if len(items) <= limit {
		return items, "", nil
	}

	startIdx := 0
	if cursor != "" {
		for i, item := range items {
			if item.ID == cursor {
				startIdx = i + 1
				break
			}
		}
	}

	endIdx := startIdx + limit
	if endIdx > len(items) {
		endIdx = len(items)
	}

	var nextCursor string
	if endIdx < len(items) {
		nextCursor = items[endIdx-1].ID
	}

	return items[startIdx:endIdx], nextCursor, nil
}

func (e *FeedEngine) fanoutWorker(ctx context.Context) {
	var buffer []fanoutTask
	ticker := time.NewTicker(100 * time.Millisecond)
	defer ticker.Stop()

	for {
		select {
		case task, ok := <-e.fanoutQueue:
			if !ok {
				if len(buffer) > 0 {
					e.processBatch(ctx, buffer)
				}
				return
			}
			buffer = append(buffer, task)
			if len(buffer) >= e.batchSize {
				e.processBatch(ctx, buffer)
				buffer = nil
			}
		case <-ticker.C:
			if len(buffer) > 0 {
				e.processBatch(ctx, buffer)
				buffer = nil
			}
		case <-ctx.Done():
			if len(buffer) > 0 {
				e.processBatch(ctx, buffer)
			}
			return
		}
	}
}

func (e *FeedEngine) processBatch(ctx context.Context, tasks []fanoutTask) {
	ctx, span := e.trace.Start(ctx, "FeedEngine.processBatch")
	defer span.End()

	_ = tasks
	span.SetAttributes(attribute.Int("batch.size", len(tasks)))
}

func chunkFollowers(followers []string, size int) [][]string {
	if size <= 0 {
		size = 100
	}
	var chunks [][]string
	for i := 0; i < len(followers); i += size {
		end := i + size
		if end > len(followers) {
			end = len(followers)
		}
		chunks = append(chunks, followers[i:end])
	}
	return chunks
}
