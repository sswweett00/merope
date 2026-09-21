package realtime

import (
	"context"
	"encoding/json"
	"log/slog"
	"time"

	"github.com/nats-io/nats.go"

	coreEvents "local/merope/internal/core/events"
)

type RoomMemberProvider interface {
	GetRoomMembers(ctx context.Context, roomID string) ([]RoomMember, error)
	GetMessageByID(ctx context.Context, messageID string) (*MessageEnvelope, error)
}

type RoomMember struct {
	ID string
}

type MessageEnvelope struct {
	RoomID  string
	SenderID string
}

type natsEventEnvelope struct {
	Type    string          `json:"type"`
	Payload json.RawMessage `json:"payload"`
}

func SubscribeEventBridge(
	ctx context.Context,
	conn *nats.Conn,
	hub *Hub,
	repo RoomMemberProvider,
) ([]*nats.Subscription, error) {
	if conn == nil || hub == nil || repo == nil {
		return nil, nil
	}

	handler := func(msg *nats.Msg) {
		if msg == nil {
			return
		}

		var envelope natsEventEnvelope
		if err := json.Unmarshal(msg.Data, &envelope); err != nil || envelope.Type == "" {
			return
		}

		var payload map[string]interface{}
		if len(envelope.Payload) > 0 {
			if err := json.Unmarshal(envelope.Payload, &payload); err != nil {
				return
			}
		}
		if payload == nil {
			payload = map[string]interface{}{}
		}

		roomID := stringValue(payload["room_id"])
		messageID := stringValue(payload["message_id"])
		senderID := firstNonEmpty(
			stringValue(payload["sender_id"]),
			stringValue(payload["author_id"]),
			stringValue(payload["user_id"]),
		)

		if roomID == "" && messageID != "" {
			lookupCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
			message, err := repo.GetMessageByID(lookupCtx, messageID)
			cancel()
			if err == nil && message != nil {
				roomID = message.RoomID
				if senderID == "" {
					senderID = message.SenderID
				}
			}
		}
		if roomID == "" {
			return
		}

		lookupCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
		members, err := repo.GetRoomMembers(lookupCtx, roomID)
		cancel()
		if err != nil {
			slog.Warn("realtime event bridge failed to resolve room members",
				"room_id", roomID,
				"subject", msg.Subject,
				"error", err,
			)
			return
		}

		payload["room_id"] = roomID
		for _, member := range members {
			if member.ID == "" {
				continue
			}
			hub.LocalDelivery(member.ID, WSMessage{
				Type:      envelope.Type,
				To:        member.ID,
				From:      senderID,
				Payload:   envelope.Payload,
				Timestamp: time.Now().UTC(),
			})
		}
	}

	subscriptions := make([]*nats.Subscription, 0, 2)
	for _, subject := range []string{"chat.*", "e2ee.*"} {
		sub, err := conn.Subscribe(subject, handler)
		if err != nil {
			for _, existing := range subscriptions {
				_ = existing.Unsubscribe()
			}
			return nil, err
		}
		subscriptions = append(subscriptions, sub)
	}

	return subscriptions, nil
}

func stringValue(value interface{}) string {
	switch v := value.(type) {
	case string:
		return v
	default:
		return ""
	}
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		if value != "" {
			return value
		}
	}
	return ""
}

var _ coreEvents.Publisher
