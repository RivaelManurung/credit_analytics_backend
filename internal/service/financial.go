package service

import (
	"context"
	"time"

	pb "credit-analytics-backend/api/financial/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type FinancialService struct {
	pb.UnimplementedFinancialServer
	uc  *biz.FinancialUsecase
	log *log.Helper
}

func NewFinancialService(uc *biz.FinancialUsecase, logger log.Logger) *FinancialService {
	return &FinancialService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

func (s *FinancialService) ListFinancialFacts(ctx context.Context, req *pb.ListFinancialFactsRequest) (*pb.ListFinancialFactsReply, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	facts, err := s.uc.ListFinancialFacts(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.FinancialFact
	for _, f := range facts {
		res = append(res, &pb.FinancialFact{
			Id:              f.ID.String(),
			ApplicationId:   f.ApplicationID.String(),
			GlCode:          f.GLCode,
			PeriodType:      f.PeriodType,
			PeriodLabel:     f.PeriodLabel,
			Amount:          f.Amount,
			Source:          f.Source,
			ConfidenceLevel: f.ConfidenceLevel,
			CreatedAt:       timestamppb.New(f.CreatedAt),
		})
	}
	return &pb.ListFinancialFactsReply{Facts: res}, nil
}

func (s *FinancialService) UpsertFinancialFact(ctx context.Context, req *pb.UpsertFinancialFactRequest) (*pb.FinancialFact, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	f, err := s.uc.UpsertFinancialFact(ctx, &biz.FinancialFact{
		ApplicationID:   appID,
		GLCode:          req.GlCode,
		PeriodType:      req.PeriodType,
		PeriodLabel:     req.PeriodLabel,
		Amount:          req.Amount,
		Source:          req.Source,
		ConfidenceLevel: req.ConfidenceLevel,
	})
	if err != nil {
		return nil, err
	}
	return &pb.FinancialFact{
		Id:              f.ID.String(),
		ApplicationId:   f.ApplicationID.String(),
		GlCode:          f.GLCode,
		PeriodType:      f.PeriodType,
		PeriodLabel:     f.PeriodLabel,
		Amount:          f.Amount,
		Source:          f.Source,
		ConfidenceLevel: f.ConfidenceLevel,
		CreatedAt:       timestamppb.New(f.CreatedAt),
	}, nil
}

func (s *FinancialService) CreateAsset(ctx context.Context, req *pb.CreateAssetRequest) (*pb.Asset, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	a, err := s.uc.CreateAsset(ctx, &biz.Asset{
		ApplicationID:   appID,
		AssetTypeCode:   req.AssetTypeCode,
		AssetName:       req.AssetName,
		OwnershipStatus: req.OwnershipStatus,
		AcquisitionYear: req.AcquisitionYear,
		EstimatedValue:  req.EstimatedValue,
		ValuationMethod: req.ValuationMethod,
		LocationText:    req.LocationText,
		Encumbered:      req.Encumbered,
	})
	if err != nil {
		return nil, err
	}
	return &pb.Asset{
		Id:              a.ID.String(),
		ApplicationId:   a.ApplicationID.String(),
		AssetTypeCode:   a.AssetTypeCode,
		AssetName:       a.AssetName,
		OwnershipStatus: a.OwnershipStatus,
		AcquisitionYear: a.AcquisitionYear,
		EstimatedValue:  a.EstimatedValue,
		ValuationMethod: a.ValuationMethod,
		LocationText:    a.LocationText,
		Encumbered:      a.Encumbered,
	}, nil
}

func (s *FinancialService) ListAssets(ctx context.Context, req *pb.ListAssetsRequest) (*pb.ListAssetsReply, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	assets, err := s.uc.ListAssets(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.Asset
	for _, a := range assets {
		res = append(res, &pb.Asset{
			Id:              a.ID.String(),
			ApplicationId:   a.ApplicationID.String(),
			AssetTypeCode:   a.AssetTypeCode,
			AssetName:       a.AssetName,
			OwnershipStatus: a.OwnershipStatus,
			AcquisitionYear: a.AcquisitionYear,
			EstimatedValue:  a.EstimatedValue,
			ValuationMethod: a.ValuationMethod,
			LocationText:    a.LocationText,
			Encumbered:      a.Encumbered,
		})
	}
	return &pb.ListAssetsReply{Assets: res}, nil
}

func (s *FinancialService) CreateLiability(ctx context.Context, req *pb.CreateLiabilityRequest) (*pb.Liability, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	maturity, _ := time.Parse(time.RFC3339, req.MaturityDate)
	l, err := s.uc.CreateLiability(ctx, &biz.Liability{
		ApplicationID:      appID,
		CreditorName:       req.CreditorName,
		LiabilityType:      req.LiabilityType,
		OutstandingAmount:  req.OutstandingAmount,
		MonthlyInstallment: req.MonthlyInstallment,
		InterestRate:       req.InterestRate,
		MaturityDate:       maturity,
		Source:             req.Source,
	})
	if err != nil {
		return nil, err
	}
	return &pb.Liability{
		Id:                 l.ID.String(),
		ApplicationId:      l.ApplicationID.String(),
		CreditorName:       l.CreditorName,
		LiabilityType:      l.LiabilityType,
		OutstandingAmount:  l.OutstandingAmount,
		MonthlyInstallment: l.MonthlyInstallment,
		InterestRate:       l.InterestRate,
		MaturityDate:       l.MaturityDate.Format(time.RFC3339),
		Source:             l.Source,
	}, nil
}

func (s *FinancialService) ListLiabilities(ctx context.Context, req *pb.ListLiabilitiesRequest) (*pb.ListLiabilitiesReply, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	liabilities, err := s.uc.ListLiabilities(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.Liability
	for _, l := range liabilities {
		res = append(res, &pb.Liability{
			Id:                 l.ID.String(),
			ApplicationId:      l.ApplicationID.String(),
			CreditorName:       l.CreditorName,
			LiabilityType:      l.LiabilityType,
			OutstandingAmount:  l.OutstandingAmount,
			MonthlyInstallment: l.MonthlyInstallment,
			InterestRate:       l.InterestRate,
			MaturityDate:       l.MaturityDate.Format(time.RFC3339),
			Source:             l.Source,
		})
	}
	return &pb.ListLiabilitiesReply{Liabilities: res}, nil
}

func (s *FinancialService) UpsertFinancialRatio(ctx context.Context, req *pb.UpsertFinancialRatioRequest) (*pb.FinancialRatio, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	r, err := s.uc.UpsertFinancialRatio(ctx, &biz.FinancialRatio{
		ApplicationID:      appID,
		RatioCode:          req.RatioCode,
		RatioValue:         req.RatioValue,
		CalculationVersion: req.CalculationVersion,
	})
	if err != nil {
		return nil, err
	}
	return &pb.FinancialRatio{
		Id:                 r.ID.String(),
		ApplicationId:      r.ApplicationID.String(),
		RatioCode:          r.RatioCode,
		RatioValue:         r.RatioValue,
		CalculationVersion: r.CalculationVersion,
		CalculatedAt:       timestamppb.New(r.CalculatedAt),
	}, nil
}
