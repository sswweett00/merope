package infra

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/core/security"
)

// RotateRefreshToken atomically consumes the presented refresh token and
// installs a replacement. It is intentionally kept outside the legacy
// repository methods so existing callers remain source-compatible.
func (r *PostgresIdentityRepository) RotateRefreshToken(ctx context.Context, oldToken, newToken string, expiration time.Duration) (string, error) {
	if r.cache == nil || r.cache.Conn == nil {
		return "", fmt.Errorf("refresh token store unavailable")
	}
	return security.RotateRefreshTokenV2(ctx, r.cache.Conn, oldToken, newToken, expiration)
}
