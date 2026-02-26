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

// -----------------------------------------------------------------------
// LOAN PRODUCTS
// -----------------------------------------------------------------------

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

// -----------------------------------------------------------------------
// BRANCHES & OFFICERS
// -----------------------------------------------------------------------

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

// -----------------------------------------------------------------------
// APPLICATION STATUSES & FINANCIAL GL ACCOUNTS
// -----------------------------------------------------------------------

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

// -----------------------------------------------------------------------
// ATTRIBUTE CATEGORIES (dynamic, icon stored here)
// -----------------------------------------------------------------------

func mapCategoryToBiz(c db.AttributeCategory) *biz.AttributeCategory {
	return &biz.AttributeCategory{
		CategoryCode: c.CategoryCode,
		CategoryName: c.CategoryName,
		UiIcon:       c.UiIcon.String,
		DisplayOrder: c.DisplayOrder.Int32,
		Description:  c.Description.String,
	}
}

func (r *referenceRepo) ListAttributeCategories(ctx context.Context) ([]*biz.AttributeCategory, error) {
	rows, err := r.data.db.ListAttributeCategories(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.AttributeCategory
	for _, row := range rows {
		res = append(res, mapCategoryToBiz(row))
	}
	return res, nil
}

func (r *referenceRepo) GetAttributeCategory(ctx context.Context, categoryCode string) (*biz.AttributeCategory, error) {
	row, err := r.data.db.GetAttributeCategory(ctx, categoryCode)
	if err != nil {
		return nil, err
	}
	return mapCategoryToBiz(row), nil
}

func (r *referenceRepo) CreateAttributeCategory(ctx context.Context, cat *biz.AttributeCategory) error {
	return r.data.db.CreateAttributeCategory(ctx, db.CreateAttributeCategoryParams{
		CategoryCode: cat.CategoryCode,
		CategoryName: cat.CategoryName,
		UiIcon:       sql.NullString{String: cat.UiIcon, Valid: cat.UiIcon != ""},
		DisplayOrder: sql.NullInt32{Int32: cat.DisplayOrder, Valid: true},
		Description:  sql.NullString{String: cat.Description, Valid: cat.Description != ""},
	})
}

func (r *referenceRepo) UpdateAttributeCategory(ctx context.Context, cat *biz.AttributeCategory) error {
	return r.data.db.UpdateAttributeCategory(ctx, db.UpdateAttributeCategoryParams{
		CategoryCode: cat.CategoryCode,
		CategoryName: cat.CategoryName,
		UiIcon:       sql.NullString{String: cat.UiIcon, Valid: cat.UiIcon != ""},
		DisplayOrder: sql.NullInt32{Int32: cat.DisplayOrder, Valid: true},
		Description:  sql.NullString{String: cat.Description, Valid: cat.Description != ""},
	})
}

func (r *referenceRepo) DeleteAttributeCategory(ctx context.Context, categoryCode string) error {
	return r.data.db.DeleteAttributeCategory(ctx, categoryCode)
}

// -----------------------------------------------------------------------
// ATTRIBUTE REGISTRIES
// -----------------------------------------------------------------------

func (r *referenceRepo) ListAttributeRegistry(ctx context.Context) ([]*biz.AttributeRegistry, error) {
	attrs, err := r.data.db.ListAttributeRegistry(ctx)
	if err != nil {
		return nil, err
	}

	// Fetch all options to avoid N+1 queries
	allOptions, err := r.data.db.ListAttributeOptions(ctx)
	if err != nil {
		return nil, err
	}

	// Group options by attribute_id
	optMap := make(map[uuid.UUID][]*biz.AttributeOption)
	for _, o := range allOptions {
		bizOpt := &biz.AttributeOption{
			ID:           o.ID,
			AttributeID:  o.AttributeID,
			OptionValue:  o.OptionValue,
			OptionLabel:  o.OptionLabel,
			DisplayOrder: o.DisplayOrder.Int32,
			IsActive:     o.IsActive.Bool,
		}
		optMap[o.AttributeID] = append(optMap[o.AttributeID], bizOpt)
	}

	var res []*biz.AttributeRegistry
	for _, a := range attrs {
		bizAttr := &biz.AttributeRegistry{
			ID:            a.ID,
			AttributeCode: a.AttributeCode,
			AppliesTo:     a.AppliesTo,
			Scope:         a.Scope,
			DataType:      a.ValueType,
			CategoryCode:  a.CategoryCode.String,
			UiLabel:       a.UiLabel.String,
			IsRequired:    a.IsRequired.Bool,
			RiskRelevant:  a.RiskRelevant.Bool,
			IsActive:      a.IsActive.Bool,
			DisplayOrder:  a.DisplayOrder.Int32,
			Description:   a.Description.String,
			CategoryName:  a.CategoryName.String,
			CategoryIcon:  a.CategoryIcon.String,
			Options:       optMap[a.ID],
		}
		res = append(res, bizAttr)
	}
	return res, nil
}

func (r *referenceRepo) ListAttributeRegistryByCategory(ctx context.Context, categoryCode string) ([]*biz.AttributeRegistry, error) {
	attrs, err := r.data.db.ListAttributeRegistryByCategory(ctx, sql.NullString{String: categoryCode, Valid: categoryCode != ""})
	if err != nil {
		return nil, err
	}

	allOptions, err := r.data.db.ListAttributeOptions(ctx)
	if err != nil {
		return nil, err
	}

	optMap := make(map[uuid.UUID][]*biz.AttributeOption)
	for _, o := range allOptions {
		bizOpt := &biz.AttributeOption{
			ID:           o.ID,
			AttributeID:  o.AttributeID,
			OptionValue:  o.OptionValue,
			OptionLabel:  o.OptionLabel,
			DisplayOrder: o.DisplayOrder.Int32,
			IsActive:     o.IsActive.Bool,
		}
		optMap[o.AttributeID] = append(optMap[o.AttributeID], bizOpt)
	}

	var res []*biz.AttributeRegistry
	for _, a := range attrs {
		bizAttr := &biz.AttributeRegistry{
			ID:            a.ID,
			AttributeCode: a.AttributeCode,
			AppliesTo:     a.AppliesTo,
			Scope:         a.Scope,
			DataType:      a.ValueType,
			CategoryCode:  a.CategoryCode.String,
			UiLabel:       a.UiLabel.String,
			IsRequired:    a.IsRequired.Bool,
			RiskRelevant:  a.RiskRelevant.Bool,
			IsActive:      a.IsActive.Bool,
			DisplayOrder:  a.DisplayOrder.Int32,
			Description:   a.Description.String,
			CategoryName:  a.CategoryName.String,
			CategoryIcon:  a.CategoryIcon.String,
			Options:       optMap[a.ID],
		}
		res = append(res, bizAttr)
	}
	return res, nil
}

func (r *referenceRepo) CreateAttributeRegistry(ctx context.Context, attr *biz.AttributeRegistry) error {
	_, err := r.data.db.CreateAttributeRegistry(ctx, db.CreateAttributeRegistryParams{
		AttributeCode: attr.AttributeCode,
		AppliesTo:     attr.AppliesTo,
		Scope:         attr.Scope,
		ValueType:     attr.DataType,
		CategoryCode:  sql.NullString{String: attr.CategoryCode, Valid: attr.CategoryCode != ""},
		UiLabel:       sql.NullString{String: attr.UiLabel, Valid: attr.UiLabel != ""},
		IsRequired:    sql.NullBool{Bool: attr.IsRequired, Valid: true},
		RiskRelevant:  sql.NullBool{Bool: attr.RiskRelevant, Valid: true},
		IsActive:      sql.NullBool{Bool: attr.IsActive, Valid: true},
		DisplayOrder:  sql.NullInt32{Int32: attr.DisplayOrder, Valid: true},
		Description:   sql.NullString{String: attr.Description, Valid: attr.Description != ""},
	})
	return err
}

func (r *referenceRepo) UpdateAttributeRegistry(ctx context.Context, attr *biz.AttributeRegistry) error {
	_, err := r.data.db.UpdateAttributeRegistry(ctx, db.UpdateAttributeRegistryParams{
		ID:           attr.ID,
		AppliesTo:    attr.AppliesTo,
		Scope:        attr.Scope,
		ValueType:    attr.DataType,
		CategoryCode: sql.NullString{String: attr.CategoryCode, Valid: attr.CategoryCode != ""},
		UiLabel:      sql.NullString{String: attr.UiLabel, Valid: attr.UiLabel != ""},
		IsRequired:   sql.NullBool{Bool: attr.IsRequired, Valid: true},
		RiskRelevant: sql.NullBool{Bool: attr.RiskRelevant, Valid: true},
		IsActive:     sql.NullBool{Bool: attr.IsActive, Valid: true},
		DisplayOrder: sql.NullInt32{Int32: attr.DisplayOrder, Valid: true},
		Description:  sql.NullString{String: attr.Description, Valid: attr.Description != ""},
	})
	return err
}

func (r *referenceRepo) DeleteAttributeRegistry(ctx context.Context, id uuid.UUID) error {
	return r.data.db.DeleteAttributeRegistry(ctx, id)
}
