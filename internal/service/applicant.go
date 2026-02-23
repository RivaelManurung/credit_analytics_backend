package service

import (
	"context"

	pb "credit-analytics-backend/api/applicant/v1"
	"credit-analytics-backend/internal/biz"

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
	a := &biz.Applicant{
		HeadType:       req.HeadType,
		IdentityNumber: req.IdentityNumber,
		TaxID:          req.TaxId,
		FullName:       req.FullName,
	}
	for _, attr := range req.Attributes {
		a.Attributes = append(a.Attributes, biz.ApplicantAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	id, err := s.uc.Create(ctx, a)
	if err != nil {
		return nil, err
	}
	// Fetch the created applicant to return full info
	created, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}
	return mapBizToProto(created), nil
}

func (s *ApplicantService) GetApplicant(ctx context.Context, req *pb.GetApplicantRequest) (*pb.Applicant, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}

	return mapBizToProto(a), nil
}

func (s *ApplicantService) UpdateApplicant(ctx context.Context, req *pb.UpdateApplicantRequest) (*pb.Applicant, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	a := &biz.Applicant{
		ID:             id,
		HeadType:       req.HeadType,
		IdentityNumber: req.IdentityNumber,
		TaxID:          req.TaxId,
		FullName:       req.FullName,
	}
	for _, attr := range req.Attributes {
		a.Attributes = append(a.Attributes, biz.ApplicantAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	err = s.uc.Update(ctx, a)
	if err != nil {
		return nil, err
	}
	return mapBizToProto(a), nil
}

func (s *ApplicantService) GetApplicantAttributes(ctx context.Context, req *pb.GetApplicantAttributesRequest) (*pb.ApplicantAttributes, error) {
	id, err := uuid.Parse(req.ApplicantId)
	if err != nil {
		return nil, err
	}
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}
	res := &pb.ApplicantAttributes{}
	for _, attr := range a.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicantAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res, nil
}

func (s *ApplicantService) UpsertApplicantAttributes(ctx context.Context, req *pb.UpsertApplicantAttributesRequest) (*pb.ApplicantAttributes, error) {
	// Simple implementation for now
	return &pb.ApplicantAttributes{}, nil
}

func (s *ApplicantService) ListApplicants(ctx context.Context, req *pb.ListApplicantsRequest) (*pb.ListApplicantsResponse, error) {
	params := biz.PaginationParams{
		Cursor:   req.Cursor,
		PageSize: req.PageSize,
	}

	result, err := s.uc.List(ctx, params)
	if err != nil {
		return nil, err
	}

	var res []*pb.Applicant
	for _, a := range result.Items {
		res = append(res, mapBizToProto(a))
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
		HeadType:          a.HeadType,
		IdentityNumber:    a.IdentityNumber,
		TaxId:             a.TaxID,
		FullName:          a.FullName,
		BirthDate:         a.BirthDate.Format("2006-01-02"),
		EstablishmentDate: a.EstablishmentDate.Format("2006-01-02"),
	}
	for _, attr := range a.Attributes {
		res.Attributes = append(res.Attributes, &pb.ApplicantAttribute{
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res
}
