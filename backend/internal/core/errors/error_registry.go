package errors

import (
	"fmt"
	"net/http"
)

type Code string

const (
	ErrUnknown          Code = "ERR_UNKNOWN"
	ErrAuthFailed       Code = "ERR_AUTH_FAILED"
	ErrVaultDuplicate   Code = "ERR_VAULT_DUPLICATE"
	ErrStorageQuota     Code = "ERR_STORAGE_QUOTA"
	ErrCircuitTriggered Code = "ERR_CIRCUIT_OPEN"

	ErrValidation     Code = "ERR_VALIDATION"
	ErrRateLimited    Code = "ERR_RATE_LIMITED"
	ErrNotFound       Code = "ERR_NOT_FOUND"
	ErrForbidden      Code = "ERR_FORBIDDEN"
	ErrConflict       Code = "ERR_CONFLICT"
	ErrBadRequest     Code = "ERR_BAD_REQUEST"
	ErrUnauthorized   Code = "ERR_UNAUTHORIZED"
	ErrInternal       Code = "ERR_INTERNAL"
	ErrSessionExpired Code = "ERR_SESSION_EXPIRED"
	ErrMFARequired    Code = "ERR_MFA_REQUIRED"
)

type DomainError struct {
	Code    Code   `json:"code"`
	Message string `json:"message"`
}

func (e *DomainError) Error() string {
	return fmt.Sprintf("[%s] %s", e.Code, e.Message)
}

func New(code Code, msg string) *DomainError {
	return &DomainError{Code: code, Message: msg}
}

func ToHTTPStatus(err error) int {
	if err == nil {
		return http.StatusOK
	}

	if domainErr, ok := err.(*DomainError); ok {
		switch domainErr.Code {
		case ErrAuthFailed, ErrUnauthorized, ErrSessionExpired:
			return http.StatusUnauthorized
		case ErrForbidden:
			return http.StatusForbidden
		case ErrNotFound:
			return http.StatusNotFound
		case ErrRateLimited:
			return http.StatusTooManyRequests
		case ErrValidation, ErrBadRequest, ErrMFARequired:
			return http.StatusBadRequest
		case ErrConflict:
			return http.StatusConflict
		case ErrInternal, ErrUnknown:
			return http.StatusInternalServerError
		default:
			return http.StatusInternalServerError
		}
	}

	return http.StatusInternalServerError
}

func GetCode(err error) Code {
	if err == nil {
		return ErrUnknown
	}

	if domainErr, ok := err.(*DomainError); ok {
		return domainErr.Code
	}

	return ErrUnknown
}

func Wrap(err error, code Code, msg string) error {
	if domainErr, ok := err.(*DomainError); ok {
		domainErr.Message = msg
		return domainErr
	}
	return New(code, fmt.Sprintf("%s: %v", msg, err))
}
