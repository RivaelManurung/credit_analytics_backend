package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type financialRepo struct {
	data *Data
	log  *log.Helper
}

func NewFinancialRepo(data *Data, logger log.Logger) biz.FinancialRepo {
	return &financialRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *financialRepo) ListFinancialFacts(ctx context.Context, appID uuid.UUID) ([]*biz.FinancialFact, error) {
	facts, err := r.data.db.ListFinancialFacts(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*biz.FinancialFact
	for _, f := range facts {
		res = append(res, &biz.FinancialFact{
			ID:              f.ID,
			ApplicationID:   f.ApplicationID,
			GLCode:          f.GlCode,
			PeriodType:      f.PeriodType,
			PeriodLabel:     f.PeriodLabel,
			Amount:          f.Amount,
			Source:          f.Source.String,
			ConfidenceLevel: f.ConfidenceLevel.String,
			CreatedAt:       f.CreatedAt.Time,
		})
	}
	return res, nil
}

func (r *financialRepo) UpsertFinancialFact(ctx context.Context, f *biz.FinancialFact) (*biz.FinancialFact, error) {
	amount, _ := decimal.NewFromString(f.Amount)
	res, err := r.data.db.UpsertFinancialFact(ctx, db.UpsertFinancialFactParams{
		ApplicationID:   f.ApplicationID,
		GlCode:          f.GLCode,
		PeriodType:      f.PeriodType,
		PeriodLabel:     f.PeriodLabel,
		Amount:          amount.String(),
		Source:          sql.NullString{String: f.Source, Valid: f.Source != ""},
		ConfidenceLevel: sql.NullString{String: f.ConfidenceLevel, Valid: f.ConfidenceLevel != ""},
	})
	if err != nil {
		return nil, err
	}
	return &biz.FinancialFact{
		ID:              res.ID,
		ApplicationID:   res.ApplicationID,
		GLCode:          res.GlCode,
		PeriodType:      res.PeriodType,
		PeriodLabel:     res.PeriodLabel,
		Amount:          res.Amount,
		Source:          res.Source.String,
		ConfidenceLevel: res.ConfidenceLevel.String,
		CreatedAt:       res.CreatedAt.Time,
	}, nil
}

func (r *financialRepo) CreateAsset(ctx context.Context, a *biz.Asset) (*biz.Asset, error) {
	val, _ := decimal.NewFromString(a.EstimatedValue)
	res, err := r.data.db.CreateAsset(ctx, db.CreateAssetParams{
		ApplicationID:   a.ApplicationID,
		AssetTypeCode:   sql.NullString{String: a.AssetTypeCode, Valid: true},
		AssetName:       sql.NullString{String: a.AssetName, Valid: true},
		OwnershipStatus: sql.NullString{String: a.OwnershipStatus, Valid: a.OwnershipStatus != ""},
		AcquisitionYear: sql.NullInt32{Int32: a.AcquisitionYear, Valid: a.AcquisitionYear != 0},
		EstimatedValue:  sql.NullString{String: val.String(), Valid: true},
		ValuationMethod: sql.NullString{String: a.ValuationMethod, Valid: a.ValuationMethod != ""},
		LocationText:    sql.NullString{String: a.LocationText, Valid: a.LocationText != ""},
		Encumbered:      sql.NullBool{Bool: a.Encumbered, Valid: true},
	})
	if err != nil {
		return nil, err
	}
	return mapAssetToBiz(&res), nil
}

func (r *financialRepo) UpdateAsset(ctx context.Context, a *biz.Asset) (*biz.Asset, error) {
	val, _ := decimal.NewFromString(a.EstimatedValue)
	res, err := r.data.db.UpdateAsset(ctx, db.UpdateAssetParams{
		ID:              a.ID,
		AssetTypeCode:   sql.NullString{String: a.AssetTypeCode, Valid: true},
		AssetName:       sql.NullString{String: a.AssetName, Valid: true},
		OwnershipStatus: sql.NullString{String: a.OwnershipStatus, Valid: a.OwnershipStatus != ""},
		AcquisitionYear: sql.NullInt32{Int32: a.AcquisitionYear, Valid: a.AcquisitionYear != 0},
		EstimatedValue:  sql.NullString{String: val.String(), Valid: true},
		ValuationMethod: sql.NullString{String: a.ValuationMethod, Valid: a.ValuationMethod != ""},
		LocationText:    sql.NullString{String: a.LocationText, Valid: a.LocationText != ""},
		Encumbered:      sql.NullBool{Bool: a.Encumbered, Valid: true},
	})
	if err != nil {
		return nil, err
	}
	return mapAssetToBiz(&res), nil
}

func mapAssetToBiz(res *db.ApplicationAsset) *biz.Asset {
	return &biz.Asset{
		ID:              res.ID,
		ApplicationID:   res.ApplicationID,
		AssetTypeCode:   res.AssetTypeCode.String,
		AssetName:       res.AssetName.String,
		OwnershipStatus: res.OwnershipStatus.String,
		AcquisitionYear: res.AcquisitionYear.Int32,
		EstimatedValue:  res.EstimatedValue.String,
		ValuationMethod: res.ValuationMethod.String,
		LocationText:    res.LocationText.String,
		Encumbered:      res.Encumbered.Bool,
	}
}

func (r *financialRepo) ListAssets(ctx context.Context, appID uuid.UUID) ([]*biz.Asset, error) {
	assets, err := r.data.db.ListAssets(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*biz.Asset
	for _, a := range assets {
		res = append(res, &biz.Asset{
			ID:              a.ID,
			ApplicationID:   a.ApplicationID,
			AssetTypeCode:   a.AssetTypeCode.String,
			AssetName:       a.AssetName.String,
			OwnershipStatus: a.OwnershipStatus.String,
			AcquisitionYear: a.AcquisitionYear.Int32,
			EstimatedValue:  a.EstimatedValue.String,
			ValuationMethod: a.ValuationMethod.String,
			LocationText:    a.LocationText.String,
			Encumbered:      a.Encumbered.Bool,
		})
	}
	return res, nil
}

func (r *financialRepo) CreateLiability(ctx context.Context, l *biz.Liability) (*biz.Liability, error) {
	outstanding, _ := decimal.NewFromString(l.OutstandingAmount)
	installment, _ := decimal.NewFromString(l.MonthlyInstallment)
	rate, _ := decimal.NewFromString(l.InterestRate)

	res, err := r.data.db.CreateLiability(ctx, db.CreateLiabilityParams{
		ApplicationID:      l.ApplicationID,
		CreditorName:       sql.NullString{String: l.CreditorName, Valid: true},
		LiabilityType:      sql.NullString{String: l.LiabilityType, Valid: l.LiabilityType != ""},
		OutstandingAmount:  sql.NullString{String: outstanding.String(), Valid: true},
		MonthlyInstallment: sql.NullString{String: installment.String(), Valid: true},
		InterestRate:       sql.NullString{String: rate.String(), Valid: true},
		MaturityDate:       sql.NullTime{Time: l.MaturityDate, Valid: !l.MaturityDate.IsZero()},
		Source:             sql.NullString{String: l.Source, Valid: l.Source != ""},
	})
	if err != nil {
		return nil, err
	}
	return mapLiabilityToBiz(&res), nil
}

func (r *financialRepo) UpdateLiability(ctx context.Context, l *biz.Liability) (*biz.Liability, error) {
	outstanding, _ := decimal.NewFromString(l.OutstandingAmount)
	installment, _ := decimal.NewFromString(l.MonthlyInstallment)
	rate, _ := decimal.NewFromString(l.InterestRate)

	res, err := r.data.db.UpdateLiability(ctx, db.UpdateLiabilityParams{
		ID:                 l.ID,
		CreditorName:       sql.NullString{String: l.CreditorName, Valid: true},
		LiabilityType:      sql.NullString{String: l.LiabilityType, Valid: l.LiabilityType != ""},
		OutstandingAmount:  sql.NullString{String: outstanding.String(), Valid: true},
		MonthlyInstallment: sql.NullString{String: installment.String(), Valid: true},
		InterestRate:       sql.NullString{String: rate.String(), Valid: true},
		MaturityDate:       sql.NullTime{Time: l.MaturityDate, Valid: !l.MaturityDate.IsZero()},
		Source:             sql.NullString{String: l.Source, Valid: l.Source != ""},
	})
	if err != nil {
		return nil, err
	}
	return mapLiabilityToBiz(&res), nil
}

func mapLiabilityToBiz(res *db.ApplicationLiability) *biz.Liability {
	return &biz.Liability{
		ID:                 res.ID,
		ApplicationID:      res.ApplicationID,
		CreditorName:       res.CreditorName.String,
		LiabilityType:      res.LiabilityType.String,
		OutstandingAmount:  res.OutstandingAmount.String,
		MonthlyInstallment: res.MonthlyInstallment.String,
		InterestRate:       res.InterestRate.String,
		MaturityDate:       res.MaturityDate.Time,
		Source:             res.Source.String,
	}
}

func (r *financialRepo) ListLiabilities(ctx context.Context, appID uuid.UUID) ([]*biz.Liability, error) {
	liabilities, err := r.data.db.ListLiabilities(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*biz.Liability
	for _, l := range liabilities {
		res = append(res, &biz.Liability{
			ID:                 l.ID,
			ApplicationID:      l.ApplicationID,
			CreditorName:       l.CreditorName.String,
			LiabilityType:      l.LiabilityType.String,
			OutstandingAmount:  l.OutstandingAmount.String,
			MonthlyInstallment: l.MonthlyInstallment.String,
			InterestRate:       l.InterestRate.String,
			MaturityDate:       l.MaturityDate.Time,
			Source:             l.Source.String,
		})
	}
	return res, nil
}

func (r *financialRepo) UpsertFinancialRatio(ctx context.Context, rr *biz.FinancialRatio) (*biz.FinancialRatio, error) {
	val, _ := decimal.NewFromString(rr.RatioValue)
	res, err := r.data.db.UpsertFinancialRatio(ctx, db.UpsertFinancialRatioParams{
		ApplicationID:      rr.ApplicationID,
		RatioCode:          sql.NullString{String: rr.RatioCode, Valid: true},
		RatioValue:         sql.NullString{String: val.String(), Valid: true},
		CalculationVersion: sql.NullString{String: rr.CalculationVersion, Valid: rr.CalculationVersion != ""},
	})
	if err != nil {
		return nil, err
	}
	return &biz.FinancialRatio{
		ID:                 res.ID,
		ApplicationID:      res.ApplicationID,
		RatioCode:          res.RatioCode.String,
		RatioValue:         res.RatioValue.String,
		CalculationVersion: res.CalculationVersion.String,
		CalculatedAt:       res.CalculatedAt.Time,
	}, nil
}
