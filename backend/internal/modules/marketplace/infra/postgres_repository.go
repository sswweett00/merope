package infra

import (
	"context"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/marketplace/domain"
	"local/merope/internal/core/util"

	"github.com/jackc/pgx/v5/pgtype"
)

type PostgresMarketplaceRepository struct {
	queries *db.Queries
}

func NewPostgresMarketplaceRepository(queries *db.Queries) *PostgresMarketplaceRepository {
	return &PostgresMarketplaceRepository{queries: queries}
}

func (r *PostgresMarketplaceRepository) CreateProduct(ctx context.Context, p *domain.Product) error {
	var sid pgtype.UUID
	_ = sid.Scan(p.SellerID)

	dbProd, err := r.queries.CreateProduct(ctx, db.CreateProductParams{
		SellerID:    sid,
		Name:        p.Name,
		Description: pgtype.Text{String: p.Description, Valid: p.Description != ""},
		Price:       p.Price,
		Currency:    p.Currency,
		Category:    p.Category,
	})
	if err != nil {
		return err
	}

	p.ID = util.UUIDToString(dbProd.ID)
	p.CreatedAt = dbProd.CreatedAt.Time
	return nil
}

func (r *PostgresMarketplaceRepository) GetProduct(ctx context.Context, id string) (*domain.Product, error) {
	var pid pgtype.UUID
	_ = pid.Scan(id)
	dbProd, err := r.queries.GetProduct(ctx, pid)
	if err != nil {
		return nil, err
	}
	return &domain.Product{
		ID:          util.UUIDToString(dbProd.ID),
		SellerID:    util.UUIDToString(dbProd.SellerID),
		Name:        dbProd.Name,
		Description: dbProd.Description.String,
		Price:       dbProd.Price,
		Currency:    dbProd.Currency,
		Category:    dbProd.Category,
		CreatedAt:   dbProd.CreatedAt.Time,
	}, nil
}

func (r *PostgresMarketplaceRepository) CreateOrder(ctx context.Context, o *domain.Order) error {
	var bid pgtype.UUID
	_ = bid.Scan(o.BuyerID)

	dbOrder, err := r.queries.CreateOrder(ctx, db.CreateOrderParams{
		BuyerID:     bid,
		TotalAmount: o.TotalAmount,
		Status:      "pending",
	})
	if err != nil {
		return err
	}

	o.ID = util.UUIDToString(dbOrder.ID)
	o.CreatedAt = dbOrder.CreatedAt.Time

	for _, item := range o.Items {
		var pid pgtype.UUID
		_ = pid.Scan(item.ProductID)
		_ = r.queries.AddOrderItem(ctx, db.AddOrderItemParams{
			OrderID:         dbOrder.ID,
			ProductID:       pid,
			Quantity:        item.Quantity,
			PriceAtPurchase: item.PriceAtPurchase,
		})
	}

	return nil
}

func (r *PostgresMarketplaceRepository) ListProducts(ctx context.Context, category string, search string) ([]*domain.Product, error) { return nil, nil }
func (r *PostgresMarketplaceRepository) RecordTransaction(ctx context.Context, tx *domain.PulseTransaction) error { return nil }
func (r *PostgresMarketplaceRepository) AddToWishlist(ctx context.Context, userID, productID string) error { return nil }
func (r *PostgresMarketplaceRepository) GetWishlist(ctx context.Context, userID string) ([]*domain.Product, error) { return nil, nil }
func (r *PostgresMarketplaceRepository) RateProduct(ctx context.Context, userID, productID string, rating int, comment string) error { return nil }
