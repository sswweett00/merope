package redis

import (
	"github.com/redis/go-redis/v9"
)

type Client struct {
	Conn *redis.Client
}

func New(addr, password string) *Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: password,
		DB:       0,
	})
	return &Client{Conn: rdb}
}

func (c *Client) Close() error {
	return c.Conn.Close()
}
