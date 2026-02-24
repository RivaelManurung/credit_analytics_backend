package biz

import (
	"context"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type LoanProduct struct {
	ID          uuid.UUID
	ProductCode string
	ProductName string
	Segment     string
	Active      bool
}

type Branch struct {
	BranchCode string
	BranchName string
	RegionCode string
}

type LoanOfficer struct {
	ID          uuid.UUID
	OfficerCode string
	BranchCode  string
}

type ApplicationStatusRef struct {
	StatusCode  string
	StatusGroup string
	IsTerminal  bool
	Description string
}

type FinancialGLAccount struct {
	GLCode        string
	GLName        string
	StatementType string
	Category      string
	Sign          int32
	IsDebtService bool
	IsOperating   bool
	Description   string
}

type AttributeRegistry struct {
	AttrKey    string
	AttrName   string
	DataType   string
	Category   string
	IsRequired bool
}

type ReferenceRepo interface {
	ListLoanProducts(ctx context.Context) ([]*LoanProduct, error)
	GetLoanProduct(ctx context.Context, id uuid.UUID) (*LoanProduct, error)
	ListBranches(ctx context.Context) ([]*Branch, error)
	ListLoanOfficers(ctx context.Context, branchCode string) ([]*LoanOfficer, error)
	ListApplicationStatuses(ctx context.Context) ([]*ApplicationStatusRef, error)
	ListFinancialGLAccounts(ctx context.Context) ([]*FinancialGLAccount, error)
	ListAttributeRegistry(ctx context.Context) ([]*AttributeRegistry, error)
	CreateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error
}

type ReferenceUsecase struct {
	repo ReferenceRepo
	log  *log.Helper
}

func NewReferenceUsecase(repo ReferenceRepo, logger log.Logger) *ReferenceUsecase {
	return &ReferenceUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *ReferenceUsecase) ListLoanProducts(ctx context.Context) ([]*LoanProduct, error) {
	return uc.repo.ListLoanProducts(ctx)
}

func (uc *ReferenceUsecase) GetLoanProduct(ctx context.Context, id uuid.UUID) (*LoanProduct, error) {
	return uc.repo.GetLoanProduct(ctx, id)
}

func (uc *ReferenceUsecase) ListBranches(ctx context.Context) ([]*Branch, error) {
	return uc.repo.ListBranches(ctx)
}

func (uc *ReferenceUsecase) ListLoanOfficers(ctx context.Context, branchCode string) ([]*LoanOfficer, error) {
	return uc.repo.ListLoanOfficers(ctx, branchCode)
}

func (uc *ReferenceUsecase) ListApplicationStatuses(ctx context.Context) ([]*ApplicationStatusRef, error) {
	return uc.repo.ListApplicationStatuses(ctx)
}

func (uc *ReferenceUsecase) ListFinancialGLAccounts(ctx context.Context) ([]*FinancialGLAccount, error) {
	return uc.repo.ListFinancialGLAccounts(ctx)
}

func (uc *ReferenceUsecase) ListAttributeRegistry(ctx context.Context) ([]*AttributeRegistry, error) {
	return uc.repo.ListAttributeRegistry(ctx)
}

func (uc *ReferenceUsecase) CreateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error {
	return uc.repo.CreateAttributeRegistry(ctx, attr)
}
