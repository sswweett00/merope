package events

import (
	"context"
)

type Event struct {
	Type    string `json:"type"`
	Payload any    `json:"payload"`
}

type Publisher interface {
	Publish(ctx context.Context, subject string, event Event) error
}
