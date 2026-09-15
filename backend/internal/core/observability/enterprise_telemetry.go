package observability

import (
	"context"
	"runtime"
	"sync"
	"time"
)

type SystemTelemetry struct {
	Goroutines    int       `json:"goroutines"`
	HeapAllocMB   uint64    `json:"heap_alloc_mb"`
	SystemMemoryMB uint64   `json:"system_memory_mb"`
	UptimeSeconds int64     `json:"uptime_seconds"`
	CircuitStatus string    `json:"circuit_status"`
	Timestamp     time.Time `json:"timestamp"`
}

type EnterpriseTelemetryCollector interface {
	CollectMetrics(ctx context.Context) SystemTelemetry
}

type enterpriseTelemetryCollector struct {
	startTime time.Time
	mu        sync.RWMutex
}

func NewEnterpriseTelemetryCollector() EnterpriseTelemetryCollector {
	return &enterpriseTelemetryCollector{
		startTime: time.Now(),
	}
}

func (c *enterpriseTelemetryCollector) CollectMetrics(ctx context.Context) SystemTelemetry {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)

	return SystemTelemetry{
		Goroutines:     runtime.NumGoroutine(),
		HeapAllocMB:    m.HeapAlloc / 1024 / 1024,
		SystemMemoryMB: m.Sys / 1024 / 1024,
		UptimeSeconds:  int64(time.Since(c.startTime).Seconds()),
		CircuitStatus:  "CLOSED", // Normal operational state
		Timestamp:      time.Now(),
	}
}
