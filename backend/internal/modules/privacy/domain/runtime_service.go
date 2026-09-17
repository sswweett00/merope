package domain

import "context"

type RuntimePrivacyService interface {
	SetGhostMode(context.Context, string, bool) error
	CheckVisibility(context.Context, string, string) (bool, error)
	ListSessions(context.Context, string) ([]*ActiveSession, error)
	LogoutSession(context.Context, string) error
	UpdateIdentityKeys(context.Context, string, string, []byte) error
	UploadPreKeys(context.Context, string, string, *SignedPreKey, []OneTimePreKey) error
	GetPreKeyBundle(context.Context, string, string) (*PreKeyBundle, error)
}
