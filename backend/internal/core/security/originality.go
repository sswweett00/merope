package security

import (
	"crypto/ed25519"
	"encoding/hex"
)

// VerifyOriginality checks if a video signature is valid for a given payload (Cosmos v9.0)
func VerifyOriginality(publicKeyHex, signatureHex string, payload []byte) (bool, error) {
	pubKey, err := hex.DecodeString(publicKeyHex)
	if err != nil {
		return false, err
	}

	sig, err := hex.DecodeString(signatureHex)
	if err != nil {
		return false, err
	}

	return ed25519.Verify(pubKey, payload, sig), nil
}
