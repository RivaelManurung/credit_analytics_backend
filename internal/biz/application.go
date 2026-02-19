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
	StatusAnalysis  ApplicationStatus = "ANALYSIS"
	StatusApproved  ApplicationStatus = "APPROVED"
	StatusRejected  ApplicationStatus = "REJECTED"
	StatusCancelled ApplicationStatus = "CANCELLED"
)

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
	CreatedAt          time.Time
	UpdatedAt          time.Time

	// Domain Events
	events []interface{}
}

func (a *Application) AddEvent(event interface{}) {
	a.events = append(a.events, event)
}

func (a *Application) Events() []interface{} {
	return a.events
}

// Domain Behavior / State Machine
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
		allowed = (newStatus == StatusAnalysis || newStatus == StatusCancelled)
	case StatusAnalysis:
		allowed = (newStatus == StatusApproved || newStatus == StatusRejected || newStatus == StatusCancelled)
	}

	// Admin or system might override, but for domain logic we enforce this
	if !allowed && a.Status != newStatus {
		return fmt.Errorf("invalid status transition from %s to %s", a.Status, newStatus)
	}

	a.Status = newStatus
	a.UpdatedAt = time.Now()
	return nil
}

type ApplicationAttribute struct {
	Key      string
	Value    string
	DataType string
}

// Repository Interface
type ApplicationRepo interface {
	Save(context.Context, *Application) (uuid.UUID, error)
	Update(context.Context, *Application) error
	FindByID(context.Context, uuid.UUID) (*Application, error)
	ListAll(context.Context) ([]*Application, error)
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
