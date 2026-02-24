package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type referenceRepo struct {
	data *Data
	log  *log.Helper
}

func NewReferenceRepo(data *Data, logger log.Logger) biz.ReferenceRepo {
	return &referenceRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *referenceRepo) ListLoanProducts(ctx context.Context) ([]*biz.LoanProduct, error) {
	products, err := r.data.db.ListLoanProducts(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.LoanProduct
	for _, p := range products {
		res = append(res, &biz.LoanProduct{
			ID:          p.ID,
			ProductCode: p.ProductCode.String,
			ProductName: p.ProductName.String,
			Segment:     p.Segment.String,
			Active:      p.Active.Bool,
		})
	}
	return res, nil
}

func (r *referenceRepo) GetLoanProduct(ctx context.Context, id uuid.UUID) (*biz.LoanProduct, error) {
	p, err := r.data.db.GetLoanProduct(ctx, id)
	if err != nil {
		return nil, err
	}
	return &biz.LoanProduct{
		ID:          p.ID,
		ProductCode: p.ProductCode.String,
		ProductName: p.ProductName.String,
		Segment:     p.Segment.String,
		Active:      p.Active.Bool,
	}, nil
}

func (r *referenceRepo) ListBranches(ctx context.Context) ([]*biz.Branch, error) {
	branches, err := r.data.db.ListBranches(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.Branch
	for _, b := range branches {
		res = append(res, &biz.Branch{
			BranchCode: b.BranchCode,
			BranchName: b.BranchName.String,
			RegionCode: b.RegionCode.String,
		})
	}
	return res, nil
}

func (r *referenceRepo) ListLoanOfficers(ctx context.Context, branchCode string) ([]*biz.LoanOfficer, error) {
	officers, err := r.data.db.ListLoanOfficers(ctx, branchCode)
	if err != nil {
		return nil, err
	}
	var res []*biz.LoanOfficer
	for _, o := range officers {
		res = append(res, &biz.LoanOfficer{
			ID:          o.ID,
			OfficerCode: o.OfficerCode.String,
			BranchCode:  o.BranchCode,
		})
	}
	return res, nil
}

func (r *referenceRepo) ListApplicationStatuses(ctx context.Context) ([]*biz.ApplicationStatusRef, error) {
	statuses, err := r.data.db.ListApplicationStatuses(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.ApplicationStatusRef
	for _, s := range statuses {
		res = append(res, &biz.ApplicationStatusRef{
			StatusCode:  s.StatusCode,
			StatusGroup: s.StatusGroup.String,
			IsTerminal:  s.IsTerminal.Bool,
			Description: s.Description.String,
		})
	}
	return res, nil
}

func (r *referenceRepo) ListFinancialGLAccounts(ctx context.Context) ([]*biz.FinancialGLAccount, error) {
	accounts, err := r.data.db.ListFinancialGLAccounts(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.FinancialGLAccount
	for _, a := range accounts {
		res = append(res, &biz.FinancialGLAccount{
			GLCode:        a.GlCode,
			GLName:        a.GlName.String,
			StatementType: a.StatementType,
			Category:      a.Category,
			Sign:          a.Sign,
			IsDebtService: a.IsDebtService.Bool,
			IsOperating:   a.IsOperating.Bool,
			Description:   a.Description.String,
		})
	}
	return res, nil
}

func (r *referenceRepo) ListAttributeRegistry(ctx context.Context) ([]*biz.AttributeRegistry, error) {
	attrs, err := r.data.db.ListAttributeRegistry(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.AttributeRegistry
	for _, a := range attrs {
		res = append(res, &biz.AttributeRegistry{
			AttrKey:    a.AttributeCode,
			AttrName:   a.Description.String,
			DataType:   a.ValueType,
			Category:   a.Category.String,
			IsRequired: a.IsRequired.Bool,
			UiIcon:     a.UiIcon.String,
			UiLabel:    a.UiLabel.String,
		})
	}
	return res, nil
}

func (r *referenceRepo) CreateAttributeRegistry(ctx context.Context, attr *biz.AttributeRegistry) error {
	return r.data.db.CreateAttributeRegistry(ctx, db.CreateAttributeRegistryParams{
		AttributeCode: attr.AttrKey,
		AppliesTo:     "BOTH", // Default to BOTH for Registry creation
		Scope:         "APPLICANT",
		ValueType:     attr.DataType,
		Category:      sql.NullString{String: attr.Category, Valid: true},
		IsRequired:    sql.NullBool{Bool: attr.IsRequired, Valid: true},
		Description:   sql.NullString{String: attr.AttrName, Valid: true},
		UiIcon:        sql.NullString{String: attr.UiIcon, Valid: true},
		UiLabel:       sql.NullString{String: attr.UiLabel, Valid: true},
	})
}
