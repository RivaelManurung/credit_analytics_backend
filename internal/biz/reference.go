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

// AttributeCategory adalah tabel master kategori yang dikelola secara dinamis via API.
// Icon disimpan di sini (satu icon per kategori), bukan di setiap atribut.
type AttributeCategory struct {
	CategoryCode string
	CategoryName string
	UiIcon       string // Nama icon Lucide/Heroicons, e.g. "id-card", "home"
	DisplayOrder int32
	Description  string
}

type AttributeOption struct {
	ID            uuid.UUID
	AttributeCode string
	OptionValue   string
	OptionLabel   string
	DisplayOrder  int32
	IsActive      bool
}

// AttributeRegistry adalah definisi sebuah atribut EAV.
// Tidak membawa icon sendiri — icon diambil dari kategorinya.
type AttributeRegistry struct {
	AttrKey      string
	AppliesTo    string
	Scope        string
	DataType     string
	CategoryCode string
	UiLabel      string // Label tampilan per atribut (bisa berbeda dari Description)
	IsRequired   bool
	RiskRelevant bool
	Description  string
	// Denormalized dari JOIN (read-only, tidak disimpan di registries)
	CategoryName string
	CategoryIcon string
	Options      []*AttributeOption // Daftar pilihan jika DataType = SELECT
}

type ReferenceRepo interface {
	ListLoanProducts(ctx context.Context) ([]*LoanProduct, error)
	GetLoanProduct(ctx context.Context, id uuid.UUID) (*LoanProduct, error)
	ListBranches(ctx context.Context) ([]*Branch, error)
	ListLoanOfficers(ctx context.Context, branchCode string) ([]*LoanOfficer, error)
	ListApplicationStatuses(ctx context.Context) ([]*ApplicationStatusRef, error)
	ListFinancialGLAccounts(ctx context.Context) ([]*FinancialGLAccount, error)

	// Attribute Categories — CRUD dinamis
	ListAttributeCategories(ctx context.Context) ([]*AttributeCategory, error)
	GetAttributeCategory(ctx context.Context, categoryCode string) (*AttributeCategory, error)
	CreateAttributeCategory(ctx context.Context, cat *AttributeCategory) error
	UpdateAttributeCategory(ctx context.Context, cat *AttributeCategory) error
	DeleteAttributeCategory(ctx context.Context, categoryCode string) error

	// Attribute Registries
	ListAttributeRegistry(ctx context.Context) ([]*AttributeRegistry, error)
	ListAttributeRegistryByCategory(ctx context.Context, categoryCode string) ([]*AttributeRegistry, error)
	CreateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error
	UpdateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error
	DeleteAttributeRegistry(ctx context.Context, attrKey string) error
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

// --- Attribute Categories ---

func (uc *ReferenceUsecase) ListAttributeCategories(ctx context.Context) ([]*AttributeCategory, error) {
	return uc.repo.ListAttributeCategories(ctx)
}

func (uc *ReferenceUsecase) GetAttributeCategory(ctx context.Context, code string) (*AttributeCategory, error) {
	return uc.repo.GetAttributeCategory(ctx, code)
}

func (uc *ReferenceUsecase) CreateAttributeCategory(ctx context.Context, cat *AttributeCategory) error {
	if cat.CategoryCode == "" {
		return &ErrInvalidArgument{Field: "category_code", Message: "must not be empty"}
	}
	if cat.CategoryName == "" {
		return &ErrInvalidArgument{Field: "category_name", Message: "must not be empty"}
	}
	return uc.repo.CreateAttributeCategory(ctx, cat)
}

func (uc *ReferenceUsecase) UpdateAttributeCategory(ctx context.Context, cat *AttributeCategory) error {
	if cat.CategoryCode == "" {
		return &ErrInvalidArgument{Field: "category_code", Message: "must not be empty"}
	}
	return uc.repo.UpdateAttributeCategory(ctx, cat)
}

func (uc *ReferenceUsecase) DeleteAttributeCategory(ctx context.Context, code string) error {
	return uc.repo.DeleteAttributeCategory(ctx, code)
}

// --- Attribute Registries ---

func (uc *ReferenceUsecase) ListAttributeRegistry(ctx context.Context) ([]*AttributeRegistry, error) {
	return uc.repo.ListAttributeRegistry(ctx)
}

func (uc *ReferenceUsecase) ListAttributeRegistryByCategory(ctx context.Context, categoryCode string) ([]*AttributeRegistry, error) {
	return uc.repo.ListAttributeRegistryByCategory(ctx, categoryCode)
}

func (uc *ReferenceUsecase) CreateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error {
	return uc.repo.CreateAttributeRegistry(ctx, attr)
}

func (uc *ReferenceUsecase) UpdateAttributeRegistry(ctx context.Context, attr *AttributeRegistry) error {
	return uc.repo.UpdateAttributeRegistry(ctx, attr)
}

func (uc *ReferenceUsecase) DeleteAttributeRegistry(ctx context.Context, attrKey string) error {
	return uc.repo.DeleteAttributeRegistry(ctx, attrKey)
}
