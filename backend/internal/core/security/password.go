package security

import (
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"errors"
	"fmt"
	"strings"

	"golang.org/x/crypto/argon2"
)

var (
	ErrInvalidHash         = errors.New("the encoded hash is not in the correct format")
	ErrIncompatibleVersion = errors.New("incompatible version of argon2")
)

type Argon2Params struct {
	Memory      uint32
	Iterations  uint32
	Parallelism uint8
	SaltLength  uint32
	KeyLength   uint32
}

func DefaultArgon2Params() *Argon2Params {
	return &Argon2Params{
		Memory:      64 * 1024,
		Iterations:  3,
		Parallelism: 2,
		SaltLength:  16,
		KeyLength:   32,
	}
}

func HashPassword(password string) (string, error) {
	params := DefaultArgon2Params()

	salt := make([]byte, params.SaltLength)
	if _, err := rand.Read(salt); err != nil {
		return "", err
	}

	hash := argon2.IDKey([]byte(password), salt, params.Iterations, params.Memory, params.Parallelism, params.KeyLength)

	b64Salt := base64.RawStdEncoding.EncodeToString(salt)
	b64Hash := base64.RawStdEncoding.EncodeToString(hash)

	encoded := fmt.Sprintf("$argon2id$v=%d$m=%d,t=%d,p=%d$%s$%s",
		argon2.Version, params.Memory, params.Iterations, params.Parallelism, b64Salt, b64Hash)

	return encoded, nil
}

func ComparePassword(password, encodedHash string) (bool, error) {
	p, salt, hash, err := decodeHash(encodedHash)
	if err != nil {
		return false, err
	}

	otherHash := argon2.IDKey([]byte(password), salt, p.Iterations, p.Memory, p.Parallelism, p.KeyLength)

	if subtle.ConstantTimeCompare(hash, otherHash) == 1 {
		return true, nil
	}

	return false, nil
}

func decodeHash(encodedHash string) (p *Argon2Params, salt, hash []byte, err error) {
	vals := strings.Split(encodedHash, "$")
	if len(vals) != 6 || vals[0] != "" || vals[1] != "argon2id" {
		return nil, nil, nil, ErrInvalidHash
	}

	var version int
	if _, err = fmt.Sscanf(vals[2], "v=%d", &version); err != nil {
		return nil, nil, nil, ErrInvalidHash
	}
	if version != argon2.Version {
		return nil, nil, nil, ErrIncompatibleVersion
	}

	p = &Argon2Params{}
	if _, err = fmt.Sscanf(vals[3], "m=%d,t=%d,p=%d", &p.Memory, &p.Iterations, &p.Parallelism); err != nil {
		return nil, nil, nil, ErrInvalidHash
	}

	// Reject malformed or attacker-controlled cost parameters before Argon2 allocates memory.
	const (
		minMemoryKiB   = 16 * 1024
		maxMemoryKiB   = 256 * 1024
		minIterations  = 1
		maxIterations  = 10
		minParallelism = 1
		maxParallelism = 16
	)
	if p.Memory < minMemoryKiB || p.Memory > maxMemoryKiB ||
		p.Iterations < minIterations || p.Iterations > maxIterations ||
		p.Parallelism < minParallelism || p.Parallelism > maxParallelism {
		return nil, nil, nil, ErrInvalidHash
	}

	salt, err = base64.RawStdEncoding.DecodeString(vals[4])
	if err != nil || len(salt) < 16 || len(salt) > 64 {
		return nil, nil, nil, ErrInvalidHash
	}
	p.SaltLength = uint32(len(salt))

	hash, err = base64.RawStdEncoding.DecodeString(vals[5])
	if err != nil || len(hash) < 16 || len(hash) > 64 {
		return nil, nil, nil, ErrInvalidHash
	}
	p.KeyLength = uint32(len(hash))

	return p, salt, hash, nil
}
