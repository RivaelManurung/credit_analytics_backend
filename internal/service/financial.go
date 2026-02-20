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
	pb.UnimplementedFinancialServiceServer
	uc  *biz.FinancialUsecase
	log *log.Helper
}

func NewFinancialService(uc *biz.FinancialUsecase, logger log.Logger) *FinancialService {
	return &FinancialService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

func (s *FinancialService) ListFinancialFacts(ctx context.Context, req *pb.ListFinancialFactsRequest) (*pb.ListFinancialFactsResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	facts, err := s.uc.ListFinancialFacts(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationFinancialFact
	for _, f := range facts {
		res = append(res, &pb.ApplicationFinancialFact{
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
	return &pb.ListFinancialFactsResponse{Facts: res}, nil
}

func (s *FinancialService) UpsertFinancialFact(ctx context.Context, req *pb.UpsertFinancialFactRequest) (*pb.ApplicationFinancialFact, error) {
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
	return &pb.ApplicationFinancialFact{
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

func (s *FinancialService) AddAsset(ctx context.Context, req *pb.AddAssetRequest) (*pb.ApplicationAsset, error) {
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
	return &pb.ApplicationAsset{
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

func (s *FinancialService) UpdateAsset(ctx context.Context, req *pb.UpdateAssetRequest) (*pb.ApplicationAsset, error) {
	id, _ := uuid.Parse(req.Id)
	appID, _ := uuid.Parse(req.ApplicationId)
	a, err := s.uc.UpdateAsset(ctx, &biz.Asset{
		ID:              id,
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
	return &pb.ApplicationAsset{
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

func (s *FinancialService) ListAssetsByApplication(ctx context.Context, req *pb.ListAssetsByApplicationRequest) (*pb.ListAssetsResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	assets, err := s.uc.ListAssets(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationAsset
	for _, a := range assets {
		res = append(res, &pb.ApplicationAsset{
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
	return &pb.ListAssetsResponse{Assets: res}, nil
}

func (s *FinancialService) AddLiability(ctx context.Context, req *pb.AddLiabilityRequest) (*pb.ApplicationLiability, error) {
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
	return &pb.ApplicationLiability{
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

func (s *FinancialService) UpdateLiability(ctx context.Context, req *pb.UpdateLiabilityRequest) (*pb.ApplicationLiability, error) {
	id, _ := uuid.Parse(req.Id)
	appID, _ := uuid.Parse(req.ApplicationId)
	maturity, _ := time.Parse(time.RFC3339, req.MaturityDate)
	l, err := s.uc.UpdateLiability(ctx, &biz.Liability{
		ID:                 id,
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
	return &pb.ApplicationLiability{
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

func (s *FinancialService) ListLiabilitiesByApplication(ctx context.Context, req *pb.ListLiabilitiesByApplicationRequest) (*pb.ListLiabilitiesResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	liabilities, err := s.uc.ListLiabilities(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationLiability
	for _, l := range liabilities {
		res = append(res, &pb.ApplicationLiability{
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
	return &pb.ListLiabilitiesResponse{Liabilities: res}, nil
}

func (s *FinancialService) CalculateFinancialRatios(ctx context.Context, req *pb.CalculateFinancialRatiosRequest) (*pb.ListFinancialRatiosResponse, error) {
	// Simple implementation for now, just return empty list as calculation logic is not yet implemented
	return &pb.ListFinancialRatiosResponse{Ratios: []*pb.FinancialRatio{}}, nil
}
