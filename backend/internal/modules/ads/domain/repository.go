package domain

import (
	"context"
	"time"
)

type AdsRepository interface {
	GetActiveAds(ctx context.Context) ([]*Ad, error)
	CreateCampaign(ctx context.Context, campaign *AdCampaign) error
	UpdateBudget(ctx context.Context, campaignID string, amount int32) error
}

type DemandRepository interface {
	CreateAdAccount(ctx context.Context, account *AdAccount) error
	GetAdAccount(ctx context.Context, id string) (*AdAccount, error)
	CreateCampaign(ctx context.Context, campaign *Campaign) error
	GetCampaign(ctx context.Context, id string) (*Campaign, error)
	ListCampaigns(ctx context.Context, adAccountID string) ([]*Campaign, error)
	CreateAdGroup(ctx context.Context, group *AdGroup) error
	GetAdGroup(ctx context.Context, id string) (*AdGroup, error)
	ListAdGroups(ctx context.Context, campaignID string) ([]*AdGroup, error)
	CreateCreative(ctx context.Context, creative *Creative) error
	GetCreative(ctx context.Context, id string) (*Creative, error)
	ListCreatives(ctx context.Context, adGroupID string) ([]*Creative, error)
	CreateAudience(ctx context.Context, audience *Audience) error
	GetAudience(ctx context.Context, id string) (*Audience, error)
	ListAudiences(ctx context.Context, adAccountID string) ([]*Audience, error)
	CreateBid(ctx context.Context, bid *Bid) error
	GetBid(ctx context.Context, id string) (*Bid, error)
	ListBids(ctx context.Context, adGroupID string) ([]*Bid, error)
	CreateSpendRecord(ctx context.Context, record *SpendRecord) error
	GetSpendRecords(ctx context.Context, adAccountID string, from, to time.Time) ([]*SpendRecord, error)
}

type SupplyRepository interface {
	CreatePublisherAccount(ctx context.Context, account *PublisherAccount) error
	GetPublisherAccount(ctx context.Context, id string) (*PublisherAccount, error)
	CreateSite(ctx context.Context, site *Site) error
	GetSite(ctx context.Context, id string) (*Site, error)
	ListSites(ctx context.Context, publisherAccountID string) ([]*Site, error)
	CreateAdPlacement(ctx context.Context, placement *AdPlacement) error
	GetAdPlacement(ctx context.Context, id string) (*AdPlacement, error)
	ListAdPlacements(ctx context.Context, publisherAccountID string) ([]*AdPlacement, error)
	CreateAdTag(ctx context.Context, tag *AdTag) error
	GetAdTag(ctx context.Context, id string) (*AdTag, error)
	ListAdTags(ctx context.Context, placementID string) ([]*AdTag, error)
	CreatePayout(ctx context.Context, payout *Payout) error
	GetPayout(ctx context.Context, id string) (*Payout, error)
	ListPayouts(ctx context.Context, publisherAccountID string) ([]*Payout, error)
	UpdatePayout(ctx context.Context, payout *Payout) error
}

type AuctionRepository interface {
	CreateAuctionLog(ctx context.Context, log *AuctionLog) error
	GetAuctionLog(ctx context.Context, id string) (*AuctionLog, error)
	ListAuctionLogs(ctx context.Context, placementID string, from, to time.Time) ([]*AuctionLog, error)
	CreateAdImpression(ctx context.Context, impression *AdImpression) error
	GetAdImpression(ctx context.Context, id string) (*AdImpression, error)
	ListAdImpressions(ctx context.Context, filters ImpressionFilters) ([]*AdImpression, error)
	CreateAdClick(ctx context.Context, click *AdClick) error
	GetAdClick(ctx context.Context, id string) (*AdClick, error)
	ListAdClicks(ctx context.Context, impressionID string) ([]*AdClick, error)
	CreateAdConversion(ctx context.Context, conversion *AdConversion) error
	GetAdConversion(ctx context.Context, id string) (*AdConversion, error)
	ListAdConversions(ctx context.Context, clickID string) ([]*AdConversion, error)
}

type ImpressionFilters struct {
	PlacementID  string
	CreativeID   string
	PublisherID  string
	AdvertiserID string
	CampaignID   string
	From         time.Time
	To           time.Time
	Limit        int
	Offset       int
}
