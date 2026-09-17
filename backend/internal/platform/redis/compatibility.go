package redis

import "context"

func (c *Client) Info(ctx context.Context) (string, error) {
	if c == nil || c.Conn == nil { return "", nil }
	return c.Conn.Info(ctx).Result()
}
