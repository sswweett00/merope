//go:build discovery

package service

import (
	"context"
	"io"
	"log/slog"
	"time"

	"local/merope/internal/platform/elasticsearch"
	"local/merope/internal/platform/scylla"
	"local/merope/proto/discovery"
)

type DiscoveryHandler struct {
	discovery.UnimplementedDiscoveryServiceServer
	es     *elasticsearch.Client
	scylla *scylla.Client
}

func NewDiscoveryHandler(es *elasticsearch.Client, scylla *scylla.Client) *DiscoveryHandler {
	return &DiscoveryHandler{
		es:     es,
		scylla: scylla,
	}
}

func (h *DiscoveryHandler) StreamRecommendations(stream discovery.DiscoveryService_StreamRecommendationsServer) error {
	for {
		req, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}

		ctx, cancel := context.WithTimeout(stream.Context(), 5*time.Second)

		query := map[string]interface{}{
			"size": req.Limit * 3,
			"query": map[string]interface{}{
				"script_score": map[string]interface{}{
					"query": map[string]interface{}{"match_all": map[string]interface{}{}},
					"script": map[string]interface{}{
						"source": "cosineSimilarity(params.query_vector, 'vector_field') + 1.0",
						"params": map[string]interface{}{
							"query_vector": req.ProfileVector,
						},
					},
				},
			},
		}

		res, err := h.es.Search(ctx, "content_vectors", query)
		if err != nil {
			cancel()
			slog.Error("Failed to search discovery vectors", "error", err)
			continue
		}

		enrichedItems := h.processAndRank(ctx, res.Hits.Hits, req.Limit)
		cancel()

		resp := &discovery.RecommendationResponse{
			Items: enrichedItems,
		}

		if err := stream.Send(resp); err != nil {
			return err
		}
	}
}

func (h *DiscoveryHandler) processAndRank(ctx context.Context, hits []*elasticsearch.SearchHit, limit int32) []*discovery.RecommendedItem {
	if len(hits) == 0 {
		return nil
	}

	ids := make([]string, len(hits))
	for i, hit := range hits {
		ids[i] = hit.ID
	}
	_ = ids

	lambda := 0.7
	selected := make([]*discovery.RecommendedItem, 0, limit)

	for _, hit := range hits {
		if int32(len(selected)) >= limit {
			break
		}

		isDiverse := true
		for _, s := range selected {
			if s.ItemId == hit.ID {
				isDiverse = false
				break
			}
		}

		if isDiverse {
			selected = append(selected, &discovery.RecommendedItem{
				ItemId: hit.ID,
				Score:  hit.Score * lambda,
			})
		}
	}

	return selected
}
