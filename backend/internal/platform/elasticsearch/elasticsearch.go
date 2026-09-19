package elasticsearch

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/elastic/go-elasticsearch/v8"
	"github.com/elastic/go-elasticsearch/v8/esapi"
)

type Client struct {
	es *elasticsearch.Client
}

type SearchHit struct {
	Index  string          `json:"_index"`
	ID     string          `json:"_id"`
	Score  float64         `json:"_score"`
	Source json.RawMessage `json:"_source"`
}

type SearchResponse struct {
	Hits struct {
		Total struct {
			Value int64 `json:"value"`
		} `json:"total"`
		Hits []*SearchHit `json:"hits"`
	} `json:"hits"`
	Suggest map[string]json.RawMessage `json:"suggest"`
}

type Suggestion struct {
	Text    string `json:"text"`
	Offset  int    `json:"offset"`
	Length  int    `json:"length"`
	Options []struct {
		Text   string  `json:"text"`
		Score  float64 `json:"_score"`
		Source struct {
			ID    string `json:"id"`
			Title string `json:"title"`
			Type  string `json:"type"`
		} `json:"_source"`
	} `json:"options"`
}

func NewClient(addresses []string, username, password string) (*Client, error) {
	cfg := elasticsearch.Config{
		Addresses: addresses,
		Username:  username,
		Password:  password,
		Transport: &http.Transport{
			MaxIdleConnsPerHost: 100,
			IdleConnTimeout:     60 * time.Second,
		},
	}

	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		return nil, fmt.Errorf("failed to create elasticsearch client: %w", err)
	}

	res, err := es.Info()
	if err != nil {
		return nil, fmt.Errorf("failed to connect to elasticsearch: %w", err)
	}
	defer res.Body.Close()

	if res.IsError() {
		body, _ := io.ReadAll(res.Body)
		return nil, fmt.Errorf("elasticsearch connection error: %s", string(body))
	}

	return &Client{es: es}, nil
}

func (c *Client) Index(ctx context.Context, index, id string, document interface{}) error {
	body, err := json.Marshal(document)
	if err != nil {
		return err
	}

	req := esapi.IndexRequest{
		Index:      index,
		DocumentID: id,
		Body:       bytes.NewReader(body),
		Refresh:    "false",
	}

	res, err := req.Do(ctx, c.es)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.IsError() {
		return fmt.Errorf("index error: %s", res.Status())
	}

	return nil
}

func (c *Client) Delete(ctx context.Context, index, id string) error {
	req := esapi.DeleteRequest{
		Index:      index,
		DocumentID: id,
	}

	res, err := req.Do(ctx, c.es)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.StatusCode == http.StatusNotFound {
		return nil
	}

	if res.IsError() {
		return fmt.Errorf("delete error: %s", res.Status())
	}

	return nil
}

func (c *Client) Search(ctx context.Context, index string, query map[string]interface{}) (*SearchResponse, error) {
	body, err := json.Marshal(query)
	if err != nil {
		return nil, err
	}

	res, err := c.es.Search(
		c.es.Search.WithContext(ctx),
		c.es.Search.WithIndex(index),
		c.es.Search.WithBody(bytes.NewReader(body)),
	)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	if res.IsError() {
		body, _ := io.ReadAll(res.Body)
		return nil, fmt.Errorf("search error: %s", string(body))
	}

	var searchResp SearchResponse
	if err := json.NewDecoder(res.Body).Decode(&searchResp); err != nil {
		return nil, err
	}

	return &searchResp, nil
}

func (c *Client) Suggest(ctx context.Context, index, field, text string, size int) ([]string, error) {
	query := map[string]interface{}{
		"suggest": map[string]interface{}{
			"suggestions": map[string]interface{}{
				"prefix": text,
				"completion": map[string]interface{}{
					"field":           field + "_suggest",
					"size":            size,
					"skip_duplicates": true,
					"fuzzy": map[string]interface{}{
						"fuzziness": "AUTO",
					},
				},
			},
		},
	}

	res, err := c.Search(ctx, index, query)
	if err != nil {
		return nil, err
	}

	suggestions := []string{}
	for _, sugg := range res.Suggest {
		raw, _ := json.Marshal(sugg)
		var s []Suggestion
		if err := json.Unmarshal(raw, &s); err != nil {
			continue
		}
		for _, sug := range s {
			for _, opt := range sug.Options {
				suggestions = append(suggestions, opt.Text)
			}
		}
	}

	return suggestions, nil
}

func (c *Client) FuzzySearch(ctx context.Context, index string, query map[string]interface{}) (*SearchResponse, error) {
	fuzzyQuery := map[string]interface{}{
		"query": map[string]interface{}{
			"multi_match": map[string]interface{}{
				"query":         query["q"].(string),
				"fields":        []string{"title^3", "content^2", "subtitle^1"},
				"fuzziness":     "AUTO",
				"prefix_length": 2,
			},
		},
		"highlight": map[string]interface{}{
			"fields": map[string]interface{}{
				"title":   map[string]interface{}{},
				"content": map[string]interface{}{},
			},
			"pre_tags":  []string{"<mark>"},
			"post_tags": []string{"</mark>"},
		},
	}

	return c.Search(ctx, index, fuzzyQuery)
}

func (c *Client) CreateIndex(ctx context.Context, index string) error {
	res, err := c.es.Indices.Create(index)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.IsError() && !strings.Contains(res.String(), "resource_already_exists_exception") {
		return fmt.Errorf("create index error: %s", res.Status())
	}

	return nil
}

func (c *Client) BulkIndex(ctx context.Context, index string, documents []interface{}, ids []string) error {
	if len(documents) == 0 {
		return nil
	}

	var body strings.Builder
	for i, doc := range documents {
		meta := map[string]interface{}{
			"index": map[string]interface{}{
				"_index": index,
			},
		}
		if i < len(ids) {
			meta["index"].(map[string]interface{})["_id"] = ids[i]
		}
		metaBytes, _ := json.Marshal(meta)
		body.Write(metaBytes)
		body.WriteString("\n")

		docBytes, _ := json.Marshal(doc)
		body.Write(docBytes)
		body.WriteString("\n")
	}

	res, err := c.es.Bulk(
		strings.NewReader(body.String()),
		c.es.Bulk.WithRefresh("false"),
	)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.IsError() {
		respBody, _ := io.ReadAll(res.Body)
		return fmt.Errorf("bulk index error: %s: %s", res.Status(), string(respBody))
	}

	return nil
}
