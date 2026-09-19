package domain

import (
	"context"
	"time"
)

type PrivacySettings struct {
	UserID                   string
	IsGhostMode              bool
	ProfileLock              bool
	LastSeenVisibility       string // everyone, friends, nobody
	ReadReceipts             bool
	OnlineStatus             bool
	ProfilePictureVisibility string // everyone, friends, nobody
	ActivityStatusVisibility string // everyone, friends, nobody
	AllowStrangerMessages    bool
	AllowGroupInvites        bool
	AllowSearchByPhone       bool
	AllowSearchByEmail       bool
	ShowPhoneNumber          bool
	ShowEmailAddress         bool
	AllowDataCollection      bool
	AllowPersonalizedAds     bool
	AllowAnalytics           bool
	DataRetentionPeriod      int32 // days
	AutoDeleteMessages       bool
	AutoDeleteAfterDays      int32
	EncryptMetadata          bool
	EncryptBackup            bool
	EnableScreenSecurity     bool // prevent screenshots
	TwoFactorEnabled         bool
	TwoFactorMethod          string // sms, email, authenticator, hardware_key
	BiometricEnabled         bool
	SessionTimeout           int32 // minutes
	AccountRecoveryEmail     string
	AccountRecoveryPhone     string
	EmergencyContacts        []string
	PrivacyLevel             string // standard, high, maximum
	ComplianceSettings       ComplianceSettings
}

type ComplianceSettings struct {
	GDPRCompliant           bool
	CCPACompliant           bool
	DataProcessingAgreement bool
	CookieConsent           bool
	MarketingConsent        bool
	ThirdPartySharing       bool
	DataExportRequested     bool
	DataDeleteRequested     bool
	LastPolicyUpdate        time.Time
}

type ActiveSession struct {
	ID          string
	UserID      string
	DeviceName  string
	DeviceType  string // mobile, tablet, desktop, tv
	OSType      string
	OSVersion   string
	AppVersion  string
	Location    string
	Country     string
	City        string
	IPAddress   string
	LastUsed    time.Time
	IsCurrent   bool
	IsActive    bool
	UserAgent   string
	Fingerprint string
}

type SecurityEvent struct {
	ID                string
	UserID            string
	EventType         string // login, logout, password_change, 2fa_enabled, account_locked, etc.
	IPAddress         string
	DeviceFingerprint string
	UserAgent         string
	Location          string
	Severity          string // low, medium, high, critical
	Details           map[string]interface{}
	CreatedAt         time.Time
	ResolvedAt        *time.Time
	ResolvedBy        *string
}

type DataExportRequest struct {
	ID          string
	UserID      string
	Status      string // pending, processing, completed, failed
	RequestedAt time.Time
	CompletedAt *time.Time
	ExpiresAt   *time.Time
	DownloadURL *string
	FileSize    int64
	Format      string   // json, csv, pdf
	Includes    []string // messages, contacts, media, etc.
}

type DataDeletionRequest struct {
	ID                string
	UserID            string
	Status            string // pending, processing, completed, failed
	RequestedAt       time.Time
	ScheduledFor      *time.Time
	CompletedAt       *time.Time
	Reason            string
	DataTypes         []string
	VerificationToken string
}

type ConsentRecord struct {
	ID          string
	UserID      string
	ConsentType string // marketing, analytics, personalization, third_party
	IsGranted   bool
	GrantedAt   time.Time
	RevokedAt   *time.Time
	Version     string
	IPAddress   string
	UserAgent   string
	Details     map[string]interface{}
}

type AuditLog struct {
	ID           string
	UserID       string
	Action       string
	ResourceType string
	ResourceID   string
	IPAddress    string
	UserAgent    string
	Timestamp    time.Time
	Success      bool
	ErrorMessage *string
	Metadata     map[string]interface{}
}

// E2EE (End-to-End Encryption) Types

type IdentityKey struct {
	UserID    string
	DeviceID  string
	PublicKey []byte
	Signature []byte
	CreatedAt time.Time
	IsActive  bool
}

type PreKeyBundle struct {
	UserID         string
	DeviceID       string
	RegistrationID int32
	IdentityKey    []byte
	SignedPreKey   *SignedPreKey
	OneTimePreKeys []*OneTimePreKey
	CreatedAt      time.Time
}

type SignedPreKey struct {
	ID        int32
	PublicKey []byte
	Signature []byte
	CreatedAt time.Time
}

type OneTimePreKey struct {
	ID        int32
	PublicKey []byte
	Used      bool
	UsedAt    *time.Time
	CreatedAt time.Time
}

type MessageKey struct {
	MessageID    string
	SenderID     string
	ReceiverID   string
	EncryptedKey []byte
	Algorithm    string
	KeyVersion   int32
	CreatedAt    time.Time
	ExpiresAt    *time.Time
}

type GroupEncryptionKey struct {
	GroupID      string
	EncryptedKey []byte
	KeyVersion   int32
	CreatedBy    string
	CreatedAt    time.Time
	RotatedAt    *time.Time
	ExpiresAt    *time.Time
	MemberKeys   map[string][]byte // userID -> encrypted key
}

type KeyRotationPolicy struct {
	UserID          string
	RotateAfterDays int32
	MaxKeyVersions  int32
	ForceRotation   bool
	LastRotatedAt   time.Time
}

type PrivacyRepository interface {
	// Privacy Settings
	UpdateSettings(ctx context.Context, userID string, settings *PrivacySettings) error
	GetSettings(ctx context.Context, userID string) (*PrivacySettings, error)
	GetPublicSettings(ctx context.Context, userID string) (*PublicPrivacySettings, error)

	// Ghost Mode & Visibility
	SetGhostMode(ctx context.Context, userID string, active bool) error
	CheckVisibility(ctx context.Context, userID, viewerID string) (bool, error)
	SetOnlineStatus(ctx context.Context, userID string, online bool) error

	// Session Management
	GetActiveSessions(ctx context.Context, userID string) ([]*ActiveSession, error)
	GetSession(ctx context.Context, sessionID string) (*ActiveSession, error)
	CreateSession(ctx context.Context, session *ActiveSession) error
	UpdateSession(ctx context.Context, sessionID string, updates *ActiveSession) error
	DeleteSession(ctx context.Context, sessionID string) error
	DeleteAllSessions(ctx context.Context, userID string) error
	DeleteOtherSessions(ctx context.Context, userID, currentSessionID string) error

	// Security Events
	LogSecurityEvent(ctx context.Context, event *SecurityEvent) error
	GetSecurityEvents(ctx context.Context, userID string, limit, offset int32) ([]*SecurityEvent, error)
	GetSecurityEventsByType(ctx context.Context, userID, eventType string, limit int32) ([]*SecurityEvent, error)
	ResolveSecurityEvent(ctx context.Context, eventID string, resolverID string) error

	// Data Export & Deletion (GDPR/CCPA)
	CreateDataExportRequest(ctx context.Context, userID string, includes []string) (*DataExportRequest, error)
	GetDataExportRequest(ctx context.Context, requestID string) (*DataExportRequest, error)
	GetUserExportRequests(ctx context.Context, userID string) ([]*DataExportRequest, error)
	ProcessDataExport(ctx context.Context, requestID string) error
	CreateDataDeletionRequest(ctx context.Context, userID string, reason string) (*DataDeletionRequest, error)
	GetDataDeletionRequest(ctx context.Context, requestID string) (*DataDeletionRequest, error)
	ProcessDataDeletion(ctx context.Context, requestID string) error

	// Consent Management
	RecordConsent(ctx context.Context, consent *ConsentRecord) error
	GetUserConsents(ctx context.Context, userID string) ([]*ConsentRecord, error)
	GetConsentByType(ctx context.Context, userID, consentType string) (*ConsentRecord, error)
	RevokeConsent(ctx context.Context, userID, consentType string) error
	UpdateConsent(ctx context.Context, userID, consentType string, granted bool) error

	// Audit Logging
	LogAuditEvent(ctx context.Context, log *AuditLog) error
	GetAuditLogs(ctx context.Context, userID string, limit, offset int32) ([]*AuditLog, error)
	GetAuditLogsByAction(ctx context.Context, userID, action string, limit int32) ([]*AuditLog, error)
	GetAuditLogsByResource(ctx context.Context, resourceType, resourceID string, limit int32) ([]*AuditLog, error)

	// E2EE - Identity Keys
	UpsertIdentityKey(ctx context.Context, userID, deviceID string, pubKey, signature []byte) error
	GetIdentityKey(ctx context.Context, userID, deviceID string) (*IdentityKey, error)
	GetUserIdentityKeys(ctx context.Context, userID string) ([]*IdentityKey, error)
	DeleteIdentityKey(ctx context.Context, userID, deviceID string) error

	// E2EE - PreKeys
	UpsertSignedPreKey(ctx context.Context, userID, deviceID string, keyID int32, pubKey, sig []byte) error
	GetSignedPreKey(ctx context.Context, userID, deviceID string) (*SignedPreKey, error)
	UploadOneTimePreKeys(ctx context.Context, userID, deviceID string, keys []OneTimePreKey) error
	TakeOneTimePreKey(ctx context.Context, userID, deviceID string) (*OneTimePreKey, error)
	GetPreKeyBundle(ctx context.Context, userID, deviceID string) (*PreKeyBundle, error)
	MarkPreKeyUsed(ctx context.Context, userID, deviceID, keyID int32) error

	// E2EE - Message Keys
	StoreMessageKey(ctx context.Context, key *MessageKey) error
	GetMessageKey(ctx context.Context, messageID string) (*MessageKey, error)
	DeleteMessageKey(ctx context.Context, messageID string) error

	// E2EE - Group Encryption
	StoreGroupKey(ctx context.Context, key *GroupEncryptionKey) error
	GetGroupKey(ctx context.Context, groupID string) (*GroupEncryptionKey, error)
	UpdateGroupKey(ctx context.Context, groupID string, newKey []byte) error
	RotateGroupKey(ctx context.Context, groupID string) error

	// E2EE - Key Rotation
	SetKeyRotationPolicy(ctx context.Context, userID string, policy *KeyRotationPolicy) error
	GetKeyRotationPolicy(ctx context.Context, userID string) (*KeyRotationPolicy, error)
	ShouldRotateKeys(ctx context.Context, userID string) (bool, error)
	RotateUserKeys(ctx context.Context, userID string) error

	// Two-Factor Authentication
	Enable2FA(ctx context.Context, userID, method string, secret string) error
	Disable2FA(ctx context.Context, userID string) error
	Verify2FA(ctx context.Context, userID, code string) (bool, error)
	Generate2FABackupCodes(ctx context.Context, userID string) ([]string, error)
	Get2FAStatus(ctx context.Context, userID string) (*TwoFAStatus, error)
}

type PublicPrivacySettings struct {
	UserID       string
	IsGhostMode  bool
	ProfileLock  bool
	OnlineStatus bool
	PrivacyLevel string
}

type TwoFAStatus struct {
	UserID               string
	IsEnabled            bool
	Method               string
	LastUsedAt           time.Time
	BackupCodesRemaining int32
}

type PrivacyService interface {
	// Privacy Settings
	UpdatePrivacy(ctx context.Context, userID string, settings *PrivacySettings) error
	GetPrivacySettings(ctx context.Context, userID string) (*PrivacySettings, error)
	GetPublicPrivacy(ctx context.Context, userID string) (*PublicPrivacySettings, error)

	// Ghost Mode & Visibility
	SetGhostMode(ctx context.Context, userID string, active bool) error
	CheckVisibility(ctx context.Context, userID, viewerID string) (bool, error)
	SetOnlineStatus(ctx context.Context, userID string, online bool) error

	// Session Management
	ListSessions(ctx context.Context, userID string) ([]*ActiveSession, error)
	LogoutSession(ctx context.Context, sessionID string) error
	LogoutAllSessions(ctx context.Context, userID string) error
	LogoutOtherSessions(ctx context.Context, userID, currentSessionID string) error
	GetCurrentSession(ctx context.Context, userID string) (*ActiveSession, error)

	// 2FA & Security
	Toggle2FA(ctx context.Context, userID string, enable bool, method string) (string, error)
	Verify2FA(ctx context.Context, userID, code string) (bool, error)
	GenerateBackupCodes(ctx context.Context, userID string) ([]string, error)
	Get2FAStatus(ctx context.Context, userID string) (*TwoFAStatus, error)

	// Data Export & Deletion (GDPR/CCPA)
	RequestDataExport(ctx context.Context, userID string, includes []string) (*DataExportRequest, error)
	GetExportStatus(ctx context.Context, requestID string) (*DataExportRequest, error)
	RequestDataDeletion(ctx context.Context, userID string, reason string) (*DataDeletionRequest, error)
	GetDeletionStatus(ctx context.Context, requestID string) (*DataDeletionRequest, error)
	CancelDeletionRequest(ctx context.Context, requestID string) error

	// Consent Management
	GrantConsent(ctx context.Context, userID, consentType string) error
	RevokeConsent(ctx context.Context, userID, consentType string) error
	GetUserConsents(ctx context.Context, userID string) ([]*ConsentRecord, error)
	UpdateConsent(ctx context.Context, userID, consentType string, granted bool) error

	// Security Events
	GetSecurityEvents(ctx context.Context, userID string, limit int32) ([]*SecurityEvent, error)
	GetRecentSecurityEvents(ctx context.Context, userID string, hours int32) ([]*SecurityEvent, error)
	ReportSecurityIssue(ctx context.Context, userID, issueType string, details map[string]interface{}) error

	// Audit Logs
	GetAuditLogs(ctx context.Context, userID string, limit int32) ([]*AuditLog, error)
	GetAuditLogsByAction(ctx context.Context, userID, action string, limit int32) ([]*AuditLog, error)

	// E2EE - Key Management
	UpdateIdentityKeys(ctx context.Context, userID, deviceID string, pubKey, signature []byte) error
	UploadPreKeys(ctx context.Context, userID, deviceID string, signedKey *SignedPreKey, otKeys []OneTimePreKey) error
	GetPreKeyBundle(ctx context.Context, userID, deviceID string) (*PreKeyBundle, error)
	StoreMessageKey(ctx context.Context, messageID, senderID, receiverID string, encryptedKey []byte) error
	GetMessageKey(ctx context.Context, messageID string) (*MessageKey, error)

	// E2EE - Group Encryption
	CreateGroupKey(ctx context.Context, groupID string, creatorID string) (*GroupEncryptionKey, error)
	GetGroupKey(ctx context.Context, groupID string) (*GroupEncryptionKey, error)
	AddMemberToGroupKey(ctx context.Context, groupID, userID string, encryptedKey []byte) error
	RemoveMemberFromGroupKey(ctx context.Context, groupID, userID string) error
	RotateGroupKey(ctx context.Context, groupID string) error

	// E2EE - Key Rotation
	SetKeyRotationPolicy(ctx context.Context, userID string, rotateAfterDays int32) error
	GetKeyRotationPolicy(ctx context.Context, userID string) (*KeyRotationPolicy, error)
	RotateUserKeys(ctx context.Context, userID string) error
	CheckKeyRotationNeeded(ctx context.Context, userID string) (bool, error)

	// Privacy Compliance
	CheckCompliance(ctx context.Context, userID string) (*ComplianceStatus, error)
	UpdateComplianceSettings(ctx context.Context, userID string, settings *ComplianceSettings) error
	GetPrivacyReport(ctx context.Context, userID string) (*PrivacyReport, error)
}

type ComplianceStatus struct {
	UserID          string
	IsCompliant     bool
	GDPRCompliant   bool
	CCPACompliant   bool
	RequiredActions []string
	ConsentIssues   []string
	DataRetention   string
	LastChecked     time.Time
}

type PrivacyReport struct {
	UserID           string
	GeneratedAt      time.Time
	PrivacyLevel     string
	DataCollected    []string
	DataShared       []string
	ThirdPartyAccess []string
	ConsentStatus    map[string]bool
	SecurityScore    int32
	Recommendations  []string
}
