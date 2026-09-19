package infra

import (
	"context"

	"local/merope/internal/modules/search/domain"
)

type ElasticsearchRepository struct {
	client interface {
		Index(ctx context.Context, index, id string, document interface{}) error
		Search(ctx context.Context, index string, query map[string]interface{}) ([]*domain.SearchResult, error)
		Suggest(ctx context.Context, index, field, text string, size int) ([]string, error)
		BulkIndex(ctx context.Context, index string, documents []interface{}, ids []string) error
		Delete(ctx context.Context, index, id string) error
	}
}

func NewElasticsearchRepository(client interface {
	Index(ctx context.Context, index, id string, document interface{}) error
	Search(ctx context.Context, index string, query map[string]interface{}) ([]*domain.SearchResult, error)
	Suggest(ctx context.Context, index, field, text string, size int) ([]string, error)
	BulkIndex(ctx context.Context, index string, documents []interface{}, ids []string) error
	Delete(ctx context.Context, index, id string) error
}) *ElasticsearchRepository {
	return &ElasticsearchRepository{client: client}
}

func (r *ElasticsearchRepository) FullTextSearch(ctx context.Context, query string, limit int) ([]*domain.SearchResult, error) {
	fuzzyQuery := map[string]interface{}{
		"query": map[string]interface{}{
			"multi_match": map[string]interface{}{
				"query":         query,
				"fields":        []string{"title^3", "content^2", "subtitle^1"},
				"fuzziness":     "AUTO",
				"prefix_length": 2,
			},
		},
		"size": limit,
	}
	return r.client.Search(ctx, "merope_search", fuzzyQuery)
}

func (r *ElasticsearchRepository) Autocomplete(ctx context.Context, query string, limit int) ([]*domain.SearchResult, error) {
	boolPrefixQuery := map[string]interface{}{
		"query": map[string]interface{}{
			"multi_match": map[string]interface{}{
				"query":  query,
				"fields": []string{"title^5", "subtitle^3", "content^1"},
				"type":   "bool_prefix",
			},
		},
		"size": limit,
	}
	return r.client.Search(ctx, "merope_search", boolPrefixQuery)
}

func (r *ElasticsearchRepository) IndexPost(ctx context.Context, id, content string) error {
	doc := map[string]interface{}{
		"title":   "",
		"content": content,
		"type":    "post",
	}
	return r.client.Index(ctx, "merope_posts", id, doc)
}

func (r *ElasticsearchRepository) IndexUser(ctx context.Context, id, username, displayName string) error {
	doc := map[string]interface{}{
		"title":            username,
		"subtitle":         displayName,
		"type":             "user",
		"title_suggest":    username,
		"subtitle_suggest": displayName,
	}
	return r.client.Index(ctx, "merope_users", id, doc)
}

func (r *ElasticsearchRepository) DeleteIndex(ctx context.Context, id, indexType string) error {
	index := "merope_posts"
	if indexType == "user" {
		index = "merope_users"
	}
	return r.client.Delete(ctx, index, id)
}
