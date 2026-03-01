package biz

import (
	"context"
	"fmt"
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
	Amount          string
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
	EstimatedValue  string
	ValuationMethod string
	LocationText    string
	Encumbered      bool
}

type Liability struct {
	ID                 uuid.UUID
	ApplicationID      uuid.UUID
	CreditorName       string
	LiabilityType      string
	OutstandingAmount  string
	MonthlyInstallment string
	InterestRate       string
	MaturityDate       time.Time
	Source             string
}

type FinancialRatio struct {
	ID                 uuid.UUID
	ApplicationID      uuid.UUID
	RatioCode          string
	RatioValue         string
	CalculationVersion string
	CalculatedAt       time.Time
}

type FinancialRepo interface {
	ListFinancialFacts(ctx context.Context, appID uuid.UUID) ([]*FinancialFact, error)
	UpsertFinancialFact(ctx context.Context, f *FinancialFact) (*FinancialFact, error)
	CreateAsset(ctx context.Context, a *Asset) (*Asset, error)
	UpdateAsset(ctx context.Context, a *Asset) (*Asset, error)
	ListAssets(ctx context.Context, appID uuid.UUID) ([]*Asset, error)
	CreateLiability(ctx context.Context, l *Liability) (*Liability, error)
	UpdateLiability(ctx context.Context, l *Liability) (*Liability, error)
	ListLiabilities(ctx context.Context, appID uuid.UUID) ([]*Liability, error)
	UpsertFinancialRatio(ctx context.Context, r *FinancialRatio) (*FinancialRatio, error)
}

type FinancialUsecase struct {
	repo    FinancialRepo
	appRepo ApplicationRepo
	log     *log.Helper
}

func NewFinancialUsecase(repo FinancialRepo, appRepo ApplicationRepo, logger log.Logger) *FinancialUsecase {
	return &FinancialUsecase{
		repo:    repo,
		appRepo: appRepo,
		log:     log.NewHelper(logger),
	}
}

func (uc *FinancialUsecase) checkLock(ctx context.Context, appID uuid.UUID) error {
	app, err := uc.appRepo.FindByID(ctx, appID)
	if err != nil {
		return err
	}
	isTerminal, _ := uc.appRepo.IsTerminalStatus(ctx, string(app.Status))
	if isTerminal {
		return fmt.Errorf("application %s is locked and financial data cannot be modified", appID)
	}
	return nil
}

func (uc *FinancialUsecase) ListFinancialFacts(ctx context.Context, appID uuid.UUID) ([]*FinancialFact, error) {
	return uc.repo.ListFinancialFacts(ctx, appID)
}

func (uc *FinancialUsecase) UpsertFinancialFact(ctx context.Context, f *FinancialFact) (*FinancialFact, error) {
	if err := uc.checkLock(ctx, f.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.UpsertFinancialFact(ctx, f)
}

func (uc *FinancialUsecase) CreateAsset(ctx context.Context, a *Asset) (*Asset, error) {
	if err := uc.checkLock(ctx, a.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.CreateAsset(ctx, a)
}

func (uc *FinancialUsecase) UpdateAsset(ctx context.Context, a *Asset) (*Asset, error) {
	if err := uc.checkLock(ctx, a.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.UpdateAsset(ctx, a)
}

func (uc *FinancialUsecase) ListAssets(ctx context.Context, appID uuid.UUID) ([]*Asset, error) {
	return uc.repo.ListAssets(ctx, appID)
}

func (uc *FinancialUsecase) CreateLiability(ctx context.Context, l *Liability) (*Liability, error) {
	if err := uc.checkLock(ctx, l.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.CreateLiability(ctx, l)
}

func (uc *FinancialUsecase) UpdateLiability(ctx context.Context, l *Liability) (*Liability, error) {
	if err := uc.checkLock(ctx, l.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.UpdateLiability(ctx, l)
}

func (uc *FinancialUsecase) ListLiabilities(ctx context.Context, appID uuid.UUID) ([]*Liability, error) {
	return uc.repo.ListLiabilities(ctx, appID)
}

func (uc *FinancialUsecase) UpsertFinancialRatio(ctx context.Context, r *FinancialRatio) (*FinancialRatio, error) {
	if err := uc.checkLock(ctx, r.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.UpsertFinancialRatio(ctx, r)
}
