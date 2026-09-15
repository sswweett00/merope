package observability

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	HttpRequestsTotal = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "merope_http_requests_total",
		Help: "Total number of HTTP requests",
	}, []string{"method", "path", "status"})

	HttpRequestDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "merope_http_request_duration_seconds",
		Help:    "Duration of HTTP requests in seconds",
		Buckets: prometheus.DefBuckets,
	}, []string{"method", "path"})

	DbQueryDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "merope_db_query_duration_seconds",
		Help:    "Duration of database queries in seconds",
		Buckets: prometheus.DefBuckets,
	}, []string{"query_name"})
)
