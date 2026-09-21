package nats

import (
	"fmt"

	"github.com/nats-io/nats.go"
)

type Client struct {
	Conn *nats.Conn
	JS   nats.JetStreamContext
}

func New(url string) (*Client, error) {
	nc, err := nats.Connect(url)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to nats: %w", err)
	}

	js, err := nc.JetStream()
	if err != nil {
		nc.Close()
		return nil, fmt.Errorf("failed to get jetstream context: %w", err)
	}

	return &Client{Conn: nc, JS: js}, nil
}

func (c *Client) EnsureStreams() error {
	streams := []struct {
		name     string
		subjects []string
	}{
		{Name: "SOCIAL", Subjects: []string{"SOCIAL.*"}},
		{Name: "MESSAGING", Subjects: []string{"MESSAGING.*", "chat.*"}},
		{Name: "E2EE", Subjects: []string{"e2ee.*"}},
		{Name: "FLOW", Subjects: []string{"flow.*"}},
		{Name: "AI", Subjects: []string{"AI.*"}},
	}
	for _, spec := range streams {
		_, err := c.JS.StreamInfo(spec.name)
		if err == nil {
			continue
		}
		_, err = c.JS.AddStream(&nats.StreamConfig{
			Name:     spec.name,
			Subjects: spec.subjects,
			Storage:  nats.FileStorage,
		})
		if err != nil {
			return fmt.Errorf("failed to create stream %s: %w", spec.name, err)
		}
	}
	return nil
}
