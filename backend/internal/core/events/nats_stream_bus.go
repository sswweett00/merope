package events

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/nats-io/nats.go"
	"github.com/nats-io/nats.go/jetstream"
)

type NatsStreamBus struct {
	nc *nats.Conn
	js jetstream.JetStream
}

func NewNatsStreamBus(url string) (*NatsStreamBus, error) {
	nc, err := nats.Connect(url, nats.Name("Merope Singularity Bus"), nats.Timeout(10*time.Second))
	if err != nil {
		return nil, fmt.Errorf("nats connect fail: %w", err)
	}

	js, err := jetstream.New(nc)
	if err != nil {
		return nil, fmt.Errorf("jetstream init fail: %w", err)
	}

	return &NatsStreamBus{nc: nc, js: js}, nil
}

func (b *NatsStreamBus) Publish(ctx context.Context, subject string, event Event) error {
	data, err := json.Marshal(event)
	if err != nil {
		return fmt.Errorf("marshal event fail: %w", err)
	}

	// Zenith: Use PublishAsync for high throughput if needed
	_, err = b.js.Publish(ctx, subject, data)
	if err != nil {
		return fmt.Errorf("js publish fail: %w", err)
	}

	return nil
}

func (b *NatsStreamBus) CreateStream(ctx context.Context, name string, subjects []string) error {
	_, err := b.js.CreateStream(ctx, jetstream.StreamConfig{
		Name:     name,
		Subjects: subjects,
		Storage:  jetstream.FileStorage,
		Retention: jetstream.LimitsPolicy,
	})
	return err
}

func (b *NatsStreamBus) Close() {
	if b.nc != nil {
		b.nc.Close()
	}
}
