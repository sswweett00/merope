package domain

import "context"

type E2EEPublicKey struct {
	UserID    string `json:"user_id"`
	PublicKey string `json:"public_key"`
	Algorithm string `json:"algorithm"`
}

type E2EEPublicKeyRepository interface {
	GetPublicKey(ctx context.Context, userID string) (*E2EEPublicKey, error)
	UpsertPublicKey(ctx context.Context, userID, publicKey, algorithm string) error
}
