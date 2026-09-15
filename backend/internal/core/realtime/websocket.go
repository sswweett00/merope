package realtime

import (
	"context"
	"encoding/json"
	"hash/fnv"
	"log/slog"
	"sync"

	"github.com/gofiber/contrib/websocket"
	"local/merope/internal/core/events"
)

const ShardCount = 32

type Client struct {
	UserID string
	Conn   *websocket.Conn
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
	Type    string          `json:"type"`
	To      string          `json:"to"`
	From    string          `json:"from"`
	Payload json.RawMessage `json:"payload"`
}

func NewHub(pub events.Publisher) *Hub {
	h := &Hub{
		register:   make(chan *Client, 1024),
		unregister: make(chan *Client, 1024),
		pub:        pub,
	}
	for i := 0; i < ShardCount; i++ {
		h.shards[i] = &shard{
			clients: make(map[string][]*Client),
		}
	}
	return h
}

func (h *Hub) getShard(userID string) *shard {
	// Optimized zero-allocation hashing for high-performance sharding
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
			s := h.getShard(client.UserID)
			s.mu.Lock()
			s.clients[client.UserID] = append(s.clients[client.UserID], client)
			s.mu.Unlock()
			slog.Debug("WebSocket client registered", "user_id", client.UserID)
			go h.handleIncoming(client)

		case client := <-h.unregister:
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
			slog.Debug("WebSocket client unregistered", "user_id", client.UserID)
		}
	}
}

func (h *Hub) handleIncoming(client *Client) {
	defer func() {
		h.unregister <- client
	}()

	for {
		_, msg, err := client.Conn.ReadMessage()
		if err != nil {
			break
		}

		var wsMsg WSMessage
		if err := json.Unmarshal(msg, &wsMsg); err != nil {
			continue
		}

		wsMsg.From = client.UserID

		// If it's a direct message to another user, we might need to route it through NATS
		// if the user is not on this instance.
		if wsMsg.To != "" {
			err := h.pub.Publish(context.Background(), "ws.route."+wsMsg.To, events.Event{
				Type:    "WS_MSG",
				Payload: wsMsg,
			})
			if err != nil {
				slog.Error("Failed to publish WS message to NATS", "error", err)
			}
		}
	}
}

// LocalDelivery sends a message to users connected to THIS instance
func (h *Hub) LocalDelivery(toUserID string, msg WSMessage) {
	data, _ := json.Marshal(msg)
	s := h.getShard(toUserID)
	s.mu.RLock()
	defer s.mu.RUnlock()

	if clients, ok := s.clients[toUserID]; ok {
		for _, client := range clients {
			_ = client.Conn.WriteMessage(websocket.TextMessage, data)
		}
	}
}

func (h *Hub) Broadcast(userID string, payload interface{}) {
	data, _ := json.Marshal(payload)
	s := h.getShard(userID)
	s.mu.RLock()
	defer s.mu.RUnlock()

	if clients, ok := s.clients[userID]; ok {
		for _, client := range clients {
			_ = client.Conn.WriteMessage(websocket.TextMessage, data)
		}
	}
}

func (h *Hub) Register() chan<- *Client {
	return h.register
}

func (h *Hub) Unregister() chan<- *Client {
	return h.unregister
}

func (h *Hub) Stop() {
	close(h.register)
	close(h.unregister)
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
