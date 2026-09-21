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
		{name: "SOCIAL", subjects: []string{"SOCIAL.*"}},
		{name: "MESSAGING", subjects: []string{"MESSAGING.*", "chat.*"}},
		{name: "E2EE", subjects: []string{"e2ee.*"}},
		{name: "FLOW", subjects: []string{"flow.*"}},
		{name: "AI", subjects: []string{"AI.*"}},
	}
	for _, spec := range streams {
		config := &nats.StreamConfig{
			Name:     spec.name,
			Subjects: spec.subjects,
			Storage:  nats.FileStorage,
		}
		info, err := c.JS.StreamInfo(spec.name)
		if err != nil {
			if _, err = c.JS.AddStream(config); err != nil {
				return fmt.Errorf("failed to create stream %s: %w", spec.name, err)
			}
			continue
		}
		if !sameSubjects(info.Config.Subjects, config.Subjects) {
			updated := info.Config
			updated.Subjects = append([]string(nil), config.Subjects...)
			if _, err = c.JS.UpdateStream(&updated); err != nil {
				return fmt.Errorf("failed to update stream %s: %w", spec.name, err)
			}
		}
	}
	return nil
}

func sameSubjects(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	set := make(map[string]struct{}, len(a))
	for _, subject := range a {
		set[subject] = struct{}{}
	}
	for _, subject := range b {
		if _, ok := set[subject]; !ok {
			return false
		}
	}
	return true
}
