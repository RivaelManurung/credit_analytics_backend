package biz

import (
	"context"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

// Applicant Domain Model
type Applicant struct {
	ID                uuid.UUID
	HeadType          string
	IdentityNumber    string
	TaxID             string
	FullName          string
	BirthDate         time.Time
	EstablishmentDate time.Time
	CreatedBy         uuid.UUID
	Attributes        []ApplicantAttribute
}

type ApplicantAttribute struct {
	Key      string
	Value    string
	DataType string
}

// ApplicantRepo .
type ApplicantRepo interface {
	Save(context.Context, *Applicant) (uuid.UUID, error)
	Update(context.Context, *Applicant) error
	FindByID(context.Context, uuid.UUID) (*Applicant, error)
	ListAll(context.Context) ([]*Applicant, error)
}

// ApplicantUsecase .
type ApplicantUsecase struct {
	repo ApplicantRepo
	log  *log.Helper
}

func NewApplicantUsecase(repo ApplicantRepo, logger log.Logger) *ApplicantUsecase {
	return &ApplicantUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *ApplicantUsecase) Create(ctx context.Context, a *Applicant) (uuid.UUID, error) {
	uc.log.WithContext(ctx).Infof("Creating Applicant: %s", a.FullName)
	if a.ID == uuid.Nil {
		a.ID = uuid.New()
	}
	return uc.repo.Save(ctx, a)
}

func (uc *ApplicantUsecase) Get(ctx context.Context, id uuid.UUID) (*Applicant, error) {
	uc.log.WithContext(ctx).Infof("Getting Applicant: %s", id)
	return uc.repo.FindByID(ctx, id)
}

func (uc *ApplicantUsecase) ListAll(ctx context.Context) ([]*Applicant, error) {
	uc.log.WithContext(ctx).Infof("Listing all Applicants")
	return uc.repo.ListAll(ctx)
}

func (uc *ApplicantUsecase) Update(ctx context.Context, a *Applicant) error {
	uc.log.WithContext(ctx).Infof("Updating Applicant: %s", a.ID)
	return uc.repo.Update(ctx, a)
}
