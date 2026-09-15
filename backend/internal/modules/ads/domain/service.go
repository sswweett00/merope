package domain

import (
	"context"
	"time"
)

type AdsService interface {
	ServeAds(ctx context.Context, userInterests []string) ([]*Ad, error)
	CreateCampaign(ctx context.Context, advertiserID, name string, budget int32) (*AdCampaign, error)
	RecordConversion(ctx context.Context, clickID string, conversionType string, value int32) (*AdConversion, error)
}

type DemandService interface {
	CreateAdAccount(ctx context.Context, tenantID, userID string) (*AdAccount, error)
	CreateCampaign(ctx context.Context, adAccountID, name, objective string, budgetTotal, budgetDaily int32, startAt, endAt time.Time) (*Campaign, error)
	CreateAdGroup(ctx context.Context, campaignID, name, bidStrategy string, bidAmount int32, pacing string) (*AdGroup, error)
	CreateCreative(ctx context.Context, adGroupID, name, creativeType, mediaURL, contentText, ctaText, landingURL string) (*Creative, error)
	CreateAudience(ctx context.Context, adAccountID, name, targetingJSON string) (*Audience, error)
	PlaceBid(ctx context.Context, adGroupID, bidType string, bidAmount, maxSpend int32) (*Bid, error)
	GetCampaignAnalytics(ctx context.Context, campaignID string, from, to time.Time) (*CampaignAnalytics, error)
	GetAdGroupAnalytics(ctx context.Context, adGroupID string, from, to time.Time) (*AdGroupAnalytics, error)
}

type SupplyService interface {
	CreatePublisherAccount(ctx context.Context, tenantID, userID string) (*PublisherAccount, error)
	CreateSite(ctx context.Context, publisherAccountID, name, url, contentRating string) (*Site, error)
	CreateAdPlacement(ctx context.Context, publisherAccountID, siteID, name, placementType string, floorPriceCPM int32, adRulesJSON string) (*AdPlacement, error)
	GenerateAdTag(ctx context.Context, placementID, tagType string) (*AdTag, error)
	GetPlacementTag(ctx context.Context, placementID string) (*AdTag, error)
	GetPublisherEarnings(ctx context.Context, publisherAccountID string, from, to time.Time) (*EarningsReport, error)
	RequestPayout(ctx context.Context, publisherAccountID string, amount int32) (*Payout, error)
}

type ServeAdResponse struct {
	CreativeID    string
	MediaURL      string
	ContentText   string
	CTAText       string
	LandingURL    string
	ImpressionID  string
	TrackingPixels []string
}

type CampaignAnalytics struct {
	CampaignID   string
	Impressions  int32
	Clicks       int32
	Conversions  int32
	Spend        int32
	CTR          float64
	CPC          float64
	CPA          float64
	RoAS         float64
}

type AdGroupAnalytics struct {
	AdGroupID    string
	Impressions  int32
	Clicks       int32
	Conversions  int32
	Spend        int32
	CTR          float64
	CPC          float64
	CPA          float64
}

type EarningsReport struct {
	PublisherAccountID string
	Impressions        int32
	Revenue            int32
	FillRate           float64
	ECPM              float32
	Payouts            []*Payout
}
