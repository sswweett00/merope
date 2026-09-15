package domain

import (
	"context"
	"time"
)

type Wallet struct {
	UserID       string
	Balance      int64
	Currency     string
	FrozenBalance int64
	IsFrozen     bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Settings     WalletSettings
	Limits       WalletLimits
	Stats        WalletStats
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
	MaxSingleTransfer   int64
	MinTransferAmount   int64
	WithdrawalLimit     int64
}

type WalletStats struct {
	TotalTransactions int64
	TotalReceived      int64
	TotalSent          int64
	TotalTips          int64
	TotalUnlockPayments int64
	MonthlyVolume      int64
	LastTransactionAt  time.Time
}

type Transaction struct {
	ID              string
	SenderID        string
	ReceiverID      string
	Amount          int64
	Currency        string
	Type            string // tip, unlock, withdrawal, deposit, refund, escrow, subscription, marketplace, transfer
	EntityType      *string
	EntityID        *string
	Status          string // pending, completed, failed, cancelled
	Fee             int64
	Description     string
	Metadata        map[string]interface{}
	CreatedAt       time.Time
	ProcessedAt     *time.Time
	ConfirmedAt     *time.Time
	RefundedAt      *time.Time
	IsReversible    bool
	RequiresApproval bool
	ApprovedBy      *string
	ApprovalNotes   string
	ReceiptURL      *string
}

type EscrowRecord struct {
	ID          string
	OrderID     string
	BuyerID     string
	SellerID    string
	Amount      int64
	Currency    string
	Status      string // held, released, disputed, refunded, partial_release
	Description string
	ReleaseAt   *time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Conditions  EscrowConditions
	DisputeInfo *EscrowDispute
}

type EscrowConditions struct {
	AutoReleaseDays   int32
	AllowDispute      bool
	DisputeWindowDays int32
	PartialReleaseAllowed bool
	BuyerProtectionPercent int32
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
	BillingCycle string // monthly, yearly
	Features     []string
	IsActive     bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Tier         string // basic, pro, enterprise
	TrialDays    int32
}

type UserSubscription struct {
	ID           string
	UserID       string
	PlanID       string
	Status       string // active, cancelled, expired, past_due
	StartedAt    time.Time
	ExpiresAt    time.Time
	AutoRenew    bool
	NextBillingAt *time.Time
	CancelledAt  *time.Time
	Features     []string
	UsageStats   SubscriptionUsage
}

type SubscriptionUsage struct {
	MessagesSent  int32
	StorageUsed  int64
	API callsMade int32
	BandwidthUsed int64
}

type PaymentMethod struct {
	ID           string
	UserID       string
	Type         string // credit_card, bank_account, pulse
	Provider     string
	IsDefault    bool
	IsActive     bool
	DisplayInfo  string // masked card number, bank name
	Metadata     map[string]interface{}
	CreatedAt    time.Time
	UpdatedAt    time.Time
	LastUsedAt   *time.Time
}

type Invoice struct {
	ID              string
	UserID          string
	Amount          int64
	Currency        string
	Status          string // draft, pending, paid, overdue, cancelled
	DueDate         time.Time
	PaidAt          *time.Time
	Items           []InvoiceItem
	TaxAmount       int64
	DiscountAmount  int64
	TotalAmount     int64
	Description     string
	Metadata        map[string]interface{}
	CreatedAt       time.Time
	UpdatedAt       time.Time
	PaymentMethods  []string
}

type InvoiceItem struct {
	Description string
	Quantity    int32
	UnitPrice   int64
	Subtotal    int64
}

type RevenueReport struct {
	ID             string
	UserID         string
	Period         string // daily, weekly, monthly
	TotalRevenue   int64
	GrossRevenue   int64
	NetRevenue     int64
	TipsReceived  int64
	ContentSales   int64
	SubscriptionRevenue int64
	MarketplaceRevenue int64
	Fees           int64
	Refunds        int64
	Chargebacks    int64
	CreatedAt      time.Time
	GeneratedAt    time.Time
}

type FinanceRepository interface {
	// Wallets
	GetWallet(ctx context.Context, userID string) (*Wallet, error)
	CreateWallet(ctx context.Context, wallet *Wallet) error
	UpdateWalletBalance(ctx context.Context, userID string, balance int64) error
	FreezeWallet(ctx context.Context, userID string, freeze bool) error
	UpdateWalletSettings(ctx context.Context, userID string, settings *WalletSettings) error
	GetWalletStats(ctx context.Context, userID string, period string) (*WalletStats, error)
	
	// Transactions
	CreateTransaction(ctx context.Context, tx *Transaction) error
	GetTransaction(ctx context.Context, txID string) (*Transaction, error)
	GetUserTransactions(ctx context.Context, userID string, filters map[string]interface{}, limit, offset int32) ([]*Transaction, error)
	UpdateTransactionStatus(ctx context.Context, txID string, status string) error
	ReverseTransaction(ctx context.Context, txID string, reason string) error
	GetTransactionHistory(ctx context.Context, userID string, limit, offset int32) ([]*Transaction, error)
	
	// Transfers
	Transfer(ctx context.Context, senderID, receiverID string, amount int64, tType string, entityType, entityID *string) error
	BatchTransfer(ctx context.Context, transfers []TransferRequest) error
	GetTransferHistory(ctx context.Context, userID string, limit, offset int32) ([]*Transaction, error)
	
	// Escrow
	CreateEscrow(ctx context.Context, escrow *EscrowRecord) error
	GetEscrow(ctx context.Context, id string) (*EscrowRecord, error)
	GetUserEscrows(ctx context.Context, userID string, status string, limit, offset int32) ([]*EscrowRecord, error)
	UpdateEscrowStatus(ctx context.Context, id, status string) error
	ReleaseEscrow(ctx context.Context, id string) error
	PartialReleaseEscrow(ctx context.Context, id string, amount int64) error
	DisputeEscrow(ctx context.Context, id string, disputerID, reason string) error
	ResolveDispute(ctx context.Context, id string, resolution string) error
	
	// Subscriptions
	CreateSubscriptionPlan(ctx context.Context, plan *SubscriptionPlan) error
	GetSubscriptionPlan(ctx context.Context, planID string) (*SubscriptionPlan, error)
	ListSubscriptionPlans(ctx context.Context, isActive bool) ([]*SubscriptionPlan, error)
	CreateUserSubscription(ctx context.Context, sub *UserSubscription) error
	GetUserSubscription(ctx context.Context, userID string) (*UserSubscription, error)
	GetUserSubscriptions(ctx context.Context, userID string) ([]*UserSubscription, error)
	UpdateUserSubscription(ctx context.Context, subID string, updates *UserSubscription) error
	CancelSubscription(ctx context.Context, subID string) error
	RenewSubscription(ctx context.Context, subID string) error
	
	// Payment Methods
	AddPaymentMethod(ctx context.Context, method *PaymentMethod) error
	GetPaymentMethods(ctx context.Context, userID string) ([]*PaymentMethod, error)
	UpdatePaymentMethod(ctx context.Context, methodID string, updates *PaymentMethod) error
	DeletePaymentMethod(ctx context.Context, methodID string) error
	SetDefaultPaymentMethod(ctx context.Context, userID, methodID string) error
	
	// Invoices
	CreateInvoice(ctx context.Context, invoice *Invoice) error
	GetInvoice(ctx context.Context, invoiceID string) (*Invoice, error)
	GetUserInvoices(ctx context.Context, userID string, status string, limit, offset int32) ([]*Invoice, error)
	UpdateInvoiceStatus(ctx context.Context, invoiceID string, status string) error
	PayInvoice(ctx context.Context, invoiceID string, paymentMethodID string) error
	
	// Revenue Reports
	CreateRevenueReport(ctx context.Context, report *RevenueReport) error
	GetRevenueReport(ctx context.Context, reportID string) (*RevenueReport, error)
	GetUserRevenueReports(ctx context.Context, userID string, period string, limit, offset int32) ([]*RevenueReport, error)
	GenerateRevenueReport(ctx context.Context, userID string, period string) (*RevenueReport, error)
	
	// Analytics
	GetFinancialOverview(ctx context.Context, userID string, period string) (*FinancialOverview, error)
	GetTransactionAnalytics(ctx context.Context, userID string, period string) (*TransactionAnalytics, error)
}

type TransferRequest struct {
	ReceiverID string
	Amount     int64
	Type       string
	EntityType *string
	EntityID   *string
}

type FinancialOverview struct {
	UserID            string
	Period             string
	TotalBalance       int64
	AvailableBalance  int64
	FrozenBalance     int64
	TotalRevenue       int64
	TotalExpenses      int64
	NetProfit          int64
	TransactionCount   int64
	TipRevenue         int64
	ContentRevenue     int64
	SubscriptionRevenue int64
	MarketplaceRevenue int64
	GrowthRate         float64
	PredictedRevenue   int64
}

type TransactionAnalytics struct {
	UserID              string
	Period              string
	TotalTransactions   int64
	TotalVolume         int64
	AverageTransaction  float64
	PeakTransactionDay  string
	TopIncomeSources   []IncomeSource
	SpendingCategories  []SpendingCategory
	PaymentMethods     []PaymentMethodUsage
	FeesPaid           int64
	RefundsReceived     int64
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
	// Wallet Management
	GetBalance(ctx context.Context, userID string) (int64, error)
	GetWallet(ctx context.Context, userID string) (*Wallet, error)
	CreateWallet(ctx context.Context, userID string) (*Wallet, error)
	FreezeWallet(ctx context.Context, userID string, freeze bool) error
	UpdateWalletSettings(ctx context.Context, userID string, settings *WalletSettings) error
	
	// Transaction Management
	TipUser(ctx context.Context, senderID, receiverID string, amount int32) error
	UnlockContent(ctx context.Context, userID, postID string, amount int32) error
	TransferFunds(ctx context.Context, senderID, receiverID string, amount int64, description string) error
	BatchTransfer(ctx context.Context, transfers []TransferRequest) error
	GetTransaction(ctx context.Context, txID string) (*Transaction, error)
	GetUserTransactions(ctx context.Context, userID string, filters map[string]interface{}) ([]*Transaction, error)
	ReverseTransaction(ctx context.Context, txID string, reason string) error
	
	// Escrow Management
	InitiateEscrow(ctx context.Context, buyerID, sellerID string, amount int64, description string) (*EscrowRecord, error)
	ReleaseEscrow(ctx context.Context, escrowID, userID string) error
	RefundEscrow(ctx context.Context, escrowID, userID string) error
	PartialReleaseEscrow(ctx context.Context, escrowID string, amount int64) error
	DisputeEscrow(ctx context.Context, escrowID string, reason string) error
	ResolveDispute(ctx context.Context, escrowID string, resolution string) error
	GetEscrow(ctx context.Context, escrowID string) (*EscrowRecord, error)
	
	// Subscription Management
	CreateSubscriptionPlan(ctx context.Context, plan *SubscriptionPlan) error
	SubscribeToPlan(ctx context.Context, userID, planID string) (*UserSubscription, error)
	CancelSubscription(ctx context.Context, subID string) error
	RenewSubscription(ctx context.Context, subID string) error
	UpgradeSubscription(ctx context.Context, userID, newPlanID string) error
	GetUserSubscription(ctx context.Context, userID string) (*UserSubscription, error)
	ListSubscriptionPlans(ctx context.Context) ([]*SubscriptionPlan, error)
	
	// Payment Method Management
	AddPaymentMethod(ctx context.Context, userID, methodType, provider, displayInfo string) (*PaymentMethod, error)
	GetPaymentMethods(ctx context.Context, userID string) ([]*PaymentMethod, error)
	DeletePaymentMethod(ctx context.Context, methodID string) error
	SetDefaultPaymentMethod(ctx context.Context, userID, methodID string) error
	
	// Invoice Management
	CreateInvoice(ctx context.Context, userID string, items []InvoiceItem, dueDate time.Time) (*Invoice, error)
	GetInvoice(ctx context.Context, invoiceID string) (*Invoice, error)
	GetUserInvoices(ctx context.Context, userID string, status string) ([]*Invoice, error)
	PayInvoice(ctx context.Context, invoiceID string, paymentMethodID string) error
	
	// Revenue & Analytics
	GetFinancialOverview(ctx context.Context, userID string, period string) (*FinancialOverview, error)
	GetTransactionAnalytics(ctx context.Context, userID string, period string) (*TransactionAnalytics, error)
	GenerateRevenueReport(ctx context.Context, userID string, period string) (*RevenueReport, error)
	GetRevenueReports(ctx context.Context, userID string, period string) ([]*RevenueReport, error)
	
	// Limits & Compliance
	CheckTransferLimits(ctx context.Context, userID string, amount int64) (bool, error)
	GetWalletLimits(ctx context.Context, userID string) (*WalletLimits, error)
	UpdateWalletLimits(ctx context.Context, userID string, limits *WalletLimits) error
	ComplianceCheck(ctx context.Context, userID string) (*ComplianceStatus, error)
}

type ComplianceStatus struct {
	IsCompliant    bool
	RequirementsMet []string
	Violations      []string
	Restrictions    []string
	NextReviewDate time.Time
}
