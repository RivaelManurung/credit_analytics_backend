package service

import (
	"context"

	pb "credit-analytics-backend/api/applicant/v1"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/pkg/grpcerr"
	"credit-analytics-backend/pkg/validate"

	"github.com/google/uuid"
)

type ApplicantService struct {
	pb.UnimplementedApplicantServiceServer

	uc *biz.ApplicantUsecase
}

func NewApplicantService(uc *biz.ApplicantUsecase) *ApplicantService {
	return &ApplicantService{uc: uc}
}

func (s *ApplicantService) CreateApplicant(ctx context.Context, req *pb.CreateApplicantRequest) (*pb.Applicant, error) {
	if err := validate.NotEmpty("full_name", req.FullName); err != nil {
		return nil, grpcerr.From(err)
	}
	if err := validate.NotEmpty("applicant_type", req.ApplicantType); err != nil {
		return nil, grpcerr.From(err)
	}

	a := &biz.Applicant{
		ApplicantType:  req.ApplicantType,
		IdentityNumber: req.IdentityNumber,
		TaxID:          req.TaxId,
		FullName:       req.FullName,
	}
	for _, attr := range req.Attributes {
		attrID, _ := uuid.Parse(attr.AttributeId)
		optID, _ := uuid.Parse(attr.AttributeOptionId)
		a.Attributes = append(a.Attributes, biz.ApplicantAttribute{
			AttributeID:       attrID,
			AttributeOptionID: optID,
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	id, err := s.uc.Create(ctx, a)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	created, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapBizToProto(created), nil
}

func (s *ApplicantService) GetApplicant(ctx context.Context, req *pb.GetApplicantRequest) (*pb.Applicant, error) {
	id, err := validate.UUID("id", req.Id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapBizToProto(a), nil
}

func (s *ApplicantService) UpdateApplicant(ctx context.Context, req *pb.UpdateApplicantRequest) (*pb.Applicant, error) {
	id, err := validate.UUID("id", req.Id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	if err := validate.NotEmpty("full_name", req.FullName); err != nil {
		return nil, grpcerr.From(err)
	}

	a := &biz.Applicant{
		ID:             id,
		ApplicantType:  req.ApplicantType,
		IdentityNumber: req.IdentityNumber,
		TaxID:          req.TaxId,
		FullName:       req.FullName,
	}
	for _, attr := range req.Attributes {
		attrID, _ := uuid.Parse(attr.AttributeId)
		optID, _ := uuid.Parse(attr.AttributeOptionId)
		a.Attributes = append(a.Attributes, biz.ApplicantAttribute{
			AttributeID:       attrID,
			AttributeOptionID: optID,
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	if err := s.uc.Update(ctx, a); err != nil {
		return nil, grpcerr.From(err)
	}
	// Fetch from DB to return the actual persisted state (fixes stale data response)
	updated, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	return mapBizToProto(updated), nil
}

func (s *ApplicantService) GetApplicantAttributes(ctx context.Context, req *pb.GetApplicantAttributesRequest) (*pb.ApplicantAttributes, error) {
	id, err := validate.UUID("applicant_id", req.ApplicantId)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}
	res := &pb.ApplicantAttributes{}
	for _, attr := range a.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicantAttribute{
			AttributeId:       attr.AttributeID.String(),
			AttributeOptionId: attr.AttributeOptionID.String(),
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	return res, nil
}

// UpsertApplicantAttributes upserts all provided attributes for an applicant.
func (s *ApplicantService) UpsertApplicantAttributes(ctx context.Context, req *pb.UpsertApplicantAttributesRequest) (*pb.ApplicantAttributes, error) {
	id, err := validate.UUID("applicant_id", req.ApplicantId)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	// Fetch the existing applicant and replace only its attributes.
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	a.Attributes = nil
	for _, attr := range req.Attributes {
		attrID, _ := uuid.Parse(attr.AttributeId)
		optID, _ := uuid.Parse(attr.AttributeOptionId)
		a.Attributes = append(a.Attributes, biz.ApplicantAttribute{
			AttributeID:       attrID,
			AttributeOptionID: optID,
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	if err := s.uc.Update(ctx, a); err != nil {
		return nil, grpcerr.From(err)
	}

	res := &pb.ApplicantAttributes{}
	for _, attr := range a.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicantAttribute{
			AttributeId:       attr.AttributeID.String(),
			AttributeOptionId: attr.AttributeOptionID.String(),
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	return res, nil
}

func (s *ApplicantService) ListApplicants(ctx context.Context, req *pb.ListApplicantsRequest) (*pb.ListApplicantsResponse, error) {
	params := biz.PaginationParams{
		Cursor:   req.Cursor,
		PageSize: validate.PageSize(req.PageSize, 10, 100),
	}

	result, err := s.uc.List(ctx, params)
	if err != nil {
		return nil, grpcerr.From(err)
	}

	var res []*pb.Applicant
	for _, a := range result.Items {
		res = append(res, mapBizToProto(a))
	}
	if res == nil {
		res = []*pb.Applicant{}
	}

	return &pb.ListApplicantsResponse{
		Applicants: res,
		NextCursor: result.NextCursor,
		HasNext:    result.HasNext,
	}, nil
}

func mapBizToProto(a *biz.Applicant) *pb.Applicant {
	res := &pb.Applicant{
		Id:                a.ID.String(),
		ApplicantType:     a.ApplicantType,
		IdentityNumber:    a.IdentityNumber,
		TaxId:             a.TaxID,
		FullName:          a.FullName,
		BirthDate:         a.BirthDate.Format("2006-01-02"),
		EstablishmentDate: a.EstablishmentDate.Format("2006-01-02"),
	}
	for _, attr := range a.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicantAttribute{
			AttributeId:       attr.AttributeID.String(),
			AttributeOptionId: attr.AttributeOptionID.String(),
			Value:             attr.Value,
			DataType:          attr.DataType,
		})
	}
	return res
}

// parseOptionalUUID is a helper for optional UUID fields (e.g. filters).
func parseOptionalUUID(s string) uuid.UUID {
	id, _ := uuid.Parse(s)
	return id
}
