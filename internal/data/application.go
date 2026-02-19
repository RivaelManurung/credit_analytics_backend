package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"
	"fmt"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type applicationRepo struct {
	data *Data
	log  *log.Helper
}

// NewApplicationRepo .
func NewApplicationRepo(data *Data, logger log.Logger) biz.ApplicationRepo {
	return &applicationRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *applicationRepo) Save(ctx context.Context, a *biz.Application) (uuid.UUID, error) {
	err := r.data.InTx(ctx, func(q *db.Queries) error {
		app, err := q.CreateApplication(ctx, db.CreateApplicationParams{
			ApplicantID:        a.ApplicantID,
			ProductID:          a.ProductID,
			AoID:               a.AoID,
			LoanAmount:         sql.NullString{String: a.LoanAmount.Amount.String(), Valid: !a.LoanAmount.Amount.IsZero()},
			TenorMonths:        sql.NullInt32{Int32: a.TenorMonths, Valid: a.TenorMonths > 0},
			InterestType:       sql.NullString{String: a.InterestType, Valid: a.InterestType != ""},
			InterestRate:       sql.NullString{String: a.InterestRate.Value.String(), Valid: !a.InterestRate.Value.IsZero()},
			LoanPurpose:        sql.NullString{String: a.LoanPurpose, Valid: a.LoanPurpose != ""},
			ApplicationChannel: sql.NullString{String: a.ApplicationChannel, Valid: a.ApplicationChannel != ""},
			Status:             string(a.Status),
			BranchCode:         a.BranchCode,
		})
		if err != nil {
			return fmt.Errorf("failed to create application: %w", err)
		}
		a.ID = app.ID

		for _, attr := range a.Attributes {
			_, err = q.UpsertApplicationAttribute(ctx, db.UpsertApplicationAttributeParams{
				ApplicationID: app.ID,
				AttrKey:       attr.Key,
				AttrValue:     sql.NullString{String: attr.Value, Valid: true},
				DataType:      sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return fmt.Errorf("failed to upsert attribute %s: %w", attr.Key, err)
			}
		}
		return nil
	})
	if err != nil {
		return uuid.Nil, err
	}
	return a.ID, nil
}

func (r *applicationRepo) Update(ctx context.Context, a *biz.Application) error {
	return r.data.InTx(ctx, func(q *db.Queries) error {
		_, err := q.UpdateApplication(ctx, db.UpdateApplicationParams{
			ID:           a.ID,
			ApplicantID:  a.ApplicantID,
			ProductID:    a.ProductID,
			AoID:         a.AoID,
			LoanAmount:   sql.NullString{String: a.LoanAmount.Amount.String(), Valid: !a.LoanAmount.Amount.IsZero()},
			TenorMonths:  sql.NullInt32{Int32: a.TenorMonths, Valid: a.TenorMonths > 0},
			InterestType: sql.NullString{String: a.InterestType, Valid: a.InterestType != ""},
			InterestRate: sql.NullString{String: a.InterestRate.Value.String(), Valid: !a.InterestRate.Value.IsZero()},
			LoanPurpose:  sql.NullString{String: a.LoanPurpose, Valid: a.LoanPurpose != ""},
			Status:       string(a.Status),
		})
		if err != nil {
			return fmt.Errorf("failed to update application: %w", err)
		}

		for _, attr := range a.Attributes {
			_, err = q.UpsertApplicationAttribute(ctx, db.UpsertApplicationAttributeParams{
				ApplicationID: a.ID,
				AttrKey:       attr.Key,
				AttrValue:     sql.NullString{String: attr.Value, Valid: true},
				DataType:      sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return fmt.Errorf("failed to upsert attribute %s: %w", attr.Key, err)
			}
		}
		return nil
	})
}

func (r *applicationRepo) FindByID(ctx context.Context, id uuid.UUID) (*biz.Application, error) {
	app, err := r.data.db.GetApplication(ctx, id)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("application not found: %s", id)
		}
		return nil, fmt.Errorf("failed to get application: %w", err)
	}

	res := mapToBiz(&app)

	attrs, err := r.data.db.GetApplicationAttributes(ctx, id)
	if err != nil {
		if err != sql.ErrNoRows {
			return nil, fmt.Errorf("failed to get application attributes: %w", err)
		}
	} else {
		for _, attr := range attrs {
			res.Attributes = append(res.Attributes, biz.ApplicationAttribute{
				Key:      attr.AttrKey,
				Value:    attr.AttrValue.String,
				DataType: attr.DataType.String,
			})
		}
	}

	return res, nil
}

func (r *applicationRepo) ListAll(ctx context.Context) ([]*biz.Application, error) {
	apps, err := r.data.db.ListApplications(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to list applications: %w", err)
	}

	if len(apps) == 0 {
		return []*biz.Application{}, nil
	}

	appIDs := make([]uuid.UUID, len(apps))
	for i, app := range apps {
		appIDs[i] = app.ID
	}

	attrMap, err := r.batchGetAttributes(ctx, appIDs)
	if err != nil {
		return nil, fmt.Errorf("failed to batch get attributes: %w", err)
	}

	var res []*biz.Application
	for _, app := range apps {
		item := mapToBiz(&app)
		item.Attributes = attrMap[app.ID]
		res = append(res, item)
	}
	return res, nil
}

func (r *applicationRepo) batchGetAttributes(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID][]biz.ApplicationAttribute, error) {
	attrs, err := r.data.db.ListApplicationAttributesByIDs(ctx, ids)
	if err != nil {
		return nil, err
	}

	res := make(map[uuid.UUID][]biz.ApplicationAttribute)
	for _, attr := range attrs {
		res[attr.ApplicationID] = append(res[attr.ApplicationID], biz.ApplicationAttribute{
			Key:      attr.AttrKey,
			Value:    attr.AttrValue.String,
			DataType: attr.DataType.String,
		})
	}
	return res, nil
}

func mapToBiz(app *db.Application) *biz.Application {
	loanAmount, _ := decimal.NewFromString(app.LoanAmount.String)
	interestRate, _ := decimal.NewFromString(app.InterestRate.String)

	return &biz.Application{
		ID:                 app.ID,
		ApplicantID:        app.ApplicantID,
		ProductID:          app.ProductID,
		AoID:               app.AoID,
		LoanAmount:         biz.NewMoney(loanAmount, "IDR"),
		TenorMonths:        app.TenorMonths.Int32,
		InterestType:       app.InterestType.String,
		InterestRate:       biz.NewInterestRate(interestRate),
		LoanPurpose:        app.LoanPurpose.String,
		ApplicationChannel: app.ApplicationChannel.String,
		Status:             biz.ApplicationStatus(app.Status),
		BranchCode:         app.BranchCode,
		CreatedAt:          app.CreatedAt.Time,
		UpdatedAt:          app.UpdatedAt.Time,
	}
}
