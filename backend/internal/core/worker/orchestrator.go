package worker

import (
	"context"
	"log/slog"
	"sync"
	"local/merope/internal/database/db"
)

type Priority int

const (
	PriorityRealTime Priority = iota
	PriorityBackground
)

type OrchestratedTask struct {
	Priority Priority
	Execute  Task
}

/// Orchestrator manages multiple worker pools with different priorities (SLAs).
type Orchestrator struct {
	realTimePool   *Engine
	backgroundPool *Engine
	mu             sync.RWMutex
}

func NewOrchestrator(queries *db.Queries, realTimeWorkers, backgroundWorkers int) *Orchestrator {
	return &Orchestrator{
		realTimePool:   New(queries, realTimeWorkers),
		backgroundPool: New(queries, backgroundWorkers),
	}
}

func (o *Orchestrator) Start(ctx context.Context) {
	slog.Info("Starting Orchestrator with prioritized pools")
	o.realTimePool.Start(ctx)
	o.backgroundPool.Start(ctx)
}

func (o *Orchestrator) Stop() {
	o.realTimePool.Stop()
	o.backgroundPool.Stop()
}

func (o *Orchestrator) Submit(task OrchestratedTask) bool {
	switch task.Priority {
	case PriorityRealTime:
		return o.realTimePool.Submit(task.Execute)
	case PriorityBackground:
		return o.backgroundPool.Submit(task.Execute)
	default:
		return o.backgroundPool.Submit(task.Execute)
	}
}

/// SubmitBackground is a convenience method for non-critical tasks like mirroring or analytics
func (o *Orchestrator) SubmitBackground(task Task) bool {
	return o.Submit(OrchestratedTask{Priority: PriorityBackground, Execute: task})
}

/// SubmitRealTime is a convenience method for critical path tasks
func (o *Orchestrator) SubmitRealTime(task Task) bool {
	return o.Submit(OrchestratedTask{Priority: PriorityRealTime, Execute: task})
}
