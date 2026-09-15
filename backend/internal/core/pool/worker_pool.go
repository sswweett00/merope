package pool

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	poolQueueDepth = promauto.NewGauge(prometheus.GaugeOpts{
		Name: "merope_pool_queue_depth",
		Help: "Current number of jobs waiting in the pool queue",
	})
	poolWorkerCount = promauto.NewGauge(prometheus.GaugeOpts{
		Name: "merope_pool_worker_count",
		Help: "Current number of active workers in the pool",
	})
)

type Job func(ctx context.Context)

type WorkerPool struct {
	minConcurrency int
	maxConcurrency int
	jobQueue       chan Job
	wg             sync.WaitGroup
	quit           chan struct{}
	mu             sync.Mutex
	activeWorkers  int
}

func NewWorkerPool(min, max int) *WorkerPool {
	p := &WorkerPool{
		minConcurrency: min,
		maxConcurrency: max,
		jobQueue:       make(chan Job, max*100),
		quit:           make(chan struct{}),
	}
	p.startInitialWorkers()
	go p.adaptiveScaler()
	return p
}

func (p *WorkerPool) startInitialWorkers() {
	for i := 0; i < p.minConcurrency; i++ {
		p.spawnWorker()
	}
}

func (p *WorkerPool) spawnWorker() {
	p.mu.Lock()
	if p.activeWorkers >= p.maxConcurrency {
		p.mu.Unlock()
		return
	}
	p.activeWorkers++
	poolWorkerCount.Set(float64(p.activeWorkers))
	p.mu.Unlock()

	p.wg.Add(1)
	go func() {
		defer p.wg.Done()
		defer func() {
			p.mu.Lock()
			p.activeWorkers--
			poolWorkerCount.Set(float64(p.activeWorkers))
			p.mu.Unlock()
		}()

		for {
			select {
			case job := <-p.jobQueue:
				p.safeExecute(job)
				poolQueueDepth.Set(float64(len(p.jobQueue)))
			case <-p.quit:
				return
			}
		}
	}()
}

func (p *WorkerPool) adaptiveScaler() {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			p.mu.Lock()
			qLen := len(p.jobQueue)
			// If queue is building up, spawn more workers
			if qLen > p.activeWorkers && p.activeWorkers < p.maxConcurrency {
				p.spawnWorker()
			}
			p.mu.Unlock()
		case <-p.quit:
			return
		}
	}
}

func (p *WorkerPool) Submit(job Job) {
	select {
	case p.jobQueue <- job:
		poolQueueDepth.Set(float64(len(p.jobQueue)))
	case <-p.quit:
		return
	default:
		// Capacity reached, either scale immediately or execute inline
		p.spawnWorker()
		go p.safeExecute(job)
	}
}

func (p *WorkerPool) safeExecute(job Job) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("Apex Worker Panic Recovered: %v\n", r)
		}
	}()
	job(context.Background())
}

func (p *WorkerPool) Shutdown() {
	close(p.quit)
	p.wg.Wait()
}
