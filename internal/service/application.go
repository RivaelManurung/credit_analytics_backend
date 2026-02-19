package service

import (
	"context"

	pb "credit-analytics-backend/api/application/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type ApplicationService struct {
	pb.UnimplementedApplicationServer

	uc *biz.ApplicationUsecase
}

func NewApplicationService(uc *biz.ApplicationUsecase) *ApplicationService {
	return &ApplicationService{uc: uc}
}

func (s *ApplicationService) CreateApplication(ctx context.Context, req *pb.CreateApplicationRequest) (*pb.CreateApplicationReply, error) {
	applicantID, _ := uuid.Parse(req.ApplicantId)
	productID, _ := uuid.Parse(req.ProductId)
	aoID, _ := uuid.Parse(req.AoId)

	amount, _ := decimal.NewFromString(req.LoanAmount)
	rate, _ := decimal.NewFromString(req.InterestRate)

	app := &biz.Application{
		ApplicantID:        applicantID,
		ProductID:          productID,
		AoID:               aoID,
		LoanAmount:         biz.NewMoney(amount, "IDR"),
		TenorMonths:        req.TenorMonths,
		InterestType:       req.InterestType,
		InterestRate:       biz.NewInterestRate(rate),
		LoanPurpose:        req.LoanPurpose,
		ApplicationChannel: req.ApplicationChannel,
		BranchCode:         req.BranchCode,
	}
	for _, attr := range req.Attributes {
		app.Attributes = append(app.Attributes, biz.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	id, err := s.uc.Create(ctx, app)
	if err != nil {
		return nil, err
	}
	return &pb.CreateApplicationReply{
		Id:      id.String(),
		Message: "Application created successfully",
	}, nil
}

func (s *ApplicationService) GetApplication(ctx context.Context, req *pb.GetApplicationRequest) (*pb.GetApplicationReply, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}
	return &pb.GetApplicationReply{
		Application: mapAppBizToProto(app),
	}, nil
}

func (s *ApplicationService) UpdateApplication(ctx context.Context, req *pb.UpdateApplicationRequest) (*pb.UpdateApplicationReply, error) {
	id, _ := uuid.Parse(req.Id)
	applicantID, _ := uuid.Parse(req.ApplicantId)
	productID, _ := uuid.Parse(req.ProductId)
	aoID, _ := uuid.Parse(req.AoId)

	amount, _ := decimal.NewFromString(req.LoanAmount)
	rate, _ := decimal.NewFromString(req.InterestRate)

	app := &biz.Application{
		ID:           id,
		ApplicantID:  applicantID,
		ProductID:    productID,
		AoID:         aoID,
		LoanAmount:   biz.NewMoney(amount, "IDR"),
		TenorMonths:  req.TenorMonths,
		InterestType: req.InterestType,
		InterestRate: biz.NewInterestRate(rate),
		LoanPurpose:  req.LoanPurpose,
		Status:       biz.ApplicationStatus(req.Status),
	}
	for _, attr := range req.Attributes {
		app.Attributes = append(app.Attributes, biz.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	err := s.uc.Update(ctx, app)
	if err != nil {
		return nil, err
	}
	return &pb.UpdateApplicationReply{
		Message: "Application updated successfully",
	}, nil
}

func (s *ApplicationService) ListApplications(ctx context.Context, req *pb.ListApplicationsRequest) (*pb.ListApplicationsReply, error) {
	apps, err := s.uc.List(ctx)
	if err != nil {
		return nil, err
	}
	res := &pb.ListApplicationsReply{}
	for _, app := range apps {
		res.Applications = append(res.Applications, mapAppBizToProto(app))
	}
	return res, nil
}

func mapAppBizToProto(app *biz.Application) *pb.ApplicationInfo {
	res := &pb.ApplicationInfo{
		Id:                 app.ID.String(),
		ApplicantId:        app.ApplicantID.String(),
		ProductId:          app.ProductID.String(),
		AoId:               app.AoID.String(),
		LoanAmount:         app.LoanAmount.Amount.String(),
		TenorMonths:        app.TenorMonths,
		InterestType:       app.InterestType,
		InterestRate:       app.InterestRate.Value.String(),
		LoanPurpose:        app.LoanPurpose,
		ApplicationChannel: app.ApplicationChannel,
		Status:             string(app.Status),
		BranchCode:         app.BranchCode,
	}
	for _, attr := range app.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res
}
