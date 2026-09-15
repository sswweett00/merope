package repository

import (
	"context"
	"local/merope/internal/modules/ads/domain"
	"sync"
)

type inMemoryAdsRepository struct {
	mu        sync.RWMutex
	ads       []*domain.Ad
	campaigns map[string]*domain.AdCampaign
}

func NewInMemoryAdsRepository() domain.AdsRepository {
	repo := &inMemoryAdsRepository{
		ads:       make([]*domain.Ad, 0),
		campaigns: make(map[string]*domain.AdCampaign),
	}

	// Mock veriler ekleyelim
	repo.ads = append(repo.ads, &domain.Ad{
		ID:                 "1",
		ContentText:        "Merope Premium'u Keşfedin!",
		TargetingInterests: []string{"tech", "productivity"},
		MediaURL:           "https://picsum.photos/200/100",
	})

	return repo
}

func (r *inMemoryAdsRepository) GetActiveAds(ctx context.Context) ([]*domain.Ad, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return r.ads, nil
}

func (r *inMemoryAdsRepository) CreateCampaign(ctx context.Context, campaign *domain.AdCampaign) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.campaigns[campaign.ID] = campaign
	return nil
}

func (r *inMemoryAdsRepository) UpdateBudget(ctx context.Context, campaignID string, amount int32) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	if c, ok := r.campaigns[campaignID]; ok {
		c.BudgetRemaining -= amount
	}
	return nil
}
