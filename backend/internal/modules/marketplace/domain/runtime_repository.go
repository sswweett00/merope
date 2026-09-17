package domain

import "context"

type RuntimeMarketplaceRepository interface {
	CreateProduct(context.Context, *Product) error
	GetProduct(context.Context, string) (*Product, error)
	CreateOrder(context.Context, *Order) error
	ListProducts(context.Context, string, string) ([]*Product, error)
	RecordTransaction(context.Context, *PulseTransaction) error
	AddToWishlist(context.Context, string, string) error
	GetWishlist(context.Context, string) ([]*Product, error)
	RateProduct(context.Context, string, string, int, string) error
}
