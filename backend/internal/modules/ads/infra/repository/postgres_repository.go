package repository

import (
	"context"
	"encoding/json"
	"log/slog"

	"local/merope/internal/modules/ads/domain"
	"local/merope/internal/platform/postgres"
)

type postgresAdsRepository struct {
	client *postgres.Client
}

func NewPostgresAdsRepository(client *postgres.Client) domain.AdsRepository {
	return &postgresAdsRepository{client: client}
}

func (r *postgresAdsRepository) pool() *pgxpool.Pool {
	return r.client.CorePool
}

func (r *postgresAdsRepository) GetActiveAds(ctx context.Context) ([]*domain.Ad, error) {
	query := `SELECT id, campaign_id, title, content_text, media_url, targeting_interests, status FROM ads WHERE status = 'ACTIVE'`
	rows, err := r.pool().Query(ctx, query)
	if err != nil {
		slog.Error("failed to query active ads", "error", err)
		return nil, err
	}
	defer rows.Close()

	var ads []*domain.Ad
	for rows.Next() {
		ad := &domain.Ad{}
		var interests []byte
		if err := rows.Scan(&ad.ID, &ad.CampaignID, &ad.Title, &ad.ContentText, &ad.MediaURL, &interests, &ad.Status); err != nil {
			slog.Error("failed to scan ad row", "error", err)
			return nil, err
		}
		if len(interests) > 0 {
			if err := json.Unmarshal(interests, &ad.TargetingInterests); err != nil {
				slog.Warn("failed to decode ad targeting interests", "error", err, "ad_id", ad.ID)
			}
		}
		ads = append(ads, ad)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return ads, nil
}

func (r *postgresAdsRepository) CreateCampaign(ctx context.Context, campaign *domain.AdCampaign) error {
	query := `INSERT INTO ad_campaigns (id, advertiser_id, name, budget_total, budget_remaining, status) VALUES ($1, $2, $3, $4, $5, $6)`
	_, err := r.pool().Exec(ctx, query, campaign.ID, campaign.AdvertiserID, campaign.Name, campaign.BudgetTotal, campaign.BudgetRemaining, campaign.Status)
	if err != nil {
		slog.Error("failed to create ad campaign", "error", err, "campaign_id", campaign.ID)
	}
	return err
}

func (r *postgresAdsRepository) UpdateBudget(ctx context.Context, campaignID string, amount int32) error {
	query := `UPDATE ad_campaigns SET budget_remaining = budget_remaining - $1 WHERE id = $2`
	_, err := r.pool().Exec(ctx, query, amount, campaignID)
	if err != nil {
		slog.Error("failed to update campaign budget", "error", err, "campaign_id", campaignID)
	}
	return err
}

func (r *postgresAdsRepository) CreateAdConversion(ctx context.Context, conversion *domain.AdConversion) error {
	query := `INSERT INTO ad_conversions (id, click_id, conversion_type, value, currency, conversion_timestamp) VALUES ($1, $2, $3, $4, $5, $6)`
	_, err := r.pool().Exec(ctx, query, conversion.ID, conversion.ClickID, conversion.ConversionType, conversion.Value, conversion.Currency, conversion.ConversionTimestamp)
	if err != nil {
		slog.Error("failed to create ad conversion", "error", err, "click_id", conversion.ClickID)
	}
	return err
}
