package infra

import (
	"context"
	"time"

	"local/merope/internal/core/security"
)

// RotateRefreshToken atomically consumes the presented refresh token and
// installs a replacement. It is intentionally kept outside the legacy
// repository methods so existing callers remain source-compatible.
func (r *PostgresIdentityRepository) RotateRefreshToken(ctx context.Context, oldToken, newToken string, expiration time.Duration) (string, error) {
	return security.RotateRefreshTokenV2(ctx, r.cache.Conn, oldToken, newToken, expiration)
}
