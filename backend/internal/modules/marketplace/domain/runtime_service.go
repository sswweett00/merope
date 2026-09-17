package domain

import "context"

type RuntimeMarketplaceService interface {
	PostProduct(context.Context, *Product) error
	SearchProducts(context.Context, string) ([]*Product, error)
	ExecutePulsePay(context.Context, string, string, int32) error
	ManageWishlist(context.Context, string, string, bool) error
	GetWishlist(context.Context, string) ([]*Product, error)
	ReviewProduct(context.Context, string, string, int, string) error
	Purchase(context.Context, string, []string, []int32, string) (*Order, error)
}
