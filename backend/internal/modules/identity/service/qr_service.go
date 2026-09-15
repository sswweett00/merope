package service

import (
	"fmt"
)

func GenerateProfileQR(username string) string {
	// In production, use a library like 'skip2/go-qrcode'
	return fmt.Sprintf("https://merope.app/qr/%s", username)
}
