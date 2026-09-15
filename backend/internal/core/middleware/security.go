package middleware

import (
	"encoding/json"
	"net"
	"net/http"
	"sync"
	"time"

	"go.uber.org/zap"
)

var responsePool = sync.Pool{New: func() interface{} { return make(map[string]string) }}

type TokenBucket struct {
	tokens     float64
	capacity   float64
	refillRate float64
	lastRefill time.Time
	mu         sync.Mutex
}

type RateLimiter struct {
	visitors map[string]*TokenBucket
	mu       sync.Mutex
	rate     float64
	capacity float64
}

func NewRateLimiter(rate, capacity float64) *RateLimiter {
	rl := &RateLimiter{visitors: make(map[string]*TokenBucket), rate: rate, capacity: capacity}
	go rl.cleanup()
	return rl
}

func (rl *RateLimiter) cleanup() {
	for {
		time.Sleep(time.Minute)
		rl.mu.Lock()
		for ip, tb := range rl.visitors {
			tb.mu.Lock()
			if time.Since(tb.lastRefill) > 3*time.Minute {
				delete(rl.visitors, ip)
			}
			tb.mu.Unlock()
		}
		rl.mu.Unlock()
	}
}

func (rl *RateLimiter) getVisitor(ip string) *TokenBucket {
	rl.mu.Lock()
	defer rl.mu.Unlock()
	if tb, ok := rl.visitors[ip]; ok {
		return tb
	}
	tb := &TokenBucket{tokens: rl.capacity, capacity: rl.capacity, refillRate: rl.rate, lastRefill: time.Now()}
	rl.visitors[ip] = tb
	return tb
}

func (tb *TokenBucket) Allow() bool {
	tb.mu.Lock()
	defer tb.mu.Unlock()
	now := time.Now()
	tb.tokens += now.Sub(tb.lastRefill).Seconds() * tb.refillRate
	tb.lastRefill = now
	if tb.tokens > tb.capacity {
		tb.tokens = tb.capacity
	}
	if tb.tokens < 1 {
		return false
	}
	tb.tokens--
	return true
}

func RateLimitMiddleware(limiter *RateLimiter) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			host, _, err := net.SplitHostPort(r.RemoteAddr)
			if err != nil || host == "" {
				host = r.RemoteAddr
			}
			if !limiter.getVisitor(host).Allow() {
				errResp := responsePool.Get().(map[string]string)
				errResp["error"] = "Rate limit exceeded"
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(http.StatusTooManyRequests)
				_ = json.NewEncoder(w).Encode(errResp)
				delete(errResp, "error")
				responsePool.Put(errResp)
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

func SecurityHeadersMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("X-Frame-Options", "DENY")
		w.Header().Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains; preload")
		w.Header().Set("Content-Security-Policy", "default-src 'self'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'")
		w.Header().Set("Referrer-Policy", "no-referrer")
		w.Header().Set("Permissions-Policy", "camera=(), microphone=(), geolocation=(), payment=(), usb=()")
		next.ServeHTTP(w, r)
	})
}

func ZapAuditLogger(logger *zap.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			ww := &responseWriterWrapper{ResponseWriter: w, statusCode: http.StatusOK}
			defer func() {
				logger.Info("Request", zap.String("method", r.Method), zap.String("path", r.URL.Path), zap.Int("status", ww.statusCode), zap.Duration("duration", time.Since(start)))
			}()
			next.ServeHTTP(ww, r)
		})
	}
}

type responseWriterWrapper struct {
	http.ResponseWriter
	statusCode int
}

func (w *responseWriterWrapper) WriteHeader(code int) {
	w.statusCode = code
	w.ResponseWriter.WriteHeader(code)
}
