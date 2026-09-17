package domain

import "context"

type RuntimeNotificationRepository interface {
	Create(context.Context, *Notification) error
	GetForUser(context.Context, string, int32, int32) ([]*Notification, error)
}
