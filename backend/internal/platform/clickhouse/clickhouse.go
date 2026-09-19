package clickhouse

import (
	"context"
	"fmt"
	"os"

	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
)

type Client struct {
	Conn driver.Conn
}

func New(ctx context.Context, addr, database string) (*Client, error) {
	username := os.Getenv("CLICKHOUSE_USER")
	if username == "" {
		username = "default"
	}
	password := os.Getenv("CLICKHOUSE_PASSWORD")

	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{addr},
		Auth: clickhouse.Auth{
			Database: database,
			Username: username,
			Password: password,
		},
		Settings: clickhouse.Settings{
			"async_insert":          1,
			"wait_for_async_insert": 0,
		},
		Compression: &clickhouse.Compression{
			Method: clickhouse.CompressionLZ4,
		},
	})
	if err != nil {
		return nil, fmt.Errorf("failed to open clickhouse: %w", err)
	}

	if err := conn.Ping(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping clickhouse: %w", err)
	}

	return &Client{Conn: conn}, nil
}

func (c *Client) Close() {
	_ = c.Conn.Close()
}
