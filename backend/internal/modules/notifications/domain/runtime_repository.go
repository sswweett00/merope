package domain

import "context"

type RuntimeNotificationRepository interface {
	Create(context.Context, *Notification) error
	GetForUser(context.Context, string, int32, int32) ([]*Notification, error)
	ClearForUser(context.Context, string) error
	MarkAsRead(context.Context, string, string) error
	MarkAllAsRead(context.Context, string) error
	GetUnreadCount(context.Context, string) (int32, error)
}
