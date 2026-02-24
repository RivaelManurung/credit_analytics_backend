package v1

import (
	"context"

	emptypb "google.golang.org/protobuf/types/known/emptypb"
)

// UpdateAttributeRegistryRequest mirrors CreateAttributeRegistryRequest (from pb.go).
// The generated grpc.pb.go references this type but pb.go only generated
// CreateAttributeRegistryRequest. Once buf generate is re-run with the new proto
// (which has separate messages), remove this alias.
type UpdateAttributeRegistryRequest = CreateAttributeRegistryRequest

// =============================================================================
// Extensions: New types and interface additions for AttributeCategory CRUD.
// These hand-written structs extend the generated pb code.
// TODO: run 'buf generate' with googleapis deps to auto-generate.
// =============================================================================

// --- AttributeCategory messages ---

type AttributeCategory struct {
	CategoryCode string `json:"category_code"`
	CategoryName string `json:"category_name"`
	UiIcon       string `json:"ui_icon"`
	DisplayOrder int32  `json:"display_order"`
	Description  string `json:"description"`
}

type ListAttributeCategoriesResponse struct {
	Categories []*AttributeCategory `json:"categories"`
}

type GetAttributeCategoryRequest struct {
	CategoryCode string `json:"category_code"`
}

type CreateAttributeCategoryRequest struct {
	CategoryCode string `json:"category_code"`
	CategoryName string `json:"category_name"`
	UiIcon       string `json:"ui_icon"`
	DisplayOrder int32  `json:"display_order"`
	Description  string `json:"description"`
}

type UpdateAttributeCategoryRequest struct {
	CategoryCode string `json:"category_code"`
	CategoryName string `json:"category_name"`
	UiIcon       string `json:"ui_icon"`
	DisplayOrder int32  `json:"display_order"`
	Description  string `json:"description"`
}

type DeleteAttributeCategoryRequest struct {
	CategoryCode string `json:"category_code"`
}

// --- Additional registry requests ---

type ListAttributeRegistryByCategoryRequest struct {
	CategoryCode string `json:"category_code"`
}

type DeleteAttributeRegistryRequest struct {
	AttributeCode string `json:"attribute_code"`
}

// =============================================================================
// Extend ReferenceServiceServer interface with new methods.
// Using a separate mixin interface so existing generated code is untouched.
// =============================================================================

// ReferenceServiceExtServer adds new category+registry methods.
// ReferenceService in service/ embeds UnimplementedReferenceServiceServer and
// implements both this and the generated ReferenceServiceServer interface.
type ReferenceServiceExtServer interface {
	ListAttributeCategories(ctx context.Context, req *emptypb.Empty) (*ListAttributeCategoriesResponse, error)
	GetAttributeCategory(ctx context.Context, req *GetAttributeCategoryRequest) (*AttributeCategory, error)
	CreateAttributeCategory(ctx context.Context, req *CreateAttributeCategoryRequest) (*AttributeCategory, error)
	UpdateAttributeCategory(ctx context.Context, req *UpdateAttributeCategoryRequest) (*AttributeCategory, error)
	DeleteAttributeCategory(ctx context.Context, req *DeleteAttributeCategoryRequest) (*emptypb.Empty, error)
	ListAttributeRegistryByCategory(ctx context.Context, req *ListAttributeRegistryByCategoryRequest) (*ListAttributeRegistryResponse, error)
	DeleteAttributeRegistry(ctx context.Context, req *DeleteAttributeRegistryRequest) (*emptypb.Empty, error)
}
