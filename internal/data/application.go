package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type cursorData struct {
	CreatedAt time.Time `json:"t"`
	ID        uuid.UUID `json:"i"`
}

func encodeCursor(t time.Time, id uuid.UUID) string {
	data, _ := json.Marshal(cursorData{CreatedAt: t, ID: id})
	return base64.StdEncoding.EncodeToString(data)
}

func decodeCursor(s string) (time.Time, uuid.UUID, error) {
	if s == "" {
		return time.Time{}, uuid.Nil, nil
	}
	data, err := base64.StdEncoding.DecodeString(s)
	if err != nil {
		return time.Time{}, uuid.Nil, err
	}
	var c cursorData
	if err := json.Unmarshal(data, &c); err != nil {
		return time.Time{}, uuid.Nil, err
	}
	return c.CreatedAt, c.ID, nil
}

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
				ApplicationID:     app.ID,
				AttributeID:       attr.AttributeID,
				AttributeOptionID: uuid.NullUUID{UUID: attr.AttributeOptionID, Valid: attr.AttributeOptionID != uuid.Nil},
				AttrValue:         sql.NullString{String: attr.Value, Valid: true},
				DataType:          sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return fmt.Errorf("failed to upsert attribute %s: %w", attr.AttributeID, err)
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
				ApplicationID:     a.ID,
				AttributeID:       attr.AttributeID,
				AttributeOptionID: uuid.NullUUID{UUID: attr.AttributeOptionID, Valid: attr.AttributeOptionID != uuid.Nil},
				AttrValue:         sql.NullString{String: attr.Value, Valid: true},
				DataType:          sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return fmt.Errorf("failed to upsert attribute %s: %w", attr.AttributeID, err)
			}
		}
		return nil
	})
}

func (r *applicationRepo) FindByID(ctx context.Context, id uuid.UUID) (*biz.Application, error) {
	row, err := r.data.db.GetApplication(ctx, id)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("application not found: %s", id)
		}
		return nil, fmt.Errorf("failed to get application: %w", err)
	}

	res := mapGetRowToBiz(&row)

	attrs, err := r.data.db.GetApplicationAttributes(ctx, id)
	if err != nil {
		if err != sql.ErrNoRows {
			return nil, fmt.Errorf("failed to get application attributes: %w", err)
		}
	} else {
		for _, attr := range attrs {
			res.Attributes = append(res.Attributes, biz.ApplicationAttribute{
				AttributeID:       attr.AttributeID,
				AttributeOptionID: attr.AttributeOptionID.UUID,
				Value:             attr.AttrValue.String,
				DataType:          attr.DataType.String,
			})
		}
	}

	return res, nil
}

func (r *applicationRepo) List(ctx context.Context, params biz.PaginationParams, status string, applicantID uuid.UUID) (*biz.PaginatedList[*biz.Application], error) {
	limit := params.PageSize
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	cursorTime, cursorID, err := decodeCursor(params.Cursor)
	if err != nil {
		return nil, fmt.Errorf("invalid cursor: %w", err)
	}

	arg := db.ListApplicationsParams{
		Limit:       limit + 1, // Get one extra to check has_next
		Status:      sql.NullString{String: status, Valid: status != ""},
		ApplicantID: uuid.NullUUID{UUID: applicantID, Valid: applicantID != uuid.Nil},
	}
	if !cursorTime.IsZero() && cursorID != uuid.Nil {
		arg.CursorCreatedAt = sql.NullTime{Time: cursorTime, Valid: true}
		arg.CursorID = uuid.NullUUID{UUID: cursorID, Valid: true}
	}

	apps, err := r.data.db.ListApplications(ctx, arg)
	if err != nil {
		return nil, fmt.Errorf("failed to list applications: %w", err)
	}

	hasNext := false
	if len(apps) > int(limit) {
		hasNext = true
		apps = apps[:limit]
	}

	if len(apps) == 0 {
		return &biz.PaginatedList[*biz.Application]{Items: []*biz.Application{}, HasNext: false}, nil
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
		item := mapListRowToBiz(&app)
		item.Attributes = attrMap[app.ID]
		res = append(res, item)
	}

	nextCursor := ""
	if hasNext && len(res) > 0 {
		last := res[len(res)-1]
		nextCursor = encodeCursor(last.CreatedAt, last.ID)
	}

	return &biz.PaginatedList[*biz.Application]{
		Items:      res,
		NextCursor: nextCursor,
		HasNext:    hasNext,
	}, nil
}

func (r *applicationRepo) ListAll(ctx context.Context, limit int32) ([]*biz.Application, error) {
	if limit <= 0 {
		limit = 100
	}
	apps, err := r.data.db.ListApplications(ctx, db.ListApplicationsParams{Limit: limit})
	if err != nil {
		return nil, err
	}
	var res []*biz.Application
	for _, app := range apps {
		res = append(res, mapListRowToBiz(&app))
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

func (r *applicationRepo) IsTerminalStatus(ctx context.Context, status string) (bool, error) {
	res, err := r.data.db.GetStatusRef(ctx, status)
	if err != nil {
		if err == sql.ErrNoRows {
			return false, nil
		}
		return false, err
	}
	return res.IsTerminal.Bool, nil
}

func (r *applicationRepo) IsTransitionAllowed(ctx context.Context, productID uuid.UUID, fromStatus, toStatus string) (bool, error) {
	return r.data.db.CheckTransitionAllowed(ctx, db.CheckTransitionAllowedParams{
		ProductID:  productID,
		FromStatus: fromStatus,
		ToStatus:   toStatus,
	})
}

func (r *applicationRepo) GetInitialStatus(ctx context.Context, productID uuid.UUID) (string, error) {
	status, err := r.data.db.GetInitialStatusForProduct(ctx, productID)
	if err != nil {
		if err == sql.ErrNoRows {
			return "INTAKE", nil // Default fallback
		}
		return "", err
	}
	return status, nil
}

func (r *applicationRepo) batchGetAttributes(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID][]biz.ApplicationAttribute, error) {
	attrs, err := r.data.db.ListApplicationAttributesByIDs(ctx, ids)
	if err != nil {
		return nil, err
	}

	res := make(map[uuid.UUID][]biz.ApplicationAttribute)
	for _, attr := range attrs {
		res[attr.ApplicationID] = append(res[attr.ApplicationID], biz.ApplicationAttribute{
			AttributeID:       attr.AttributeID,
			AttributeOptionID: attr.AttributeOptionID.UUID,
			Value:             attr.AttrValue.String,
			DataType:          attr.DataType.String,
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
	}
}

func mapGetRowToBiz(row *db.GetApplicationRow) *biz.Application {
	loanAmount, _ := decimal.NewFromString(row.LoanAmount.String)
	interestRate, _ := decimal.NewFromString(row.InterestRate.String)

	return &biz.Application{
		ID:                 row.ID,
		ApplicantID:        row.ApplicantID,
		ApplicantName:      row.ApplicantName.String,
		ProductID:          row.ProductID,
		AoID:               row.AoID,
		LoanAmount:         biz.NewMoney(loanAmount, "IDR"),
		TenorMonths:        row.TenorMonths.Int32,
		InterestType:       row.InterestType.String,
		InterestRate:       biz.NewInterestRate(interestRate),
		LoanPurpose:        row.LoanPurpose.String,
		ApplicationChannel: row.ApplicationChannel.String,
		Status:             biz.ApplicationStatus(row.Status),
		BranchCode:         row.BranchCode,
		CreatedAt:          row.CreatedAt.Time,
	}
}

func mapListRowToBiz(row *db.ListApplicationsRow) *biz.Application {
	loanAmount, _ := decimal.NewFromString(row.LoanAmount.String)
	interestRate, _ := decimal.NewFromString(row.InterestRate.String)

	return &biz.Application{
		ID:                 row.ID,
		ApplicantID:        row.ApplicantID,
		ApplicantName:      row.ApplicantName.String,
		ProductID:          row.ProductID,
		AoID:               row.AoID,
		LoanAmount:         biz.NewMoney(loanAmount, "IDR"),
		TenorMonths:        row.TenorMonths.Int32,
		InterestType:       row.InterestType.String,
		InterestRate:       biz.NewInterestRate(interestRate),
		LoanPurpose:        row.LoanPurpose.String,
		ApplicationChannel: row.ApplicationChannel.String,
		Status:             biz.ApplicationStatus(row.Status),
		BranchCode:         row.BranchCode,
		CreatedAt:          row.CreatedAt.Time,
	}
}
