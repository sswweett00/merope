package service

import (
	"context"
	"strings"
	"time"

	"github.com/google/uuid"

	"local/merope/internal/modules/ads/domain"
)

type adsService struct {
	repo        domain.AdsRepository
	auctionRepo domain.AuctionRepository
}

func NewAdsService(repo domain.AdsRepository, auctionRepo domain.AuctionRepository) domain.AdsService {
	return &adsService{
		repo:        repo,
		auctionRepo: auctionRepo,
	}
}

func (s *adsService) ServeAds(ctx context.Context, userInterests []string) ([]*domain.Ad, error) {
	allAds, err := s.repo.GetActiveAds(ctx)
	if err != nil {
		return nil, err
	}

	// Case-insensitive matching
	var filteredAds []*domain.Ad
	normalizedInterests := make([]string, len(userInterests))
	for i, interest := range userInterests {
		normalizedInterests[i] = strings.ToLower(interest)
	}

	for _, ad := range allAds {
		if len(ad.TargetingInterests) == 0 {
			filteredAds = append(filteredAds, ad)
			continue
		}

		match := false
		for _, interest := range normalizedInterests {
			for _, target := range ad.TargetingInterests {
				if interest == strings.ToLower(target) {
					match = true
					break
				}
			}
			if match {
				break
			}
		}

		if match {
			filteredAds = append(filteredAds, ad)
		}
	}

	return filteredAds, nil
}

func (s *adsService) CreateCampaign(ctx context.Context, advertiserID, name string, budget int32) (*domain.AdCampaign, error) {
	campaign := &domain.AdCampaign{
		AdvertiserID:    advertiserID,
		Name:            name,
		BudgetTotal:     budget,
		BudgetRemaining: budget,
		Status:          "ACTIVE",
	}

	err := s.repo.CreateCampaign(ctx, campaign)
	if err != nil {
		return nil, err
	}

	return campaign, nil
}

func (s *adsService) RecordConversion(ctx context.Context, clickID string, conversionType string, value int32) (*domain.AdConversion, error) {
	conversion := &domain.AdConversion{
		ID:                  uuid.New().String(),
		ClickID:             clickID,
		ConversionType:      conversionType,
		Value:               value,
		Currency:            "USD",
		ConversionTimestamp: time.Now(),
	}

	err := s.auctionRepo.CreateAdConversion(ctx, conversion)
	if err != nil {
		return nil, err
	}

	return conversion, nil
}
