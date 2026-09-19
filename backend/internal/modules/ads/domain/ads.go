package domain

import (
	"time"
)

type Ad struct {
	ID                 string
	CampaignID         string
	Title              string
	ContentText        string
	MediaURL           string
	TargetingInterests []string
	Status             string
}

type AdCampaign struct {
	ID              string
	AdvertiserID    string
	Name            string
	BudgetTotal     int32
	BudgetRemaining int32
	Status          string
}

type AdAccount struct {
	ID               string
	TenantID         string
	UserID           string
	BillingProfileID string
	Status           string
	CreatedAt        time.Time
}

type Campaign struct {
	ID          string
	TenantID    string
	AdAccountID string
	Name        string
	Objective   string
	BudgetTotal int32
	BudgetDaily int32
	StartAt     time.Time
	EndAt       time.Time
	Status      string
	CreatedAt   time.Time
}

type AdGroup struct {
	ID          string
	CampaignID  string
	Name        string
	BidStrategy string
	BidAmount   int32
	Pacing      string
	Status      string
}

type Creative struct {
	ID               string
	AdGroupID        string
	Name             string
	Type             string
	MediaURL         string
	ContentText      string
	CTAText          string
	LandingURL       string
	Status           string
	ComplianceStatus string
	CreatedAt        time.Time
}

type Audience struct {
	ID            string
	AdAccountID   string
	Name          string
	TargetingJSON string
	Status        string
}

type Bid struct {
	ID        string
	AdGroupID string
	BidType   string
	BidAmount int32
	MaxSpend  int32
	Status    string
}

type PublisherAccount struct {
	ID              string
	TenantID        string
	UserID          string
	PayoutProfileID string
	Status          string
	CreatedAt       time.Time
}

type AdPlacement struct {
	ID                 string
	PublisherAccountID string
	SiteID             string
	Name               string
	Type               string
	FloorPriceCPM      int32
	AdRulesJSON        string
	Status             string
	CreatedAt          time.Time
}

type AdTag struct {
	ID          string
	PlacementID string
	TagCode     string
	TagType     string
	Status      string
}

type Site struct {
	ID            string
	TenantID      string
	PublisherID   string
	Name          string
	URL           string
	ContentRating string
	Status        string
	CreatedAt     time.Time
}

type Payout struct {
	ID                 string
	PublisherAccountID string
	PlacementID        string
	Date               time.Time
	Impressions        int32
	Revenue            int32
	Currency           string
	Status             string
}

type AuctionLog struct {
	ID               string
	PlacementID      string
	UserSegment      string
	WinnerCreativeID string
	WinPriceCPM      int32
	Timestamp        time.Time
}

type AdImpression struct {
	ID           string
	AuctionLogID string
	CreativeID   string
	PlacementID  string
	PublisherID  string
	AdvertiserID string
	CampaignID   string
	AdGroupID    string
	UserHash     string
	IPHash       string
	UAHash       string
	Timestamp    time.Time
}

type AdClick struct {
	ID             string
	ImpressionID   string
	CreativeID     string
	ClickTimestamp time.Time
	RedirectURL    string
	IsFraud        bool
}

type AdConversion struct {
	ID                  string
	ClickID             string
	ConversionType      string
	Value               int32
	Currency            string
	ConversionTimestamp time.Time
}

type SpendRecord struct {
	ID          string
	AdAccountID string
	CampaignID  string
	AdGroupID   string
	Date        time.Time
	Impressions int32
	Clicks      int32
	Spend       int32
	Currency    string
}

type BidRequest struct {
	AuctionID   string
	PlacementID string
	UserSegment string
	FloorCPM    int32
	Timestamp   time.Time
}

type BidResponse struct {
	AuctionID  string
	CreativeID string
	PriceCPM   int32
	Adm        string
	ExtData    string
}

type AuctionResult struct {
	AuctionID    string
	Status       string
	ImpressionID string
	WinPriceCPM  int32
}
