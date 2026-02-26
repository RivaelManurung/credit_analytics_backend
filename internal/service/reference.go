package service

import (
	"context"

	pb "credit-analytics-backend/api/reference/v1"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/pkg/grpcerr"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/emptypb"
)

type ReferenceService struct {
	pb.UnimplementedReferenceServiceServer
	uc  *biz.ReferenceUsecase
	log *log.Helper
}

func NewReferenceService(uc *biz.ReferenceUsecase, logger log.Logger) *ReferenceService {
	return &ReferenceService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

// -----------------------------------------------------------------------
// LOAN PRODUCTS
// -----------------------------------------------------------------------

func (s *ReferenceService) ListLoanProducts(ctx context.Context, req *emptypb.Empty) (*pb.ListLoanProductsResponse, error) {
	products, err := s.uc.ListLoanProducts(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.LoanProduct
	for _, p := range products {
		res = append(res, &pb.LoanProduct{
			Id:          p.ID.String(),
			ProductCode: p.ProductCode,
			ProductName: p.ProductName,
			Segment:     p.Segment,
			Active:      p.Active,
		})
	}
	if res == nil {
		res = []*pb.LoanProduct{}
	}
	return &pb.ListLoanProductsResponse{Products: res}, nil
}

func (s *ReferenceService) GetLoanProduct(ctx context.Context, req *pb.GetLoanProductRequest) (*pb.LoanProduct, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, grpcerr.From(&biz.ErrInvalidArgument{Field: "id", Message: "must be a valid UUID"})
	}
	p, err := s.uc.GetLoanProduct(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return &pb.LoanProduct{
		Id:          p.ID.String(),
		ProductCode: p.ProductCode,
		ProductName: p.ProductName,
		Segment:     p.Segment,
		Active:      p.Active,
	}, nil
}

// -----------------------------------------------------------------------
// BRANCHES & OFFICERS
// -----------------------------------------------------------------------

func (s *ReferenceService) ListBranches(ctx context.Context, req *emptypb.Empty) (*pb.ListBranchesResponse, error) {
	branches, err := s.uc.ListBranches(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.Branch
	for _, b := range branches {
		res = append(res, &pb.Branch{
			BranchCode: b.BranchCode,
			BranchName: b.BranchName,
			RegionCode: b.RegionCode,
		})
	}
	if res == nil {
		res = []*pb.Branch{}
	}
	return &pb.ListBranchesResponse{Branches: res}, nil
}

func (s *ReferenceService) ListLoanOfficers(ctx context.Context, req *pb.ListLoanOfficersRequest) (*pb.ListLoanOfficersResponse, error) {
	officers, err := s.uc.ListLoanOfficers(ctx, req.BranchCode)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.LoanOfficer
	for _, o := range officers {
		res = append(res, &pb.LoanOfficer{
			Id:          o.ID.String(),
			OfficerCode: o.OfficerCode,
			BranchCode:  o.BranchCode,
		})
	}
	if res == nil {
		res = []*pb.LoanOfficer{}
	}
	return &pb.ListLoanOfficersResponse{Officers: res}, nil
}

// -----------------------------------------------------------------------
// APPLICATION STATUSES & FINANCIAL GL ACCOUNTS
// -----------------------------------------------------------------------

func (s *ReferenceService) ListApplicationStatuses(ctx context.Context, req *emptypb.Empty) (*pb.ListApplicationStatusesResponse, error) {
	statuses, err := s.uc.ListApplicationStatuses(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.ApplicationStatusRef
	for _, st := range statuses {
		res = append(res, &pb.ApplicationStatusRef{
			StatusCode:  st.StatusCode,
			StatusGroup: st.StatusGroup,
			IsTerminal:  st.IsTerminal,
			Description: st.Description,
		})
	}
	if res == nil {
		res = []*pb.ApplicationStatusRef{}
	}
	return &pb.ListApplicationStatusesResponse{Statuses: res}, nil
}

func (s *ReferenceService) ListFinancialGLAccounts(ctx context.Context, req *emptypb.Empty) (*pb.ListFinancialGLAccountsResponse, error) {
	accounts, err := s.uc.ListFinancialGLAccounts(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.FinancialGLAccount
	for _, a := range accounts {
		res = append(res, &pb.FinancialGLAccount{
			GlCode:        a.GLCode,
			GlName:        a.GLName,
			StatementType: a.StatementType,
			Category:      a.Category,
			Sign:          a.Sign,
			IsDebtService: a.IsDebtService,
			IsOperating:   a.IsOperating,
			Description:   a.Description,
		})
	}
	if res == nil {
		res = []*pb.FinancialGLAccount{}
	}
	return &pb.ListFinancialGLAccountsResponse{Accounts: res}, nil
}

// -----------------------------------------------------------------------
// ATTRIBUTE CATEGORIES (dynamic, icon stored here)
// These use types from reference_ext.go since pb.go doesn't have them yet.
// -----------------------------------------------------------------------

func (s *ReferenceService) ListAttributeCategories(ctx context.Context, req *emptypb.Empty) (*pb.ListAttributeCategoriesResponse, error) {
	cats, err := s.uc.ListAttributeCategories(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.AttributeCategory
	for _, c := range cats {
		res = append(res, mapCategoryToPb(c))
	}
	if res == nil {
		res = []*pb.AttributeCategory{}
	}
	return &pb.ListAttributeCategoriesResponse{Categories: res}, nil
}

func (s *ReferenceService) GetAttributeCategory(ctx context.Context, req *pb.GetAttributeCategoryRequest) (*pb.AttributeCategory, error) {
	cat, err := s.uc.GetAttributeCategory(ctx, req.CategoryCode)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapCategoryToPb(cat), nil
}

func (s *ReferenceService) CreateAttributeCategory(ctx context.Context, req *pb.CreateAttributeCategoryRequest) (*pb.AttributeCategory, error) {
	cat := &biz.AttributeCategory{
		CategoryCode: req.CategoryCode,
		CategoryName: req.CategoryName,
		UiIcon:       req.UiIcon,
		DisplayOrder: req.DisplayOrder,
		Description:  req.Description,
	}
	if err := s.uc.CreateAttributeCategory(ctx, cat); err != nil {
		return nil, grpcerr.From(err)
	}
	created, err := s.uc.GetAttributeCategory(ctx, req.CategoryCode)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapCategoryToPb(created), nil
}

func (s *ReferenceService) UpdateAttributeCategory(ctx context.Context, req *pb.UpdateAttributeCategoryRequest) (*pb.AttributeCategory, error) {
	cat := &biz.AttributeCategory{
		CategoryCode: req.CategoryCode,
		CategoryName: req.CategoryName,
		UiIcon:       req.UiIcon,
		DisplayOrder: req.DisplayOrder,
		Description:  req.Description,
	}
	if err := s.uc.UpdateAttributeCategory(ctx, cat); err != nil {
		return nil, grpcerr.From(err)
	}
	updated, err := s.uc.GetAttributeCategory(ctx, req.CategoryCode)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapCategoryToPb(updated), nil
}

func (s *ReferenceService) DeleteAttributeCategory(ctx context.Context, req *pb.DeleteAttributeCategoryRequest) (*emptypb.Empty, error) {
	if err := s.uc.DeleteAttributeCategory(ctx, req.CategoryCode); err != nil {
		return nil, grpcerr.From(err)
	}
	return &emptypb.Empty{}, nil
}

// -----------------------------------------------------------------------
// ATTRIBUTE REGISTRY
// Uses the generated *pb.AttributeRegistry struct.
// Field mapping: CategoryCode->Category(as FK), UiLabel->UiLabel,
// CategoryName+Icon mapped to Description+UiIcon for backward compat
// until buf generate is re-run.
// -----------------------------------------------------------------------

func (s *ReferenceService) ListAttributeRegistry(ctx context.Context, req *emptypb.Empty) (*pb.ListAttributeRegistryResponse, error) {
	attrs, err := s.uc.ListAttributeRegistry(ctx)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.AttributeRegistry
	for _, a := range attrs {
		res = append(res, mapAttrToPb(a))
	}
	if res == nil {
		res = []*pb.AttributeRegistry{}
	}
	return &pb.ListAttributeRegistryResponse{Attributes: res}, nil
}

func (s *ReferenceService) ListAttributeRegistryByCategory(ctx context.Context, req *pb.ListAttributeRegistryByCategoryRequest) (*pb.ListAttributeRegistryResponse, error) {
	attrs, err := s.uc.ListAttributeRegistryByCategory(ctx, req.CategoryCode)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.AttributeRegistry
	for _, a := range attrs {
		res = append(res, mapAttrToPb(a))
	}
	if res == nil {
		res = []*pb.AttributeRegistry{}
	}
	return &pb.ListAttributeRegistryResponse{Attributes: res}, nil
}

func (s *ReferenceService) CreateAttributeRegistry(ctx context.Context, req *pb.CreateAttributeRegistryRequest) (*emptypb.Empty, error) {
	err := s.uc.CreateAttributeRegistry(ctx, &biz.AttributeRegistry{
		AttributeCode: req.AttributeCode,
		AppliesTo:     req.AppliesTo,
		Scope:         req.Scope,
		DataType:      req.ValueType,
		CategoryCode:  req.CategoryCode,
		UiLabel:       req.UiLabel,
		IsRequired:    req.IsRequired,
		RiskRelevant:  req.RiskRelevant,
		IsActive:      req.IsActive,
		DisplayOrder:  req.DisplayOrder,
		Description:   req.Description,
	})
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return &emptypb.Empty{}, nil
}

func (s *ReferenceService) UpdateAttributeRegistry(ctx context.Context, req *pb.UpdateAttributeRegistryRequest) (*emptypb.Empty, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, grpcerr.From(&biz.ErrInvalidArgument{Field: "id", Message: "invalid UUID"})
	}
	err = s.uc.UpdateAttributeRegistry(ctx, &biz.AttributeRegistry{
		ID:            id,
		AttributeCode: req.AttributeCode,
		AppliesTo:     req.AppliesTo,
		Scope:         req.Scope,
		DataType:      req.ValueType,
		CategoryCode:  req.CategoryCode,
		UiLabel:       req.UiLabel,
		IsRequired:    req.IsRequired,
		RiskRelevant:  req.RiskRelevant,
		IsActive:      req.IsActive,
		DisplayOrder:  req.DisplayOrder,
		Description:   req.Description,
	})
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return &emptypb.Empty{}, nil
}

func (s *ReferenceService) DeleteAttributeRegistry(ctx context.Context, req *pb.DeleteAttributeRegistryRequest) (*emptypb.Empty, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, grpcerr.From(&biz.ErrInvalidArgument{Field: "id", Message: "invalid UUID"})
	}
	if err := s.uc.DeleteAttributeRegistry(ctx, id); err != nil {
		return nil, grpcerr.From(err)
	}
	return &emptypb.Empty{}, nil
}

func (s *ReferenceService) ListSurveyTemplates(ctx context.Context, req *pb.ListSurveyTemplatesRequest) (*pb.ListSurveyTemplatesResponse, error) {
	return &pb.ListSurveyTemplatesResponse{}, nil
}

// -----------------------------------------------------------------------
// Mappers
// -----------------------------------------------------------------------

func mapCategoryToPb(c *biz.AttributeCategory) *pb.AttributeCategory {
	return &pb.AttributeCategory{
		CategoryCode: c.CategoryCode,
		CategoryName: c.CategoryName,
		UiIcon:       c.UiIcon,
		DisplayOrder: c.DisplayOrder,
		Description:  c.Description,
	}
}

// mapAttrToPb maps biz.AttributeRegistry to the generated pb.AttributeRegistry.
// Because pb proto hasn't been regenerated yet, we use existing fields:
//   - Category field = CategoryCode (FK string)
//   - UiIcon field   = CategoryIcon (from JOIN)
//   - AttrName field = CategoryName (from JOIN)
//   - UiLabel field  = UiLabel (per-attribute label)
func mapAttrToPb(a *biz.AttributeRegistry) *pb.AttributeRegistry {
	var opts []*pb.AttributeOption
	for _, o := range a.Options {
		opts = append(opts, mapOptionToPb(o))
	}

	return &pb.AttributeRegistry{
		Id:            a.ID.String(),
		AttributeCode: a.AttributeCode,
		AppliesTo:     a.AppliesTo,
		Scope:         a.Scope,
		DataType:      a.DataType,
		CategoryCode:  a.CategoryCode,
		UiLabel:       a.UiLabel,
		IsRequired:    a.IsRequired,
		RiskRelevant:  a.RiskRelevant,
		IsActive:      a.IsActive,
		DisplayOrder:  a.DisplayOrder,
		Description:   a.Description,
		CategoryName:  a.CategoryName,
		CategoryIcon:  a.CategoryIcon,
		Options:       opts,
	}
}

func mapOptionToPb(o *biz.AttributeOption) *pb.AttributeOption {
	return &pb.AttributeOption{
		Id:           o.ID.String(),
		AttributeId:  o.AttributeID.String(),
		OptionValue:  o.OptionValue,
		OptionLabel:  o.OptionLabel,
		DisplayOrder: o.DisplayOrder,
		IsActive:     o.IsActive,
	}
}
