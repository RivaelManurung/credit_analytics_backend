package service

import (
	"context"

	pb "credit-analytics-backend/api/application/v1"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/pkg/grpcerr"
	"credit-analytics-backend/pkg/validate"

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
	applicantID, err := validate.UUID("applicant_id", req.ApplicantId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	productID, err := validate.UUID("product_id", req.ProductId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	aoID, _ := validate.OptionalUUID("ao_id", req.AoId)

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
		return nil, grpcerr.From(err)
	}

	created, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	return mapAppBizToProto(created), nil
}

func (s *ApplicationService) GetApplication(ctx context.Context, req *pb.GetApplicationRequest) (*pb.Application, error) {
	id, err := validate.UUID("id", req.Id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapAppBizToProto(app), nil
}

func (s *ApplicationService) UpdateApplication(ctx context.Context, req *pb.UpdateApplicationRequest) (*pb.Application, error) {
	id, err := validate.UUID("id", req.Id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	applicantID, err := validate.UUID("applicant_id", req.ApplicantId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	productID, err := validate.UUID("product_id", req.ProductId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	aoID, _ := validate.OptionalUUID("ao_id", req.AoId)

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
	if err := s.uc.Update(ctx, app); err != nil {
		return nil, grpcerr.From(err)
	}
	// Fetch up-to-date state from DB
	updated, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapAppBizToProto(updated), nil
}

func (s *ApplicationService) GetApplicationAttributes(ctx context.Context, req *pb.GetApplicationAttributesRequest) (*pb.ApplicationAttributes, error) {
	id, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	res := &pb.ApplicationAttributes{}
	for _, attr := range app.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res, nil
}

func (s *ApplicationService) UpsertApplicationAttributes(ctx context.Context, req *pb.UpsertApplicationAttributesRequest) (*pb.ApplicationAttributes, error) {
	id, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	app.Attributes = nil
	for _, attr := range req.Attributes {
		app.Attributes = append(app.Attributes, biz.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	if err := s.uc.Update(ctx, app); err != nil {
		return nil, grpcerr.From(err)
	}

	res := &pb.ApplicationAttributes{}
	for _, attr := range app.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicationAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res, nil
}

// ChangeApplicationStatus transitions the application status via the domain state machine.
func (s *ApplicationService) ChangeApplicationStatus(ctx context.Context, req *pb.ChangeApplicationStatusRequest) (*pb.Application, error) {
	id, err := validate.UUID("id", req.Id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	if !biz.IsValidStatus(req.NewStatus) {
		return nil, grpcerr.From(&biz.ErrInvalidArgument{
			Field:   "new_status",
			Message: "unknown application status: " + req.NewStatus,
		})
	}

	app, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	if err := app.TransitionTo(biz.ApplicationStatus(req.NewStatus)); err != nil {
		return nil, grpcerr.From(err)
	}
	if err := s.uc.Update(ctx, app); err != nil {
		return nil, grpcerr.From(err)
	}
	updated, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapAppBizToProto(updated), nil
}

func (s *ApplicationService) ListApplications(ctx context.Context, req *pb.ListApplicationsRequest) (*pb.ListApplicationsResponse, error) {
	applicantID, _ := validate.OptionalUUID("applicant_id", req.ApplicantId)

	params := biz.PaginationParams{
		Cursor:   req.Cursor,
		PageSize: validate.PageSize(req.PageSize, 10, 100),
	}

	result, err := s.uc.List(ctx, params, req.Status, applicantID)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	var res []*pb.Application
	for _, app := range result.Items {
		res = append(res, mapAppBizToProto(app))
	}
	if res == nil {
		res = []*pb.Application{}
	}

	return &pb.ListApplicationsResponse{
		Applications: res,
		NextCursor:   result.NextCursor,
		HasNext:      result.HasNext,
	}, nil
}

func (s *ApplicationService) UploadApplicationDocument(ctx context.Context, req *pb.UploadApplicationDocumentRequest) (*pb.ApplicationDocument, error) {
	appID, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	doc := &biz.ApplicationDocument{
		ApplicationID: appID,
		DocumentName:  req.DocumentName,
		FileURL:       req.FileUrl,
		DocumentType:  req.DocumentType,
	}
	if err := s.uc.UploadDocument(ctx, doc); err != nil {
		return nil, grpcerr.From(err)
	}
	return mapDocBizToProto(doc), nil
}

func (s *ApplicationService) ListApplicationDocuments(ctx context.Context, req *pb.ListApplicationDocumentsRequest) (*pb.ListApplicationDocumentsResponse, error) {
	appID, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	docs, err := s.uc.ListDocuments(ctx, appID)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	var res []*pb.ApplicationDocument
	for _, doc := range docs {
		res = append(res, mapDocBizToProto(&doc))
	}
	if res == nil {
		res = []*pb.ApplicationDocument{}
	}
	return &pb.ListApplicationDocumentsResponse{Documents: res}, nil
}

func (s *ApplicationService) GetPresignedUrl(ctx context.Context, req *pb.GetPresignedUrlRequest) (*pb.GetPresignedUrlResponse, error) {
	if err := validate.NotEmpty("file_name", req.FileName); err != nil {
		return nil, grpcerr.From(err)
	}
	if err := validate.NotEmpty("file_type", req.FileType); err != nil {
		return nil, grpcerr.From(err)
	}
	uploadURL, fileURL, err := s.uc.GetPresignedUrl(ctx, req.FileName, req.FileType)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return &pb.GetPresignedUrlResponse{
		UploadUrl: uploadURL,
		FileUrl:   fileURL,
	}, nil
}

// ---------------------------------------------------------------------------
// PartyService
// ---------------------------------------------------------------------------

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
	appID, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	partyID, err := validate.UUID("party_id", req.PartyId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	if err := validate.NotEmpty("role_code", req.RoleCode); err != nil {
		return nil, grpcerr.From(err)
	}

	if err := s.uc.AddPartyToApplication(ctx, appID, partyID, req.RoleCode, req.SlikRequired); err != nil {
		return nil, grpcerr.From(err)
	}

	return &pb.ApplicationParty{
		ApplicationId: appID.String(),
		PartyId:       partyID.String(),
		RoleCode:      req.RoleCode,
		SlikRequired:  req.SlikRequired,
	}, nil
}

func (s *PartyService) RemovePartyFromApplication(ctx context.Context, req *pb.RemovePartyFromApplicationRequest) (*emptypb.Empty, error) {
	_, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	_, err = validate.UUID("party_id", req.PartyId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	// TODO: implement RemoveParty in repo when soft-delete is needed
	return &emptypb.Empty{}, nil
}

func (s *PartyService) ListApplicationParties(ctx context.Context, req *pb.ListApplicationPartiesRequest) (*pb.ListApplicationPartiesResponse, error) {
	appID, err := validate.UUID("application_id", req.ApplicationId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	parties, err := s.uc.GetParties(ctx, appID)
	if err != nil {
		return nil, grpcerr.From(err)
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
	if res == nil {
		res = []*pb.ApplicationParty{}
	}
	return &pb.ListApplicationPartiesResponse{Parties: res}, nil
}

// ---------------------------------------------------------------------------
// Mappers
// ---------------------------------------------------------------------------

func mapAppBizToProto(app *biz.Application) *pb.Application {
	res := &pb.Application{
		Id:                 app.ID.String(),
		ApplicantId:        app.ApplicantID.String(),
		ApplicantName:      app.ApplicantName,
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
		CreatedAt:          timestamppb.New(app.CreatedAt),
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

// parseOptionalUUIDApp is unused but kept as a compile-time reminder.
var _ = uuid.Nil
