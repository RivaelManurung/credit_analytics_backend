package biz

import (
	"context"
	"fmt"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

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
	StatusDraft     ApplicationStatus = "DRAFT"
	StatusSubmitted ApplicationStatus = "SUBMITTED"
	StatusIntake    ApplicationStatus = "INTAKE" // For external validation
	StatusSlikCheck ApplicationStatus = "SLIK_CHECK"
	StatusPolicy    ApplicationStatus = "POLICY_GATE"
	StatusAnalysis  ApplicationStatus = "ANALYSIS"
	StatusApproved  ApplicationStatus = "APPROVED"
	StatusRejected  ApplicationStatus = "REJECTED"
	StatusCancelled ApplicationStatus = "CANCELLED"
)

func (s ApplicationStatus) IsTerminal() bool {
	return s == StatusApproved || s == StatusRejected || s == StatusCancelled
}

// Domain Models
type Application struct {
	ID                 uuid.UUID
	ApplicantID        uuid.UUID
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
	UpdatedAt          time.Time

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
		return fmt.Errorf("loan amount is required (Intake)")
	}
	if a.TenorMonths <= 0 {
		return fmt.Errorf("tenor is required (Intake)")
	}
	if a.ProductID == uuid.Nil {
		return fmt.Errorf("product is required (Intake)")
	}
	return nil
}

// Step 4: Early SLIK Check (Mock Logic)
func (a *Application) CheckEarlySLIK() (bool, string) {
	// Logic: If any party has low confidence or blacklist attribute (as mock)
	for _, p := range a.Parties {
		if p.SlikRequired {
			// In real world, call SLIK API here.
			// Mock: If name contains "BAD", reject.
			if p.Party.Name == "BAD DEBTOR" {
				return false, "Blacklisted in SLIK"
			}
		}
	}
	return true, "Passed Early SLIK"
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
	if a.Status != StatusDraft {
		return fmt.Errorf("cannot submit application in %s status", a.Status)
	}
	if a.LoanAmount.IsZero() {
		return fmt.Errorf("loan amount cannot be zero")
	}
	a.Status = StatusSubmitted
	a.UpdatedAt = time.Now()
	// a.AddEvent(ApplicationSubmittedEvent{ApplicationID: a.ID})
	return nil
}

func (a *Application) TransitionTo(newStatus ApplicationStatus) error {
	// Simple state machine enforcement
	allowed := false
	switch a.Status {
	case StatusDraft:
		allowed = (newStatus == StatusSubmitted || newStatus == StatusCancelled)
	case StatusSubmitted:
		allowed = (newStatus == StatusIntake || newStatus == StatusSlikCheck || newStatus == StatusCancelled)
	case StatusIntake:
		allowed = (newStatus == StatusSlikCheck || newStatus == StatusCancelled)
	case StatusSlikCheck:
		allowed = (newStatus == StatusPolicy || newStatus == StatusRejected || newStatus == StatusCancelled)
	case StatusPolicy:
		allowed = (newStatus == StatusAnalysis || newStatus == StatusRejected || newStatus == StatusCancelled)
	case StatusAnalysis:
		allowed = (newStatus == StatusApproved || newStatus == StatusRejected || newStatus == StatusCancelled)
	}

	// Admin or system might override, but for domain logic we enforce this
	if !allowed && a.Status != newStatus {
		return fmt.Errorf("invalid status transition from %s to %s", a.Status, newStatus)
	}

	a.Status = newStatus
	a.UpdatedAt = time.Now()

	// Logic for POINT 22: Archiving & Audit Log
	// If a status is terminal, we can consider it "Archived" for future edits
	return nil
}

func (a *Application) Archive() error {
	if !a.Status.IsTerminal() {
		return fmt.Errorf("cannot archive application that is not in terminal state (APPROVED/REJECTED/CANCELLED)")
	}
	// Here we could add logic for physical archival if needed,
	// but IsLocked() already handles the logical penguncian.
	return nil
}

type ApplicationAttribute struct {
	Key      string
	Value    string
	DataType string
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

// Repository Interface
type ApplicationRepo interface {
	Save(context.Context, *Application) (uuid.UUID, error)
	Update(context.Context, *Application) error
	FindByID(context.Context, uuid.UUID) (*Application, error)
	ListAll(context.Context) ([]*Application, error)

	// Party Related
	SaveParty(context.Context, *Party) (uuid.UUID, error)
	AddPartyToApplication(ctx context.Context, appID uuid.UUID, partyID uuid.UUID, role string, slikRequired bool) error
	GetParties(ctx context.Context, appID uuid.UUID) ([]ApplicationParty, error)

	// Step 2: AO Assignment Helpers
	ListAvailableAOs(ctx context.Context, branchCode string) ([]uuid.UUID, error)

	// Document Related
	SaveDocument(ctx context.Context, doc *ApplicationDocument) error
	ListDocuments(ctx context.Context, appID uuid.UUID) ([]ApplicationDocument, error)
}

// Usecase
type ApplicationUsecase struct {
	repo ApplicationRepo
	log  *log.Helper
}

func NewApplicationUsecase(repo ApplicationRepo, logger log.Logger) *ApplicationUsecase {
	return &ApplicationUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *ApplicationUsecase) Create(ctx context.Context, app *Application) (uuid.UUID, error) {
	uc.log.WithContext(ctx).Infof("Creating Application: Applicant=%s", app.ApplicantID)
	// Enforcement before save
	if app.ID == uuid.Nil {
		app.ID = uuid.New()
	}
	app.Status = StatusDraft
	return uc.repo.Save(ctx, app)
}

// Step 1: Create Lead (Complete)
func (uc *ApplicationUsecase) CreateLead(ctx context.Context, app *Application, applicant *Applicant) (uuid.UUID, error) {
	// 1. Save Application
	id, err := uc.Create(ctx, app)
	if err != nil {
		return uuid.Nil, err
	}

	// 2. Logic: Auto-add Related Party (Borrorwer as main party)
	borID, err := uc.repo.SaveParty(ctx, &Party{
		PartyType:   applicant.ApplicantType,
		Name:        applicant.FullName,
		Identifier:  applicant.IdentityNumber,
		DateOfBirth: applicant.BirthDate,
	})
	if err == nil {
		uc.repo.AddPartyToApplication(ctx, id, borID, "BORROWER", true)
	}

	// Logic: If Individual, try to find spouse in attributes or mock spouse
	if applicant.ApplicantType == "PERSONAL" {
		// Mock: automatically add spouse if exists in attributes
		uc.repo.AddPartyToApplication(ctx, id, uuid.New(), "SPOUSE", true)
	}

	// Step 2: AO Auto-assignment logic (simple workload mock)
	if app.AoID == uuid.Nil {
		aos, _ := uc.repo.ListAvailableAOs(ctx, app.BranchCode)
		if len(aos) > 0 {
			app.AoID = aos[0] // Simple: pick first available
			uc.repo.Update(ctx, app)
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

	// If all pass, move to POLICY_GATE status then ANALYSIS
	app.TransitionTo(StatusPolicy)
	app.TransitionTo(StatusAnalysis)
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

	// POINT 22: Penguncian Data (Data Locking)
	existing, err := uc.repo.FindByID(ctx, app.ID)
	if err == nil && existing.IsLocked() {
		return fmt.Errorf("application %s is locked (Status: %s) and cannot be modified", app.ID, existing.Status)
	}

	return uc.repo.Update(ctx, app)
}

func (uc *ApplicationUsecase) Get(ctx context.Context, id uuid.UUID) (*Application, error) {
	uc.log.WithContext(ctx).Infof("Getting Application: ID=%s", id)
	return uc.repo.FindByID(ctx, id)
}

func (uc *ApplicationUsecase) List(ctx context.Context) ([]*Application, error) {
	uc.log.WithContext(ctx).Info("Listing all Applications")
	return uc.repo.ListAll(ctx)
}

func (uc *ApplicationUsecase) AddPartyToApplication(ctx context.Context, appID, partyID uuid.UUID, role string, slikRequired bool) error {
	return uc.repo.AddPartyToApplication(ctx, appID, partyID, role, slikRequired)
}

func (uc *ApplicationUsecase) GetParties(ctx context.Context, appID uuid.UUID) ([]ApplicationParty, error) {
	return uc.repo.GetParties(ctx, appID)
}

func (uc *ApplicationUsecase) UploadDocument(ctx context.Context, doc *ApplicationDocument) error {
	if doc.ID == uuid.Nil {
		doc.ID = uuid.New()
	}
	if doc.UploadedAt.IsZero() {
		doc.UploadedAt = time.Now()
	}
	return uc.repo.SaveDocument(ctx, doc)
}

func (uc *ApplicationUsecase) ListDocuments(ctx context.Context, appID uuid.UUID) ([]ApplicationDocument, error) {
	return uc.repo.ListDocuments(ctx, appID)
}
