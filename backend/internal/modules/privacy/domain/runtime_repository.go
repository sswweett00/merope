package domain

import "context"

type RuntimePrivacyRepository interface {
	SetGhostMode(context.Context, string, bool) error
	CheckVisibility(context.Context, string, string) (bool, error)
	GetActiveSessions(context.Context, string) ([]*ActiveSession, error)
	DeleteSession(context.Context, string) error
	GetSettings(context.Context, string) (*PrivacySettings, error)
	UpdateSettings(context.Context, string, *PrivacySettings) error
	UpsertIdentityKey(context.Context, string, string, []byte, []byte) error
	GetIdentityKey(context.Context, string, string) (*IdentityKey, error)
	UpsertSignedPreKey(context.Context, string, string, int32, []byte, []byte) error
	GetSignedPreKey(context.Context, string, string) (*SignedPreKey, error)
	UploadOneTimePreKeys(context.Context, string, string, []OneTimePreKey) error
	TakeOneTimePreKey(context.Context, string, string) (*OneTimePreKey, error)
}
