package nats

import (
	"context"
	"encoding/json"
	"fmt"

	"local/merope/internal/core/events"
)

func (c *Client) Publish(ctx context.Context, subject string, event events.Event) error {
	data, err := json.Marshal(event)
	if err != nil {
		return fmt.Errorf("failed to marshal event: %w", err)
	}

	_, err = c.JS.Publish(subject, data)
	return err
}
