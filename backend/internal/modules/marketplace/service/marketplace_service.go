package service

import (
	"context"
	"fmt"
	"local/merope/internal/modules/marketplace/domain"
)

type marketplaceService struct {
	repo domain.MarketplaceRepository
}

func NewMarketplaceService(repo domain.MarketplaceRepository) domain.MarketplaceService {
	return &marketplaceService{repo: repo}
}

func (s *marketplaceService) PostProduct(ctx context.Context, p *domain.Product) error {
	return s.repo.CreateProduct(ctx, p)
}

func (s *marketplaceService) SearchProducts(ctx context.Context, query string) ([]*domain.Product, error) {
	return s.repo.ListProducts(ctx, "", query)
}

func (s *marketplaceService) ExecutePulsePay(ctx context.Context, fromID, toID string, amount int32) error {
	tx := &domain.PulseTransaction{
		FromID: fromID,
		ToID:   toID,
		Amount: amount,
		RefType: "transfer",
	}
	return s.repo.RecordTransaction(ctx, tx)
}

func (s *marketplaceService) ManageWishlist(ctx context.Context, userID, productID string, add bool) error {
	if add {
		return s.repo.AddToWishlist(ctx, userID, productID)
	}
	return nil
}

func (s *marketplaceService) GetWishlist(ctx context.Context, userID string) ([]*domain.Product, error) {
	return s.repo.GetWishlist(ctx, userID)
}

func (s *marketplaceService) ReviewProduct(ctx context.Context, userID, productID string, rating int, comment string) error {
	return s.repo.RateProduct(ctx, userID, productID, rating, comment)
}

func (s *marketplaceService) Purchase(ctx context.Context, buyerID string, productIDs []string, quantities []int32, address string) (*domain.Order, error) {
	if len(productIDs) != len(quantities) {
		return nil, fmt.Errorf("product IDs and quantities must have matching length")
	}

	var total int32
	items := make([]domain.OrderItem, 0, len(productIDs))

	for i, pid := range productIDs {
		prod, err := s.repo.GetProduct(ctx, pid)
		if err != nil {
			return nil, fmt.Errorf("failed to get product %s: %w", pid, err)
		}
		total += prod.Price * quantities[i]
		items = append(items, domain.OrderItem{
			ProductID:       pid,
			Quantity:        quantities[i],
			PriceAtPurchase: prod.Price,
		})
	}

	order := &domain.Order{
		BuyerID:         buyerID,
		TotalAmount:     total,
		Status:          "pending",
		ShippingAddress: address,
		Items:           items,
	}

	return order, s.repo.CreateOrder(ctx, order)
}
