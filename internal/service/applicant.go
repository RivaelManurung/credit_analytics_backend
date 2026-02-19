package service

import (
	"context"

	pb "credit-analytics-backend/api/applicant/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/google/uuid"
)

type ApplicantService struct {
	pb.UnimplementedApplicantServer

	uc *biz.ApplicantUsecase
}

func NewApplicantService(uc *biz.ApplicantUsecase) *ApplicantService {
	return &ApplicantService{uc: uc}
}

func (s *ApplicantService) CreateApplicant(ctx context.Context, req *pb.CreateApplicantRequest) (*pb.CreateApplicantReply, error) {
	a := &biz.Applicant{
		ApplicantType:  req.ApplicantType,
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
	return &pb.CreateApplicantReply{
		Id:      id.String(),
		Message: "Applicant created successfully",
	}, nil
}

func (s *ApplicantService) GetApplicant(ctx context.Context, req *pb.GetApplicantRequest) (*pb.GetApplicantReply, error) {
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, err
	}
	a, err := s.uc.Get(ctx, id)
	if err != nil {
		return nil, err
	}

	return &pb.GetApplicantReply{
		Applicant: mapBizToProto(a),
	}, nil
}

func (s *ApplicantService) ListApplicants(ctx context.Context, req *pb.ListApplicantsRequest) (*pb.ListApplicantsReply, error) {
	applicants, err := s.uc.ListAll(ctx)
	if err != nil {
		return nil, err
	}

	res := &pb.ListApplicantsReply{}
	for _, a := range applicants {
		res.Applicants = append(res.Applicants, mapBizToProto(a))
	}
	return res, nil
}

func mapBizToProto(a *biz.Applicant) *pb.ApplicantInfo {
	res := &pb.ApplicantInfo{
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
			Key:      attr.Key,
			Value:    attr.Value,
			DataType: attr.DataType,
		})
	}
	return res
}
