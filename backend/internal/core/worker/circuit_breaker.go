package worker

import (
	"errors"
	"sync"
	"time"
)

var ErrCircuitOpen = errors.New("circuit breaker is open")

type CircuitBreaker struct {
	mu           sync.RWMutex
	failureCount int
	threshold    int
	timeout      time.Duration
	lastFailure  time.Time
	isOpen       bool
}

func NewCircuitBreaker(threshold int, timeout time.Duration) *CircuitBreaker {
	return &CircuitBreaker{
		threshold: threshold,
		timeout:   timeout,
	}
}

func (cb *CircuitBreaker) Execute(fn func() error) error {
	cb.mu.RLock()
	if cb.isOpen {
		if time.Since(cb.lastFailure) > cb.timeout {
			cb.mu.RUnlock()
			return cb.attemptReset(fn)
		}
		cb.mu.RUnlock()
		return ErrCircuitOpen
	}
	cb.mu.RUnlock()

	err := fn()
	if err != nil {
		cb.recordFailure()
		return err
	}

	cb.reset()
	return nil
}

func (cb *CircuitBreaker) attemptReset(fn func() error) error {
	cb.mu.Lock()
	defer cb.mu.Unlock()
	// Half-open state
	err := fn()
	if err != nil {
		cb.lastFailure = time.Now()
		return err
	}
	cb.isOpen = false
	cb.failureCount = 0
	return nil
}

func (cb *CircuitBreaker) recordFailure() {
	cb.mu.Lock()
	defer cb.mu.Unlock()
	cb.failureCount++
	cb.lastFailure = time.Now()
	if cb.failureCount >= cb.threshold {
		cb.isOpen = true
	}
}

func (cb *CircuitBreaker) reset() {
	cb.mu.Lock()
	defer cb.mu.Unlock()
	cb.failureCount = 0
	cb.isOpen = false
}
