-- Marketplace runtime contract.
-- The generated SQL layer historically referenced these tables without a
-- canonical migration. This migration makes clean installs deterministic.

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    price INTEGER NOT NULL CHECK (price >= 0),
    currency TEXT NOT NULL DEFAULT 'MRO',
    category TEXT NOT NULL DEFAULT 'general',
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    rating REAL NOT NULL DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER NOT NULL DEFAULT 0 CHECK (review_count >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_products_active_category_created
    ON products(category, created_at DESC)
    WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_products_seller_created
    ON products(seller_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_products_active_price
    ON products(price, created_at DESC)
    WHERE is_active = TRUE;

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_amount INTEGER NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL DEFAULT 'pending',
    currency TEXT NOT NULL DEFAULT 'MRO',
    shipping_address TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_buyer_created
    ON orders(buyer_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status_created
    ON orders(status, created_at DESC);

CREATE TABLE IF NOT EXISTS order_items (
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price_at_purchase INTEGER NOT NULL CHECK (price_at_purchase >= 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);

CREATE TABLE IF NOT EXISTS marketplace_wishlists (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_marketplace_wishlist_user
    ON marketplace_wishlists(user_id, created_at DESC);
