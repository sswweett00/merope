package service

import "context"

// BurnMessage removes a message using the same authorization path as DeleteMessage.
// The explicit service method keeps the domain contract stable while reusing the
// existing, audited deletion implementation.
func (s *HighPerformanceMessagingService) BurnMessage(ctx context.Context, messageID, userID string) error {
	return s.DeleteMessage(ctx, messageID, userID)
}
