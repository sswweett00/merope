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
	streams := []string{"SOCIAL", "MESSAGING", "AI"}
	for _, s := range streams {
		_, err := c.JS.StreamInfo(s)
		if err != nil {
			_, err = c.JS.AddStream(&nats.StreamConfig{
				Name:     s,
				Subjects: []string{fmt.Sprintf("%s.*", s)},
				Storage:  nats.FileStorage,
			})
			if err != nil {
				return fmt.Errorf("failed to create stream %s: %w", s, err)
			}
		}
	}
	return nil
}
