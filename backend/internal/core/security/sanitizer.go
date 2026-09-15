package security

import (
	"github.com/microcosm-cc/bluemonday"
)

var (
	// UGCPolicy allows a broad selection of safe HTML tags and attributes (e.g. <b>, <i>, <a>).
	// It is intended for user-generated content.
	ugcPolicy = bluemonday.UGCPolicy()

	// StrictPolicy strips all HTML tags, leaving only text.
	strictPolicy = bluemonday.StrictPolicy()
)

// SanitizeHTML cleans up HTML content using the UGC policy.
func SanitizeHTML(text string) string {
	return ugcPolicy.Sanitize(text)
}

// StripHTML removes all HTML tags from a string.
func StripHTML(text string) string {
	return strictPolicy.Sanitize(text)
}
