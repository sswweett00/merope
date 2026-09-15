package scylla

import (
	"context"
	"fmt"
	"time"

	"github.com/gocql/gocql"
)

type Client struct {
	Session *gocql.Session
	Config  Config
}

type Config struct {
	Hosts       []string
	Keyspace    string
	Username    string
	Password    string
	Consistency string
	Timeout     time.Duration
}

func New(cfg Config) (*Client, error) {
	if cfg.Timeout == 0 {
		cfg.Timeout = 10 * time.Second
	}
	if cfg.Consistency == "" {
		cfg.Consistency = gocql.LocalQuorum.String()
	}

	cluster := gocql.NewCluster(cfg.Hosts...)
	cluster.Keyspace = cfg.Keyspace
	cluster.Consistency = gocql.ParseConsistency(cfg.Consistency)
	cluster.ConnectTimeout = cfg.Timeout
	cluster.RetryPolicy = &noRetry{}
	cluster.NumConns = 10 // Replaces old PoolConfig settings

	if cfg.Username != "" {
		cluster.Authenticator = gocql.PasswordAuthenticator{
			Username: cfg.Username,
			Password: cfg.Password,
		}
	}

	session, err := cluster.CreateSession()
	if err != nil {
		return nil, fmt.Errorf("failed to connect to ScyllaDB: %w", err)
	}

	return &Client{
		Session: session,
		Config:  cfg,
	}, nil
}

func (c *Client) Close() {
	if c.Session != nil {
		c.Session.Close()
	}
}

func (c *Client) Query(stmt string, values ...interface{}) *gocql.Query {
	return c.Session.Query(stmt, values...)
}

func (c *Client) Exec(ctx context.Context, stmt string, values ...interface{}) error {
	return c.Session.Query(stmt, values...).WithContext(ctx).Exec()
}

func (c *Client) QueryRow(ctx context.Context, stmt string, values ...interface{}) *gocql.Query {
	return c.Session.Query(stmt, values...).WithContext(ctx)
}

func (c *Client) QueryIter(ctx context.Context, stmt string, values ...interface{}) *gocql.Iter {
	return c.Session.Query(stmt, values...).WithContext(ctx).Iter()
}
