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
		// POINT 22: Audit Log - Fetch existing status to see if it changed
		existing, err := q.GetApplication(ctx, a.ID)
		if err != nil {
			return fmt.Errorf("failed to fetch existing application for audit: %w", err)
		}

		_, err = q.UpdateApplication(ctx, db.UpdateApplicationParams{
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

		// POINT 22: Audit Log - Record status transition if changed
		if existing.Status != string(a.Status) {
			_, err = q.CreateStatusLog(ctx, db.CreateStatusLogParams{
				ApplicationID: a.ID,
				FromStatus:    sql.NullString{String: existing.Status, Valid: true},
				ToStatus:      sql.NullString{String: string(a.Status), Valid: true},
				// Note: changed_by could be passed from context if we had auth
				ChangeReason: sql.NullString{String: "Status updated by system/usecase", Valid: true},
			})
			if err != nil {
				return fmt.Errorf("failed to record status audit log: %w", err)
			}
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

func (r *applicationRepo) SaveParty(ctx context.Context, p *biz.Party) (uuid.UUID, error) {
	res, err := r.data.db.CreateParty(ctx, db.CreatePartyParams{
		PartyType:   sql.NullString{String: p.PartyType, Valid: true},
		Identifier:  sql.NullString{String: p.Identifier, Valid: true},
		Name:        sql.NullString{String: p.Name, Valid: true},
		DateOfBirth: sql.NullTime{Time: p.DateOfBirth, Valid: !p.DateOfBirth.IsZero()},
	})
	if err != nil {
		return uuid.Nil, err
	}
	return res.ID, nil
}

func (r *applicationRepo) AddPartyToApplication(ctx context.Context, appID uuid.UUID, partyID uuid.UUID, role string, slikRequired bool) error {
	_, err := r.data.db.CreateApplicationParty(ctx, db.CreateApplicationPartyParams{
		ApplicationID:   appID,
		PartyID:         partyID,
		RoleCode:        role,
		SlikRequired:    sql.NullBool{Bool: slikRequired, Valid: true},
		LegalObligation: sql.NullBool{Bool: true, Valid: true},
	})
	return err
}

func (r *applicationRepo) GetParties(ctx context.Context, appID uuid.UUID) ([]biz.ApplicationParty, error) {
	rows, err := r.data.db.GetPartiesByApplication(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []biz.ApplicationParty
	for _, row := range rows {
		res = append(res, biz.ApplicationParty{
			Party: biz.Party{
				ID:          row.ID,
				PartyType:   row.PartyType.String,
				Identifier:  row.Identifier.String,
				Name:        row.Name.String,
				DateOfBirth: row.DateOfBirth.Time,
			},
			RoleCode:        row.RoleCode,
			SlikRequired:    row.SlikRequired.Bool,
			LegalObligation: row.LegalObligation.Bool,
		})
	}
	return res, nil
}

func (r *applicationRepo) ListAvailableAOs(ctx context.Context, branchCode string) ([]uuid.UUID, error) {
	aos, err := r.data.db.ListLoanOfficers(ctx, branchCode)
	if err != nil {
		return nil, err
	}
	var res []uuid.UUID
	for _, ao := range aos {
		res = append(res, ao.ID)
	}
	return res, nil
}

func (r *applicationRepo) SaveDocument(ctx context.Context, doc *biz.ApplicationDocument) error {
	_, err := r.data.db.CreateApplicationDocument(ctx, db.CreateApplicationDocumentParams{
		ID:            doc.ID,
		ApplicationID: doc.ApplicationID,
		DocumentName:  doc.DocumentName,
		FileUrl:       doc.FileURL,
		DocumentType:  sql.NullString{String: doc.DocumentType, Valid: true},
		UploadedAt:    sql.NullTime{Time: doc.UploadedAt, Valid: true},
	})
	return err
}

func (r *applicationRepo) ListDocuments(ctx context.Context, appID uuid.UUID) ([]biz.ApplicationDocument, error) {
	rows, err := r.data.db.ListApplicationDocuments(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []biz.ApplicationDocument
	for _, row := range rows {
		res = append(res, biz.ApplicationDocument{
			ID:            row.ID,
			ApplicationID: row.ApplicationID,
			DocumentName:  row.DocumentName,
			FileURL:       row.FileUrl,
			DocumentType:  row.DocumentType.String,
			UploadedAt:    row.UploadedAt.Time,
		})
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
