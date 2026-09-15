package util

import (
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

// UUIDToString converts pgtype.UUID to string
func UUIDToString(id pgtype.UUID) string {
	if !id.Valid {
		return ""
	}
	return uuid.UUID(id.Bytes).String()
}

// StringToUUID converts string to pgtype.UUID
func StringToUUID(s string) pgtype.UUID {
	if s == "" {
		return pgtype.UUID{Valid: false}
	}
	u, err := uuid.Parse(s)
	if err != nil {
		return pgtype.UUID{Valid: false}
	}
	return pgtype.UUID{Bytes: u, Valid: true}
}

// NewShortID generates a random short string for non-cryptographic unique members
func NewShortID() string {
	return uuid.New().String()[:8]
}
