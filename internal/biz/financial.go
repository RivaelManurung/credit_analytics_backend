package biz

import (
	"context"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type FinancialFact struct {
	ID              uuid.UUID
	ApplicationID   uuid.UUID
	GLCode          string
	PeriodType      string
	PeriodLabel     string
	Amount          string // decimal
	Source          string
	ConfidenceLevel string
	CreatedAt       time.Time
}

type Asset struct {
	ID              uuid.UUID
	ApplicationID   uuid.UUID
	AssetTypeCode   string
	AssetName       string
	OwnershipStatus string
	AcquisitionYear int32
	EstimatedValue  string // decimal
	ValuationMethod string
	LocationText    string
	Encumbered      bool
}

type Liability struct {
	ID                 uuid.UUID
	ApplicationID      uuid.UUID
	CreditorName       string
	LiabilityType      string
	OutstandingAmount  string // decimal
	MonthlyInstallment string // decimal
	InterestRate       string // decimal
	MaturityDate       time.Time
	Source             string
}

type FinancialRatio struct {
	ID                 uuid.UUID
	ApplicationID      uuid.UUID
	RatioCode          string
	RatioValue         string // decimal
	CalculationVersion string
	CalculatedAt       time.Time
}

type FinancialRepo interface {
	ListFinancialFacts(ctx context.Context, appID uuid.UUID) ([]*FinancialFact, error)
	UpsertFinancialFact(ctx context.Context, f *FinancialFact) (*FinancialFact, error)
	CreateAsset(ctx context.Context, a *Asset) (*Asset, error)
	ListAssets(ctx context.Context, appID uuid.UUID) ([]*Asset, error)
	CreateLiability(ctx context.Context, l *Liability) (*Liability, error)
	ListLiabilities(ctx context.Context, appID uuid.UUID) ([]*Liability, error)
	UpsertFinancialRatio(ctx context.Context, r *FinancialRatio) (*FinancialRatio, error)
}

type FinancialUsecase struct {
	repo FinancialRepo
	log  *log.Helper
}

func NewFinancialUsecase(repo FinancialRepo, logger log.Logger) *FinancialUsecase {
	return &FinancialUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *FinancialUsecase) ListFinancialFacts(ctx context.Context, appID uuid.UUID) ([]*FinancialFact, error) {
	return uc.repo.ListFinancialFacts(ctx, appID)
}

func (uc *FinancialUsecase) UpsertFinancialFact(ctx context.Context, f *FinancialFact) (*FinancialFact, error) {
	return uc.repo.UpsertFinancialFact(ctx, f)
}

func (uc *FinancialUsecase) CreateAsset(ctx context.Context, a *Asset) (*Asset, error) {
	return uc.repo.CreateAsset(ctx, a)
}

func (uc *FinancialUsecase) ListAssets(ctx context.Context, appID uuid.UUID) ([]*Asset, error) {
	return uc.repo.ListAssets(ctx, appID)
}

func (uc *FinancialUsecase) CreateLiability(ctx context.Context, l *Liability) (*Liability, error) {
	return uc.repo.CreateLiability(ctx, l)
}

func (uc *FinancialUsecase) ListLiabilities(ctx context.Context, appID uuid.UUID) ([]*Liability, error) {
	return uc.repo.ListLiabilities(ctx, appID)
}

func (uc *FinancialUsecase) UpsertFinancialRatio(ctx context.Context, r *FinancialRatio) (*FinancialRatio, error) {
	return uc.repo.UpsertFinancialRatio(ctx, r)
}
