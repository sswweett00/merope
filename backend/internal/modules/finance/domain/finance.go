package domain

import (
	"context"
	"time"
)

type Wallet struct {
	UserID        string
	Balance       int64
	Currency      string
	FrozenBalance int64
	IsFrozen      bool
	CreatedAt     time.Time
	UpdatedAt     time.Time
	Settings      WalletSettings
	Limits        WalletLimits
	Stats         WalletStats
}
type WalletSettings struct {
	AutoAcceptPayments  bool
	Require2FA          bool
	NotifyOnTransaction bool
	AllowOverdraft      bool
	OverdraftLimit      int64
	EnableNotifications bool
}
type WalletLimits struct {
	DailyTransferLimit   int64
	MonthlyTransferLimit int64
	MaxSingleTransfer    int64
	MinTransferAmount    int64
	WithdrawalLimit      int64
}
type WalletStats struct {
	TotalTransactions   int64
	TotalReceived       int64
	TotalSent           int64
	TotalTips           int64
	TotalUnlockPayments int64
	MonthlyVolume       int64
	LastTransactionAt   time.Time
}
type Transaction struct {
	ID               string
	SenderID         string
	ReceiverID       string
	Amount           int64
	Currency         string
	Type             string
	EntityType       *string
	EntityID         *string
	Status           string
	Fee              int64
	Description      string
	Metadata         map[string]interface{}
	CreatedAt        time.Time
	ProcessedAt      *time.Time
	ConfirmedAt      *time.Time
	RefundedAt       *time.Time
	IsReversible     bool
	RequiresApproval bool
	ApprovedBy       *string
	ApprovalNotes    string
	ReceiptURL       *string
}
type EscrowRecord struct {
	ID          string
	OrderID     string
	BuyerID     string
	SellerID    string
	Amount      int64
	Currency    string
	Status      string
	Description string
	ReleaseAt   *time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Conditions  EscrowConditions
	DisputeInfo *EscrowDispute
}
type EscrowConditions struct {
	AutoReleaseDays         int32
	AllowDispute            bool
	DisputeWindowDays       int32
	PartialReleaseAllowed   bool
	BuyerProtectionPercent  int32
	SellerProtectionPercent int32
}
type EscrowDispute struct {
	DisputerID   string
	Reason       string
	DisputedAt   time.Time
	ResolvedAt   *time.Time
	ResolvedBy   *string
	Resolution   string
	EvidenceURLs []string
}
type SubscriptionPlan struct {
	ID           string
	Name         string
	Description  string
	Price        int64
	Currency     string
	BillingCycle string
	Features     []string
	IsActive     bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Tier         string
	TrialDays    int32
}
type UserSubscription struct {
	ID            string
	UserID        string
	PlanID        string
	Status        string
	StartedAt     time.Time
	ExpiresAt     time.Time
	AutoRenew     bool
	NextBillingAt *time.Time
	CancelledAt   *time.Time
	Features      []string
	UsageStats    SubscriptionUsage
}
type SubscriptionUsage struct {
	MessagesSent  int32
	StorageUsed   int64
	APICallsMade  int32
	BandwidthUsed int64
}
type PaymentMethod struct {
	ID          string
	UserID      string
	Type        string
	Provider    string
	IsDefault   bool
	IsActive    bool
	DisplayInfo string
	Metadata    map[string]interface{}
	CreatedAt   time.Time
	UpdatedAt   time.Time
	LastUsedAt  *time.Time
}
type Invoice struct {
	ID             string
	UserID         string
	Amount         int64
	Currency       string
	Status         string
	DueDate        time.Time
	PaidAt         *time.Time
	Items          []InvoiceItem
	TaxAmount      int64
	DiscountAmount int64
	TotalAmount    int64
	Description    string
	Metadata       map[string]interface{}
	CreatedAt      time.Time
	UpdatedAt      time.Time
	PaymentMethods []string
}
type InvoiceItem struct {
	Description string
	Quantity    int32
	UnitPrice   int64
	Subtotal    int64
}
type RevenueReport struct {
	ID                  string
	UserID              string
	Period              string
	TotalRevenue        int64
	GrossRevenue        int64
	NetRevenue          int64
	TipsReceived        int64
	ContentSales        int64
	SubscriptionRevenue int64
	MarketplaceRevenue  int64
	Fees                int64
	Refunds             int64
	Chargebacks         int64
	CreatedAt           time.Time
	GeneratedAt         time.Time
}

type FinanceRepository interface {
	GetWallet(context.Context, string) (*Wallet, error)
	CreateWallet(context.Context, *Wallet) error
	UpdateWalletBalance(context.Context, string, int64) error
	FreezeWallet(context.Context, string, bool) error
	UpdateWalletSettings(context.Context, string, *WalletSettings) error
	GetWalletStats(context.Context, string, string) (*WalletStats, error)
	CreateTransaction(context.Context, *Transaction) error
	GetTransaction(context.Context, string) (*Transaction, error)
	GetUserTransactions(context.Context, string, map[string]interface{}, int32, int32) ([]*Transaction, error)
	UpdateTransactionStatus(context.Context, string, string) error
	ReverseTransaction(context.Context, string, string) error
	GetTransactionHistory(context.Context, string, int32, int32) ([]*Transaction, error)
	Transfer(context.Context, string, string, int64, string, *string, *string) error
	BatchTransfer(context.Context, []TransferRequest) error
	GetTransferHistory(context.Context, string, int32, int32) ([]*Transaction, error)
	CreateEscrow(context.Context, *EscrowRecord) error
	GetEscrow(context.Context, string) (*EscrowRecord, error)
	GetUserEscrows(context.Context, string, string, int32, int32) ([]*EscrowRecord, error)
	UpdateEscrowStatus(context.Context, string, string) error
	ReleaseEscrow(context.Context, string) error
	PartialReleaseEscrow(context.Context, string, int64) error
	DisputeEscrow(context.Context, string, string, string) error
	ResolveDispute(context.Context, string, string) error
	CreateSubscriptionPlan(context.Context, *SubscriptionPlan) error
	GetSubscriptionPlan(context.Context, string) (*SubscriptionPlan, error)
	ListSubscriptionPlans(context.Context, bool) ([]*SubscriptionPlan, error)
	CreateUserSubscription(context.Context, *UserSubscription) error
	GetUserSubscription(context.Context, string) (*UserSubscription, error)
	GetUserSubscriptions(context.Context, string) ([]*UserSubscription, error)
	UpdateUserSubscription(context.Context, string, *UserSubscription) error
	CancelSubscription(context.Context, string) error
	RenewSubscription(context.Context, string) error
	AddPaymentMethod(context.Context, *PaymentMethod) error
	GetPaymentMethods(context.Context, string) ([]*PaymentMethod, error)
	UpdatePaymentMethod(context.Context, string, *PaymentMethod) error
	DeletePaymentMethod(context.Context, string) error
	SetDefaultPaymentMethod(context.Context, string, string) error
	CreateInvoice(context.Context, *Invoice) error
	GetInvoice(context.Context, string) (*Invoice, error)
	GetUserInvoices(context.Context, string, string, int32, int32) ([]*Invoice, error)
	UpdateInvoiceStatus(context.Context, string, string) error
	PayInvoice(context.Context, string, string) error
	CreateRevenueReport(context.Context, *RevenueReport) error
	GetRevenueReport(context.Context, string) (*RevenueReport, error)
	GetUserRevenueReports(context.Context, string, string, int32, int32) ([]*RevenueReport, error)
	GenerateRevenueReport(context.Context, string, string) (*RevenueReport, error)
	GetFinancialOverview(context.Context, string, string) (*FinancialOverview, error)
	GetTransactionAnalytics(context.Context, string, string) (*TransactionAnalytics, error)
}
type TransferRequest struct {
	ReceiverID string
	Amount     int64
	Type       string
	EntityType *string
	EntityID   *string
}
type FinancialOverview struct {
	UserID              string
	Period              string
	TotalBalance        int64
	AvailableBalance    int64
	FrozenBalance       int64
	TotalRevenue        int64
	TotalExpenses       int64
	NetProfit           int64
	TransactionCount    int64
	TipRevenue          int64
	ContentRevenue      int64
	SubscriptionRevenue int64
	MarketplaceRevenue  int64
	GrowthRate          float64
	PredictedRevenue    int64
}
type TransactionAnalytics struct {
	UserID             string
	Period             string
	TotalTransactions  int64
	TotalVolume        int64
	AverageTransaction float64
	PeakTransactionDay string
	TopIncomeSources   []IncomeSource
	SpendingCategories []SpendingCategory
	PaymentMethods     []PaymentMethodUsage
	FeesPaid           int64
	RefundsReceived    int64
}
type IncomeSource struct {
	Source     string
	Amount     int64
	Percentage float64
	GrowthRate float64
}
type SpendingCategory struct {
	Category   string
	Amount     int64
	Percentage float64
}
type PaymentMethodUsage struct {
	Method     string
	Amount     int64
	Percentage float64
	Count      int64
}
type FinanceService interface {
	GetBalance(context.Context, string) (int64, error)
	GetWallet(context.Context, string) (*Wallet, error)
	CreateWallet(context.Context, string) (*Wallet, error)
	FreezeWallet(context.Context, string, bool) error
	UpdateWalletSettings(context.Context, string, *WalletSettings) error
	TipUser(context.Context, string, string, int32) error
	UnlockContent(context.Context, string, string, int32) error
	TransferFunds(context.Context, string, string, int64, string) error
	BatchTransfer(context.Context, []TransferRequest) error
	GetTransaction(context.Context, string) (*Transaction, error)
	GetUserTransactions(context.Context, string, map[string]interface{}) ([]*Transaction, error)
	ReverseTransaction(context.Context, string, string) error
	InitiateEscrow(context.Context, string, string, int64, string) (*EscrowRecord, error)
	ReleaseEscrow(context.Context, string, string) error
	RefundEscrow(context.Context, string, string) error
	PartialReleaseEscrow(context.Context, string, int64) error
	DisputeEscrow(context.Context, string, string) error
	ResolveDispute(context.Context, string, string) error
	GetEscrow(context.Context, string) (*EscrowRecord, error)
	CreateSubscriptionPlan(context.Context, *SubscriptionPlan) error
	SubscribeToPlan(context.Context, string, string) (*UserSubscription, error)
	CancelSubscription(context.Context, string) error
	RenewSubscription(context.Context, string) error
	UpgradeSubscription(context.Context, string, string) error
	GetUserSubscription(context.Context, string) (*UserSubscription, error)
	ListSubscriptionPlans(context.Context) ([]*SubscriptionPlan, error)
	AddPaymentMethod(context.Context, string, string, string, string) (*PaymentMethod, error)
	GetPaymentMethods(context.Context, string) ([]*PaymentMethod, error)
	DeletePaymentMethod(context.Context, string) error
	SetDefaultPaymentMethod(context.Context, string, string) error
	CreateInvoice(context.Context, string, []InvoiceItem, time.Time) (*Invoice, error)
	GetInvoice(context.Context, string) (*Invoice, error)
	GetUserInvoices(context.Context, string, string) ([]*Invoice, error)
	PayInvoice(context.Context, string, string) error
	GetFinancialOverview(context.Context, string, string) (*FinancialOverview, error)
	GetTransactionAnalytics(context.Context, string, string) (*TransactionAnalytics, error)
	GenerateRevenueReport(context.Context, string, string) (*RevenueReport, error)
	GetRevenueReports(context.Context, string, string) ([]*RevenueReport, error)
	CheckTransferLimits(context.Context, string, int64) (bool, error)
	GetWalletLimits(context.Context, string) (*WalletLimits, error)
	UpdateWalletLimits(context.Context, string, *WalletLimits) error
	ComplianceCheck(context.Context, string) (*ComplianceStatus, error)
}
type ComplianceStatus struct {
	IsCompliant     bool
	RequirementsMet []string
	Violations      []string
	Restrictions    []string
	NextReviewDate  time.Time
}
