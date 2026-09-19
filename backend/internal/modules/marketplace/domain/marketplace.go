package domain

import (
	"context"
	"time"
)

type Product struct {
	ID            string
	SellerID      string
	Name          string
	Slug          string
	Description   string
	Price         int32
	Currency      string
	StockQuantity int32
	Category      string
	Subcategory   string
	MediaURLs     []string
	IsDigital     bool
	Rating        float32
	ReviewCount   int32
	SoldCount     int32
	ViewCount     int32
	Condition     string // new, used, refurbished
	Brand         string
	Model         string
	SKU           string
	Weight        float32 // kg
	Dimensions    ProductDimensions
	ShippingInfo  ShippingInfo
	IsActive      bool
	IsFeatured    bool
	IsVerified    bool
	CreatedAt     time.Time
	UpdatedAt     time.Time
	Tags          []string
	Attributes    map[string]string
	SEO           ProductSEO
}

type ProductDimensions struct {
	Length float32 // cm
	Width  float32 // cm
	Height float32 // cm
}

type ShippingInfo struct {
	IsFree        bool
	FlatRate      float32
	Provider      string
	EstimatedDays int32
	International bool
}

type ProductSEO struct {
	Title       string
	Description string
	Keywords    []string
	MetaTags    map[string]string
}

type Seller struct {
	ID             string
	UserID         string
	BusinessName   string
	Description    string
	AvatarURL      string
	BannerURL      string
	IsVerified     bool
	Rating         float32
	ReviewCount    int32
	TotalSales     int32
	ActiveListings int32
	ResponseTime   int32 // hours
	ShippingPolicy string
	ReturnPolicy   string
	CreatedAt      time.Time
	UpdatedAt      time.Time
	Settings       SellerSettings
	Stats          SellerStats
}

type SellerSettings struct {
	AcceptInternationalOrders bool
	MinimumOrderAmount        float32
	AutoAcceptOrders          bool
	NotifyOnSale              bool
	EnableChat                bool
	EnableOffers              bool
	MinimumOfferPercent       float32
	BusinessHours             []BusinessHour
}

type BusinessHour struct {
	DayOfWeek int    // 0-6 (Sunday-Saturday)
	OpenTime  string // "09:00"
	CloseTime string // "17:00"
	IsClosed  bool
}

type SellerStats struct {
	MonthlyRevenue  float32
	MonthlyOrders   int32
	MonthlyVisitors int32
	ConversionRate  float32
	AvgOrderValue   float32
	ReturnRate      float32
}

type Order struct {
	ID              string
	BuyerID         string
	SellerID        string
	OrderNumber     string
	TotalAmount     int32
	Currency        string
	Status          string // pending, confirmed, processing, shipped, delivered, cancelled, refunded
	ShippingAddress ShippingAddress
	BillingAddress  ShippingAddress
	Items           []OrderItem
	PaymentInfo     PaymentInfo
	ShippingInfo    OrderShippingInfo
	Discount        OrderDiscount
	Tax             int32
	Notes           string
	CreatedAt       time.Time
	UpdatedAt       time.Time
	StatusHistory   []OrderStatusHistory
}

type ShippingAddress struct {
	FullName     string
	AddressLine1 string
	AddressLine2 string
	City         string
	State        string
	PostalCode   string
	Country      string
	Phone        string
	IsDefault    bool
}

type OrderItem struct {
	ProductID       string
	ProductName     string
	Quantity        int32
	PriceAtPurchase int32
	DiscountAmount  int32
	Subtotal        int32
	VariantInfo     map[string]string
	CustomFields    map[string]string
}

type PaymentInfo struct {
	Method        string // credit_card, paypal, pulse, bank_transfer
	Status        string // pending, completed, failed, refunded
	TransactionID string
	PaidAt        *time.Time
	RefundedAt    *time.Time
	RefundAmount  int32
	Metadata      map[string]interface{}
}

type OrderShippingInfo struct {
	Provider          string
	TrackingNumber    string
	EstimatedDelivery *time.Time
	ActualDelivery    *time.Time
	ShippingCost      int32
	Status            string // pending, shipped, delivered, returned
}

type OrderDiscount struct {
	Code        string
	Type        string // percentage, fixed, free_shipping
	Amount      int32
	Description string
	IsValid     bool
}

type OrderStatusHistory struct {
	Status    string
	Timestamp time.Time
	ChangedBy string // user_id or system
	Reason    string
}

type PulseTransaction struct {
	ID          string
	FromID      string
	ToID        string
	Amount      int32
	Currency    string
	RefType     string // "order", "transfer", "gift", "refund", "escrow"
	RefID       string
	Status      string // pending, completed, failed, cancelled
	CreatedAt   time.Time
	ProcessedAt *time.Time
	Fee         int32
	Metadata    map[string]interface{}
}

type Wishlist struct {
	ID         string
	UserID     string
	Name       string
	IsPublic   bool
	ProductIDs []string
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type ProductReview struct {
	ID                 string
	ProductID          string
	UserID             string
	Rating             int32 // 1-5
	Title              string
	Comment            string
	MediaURLs          []string
	IsVerified         bool
	IsVerifiedPurchase bool
	CreatedAt          time.Time
	UpdatedAt          time.Time
	HelpfulCount       int32
	Reply              *ReviewReply
}

type ReviewReply struct {
	Content   string
	AuthorID  string
	CreatedAt time.Time
	UpdatedAt time.Time
}

type DiscountCode struct {
	ID                   string
	Code                 string
	Description          string
	DiscountType         string // percentage, fixed, free_shipping
	Amount               int32
	MinPurchase          int32
	MaxUses              int32
	UsedCount            int32
	ValidFrom            time.Time
	ValidUntil           time.Time
	IsActive             bool
	ApplicableCategories []string
	ApplicableProducts   []string
}

type Escrow struct {
	ID          string
	OrderID     string
	BuyerID     string
	SellerID    string
	Amount      int32
	Currency    string
	Status      string // pending, released, refunded, disputed
	ReleaseDate *time.Time
	CreatedAt   time.Time
	Conditions  EscrowConditions
}

type EscrowConditions struct {
	AutoReleaseDays   int32
	AllowDispute      bool
	DisputeWindowDays int32
}

type MarketplaceRepository interface {
	// Products
	CreateProduct(ctx context.Context, p *Product) error
	GetProduct(ctx context.Context, id string) (*Product, error)
	GetProductBySlug(ctx context.Context, slug string) (*Product, error)
	UpdateProduct(ctx context.Context, id string, updates *Product) error
	DeleteProduct(ctx context.Context, id string) error
	ListProducts(ctx context.Context, category, subcategory string, search string, filters map[string]interface{}, limit, offset int32) ([]*Product, error)
	GetSellerProducts(ctx context.Context, sellerID string, limit, offset int32) ([]*Product, error)
	GetFeaturedProducts(ctx context.Context, limit int32) ([]*Product, error)
	GetTrendingProducts(ctx context.Context, limit int32) ([]*Product, error)
	UpdateProductStock(ctx context.Context, productID string, quantity int32) error

	// Sellers
	CreateSeller(ctx context.Context, seller *Seller) error
	GetSeller(ctx context.Context, sellerID string) (*Seller, error)
	GetSellerByUserID(ctx context.Context, userID string) (*Seller, error)
	UpdateSeller(ctx context.Context, sellerID string, updates *Seller) error
	GetTopSellers(ctx context.Context, limit int32) ([]*Seller, error)
	VerifySeller(ctx context.Context, sellerID string) error

	// Orders
	CreateOrder(ctx context.Context, o *Order) error
	GetOrder(ctx context.Context, orderID string) (*Order, error)
	GetOrderByNumber(ctx context.Context, orderNumber string) (*Order, error)
	GetUserOrders(ctx context.Context, userID string, status string, limit, offset int32) ([]*Order, error)
	UpdateOrderStatus(ctx context.Context, orderID string, status string, reason string) error
	AddOrderStatusHistory(ctx context.Context, orderID string, history *OrderStatusHistory) error

	// Payments
	RecordTransaction(ctx context.Context, tx *PulseTransaction) error
	GetTransaction(ctx context.Context, txID string) (*PulseTransaction, error)
	GetUserTransactions(ctx context.Context, userID string, limit, offset int32) ([]*PulseTransaction, error)
	RefundTransaction(ctx context.Context, txID string, amount int32, reason string) error

	// Wishlist
	CreateWishlist(ctx context.Context, wishlist *Wishlist) error
	GetWishlist(ctx context.Context, userID string) ([]*Wishlist, error)
	GetWishlistByUser(ctx context.Context, userID string) (*Wishlist, error)
	AddToWishlist(ctx context.Context, userID, productID string) error
	RemoveFromWishlist(ctx context.Context, userID, productID string) error
	UpdateWishlist(ctx context.Context, wishlistID string, updates *Wishlist) error

	// Reviews
	CreateReview(ctx context.Context, review *ProductReview) error
	GetProductReviews(ctx context.Context, productID string, limit, offset int32) ([]*ProductReview, error)
	GetUserReviews(ctx context.Context, userID string, limit, offset int32) ([]*ProductReview, error)
	UpdateReview(ctx context.Context, reviewID string, updates *ProductReview) error
	DeleteReview(ctx context.Context, reviewID string) error
	MarkReviewHelpful(ctx context.Context, reviewID, userID string) error
	ReplyToReview(ctx context.Context, reviewID, sellerID, content string) error

	// Discounts
	CreateDiscountCode(ctx context.Context, code *DiscountCode) error
	GetDiscountCode(ctx context.Context, code string) (*DiscountCode, error)
	ValidateDiscountCode(ctx context.Context, code string, userID string) (*DiscountCode, error)
	GetActiveDiscountCodes(ctx context.Context, limit int32) ([]*DiscountCode, error)
	UpdateDiscountCode(ctx context.Context, codeID string, updates *DiscountCode) error
	IncrementDiscountUsage(ctx context.Context, codeID string) error

	// Escrow
	CreateEscrow(ctx context.Context, escrow *Escrow) error
	GetEscrow(ctx context.Context, escrowID string) (*Escrow, error)
	GetOrderEscrow(ctx context.Context, orderID string) (*Escrow, error)
	ReleaseEscrow(ctx context.Context, escrowID string) error
	RefundEscrow(ctx context.Context, escrowID string, reason string) error
	DisputeEscrow(ctx context.Context, escrowID string, reason string) error

	// Analytics
	GetSellerAnalytics(ctx context.Context, sellerID string, period string) (*SellerStats, error)
	GetProductAnalytics(ctx context.Context, productID string, period string) (map[string]interface{}, error)
	GetMarketplaceStats(ctx context.Context, period string) (*MarketplaceStats, error)
}

type MarketplaceStats struct {
	TotalProducts  int32
	TotalSellers   int32
	TotalOrders    int32
	TotalRevenue   float32
	ActiveBuyers   int32
	ConversionRate float32
	AvgOrderValue  float32
	TopCategories  []string
	GrowthRate     float32
}

type MarketplaceService interface {
	// Product Management
	PostProduct(ctx context.Context, p *Product) error
	UpdateProduct(ctx context.Context, productID string, updates *Product) error
	DeleteProduct(ctx context.Context, productID string) error
	SearchProducts(ctx context.Context, query string, filters map[string]interface{}) ([]*Product, error)
	GetProduct(ctx context.Context, productID string) (*Product, error)
	GetFeaturedProducts(ctx context.Context, limit int32) ([]*Product, error)
	GetTrendingProducts(ctx context.Context, limit int32) ([]*Product, error)

	// Order Management
	Purchase(ctx context.Context, buyerID string, productIDs []string, quantities []int32, address ShippingAddress) (*Order, error)
	ProcessOrder(ctx context.Context, orderID string) error
	ShipOrder(ctx context.Context, orderID string, trackingNumber string) error
	DeliverOrder(ctx context.Context, orderID string) error
	CancelOrder(ctx context.Context, orderID string, reason string) error
	RefundOrder(ctx context.Context, orderID string, reason string, amount int32) error
	GetOrder(ctx context.Context, orderID string) (*Order, error)
	GetUserOrders(ctx context.Context, userID string, status string) ([]*Order, error)

	// Payment Processing
	ExecutePulsePay(ctx context.Context, fromID, toID string, amount int32) error
	ProcessPayment(ctx context.Context, orderID string, paymentMethod string, paymentDetails map[string]interface{}) error
	RefundPayment(ctx context.Context, orderID string, amount int32, reason string) error

	// Wishlist & Ratings
	ManageWishlist(ctx context.Context, userID, productID string, add bool) error
	GetWishlist(ctx context.Context, userID string) ([]*Product, error)
	CreateWishlist(ctx context.Context, userID, name string) (*Wishlist, error)
	ReviewProduct(ctx context.Context, userID, productID string, rating int, comment string) error
	UpdateReview(ctx context.Context, reviewID string, updates *ProductReview) error
	ReplyToReview(ctx context.Context, reviewID, sellerID, content string) error
	MarkReviewHelpful(ctx context.Context, reviewID, userID string) error

	// Seller Management
	BecomeSeller(ctx context.Context, userID, businessName string) (*Seller, error)
	UpdateSellerProfile(ctx context.Context, sellerID string, updates *Seller) error
	GetSellerProfile(ctx context.Context, sellerID string) (*Seller, error)
	GetSellerAnalytics(ctx context.Context, sellerID string, period string) (*SellerStats, error)
	VerifySeller(ctx context.Context, sellerID string) error

	// Discount Management
	CreateDiscountCode(ctx context.Context, code *DiscountCode) error
	ValidateDiscountCode(ctx context.Context, code string, userID string) (*DiscountCode, error)
	GetActiveDiscounts(ctx context.Context) ([]*DiscountCode, error)

	// Escrow Management
	CreateEscrow(ctx context.Context, orderID string, amount int32) (*Escrow, error)
	ReleaseEscrow(ctx context.Context, escrowID string) error
	RefundEscrow(ctx context.Context, escrowID string, reason string) error
	DisputeEscrow(ctx context.Context, escrowID string, reason string) error

	// Discovery
	GetRecommendedProducts(ctx context.Context, userID string, limit int32) ([]*Product, error)
	GetCategoryProducts(ctx context.Context, category string, limit int32) ([]*Product, error)
	GetSimilarProducts(ctx context.Context, productID string, limit int32) ([]*Product, error)

	// Analytics
	GetMarketplaceStats(ctx context.Context, period string) (*MarketplaceStats, error)
	GetProductAnalytics(ctx context.Context, productID string, period string) (map[string]interface{}, error)
}
