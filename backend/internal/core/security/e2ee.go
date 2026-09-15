package security

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/ecdh"
	"crypto/rand"
	"fmt"
	"io"
)

const maxE2EEMessageSize = 4 * 1024 * 1024

// GenerateKeyPair generates a new ECDH P256 key pair.
func GenerateKeyPair() (*ecdh.PrivateKey, error) {
	return ecdh.P256().GenerateKey(rand.Reader)
}

// DeriveSharedSecret derives a shared secret between a private key and a public key.
func DeriveSharedSecret(priv *ecdh.PrivateKey, pub *ecdh.PublicKey) ([]byte, error) {
	if priv == nil || pub == nil {
		return nil, fmt.Errorf("private and public keys are required")
	}
	return priv.ECDH(pub)
}

// EncryptMessage encrypts a bounded message using AES-GCM.
func EncryptMessage(plaintext []byte, key []byte) ([]byte, error) {
	if len(plaintext) > maxE2EEMessageSize {
		return nil, fmt.Errorf("plaintext exceeds maximum size")
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return nil, err
	}

	return gcm.Seal(nonce, nonce, plaintext, nil), nil
}

// DecryptMessage decrypts a bounded message using AES-GCM.
func DecryptMessage(ciphertext []byte, key []byte) ([]byte, error) {
	if len(ciphertext) > maxE2EEMessageSize+32 {
		return nil, fmt.Errorf("ciphertext exceeds maximum size")
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonceSize := gcm.NonceSize()
	if len(ciphertext) < nonceSize {
		return nil, fmt.Errorf("ciphertext too short")
	}

	nonce, actualCiphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	return gcm.Open(nil, nonce, actualCiphertext, nil)
}
