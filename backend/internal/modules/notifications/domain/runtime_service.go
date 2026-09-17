package domain

import "context"

type RuntimeNotificationsService interface {
	Notify(context.Context, string, string, string, string, string) error
	GetActivity(context.Context, string, int32) ([]*Notification, error)
	ClearForUser(context.Context, string) error
}
