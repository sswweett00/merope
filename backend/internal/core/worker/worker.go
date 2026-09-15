package worker

import (
	"context"
	"log/slog"
	"local/merope/internal/database/db"
	"local/merope/internal/core/util"
	"sync"
	"time"
)

type Task func(ctx context.Context) error

type Engine struct {
	queries    *db.Queries
	taskQueue  chan Task
	maxWorkers int
	wg         sync.WaitGroup
}

func New(queries *db.Queries, maxWorkers int) *Engine {
	if maxWorkers <= 0 {
		maxWorkers = 100 // Default to 100 workers
	}
	return &Engine{
		queries:    queries,
		taskQueue:  make(chan Task, 10000), // Buffer for 10k tasks
		maxWorkers: maxWorkers,
	}
}

func (e *Engine) Start(ctx context.Context) {
	slog.Info("Starting worker engine", "workers", e.maxWorkers)

	// Start worker pool
	for i := 0; i < e.maxWorkers; i++ {
		e.wg.Add(1)
		go e.worker(ctx)
	}

	// Start scheduled task dispatcher
	go e.dispatcher(ctx)
}

func (e *Engine) Stop() {
	close(e.taskQueue)
	e.wg.Wait()
}

func (e *Engine) Submit(task Task) bool {
	select {
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
		case task, ok := <-e.taskQueue:
			if !ok {
				return
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
		// Trigger notifications or other downstream logic here
	}
	return nil
}
