package realtime

import (
	"context"
	"encoding/json"
	"log/slog"
	"sync"
	"time"

	"github.com/gofiber/contrib/websocket"

	"local/merope/internal/core/events"
)

const (
	ShardCount        = 32
	maxWSMessageSize  = 64 * 1024
	maxWSTypeLength   = 64
	maxWSTargetLength = 128
	wsReadTimeout     = 2 * time.Minute
	wsWriteTimeout    = 10 * time.Second
	wsPingInterval    = 45 * time.Second
	wsPublishTimeout  = 5 * time.Second
)

type Client struct {
	UserID  string
	Conn    *websocket.Conn
	writeMu sync.Mutex
}

type shard struct {
	clients map[string][]*Client
	mu      sync.RWMutex
}

type Hub struct {
	shards     [ShardCount]*shard
	register   chan *Client
	unregister chan *Client
	pub        events.Publisher
}

type WSMessage struct {
	Type      string          `json:"type"`
	To        string          `json:"to"`
	From      string          `json:"from"`
	Payload   json.RawMessage `json:"payload"`
	Timestamp time.Time       `json:"timestamp"`
}

func NewHub(pub events.Publisher) *Hub {
	h := &Hub{
		register:   make(chan *Client, 1024),
		unregister: make(chan *Client, 1024),
		pub:        pub,
	}
	for i := 0; i < ShardCount; i++ {
		h.shards[i] = &shard{clients: make(map[string][]*Client)}
	}
	return h
}

func (h *Hub) getShard(userID string) *shard {
	hash := uint32(2166136261)
	for i := 0; i < len(userID); i++ {
		hash ^= uint32(userID[i])
		hash *= 16777619
	}
	return h.shards[hash%ShardCount]
}

func (h *Hub) Run(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		case client := <-h.register:
			if client == nil || client.Conn == nil || client.UserID == "" {
				continue
			}
			s := h.getShard(client.UserID)
			s.mu.Lock()
			s.clients[client.UserID] = append(s.clients[client.UserID], client)
			s.mu.Unlock()
			slog.Debug("WebSocket client registered")
			go h.handleIncoming(client)

		case client := <-h.unregister:
			if client == nil {
				continue
			}
			s := h.getShard(client.UserID)
			s.mu.Lock()
			if clients, ok := s.clients[client.UserID]; ok {
				for i, c := range clients {
					if c == client {
						s.clients[client.UserID] = append(clients[:i], clients[i+1:]...)
						break
					}
				}
				if len(s.clients[client.UserID]) == 0 {
					delete(s.clients, client.UserID)
				}
			}
			s.mu.Unlock()
			slog.Debug("WebSocket client unregistered")
		}
	}
}

func (h *Hub) Serve(client *Client) {
	if h == nil || client == nil || client.Conn == nil || client.UserID == "" {
		return
	}
	s := h.getShard(client.UserID)
	s.mu.Lock()
	s.clients[client.UserID] = append(s.clients[client.UserID], client)
	s.mu.Unlock()
	h.handleIncoming(client)
}

func (h *Hub) handleIncoming(client *Client) {
	defer func() {
		select {
		case h.unregister <- client:
		default:
			_ = client.Conn.Close()
		}
	}()

	client.Conn.SetReadLimit(maxWSMessageSize)
	_ = client.Conn.SetReadDeadline(time.Now().Add(wsReadTimeout))
	client.Conn.SetPongHandler(func(string) error {
		return client.Conn.SetReadDeadline(time.Now().Add(wsReadTimeout))
	})

	done := make(chan struct{})
	defer close(done)
	go h.pingLoop(client, done)

	for {
		_, msg, err := client.Conn.ReadMessage()
		if err != nil {
			break
		}
		_ = client.Conn.SetReadDeadline(time.Now().Add(wsReadTimeout))

		var wsMsg WSMessage
		if err := json.Unmarshal(msg, &wsMsg); err != nil || wsMsg.Type == "" || len(wsMsg.Type) > maxWSTypeLength || len(wsMsg.To) > maxWSTargetLength {
			continue
		}
		if len(wsMsg.Payload) > maxWSMessageSize {
			continue
		}
		wsMsg.From = client.UserID
		if wsMsg.Timestamp.IsZero() {
			wsMsg.Timestamp = time.Now().UTC()
		}

		if wsMsg.To != "" && h.pub != nil {
			ctx, cancel := context.WithTimeout(context.Background(), wsPublishTimeout)
			err := h.pub.Publish(ctx, "ws.route."+wsMsg.To, events.Event{
				Type:    "WS_MSG",
				Payload: wsMsg,
			})
			cancel()
			if err != nil {
				slog.Error("Failed to publish WS message to NATS", "error", err)
			}
		}
	}
}

func (h *Hub) pingLoop(client *Client, done <-chan struct{}) {
	ticker := time.NewTicker(wsPingInterval)
	defer ticker.Stop()
	for {
		select {
		case <-done:
			return
		case <-ticker.C:
			client.writeMu.Lock()
			_ = client.Conn.SetWriteDeadline(time.Now().Add(wsWriteTimeout))
			err := client.Conn.WriteControl(websocket.PingMessage, nil, time.Now().Add(wsWriteTimeout))
			client.writeMu.Unlock()
			if err != nil {
				_ = client.Conn.Close()
				return
			}
		}
	}
}

func (c *Client) writeText(data []byte) error {
	if c == nil || c.Conn == nil {
		return context.Canceled
	}
	c.writeMu.Lock()
	defer c.writeMu.Unlock()
	_ = c.Conn.SetWriteDeadline(time.Now().Add(wsWriteTimeout))
	return c.Conn.WriteMessage(websocket.TextMessage, data)
}

func (h *Hub) LocalDelivery(toUserID string, msg WSMessage) {
	if msg.Timestamp.IsZero() {
		msg.Timestamp = time.Now().UTC()
	}
	data, err := json.Marshal(msg)
	if err != nil || len(data) > maxWSMessageSize {
		return
	}
	s := h.getShard(toUserID)
	s.mu.RLock()
	clients := append([]*Client(nil), s.clients[toUserID]...)
	s.mu.RUnlock()
	for _, client := range clients {
		if err := client.writeText(data); err != nil {
			_ = client.Conn.Close()
		}
	}
}

func (h *Hub) Broadcast(userID string, payload interface{}) {
	data, err := json.Marshal(payload)
	if err != nil || len(data) > maxWSMessageSize {
		return
	}
	s := h.getShard(userID)
	s.mu.RLock()
	clients := append([]*Client(nil), s.clients[userID]...)
	s.mu.RUnlock()
	for _, client := range clients {
		if err := client.writeText(data); err != nil {
			_ = client.Conn.Close()
		}
	}
}

func (h *Hub) Register() chan<- *Client   { return h.register }
func (h *Hub) Unregister() chan<- *Client { return h.unregister }

func (h *Hub) Stop() {
	for i := 0; i < ShardCount; i++ {
		s := h.shards[i]
		s.mu.Lock()
		for userID, clients := range s.clients {
			for _, c := range clients {
				_ = c.Conn.Close()
			}
			delete(s.clients, userID)
		}
		s.mu.Unlock()
	}
}
