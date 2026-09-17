package service

import (
	"context"
	"fmt"

	"local/merope/internal/modules/marketplace/domain"
)

type marketplaceService struct {
	repo domain.RuntimeMarketplaceRepository
}

func NewMarketplaceService(repo domain.RuntimeMarketplaceRepository) domain.RuntimeMarketplaceService {
	return &marketplaceService{repo: repo}
}

func (s *marketplaceService) PostProduct(ctx context.Context, p *domain.Product) error {
	return s.repo.CreateProduct(ctx, p)
}

func (s *marketplaceService) SearchProducts(ctx context.Context, query string) ([]*domain.Product, error) {
	return s.repo.ListProducts(ctx, "", query)
}

func (s *marketplaceService) ExecutePulsePay(ctx context.Context, fromID, toID string, amount int32) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	tx := &domain.PulseTransaction{
		FromID: fromID,
		ToID: toID,
		Amount: amount,
		RefType: "transfer",
		Status: "pending",
	}
	return s.repo.RecordTransaction(ctx, tx)
}

func (s *marketplaceService) ManageWishlist(ctx context.Context, userID, productID string, add bool) error {
	if add {
		return s.repo.AddToWishlist(ctx, userID, productID)
	}
	return fmt.Errorf("wishlist removal is not available in the active runtime repository")
}

func (s *marketplaceService) GetWishlist(ctx context.Context, userID string) ([]*domain.Product, error) {
	return s.repo.GetWishlist(ctx, userID)
}

func (s *marketplaceService) ReviewProduct(ctx context.Context, userID, productID string, rating int, comment string) error {
	if rating < 1 || rating > 5 {
		return fmt.Errorf("rating must be between 1 and 5")
	}
	return s.repo.RateProduct(ctx, userID, productID, rating, comment)
}

func (s *marketplaceService) Purchase(ctx context.Context, buyerID string, productIDs []string, quantities []int32, address string) (*domain.Order, error) {
	if len(productIDs) == 0 || len(productIDs) != len(quantities) {
		return nil, fmt.Errorf("product IDs and quantities must have matching non-empty length")
	}

	var total int32
	items := make([]domain.OrderItem, 0, len(productIDs))
	for i, pid := range productIDs {
		if quantities[i] <= 0 {
			return nil, fmt.Errorf("quantity must be positive")
		}
		prod, err := s.repo.GetProduct(ctx, pid)
		if err != nil {
			return nil, fmt.Errorf("failed to get product %s: %w", pid, err)
		}
		if prod == nil || !prod.IsActive {
			return nil, fmt.Errorf("product %s is unavailable", pid)
		}
		if prod.StockQuantity > 0 && prod.StockQuantity < quantities[i] {
			return nil, fmt.Errorf("insufficient stock for product %s", pid)
		}
		total += prod.Price * quantities[i]
		items = append(items, domain.OrderItem{
			ProductID: pid,
			ProductName: prod.Name,
			Quantity: quantities[i],
			PriceAtPurchase: prod.Price,
			Subtotal: prod.Price * quantities[i],
		})
	}

	order := &domain.Order{
		BuyerID: buyerID,
		TotalAmount: total,
		Status: "pending",
		ShippingAddress: domain.ShippingAddress{FullName: buyerID, AddressLine1: address},
		Items: items,
	}
	return order, s.repo.CreateOrder(ctx, order)
}
