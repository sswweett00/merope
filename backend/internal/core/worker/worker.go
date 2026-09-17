package worker

import (
	"context"
	"log/slog"
	"sync"
	"time"

	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
)

type Task func(ctx context.Context) error

type Engine struct {
	queries    *db.Queries
	taskQueue  chan Task
	maxWorkers int
	stopCh     chan struct{}
	stopOnce   sync.Once
	wg         sync.WaitGroup
}

func New(queries *db.Queries, maxWorkers int) *Engine {
	if maxWorkers <= 0 {
		maxWorkers = 100
	}
	return &Engine{
		queries:    queries,
		taskQueue:  make(chan Task, 10000),
		maxWorkers: maxWorkers,
		stopCh:     make(chan struct{}),
	}
}

func (e *Engine) Start(ctx context.Context) {
	slog.Info("Starting worker engine", "workers", e.maxWorkers)

	for i := 0; i < e.maxWorkers; i++ {
		e.wg.Add(1)
		go e.worker(ctx)
	}

	go e.dispatcher(ctx)
}

func (e *Engine) Stop() {
	e.stopOnce.Do(func() {
		close(e.stopCh)
	})
	e.wg.Wait()
}

func (e *Engine) Submit(task Task) bool {
	if task == nil {
		return false
	}

	select {
	case <-e.stopCh:
		return false
	default:
	}

	select {
	case <-e.stopCh:
		return false
	case e.taskQueue <- task:
		return true
	default:
		slog.Warn("Worker queue full, task rejected")
		return false
	}
}

func (e *Engine) worker(ctx context.Context) {
	defer e.wg.Done()
	for {
		select {
		case <-ctx.Done():
			return
		case <-e.stopCh:
			return
		case task := <-e.taskQueue:
			if task == nil {
				continue
			}
			if err := task(ctx); err != nil {
				slog.Error("Task execution failed", "error", err)
			}
		}
	}
}

func (e *Engine) dispatcher(ctx context.Context) {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return
		case <-e.stopCh:
			return
		case <-ticker.C:
			e.Submit(e.publishScheduledPosts)
		}
	}
}

func (e *Engine) publishScheduledPosts(ctx context.Context) error {
	posts, err := e.queries.GetPendingPosts(ctx)
	if err != nil {
		return err
	}

	for _, p := range posts {
		slog.Info("Publishing scheduled post", "id", util.UUIDToString(p.ID))
	}
	return nil
}
