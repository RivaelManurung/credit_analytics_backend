package biz

import (
	"context"
	"fmt"
	"path/filepath"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

// Pagination
type PaginationParams struct {
	Cursor   string
	PageSize int32
}

type PaginatedList[T any] struct {
	Items      []T
	NextCursor string
	HasNext    bool
}

// Value Objects
type Money struct {
	Amount   decimal.Decimal
	Currency string
}

func NewMoney(amount decimal.Decimal, currency string) Money {
	return Money{Amount: amount, Currency: currency}
}

func (m Money) IsZero() bool {
	return m.Amount.IsZero()
}

type InterestRate struct {
	Value decimal.Decimal
}

func NewInterestRate(val decimal.Decimal) InterestRate {
	return InterestRate{Value: val}
}

// ApplicationStatus State Machine definitions
type ApplicationStatus string

const (
	StatusIntake    ApplicationStatus = "INTAKE"
	StatusSurvey    ApplicationStatus = "SURVEY"
	StatusAnalysis  ApplicationStatus = "ANALYSIS"
	StatusCommittee ApplicationStatus = "COMMITTEE"
	StatusApproved  ApplicationStatus = "APPROVED"
	StatusRejected  ApplicationStatus = "REJECTED"
	StatusCancelled ApplicationStatus = "CANCELLED"
)

func (s ApplicationStatus) IsTerminal() bool {
	return s == StatusApproved || s == StatusRejected || s == StatusCancelled
}

// IsValidStatus checks whether the status value is one of the defined constants.
func IsValidStatus(s string) bool {
	switch ApplicationStatus(s) {
	case StatusIntake, StatusSurvey, StatusAnalysis, StatusCommittee,
		StatusApproved, StatusRejected, StatusCancelled:
		return true
	}
	return false
}

// Domain Models
type Application struct {
	ID                 uuid.UUID
	ApplicantID        uuid.UUID
	ApplicantName      string
	ProductID          uuid.UUID
	AoID               uuid.UUID
	LoanAmount         Money
	TenorMonths        int32
	InterestType       string
	InterestRate       InterestRate
	LoanPurpose        string
	ApplicationChannel string
	Status             ApplicationStatus
	BranchCode         string
	Attributes         []ApplicationAttribute
	Parties            []ApplicationParty // Added to support Related Party
	CreatedAt          time.Time

	// Domain Events
	events []interface{}
}

func (a *Application) IsLocked() bool {
	return a.Status.IsTerminal()
}

func (a *Application) AddEvent(event interface{}) {
	a.events = append(a.events, event)
}

func (a *Application) Events() []interface{} {
	return a.events
}

// Domain Behavior / State Machine

// Step 3 & 5: Early Policy Gate & Intake Validation
func (a *Application) ValidateIntake() error {
	if a.LoanAmount.IsZero() {
		return &ErrInvalidArgument{Field: "loan_amount", Message: "must not be zero (Intake)"}
	}
	if a.TenorMonths <= 0 {
		return &ErrInvalidArgument{Field: "tenor_months", Message: "must be greater than zero (Intake)"}
	}
	if a.ProductID == uuid.Nil {
		return &ErrInvalidArgument{Field: "product_id", Message: "must not be empty (Intake)"}
	}
	return nil
}

// CheckEarlySLIK performs a preliminary SLIK creditworthiness check.
// In production this should call the actual SLIK API via an injected SLIKService interface.
// For now it always passes — integrate the real provider here.
func (a *Application) CheckEarlySLIK() (bool, string) {
	// TODO: Inject a real SLIKService and call it for each SlikRequired party.
	return true, "SLIK check passed (stub — integrate real provider)"
}

// Step 5: Early Policy Gate
func (a *Application) CheckPolicyGate() (bool, string) {
	// Mock Policy: Max 500M for Walk-in without AO initially
	limit := decimal.NewFromInt(500000000)
	if a.ApplicationChannel == "WALK_IN" && a.LoanAmount.Amount.GreaterThan(limit) {
		return false, "Loan amount exceeds policy for walk-in channel"
	}
	return true, "Passed Policy Gate"
}
func (a *Application) Submit() error {
	if a.Status != StatusIntake {
		return &ErrConflict{Message: fmt.Sprintf("cannot submit application in %s status", a.Status)}
	}
	if a.LoanAmount.IsZero() {
		return &ErrInvalidArgument{Field: "loan_amount", Message: "cannot be zero"}
	}
	a.Status = StatusSurvey
	return nil
}

func (a *Application) TransitionTo(newStatus ApplicationStatus) error {
	allowed := false
	switch a.Status {
	case StatusIntake:
		allowed = newStatus == StatusSurvey || newStatus == StatusCancelled || newStatus == StatusRejected
	case StatusSurvey:
		allowed = newStatus == StatusAnalysis || newStatus == StatusCancelled || newStatus == StatusRejected
	case StatusAnalysis:
		allowed = newStatus == StatusCommittee || newStatus == StatusApproved || newStatus == StatusRejected || newStatus == StatusCancelled
	case StatusCommittee:
		allowed = newStatus == StatusApproved || newStatus == StatusRejected || newStatus == StatusCancelled
	}

	if !allowed && a.Status != newStatus {
		return &ErrConflict{
			Message: fmt.Sprintf("invalid status transition from %s to %s", a.Status, newStatus),
		}
	}

	a.Status = newStatus
	return nil
}

func (a *Application) Archive() error {
	if !a.Status.IsTerminal() {
		return &ErrConflict{
			Message: "cannot archive application that is not in terminal state (APPROVED/REJECTED/CANCELLED)",
		}
	}
	return nil
}

type ApplicationAttribute struct {
	AttributeID       uuid.UUID
	AttributeOptionID uuid.UUID
	Value             string
	DataType          string
}

type Party struct {
	ID          uuid.UUID
	PartyType   string
	Identifier  string
	Name        string
	DateOfBirth time.Time
}

type ApplicationParty struct {
	Party           Party
	RoleCode        string
	LegalObligation bool
	SlikRequired    bool
}

type ApplicationDocument struct {
	ID            uuid.UUID
	ApplicationID uuid.UUID
	DocumentName  string
	FileURL       string
	DocumentType  string
	UploadedAt    time.Time
}

type ApplicationRepo interface {
	Save(context.Context, *Application) (uuid.UUID, error)
	Update(context.Context, *Application) error
	FindByID(context.Context, uuid.UUID) (*Application, error)
	List(ctx context.Context, params PaginationParams, status string, applicantID uuid.UUID) (*PaginatedList[*Application], error)
	ListAll(ctx context.Context, limit int32) ([]*Application, error)

	// Party Related
	SaveParty(context.Context, *Party) (uuid.UUID, error)
	AddPartyToApplication(ctx context.Context, appID uuid.UUID, partyID uuid.UUID, role string, slikRequired bool) error
	GetParties(ctx context.Context, appID uuid.UUID) ([]ApplicationParty, error)

	// AO Assignment Helpers
	ListAvailableAOs(ctx context.Context, branchCode string) ([]uuid.UUID, error)

	// Document Related
	SaveDocument(ctx context.Context, doc *ApplicationDocument) error
	ListDocuments(ctx context.Context, appID uuid.UUID) ([]ApplicationDocument, error)
}

type StorageService interface {
	GeneratePresignedPutURL(ctx context.Context, fileName string, contentType string) (uploadURL string, fileURL string, err error)
}

// Usecase
type ApplicationUsecase struct {
	repo    ApplicationRepo
	storage StorageService
	log     *log.Helper
}

func NewApplicationUsecase(repo ApplicationRepo, storage StorageService, logger log.Logger) *ApplicationUsecase {
	return &ApplicationUsecase{repo: repo, storage: storage, log: log.NewHelper(logger)}
}

func (uc *ApplicationUsecase) Create(ctx context.Context, app *Application) (uuid.UUID, error) {
	uc.log.WithContext(ctx).Infof("Creating Application: Applicant=%s", app.ApplicantID)
	// Enforcement before save
	if app.ID == uuid.Nil {
		app.ID, _ = uuid.NewV7()
	}
	app.Status = StatusIntake
	return uc.repo.Save(ctx, app)
}

// CreateLead creates an application and auto-assigns a borrower party and AO.
func (uc *ApplicationUsecase) CreateLead(ctx context.Context, app *Application, applicant *Applicant) (uuid.UUID, error) {
	id, err := uc.Create(ctx, app)
	if err != nil {
		return uuid.Nil, err
	}

	// Auto-add Borrower as the primary party.
	borID, err := uc.repo.SaveParty(ctx, &Party{
		PartyType:   applicant.ApplicantType,
		Name:        applicant.FullName,
		Identifier:  applicant.IdentityNumber,
		DateOfBirth: applicant.BirthDate,
	})
	if err != nil {
		uc.log.WithContext(ctx).Warnf("CreateLead: failed to save borrower party for app %s: %v", id, err)
	} else {
		if linkErr := uc.repo.AddPartyToApplication(ctx, id, borID, "BORROWER", true); linkErr != nil {
			uc.log.WithContext(ctx).Warnf("CreateLead: failed to link borrower party %s to app %s: %v", borID, id, linkErr)
		}
	}

	// AO Auto-assignment: pick the first available AO for the branch.
	if app.AoID == uuid.Nil && app.BranchCode != "" {
		aos, aoErr := uc.repo.ListAvailableAOs(ctx, app.BranchCode)
		if aoErr != nil {
			uc.log.WithContext(ctx).Warnf("CreateLead: failed to list AOs for branch %s: %v", app.BranchCode, aoErr)
		} else if len(aos) > 0 {
			app.AoID = aos[0]
			if updateErr := uc.repo.Update(ctx, app); updateErr != nil {
				uc.log.WithContext(ctx).Warnf("CreateLead: failed to assign AO %s to app %s: %v", app.AoID, id, updateErr)
			}
		}
	}

	return id, nil
}

// Step 4 & 5: Early Checks (100%)
func (uc *ApplicationUsecase) RunEarlyChecks(ctx context.Context, id uuid.UUID) (bool, string, error) {
	app, err := uc.repo.FindByID(ctx, id)
	if err != nil {
		return false, "", err
	}

	// Load parties for SLIK check
	parties, _ := uc.repo.GetParties(ctx, id)
	app.Parties = parties

	// Step 3: Intake Validation
	if err := app.ValidateIntake(); err != nil {
		return false, err.Error(), nil
	}

	// Step 4: Early SLIK
	if ok, msg := app.CheckEarlySLIK(); !ok {
		app.TransitionTo(StatusRejected)
		uc.repo.Update(ctx, app)
		return false, msg, nil
	}

	// Step 5: Early Policy Gate
	if ok, msg := app.CheckPolicyGate(); !ok {
		app.TransitionTo(StatusRejected)
		uc.repo.Update(ctx, app)
		return false, msg, nil
	}

	// If all pass, move to SURVEY status
	app.TransitionTo(StatusSurvey)
	uc.repo.Update(ctx, app)

	return true, "Passed all early checks", nil
}

func (uc *ApplicationUsecase) Submit(ctx context.Context, id uuid.UUID) error {
	app, err := uc.repo.FindByID(ctx, id)
	if err != nil {
		return err
	}
	if err := app.Submit(); err != nil {
		return err
	}
	return uc.repo.Update(ctx, app)
}

func (uc *ApplicationUsecase) Update(ctx context.Context, app *Application) error {
	uc.log.WithContext(ctx).Infof("Updating Application: ID=%s", app.ID)

	existing, err := uc.repo.FindByID(ctx, app.ID)
	if err != nil {
		return err
	}
	if existing.IsLocked() {
		return &ErrLocked{Resource: "application", ID: app.ID.String(), Status: string(existing.Status)}
	}

	return uc.repo.Update(ctx, app)
}

func (uc *ApplicationUsecase) Get(ctx context.Context, id uuid.UUID) (*Application, error) {
	uc.log.WithContext(ctx).Infof("Getting Application: ID=%s", id)
	return uc.repo.FindByID(ctx, id)
}

func (uc *ApplicationUsecase) List(ctx context.Context, params PaginationParams, status string, applicantID uuid.UUID) (*PaginatedList[*Application], error) {
	uc.log.WithContext(ctx).Info("Listing Applications with pagination")
	return uc.repo.List(ctx, params, status, applicantID)
}

// ListAll is reserved for internal/admin use only. Prefer List() with pagination for user-facing APIs.
func (uc *ApplicationUsecase) ListAll(ctx context.Context, limit int32) ([]*Application, error) {
	uc.log.WithContext(ctx).Info("Listing all Applications (admin)")
	return uc.repo.ListAll(ctx, limit)
}

func (uc *ApplicationUsecase) AddPartyToApplication(ctx context.Context, appID, partyID uuid.UUID, role string, slikRequired bool) error {
	return uc.repo.AddPartyToApplication(ctx, appID, partyID, role, slikRequired)
}

func (uc *ApplicationUsecase) GetParties(ctx context.Context, appID uuid.UUID) ([]ApplicationParty, error) {
	return uc.repo.GetParties(ctx, appID)
}

func (uc *ApplicationUsecase) UploadDocument(ctx context.Context, doc *ApplicationDocument) error {
	if doc.ID == uuid.Nil {
		doc.ID, _ = uuid.NewV7()
	}
	if doc.UploadedAt.IsZero() {
		doc.UploadedAt = time.Now()
	}
	return uc.repo.SaveDocument(ctx, doc)
}

func (uc *ApplicationUsecase) ListDocuments(ctx context.Context, appID uuid.UUID) ([]ApplicationDocument, error) {
	return uc.repo.ListDocuments(ctx, appID)
}

func (uc *ApplicationUsecase) GetPresignedUrl(ctx context.Context, fileName, fileType string) (uploadURL string, fileURL string, err error) {
	// Validate file type
	allowed := false
	for _, t := range []string{"pdf", "png", "jpeg", "jpg"} {
		if fileType == t {
			allowed = true
			break
		}
	}
	if !allowed {
		return "", "", fmt.Errorf("file type %s is not allowed (only pdf, png, jpeg)", fileType)
	}

	// Generate unique file name to avoid collisions
	ext := filepath.Ext(fileName)
	if ext == "" {
		ext = "." + fileType
	}
	newID, _ := uuid.NewV7()
	uniqueName := fmt.Sprintf("%d_%s%s", time.Now().UnixNano(), newID.String(), ext)

	// Map generic file types to mime types
	contentType := "application/octet-stream"
	switch fileType {
	case "pdf":
		contentType = "application/pdf"
	case "png":
		contentType = "image/png"
	case "jpeg", "jpg":
		contentType = "image/jpeg"
	}

	return uc.storage.GeneratePresignedPutURL(ctx, uniqueName, contentType)
}
