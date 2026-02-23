package service

import (
	"context"

	pb "credit-analytics-backend/api/reference/v1"
	"credit-analytics-backend/internal/biz"

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

func (s *ReferenceService) ListLoanProducts(ctx context.Context, req *emptypb.Empty) (*pb.ListLoanProductsResponse, error) {
	products, err := s.uc.ListLoanProducts(ctx)
	if err != nil {
		return nil, err
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
	return &pb.ListLoanProductsResponse{Products: res}, nil
}

func (s *ReferenceService) GetLoanProduct(ctx context.Context, req *pb.GetLoanProductRequest) (*pb.LoanProduct, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	p, err := s.uc.GetLoanProduct(ctx, id)
	if err != nil {
		return nil, err
	}
	return &pb.LoanProduct{
		Id:          p.ID.String(),
		ProductCode: p.ProductCode,
		ProductName: p.ProductName,
		Segment:     p.Segment,
		Active:      p.Active,
	}, nil
}

func (s *ReferenceService) ListBranches(ctx context.Context, req *emptypb.Empty) (*pb.ListBranchesResponse, error) {
	branches, err := s.uc.ListBranches(ctx)
	if err != nil {
		return nil, err
	}
	var res []*pb.Branch
	for _, b := range branches {
		res = append(res, &pb.Branch{
			BranchCode: b.BranchCode,
			BranchName: b.BranchName,
			RegionCode: b.RegionCode,
		})
	}
	return &pb.ListBranchesResponse{Branches: res}, nil
}

func (s *ReferenceService) ListLoanOfficers(ctx context.Context, req *pb.ListLoanOfficersRequest) (*pb.ListLoanOfficersResponse, error) {
	officers, err := s.uc.ListLoanOfficers(ctx, req.BranchCode)
	if err != nil {
		return nil, err
	}
	var res []*pb.LoanOfficer
	for _, o := range officers {
		res = append(res, &pb.LoanOfficer{
			Id:          o.ID.String(),
			OfficerCode: o.OfficerCode,
			BranchCode:  o.BranchCode,
		})
	}
	return &pb.ListLoanOfficersResponse{Officers: res}, nil
}

func (s *ReferenceService) ListApplicationStatuses(ctx context.Context, req *emptypb.Empty) (*pb.ListApplicationStatusesResponse, error) {
	statuses, err := s.uc.ListApplicationStatuses(ctx)
	if err != nil {
		return nil, err
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
	return &pb.ListApplicationStatusesResponse{Statuses: res}, nil
}

func (s *ReferenceService) ListFinancialGLAccounts(ctx context.Context, req *emptypb.Empty) (*pb.ListFinancialGLAccountsResponse, error) {
	accounts, err := s.uc.ListFinancialGLAccounts(ctx)
	if err != nil {
		return nil, err
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
	return &pb.ListFinancialGLAccountsResponse{Accounts: res}, nil
}

func (s *ReferenceService) ListAttributeRegistry(ctx context.Context, req *emptypb.Empty) (*pb.ListAttributeRegistryResponse, error) {
	attrs, err := s.uc.ListAttributeRegistry(ctx)
	if err != nil {
		return nil, err
	}
	var res []*pb.AttributeRegistry
	for _, a := range attrs {
		res = append(res, &pb.AttributeRegistry{
			AttrKey:  a.AttrKey,
			AttrName: a.AttrName,
			DataType: a.DataType,
			Category: a.Category,
			Required: a.IsRequired,
		})
	}
	return &pb.ListAttributeRegistryResponse{Attributes: res}, nil
}

func (s *ReferenceService) ListSurveyTemplates(ctx context.Context, req *pb.ListSurveyTemplatesRequest) (*pb.ListSurveyTemplatesResponse, error) {
	return &pb.ListSurveyTemplatesResponse{}, nil
}
