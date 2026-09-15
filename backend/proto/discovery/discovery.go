// Package discovery contains the Go contract for the discovery recommendation stream.
//
// The source of truth is ../discovery.proto. A checked-in generated protobuf toolchain
// can replace this file later without changing the service-layer contract.
package discovery

import "context"

type RecommendationRequest struct {
	UserID       string
	ProfileVector []float32
	Limit        int32
}

type RecommendedItem struct {
	ItemID      string
	Score       float64
	ContentType string
	Title       string
	MediaURL    string
}

type RecommendationResponse struct {
	Items []*RecommendedItem
}

type DiscoveryService_StreamRecommendationsServer interface {
	Context() context.Context
	Recv() (*RecommendationRequest, error)
	Send(*RecommendationResponse) error
}

type UnimplementedDiscoveryServiceServer struct{}
