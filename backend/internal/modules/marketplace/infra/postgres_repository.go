package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"local/merope/internal/core/util"
	"local/merope/internal/database/db"
	"local/merope/internal/modules/marketplace/domain"
)

type PostgresMarketplaceRepository struct {
	queries *db.Queries
	pool    *pgxpool.Pool
}

func NewPostgresMarketplaceRepository(queries *db.Queries, pool *pgxpool.Pool) *PostgresMarketplaceRepository {
	return &PostgresMarketplaceRepository{queries: queries, pool: pool}
}

func parseMarketplaceUUID(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}

func (r *PostgresMarketplaceRepository) CreateProduct(ctx context.Context, p *domain.Product) error {
	sellerID, err := parseMarketplaceUUID(p.SellerID)
	if err != nil {
		return err
	}
	currency := strings.TrimSpace(p.Currency)
	if currency == "" {
		currency = "MRO"
	}
	category := strings.TrimSpace(p.Category)
	if category == "" {
		category = "general"
	}

	var id pgtype.UUID
	var createdAt pgtype.Timestamptz
	err = r.queries.QueryRow(ctx, `
INSERT INTO products (seller_id, name, description, price, currency, category, stock_quantity, rating, review_count, is_active, is_featured)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 0, TRUE, FALSE)
RETURNING id, created_at`, sellerID, strings.TrimSpace(p.Name), p.Description, p.Price, currency, category, p.StockQuantity, p.Rating).Scan(&id, &createdAt)
	if err != nil {
		return err
	}
	p.ID = util.UUIDToString(id)
	p.Currency = currency
	p.Category = category
	p.CreatedAt = createdAt.Time
	p.IsActive = true
	return nil
}

func (r *PostgresMarketplaceRepository) GetProduct(ctx context.Context, id string) (*domain.Product, error) {
	productID, err := parseMarketplaceUUID(id)
	if err != nil {
		return nil, err
	}
	var p domain.Product
	var dbID, sellerID pgtype.UUID
	var createdAt pgtype.Timestamptz
	if err := r.queries.QueryRow(ctx, `
SELECT id, seller_id, name, description, price, currency, category,
       stock_quantity, rating, review_count, is_active, is_featured, created_at
FROM products
WHERE id = $1`, productID).Scan(
		&dbID,
		&sellerID,
		&p.Name,
		&p.Description,
		&p.Price,
		&p.Currency,
		&p.Category,
		&p.StockQuantity,
		&p.Rating,
		&p.ReviewCount,
		&p.IsActive,
		&p.IsFeatured,
		&createdAt,
	); err != nil {
		return nil, err
	}
	p.ID = util.UUIDToString(dbID)
	p.SellerID = util.UUIDToString(sellerID)
	p.CreatedAt = createdAt.Time
	return &p, nil
}

func (r *PostgresMarketplaceRepository) CreateOrder(ctx context.Context, o *domain.Order) error {
	if r.pool == nil {
		return fmt.Errorf("postgres pool is required")
	}
	buyerID, err := parseMarketplaceUUID(o.BuyerID)
	if err != nil {
		return err
	}
	if len(o.Items) == 0 {
		return fmt.Errorf("order must contain at least one item")
	}

	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin marketplace order transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	currency := strings.TrimSpace(o.Currency)
	if currency == "" {
		currency = "MRO"
	}
	status := strings.TrimSpace(o.Status)
	if status == "" {
		status = "pending"
	}

	var orderID pgtype.UUID
	var createdAt pgtype.Timestamptz
	if err := tx.QueryRow(ctx, `
INSERT INTO orders (buyer_id, total_amount, status, currency, shipping_address)
VALUES ($1, $2, $3, $4, $5)
RETURNING id, created_at`, buyerID, o.TotalAmount, status, currency, o.ShippingAddress.AddressLine1).Scan(&orderID, &createdAt); err != nil {
		return err
	}

	for _, item := range o.Items {
		productID, parseErr := parseMarketplaceUUID(item.ProductID)
		if parseErr != nil {
			return parseErr
		}
		if item.Quantity <= 0 {
			return fmt.Errorf("quantity must be positive")
		}

		var updatedProductID pgtype.UUID
		if err := tx.QueryRow(ctx, `
UPDATE products
SET stock_quantity = CASE
    WHEN stock_quantity = 0 THEN 0
    ELSE stock_quantity - $2
END
WHERE id = $1 AND (stock_quantity = 0 OR stock_quantity >= $2)
RETURNING id`, productID, item.Quantity).Scan(&updatedProductID); err != nil {
			return fmt.Errorf("reserve stock for product %s: %w", item.ProductID, err)
		}

		if _, err := tx.Exec(ctx, `
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES ($1, $2, $3, $4)`, orderID, productID, item.Quantity, item.PriceAtPurchase); err != nil {
			return err
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("commit marketplace order transaction: %w", err)
	}

	o.ID = util.UUIDToString(orderID)
	o.Currency = currency
	o.Status = status
	o.CreatedAt = createdAt.Time
	return nil
}
func (r *PostgresMarketplaceRepository) ListProducts(ctx context.Context, category, search string) ([]*domain.Product, error) {
	category = strings.TrimSpace(category)
	search = strings.TrimSpace(search)
	rows, err := r.queries.Query(ctx, `
SELECT id, seller_id, name, description, price, currency, category,
       stock_quantity, rating, review_count, is_active, is_featured, created_at
FROM products
WHERE is_active = TRUE
  AND ($1 = '' OR category = $1)
  AND ($2 = '' OR name ILIKE '%' || $2 || '%' OR description ILIKE '%' || $2 || '%')
ORDER BY is_featured DESC, created_at DESC, id ASC
LIMIT 100`, category, search)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	products := make([]*domain.Product, 0)
	for rows.Next() {
		product := &domain.Product{}
		var id, sellerID pgtype.UUID
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&id, &sellerID, &product.Name, &product.Description, &product.Price, &product.Currency, &product.Category, &product.StockQuantity, &product.Rating, &product.ReviewCount, &product.IsActive, &product.IsFeatured, &createdAt); err != nil {
			return nil, err
		}
		product.ID = util.UUIDToString(id)
		product.SellerID = util.UUIDToString(sellerID)
		product.CreatedAt = createdAt.Time
		products = append(products, product)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return products, nil
}

func (r *PostgresMarketplaceRepository) RecordTransaction(ctx context.Context, tx *domain.PulseTransaction) error {
	return fmt.Errorf("marketplace pulse transfers must be processed by the finance transaction service")
}

func (r *PostgresMarketplaceRepository) AddToWishlist(ctx context.Context, userID, productID string) error {
	uid, err := parseMarketplaceUUID(userID)
	if err != nil {
		return err
	}
	pid, err := parseMarketplaceUUID(productID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO marketplace_wishlists (user_id, product_id)
VALUES ($1, $2)
ON CONFLICT (user_id, product_id) DO NOTHING`, uid, pid)
	return err
}

func (r *PostgresMarketplaceRepository) GetWishlist(ctx context.Context, userID string) ([]*domain.Product, error) {
	uid, err := parseMarketplaceUUID(userID)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries.Query(ctx, `
SELECT p.id, p.seller_id, p.name, p.description, p.price, p.currency, p.category,
       p.stock_quantity, p.rating, p.review_count, p.is_active, p.is_featured, p.created_at
FROM marketplace_wishlists w
JOIN products p ON p.id = w.product_id
WHERE w.user_id = $1 AND p.is_active = TRUE
ORDER BY w.created_at DESC, p.id ASC`, uid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	products := make([]*domain.Product, 0)
	for rows.Next() {
		product := &domain.Product{}
		var id, sellerID pgtype.UUID
		var createdAt pgtype.Timestamptz
		if err := rows.Scan(&id, &sellerID, &product.Name, &product.Description, &product.Price, &product.Currency, &product.Category, &product.StockQuantity, &product.Rating, &product.ReviewCount, &product.IsActive, &product.IsFeatured, &createdAt); err != nil {
			return nil, err
		}
		product.ID = util.UUIDToString(id)
		product.SellerID = util.UUIDToString(sellerID)
		product.CreatedAt = createdAt.Time
		products = append(products, product)
	}
	return products, rows.Err()
}

func (r *PostgresMarketplaceRepository) RateProduct(ctx context.Context, userID, productID string, rating int, comment string) error {
	if rating < 1 || rating > 5 {
		return fmt.Errorf("rating must be between 1 and 5")
	}
	uid, err := parseMarketplaceUUID(userID)
	if err != nil {
		return err
	}
	pid, err := parseMarketplaceUUID(productID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `
INSERT INTO product_reviews (product_id, user_id, rating, comment)
VALUES ($1, $2, $3, $4)
ON CONFLICT (product_id, user_id)
DO UPDATE SET rating = EXCLUDED.rating, comment = EXCLUDED.comment, created_at = NOW()`, pid, uid, rating, comment)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `
UPDATE products p
SET rating = stats.avg_rating,
    review_count = stats.review_count
FROM (
    SELECT product_id, AVG(rating)::real AS avg_rating, COUNT(*)::int AS review_count
    FROM product_reviews
    WHERE product_id = $1
    GROUP BY product_id
) stats
WHERE p.id = stats.product_id`, pid)
	return err
}

var _ domain.RuntimeMarketplaceRepository = (*PostgresMarketplaceRepository)(nil)
