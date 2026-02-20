package service

import (
	"context"

	pb "credit-analytics-backend/api/application/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type ApplicationService struct {
	pb.UnimplementedApplicationServiceServer

	uc *biz.ApplicationUsecase
}

func NewApplicationService(uc *biz.ApplicationUsecase) *ApplicationService {
	return &ApplicationService{uc: uc}
}

func (s *ApplicationService) CreateApplication(ctx context.Context, req *pb.CreateApplicationRequest) (*pb.Application, error) {
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

	created, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}

	return mapAppBizToProto(created), nil
}

func (s *ApplicationService) GetApplication(ctx context.Context, req *pb.GetApplicationRequest) (*pb.Application, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}
	return mapAppBizToProto(app), nil
}

func (s *ApplicationService) UpdateApplication(ctx context.Context, req *pb.UpdateApplicationRequest) (*pb.Application, error) {
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
	return mapAppBizToProto(app), nil
}

func (s *ApplicationService) GetApplicationAttributes(ctx context.Context, req *pb.GetApplicationAttributesRequest) (*pb.ApplicationAttributes, error) {
	return &pb.ApplicationAttributes{}, nil
}

func (s *ApplicationService) UpsertApplicationAttributes(ctx context.Context, req *pb.UpsertApplicationAttributesRequest) (*pb.ApplicationAttributes, error) {
	return &pb.ApplicationAttributes{}, nil
}

func (s *ApplicationService) ChangeApplicationStatus(ctx context.Context, req *pb.ChangeApplicationStatusRequest) (*pb.Application, error) {
	return &pb.Application{}, nil
}

func (s *ApplicationService) ListApplications(ctx context.Context, req *pb.ListApplicationsRequest) (*pb.ListApplicationsResponse, error) {
	apps, err := s.uc.List(ctx)
	if err != nil {
		return nil, err
	}
	var res []*pb.Application
	for _, app := range apps {
		res = append(res, mapAppBizToProto(app))
	}
	return &pb.ListApplicationsResponse{Applications: res, NextCursor: ""}, nil
}

func (s *ApplicationService) UploadApplicationDocument(ctx context.Context, req *pb.UploadApplicationDocumentRequest) (*pb.ApplicationDocument, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	doc := &biz.ApplicationDocument{
		ApplicationID: appID,
		DocumentName:  req.DocumentName,
		FileURL:       req.FileUrl,
		DocumentType:  req.DocumentType,
	}
	err := s.uc.UploadDocument(ctx, doc)
	if err != nil {
		return nil, err
	}
	return mapDocBizToProto(doc), nil
}

func (s *ApplicationService) ListApplicationDocuments(ctx context.Context, req *pb.ListApplicationDocumentsRequest) (*pb.ListApplicationDocumentsResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	docs, err := s.uc.ListDocuments(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationDocument
	for _, doc := range docs {
		res = append(res, mapDocBizToProto(&doc))
	}
	return &pb.ListApplicationDocumentsResponse{Documents: res}, nil
}

type PartyService struct {
	pb.UnimplementedPartyServiceServer
	uc  *biz.ApplicationUsecase
	log *log.Helper
}

func NewPartyService(uc *biz.ApplicationUsecase, logger log.Logger) *PartyService {
	return &PartyService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

func (s *PartyService) AddPartyToApplication(ctx context.Context, req *pb.AddPartyToApplicationRequest) (*pb.ApplicationParty, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	partyID, _ := uuid.Parse(req.PartyId)

	err := s.uc.AddPartyToApplication(ctx, appID, partyID, req.RoleCode, req.SlikRequired)
	if err != nil {
		return nil, err
	}

	return &pb.ApplicationParty{
		ApplicationId: appID.String(),
		PartyId:       partyID.String(),
		RoleCode:      req.RoleCode,
		SlikRequired:  req.SlikRequired,
	}, nil
}

func (s *PartyService) RemovePartyFromApplication(ctx context.Context, req *pb.RemovePartyFromApplicationRequest) (*emptypb.Empty, error) {
	return &emptypb.Empty{}, nil
}

func (s *PartyService) ListApplicationParties(ctx context.Context, req *pb.ListApplicationPartiesRequest) (*pb.ListApplicationPartiesResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	parties, err := s.uc.GetParties(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationParty
	for _, p := range parties {
		res = append(res, &pb.ApplicationParty{
			ApplicationId:   appID.String(),
			PartyId:         p.Party.ID.String(),
			PartyType:       p.Party.PartyType,
			Name:            p.Party.Name,
			Identifier:      p.Party.Identifier,
			RoleCode:        p.RoleCode,
			LegalObligation: p.LegalObligation,
			SlikRequired:    p.SlikRequired,
		})
	}
	return &pb.ListApplicationPartiesResponse{Parties: res}, nil
}

func mapAppBizToProto(app *biz.Application) *pb.Application {
	res := &pb.Application{
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
	res.CreatedAt = timestamppb.New(app.CreatedAt)
	res.UpdatedAt = timestamppb.New(app.UpdatedAt)
	return res
}

func mapDocBizToProto(doc *biz.ApplicationDocument) *pb.ApplicationDocument {
	return &pb.ApplicationDocument{
		Id:            doc.ID.String(),
		ApplicationId: doc.ApplicationID.String(),
		DocumentName:  doc.DocumentName,
		FileUrl:       doc.FileURL,
		DocumentType:  doc.DocumentType,
		UploadedAt:    timestamppb.New(doc.UploadedAt),
	}
}
