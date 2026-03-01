package biz

import (
	"context"
	"fmt"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type SurveyTemplate struct {
	ID            uuid.UUID
	TemplateCode  string
	TemplateName  string
	ApplicantType string
	ProductID     uuid.UUID
	Active        bool
	Sections      []*SurveySection
}

type SurveySection struct {
	ID         uuid.UUID
	TemplateID uuid.UUID
	Name       string
	Sequence   int32
	Questions  []*SurveyQuestion
}

type SurveyQuestion struct {
	ID         uuid.UUID
	SectionID  uuid.UUID
	Text       string
	AnswerType string
	Sequence   int32
	IsRequired bool
	Options    []*SurveyQuestionOption
}

type SurveyQuestionOption struct {
	ID         uuid.UUID
	QuestionID uuid.UUID
	Text       string
	Value      string
}

type ApplicationSurvey struct {
	ID            uuid.UUID
	ApplicationID uuid.UUID
	TemplateID    uuid.UUID
	SurveyType    string
	Status        string
	AssignedTo    uuid.UUID
	SurveyPurpose string
	StartedAt     time.Time
	SubmittedAt   time.Time
	SubmittedBy   uuid.UUID
	VerifiedBy    uuid.UUID
	VerifiedAt    time.Time

	// Enrichment
	ApplicantName     string
	ApplicationStatus string

	// Progress
	TotalQuestions    int32
	AnsweredQuestions int32
}

type SurveyAnswer struct {
	ID            uuid.UUID
	SurveyID      uuid.UUID
	QuestionID    uuid.UUID
	AnswerText    string
	AnswerNumber  string // decimal
	AnswerBoolean bool
	AnswerDate    time.Time
}

type SurveyEvidence struct {
	ID           uuid.UUID
	SurveyID     uuid.UUID
	EvidenceType string
	FileURL      string
	Description  string
	CapturedAt   time.Time
}

type ListSurveysFilter struct {
	PageSize      int32
	Cursor        string
	Status        string
	ApplicationID uuid.UUID
	AssignedTo    uuid.UUID
	SurveyType    string
}

type SurveyRepo interface {
	CreateSurveyTemplate(context.Context, *SurveyTemplate) (*SurveyTemplate, error)
	GetSurveyTemplate(context.Context, uuid.UUID) (*SurveyTemplate, error)
	ListSurveyTemplates(context.Context) ([]*SurveyTemplate, error)
	AssignSurvey(context.Context, *ApplicationSurvey) (*ApplicationSurvey, error)
	GetSurvey(context.Context, uuid.UUID) (*ApplicationSurvey, error)
	ListSurveysByApplication(context.Context, uuid.UUID) ([]*ApplicationSurvey, error)
	UpdateSurveyStatus(ctx context.Context, id uuid.UUID, status string, userID uuid.UUID) (*ApplicationSurvey, error)
	UpsertSurveyAnswer(context.Context, *SurveyAnswer) (*SurveyAnswer, error)
	CreateSurveyEvidence(context.Context, *SurveyEvidence) (*SurveyEvidence, error)
	ListSurveys(ctx context.Context, filter *ListSurveysFilter) ([]*ApplicationSurvey, string, bool, error)
}

type SurveyUsecase struct {
	repo    SurveyRepo
	appRepo ApplicationRepo
	log     *log.Helper
}

func NewSurveyUsecase(repo SurveyRepo, appRepo ApplicationRepo, logger log.Logger) *SurveyUsecase {
	return &SurveyUsecase{
		repo:    repo,
		appRepo: appRepo,
		log:     log.NewHelper(logger),
	}
}

func (uc *SurveyUsecase) checkLock(ctx context.Context, appID uuid.UUID) error {
	app, err := uc.appRepo.FindByID(ctx, appID)
	if err != nil {
		return err
	}
	isLocked, _ := uc.appRepo.IsTerminalStatus(ctx, string(app.Status))
	if isLocked {
		return fmt.Errorf("application %s is locked and survey data cannot be modified", appID)
	}
	return nil
}

func (uc *SurveyUsecase) CreateSurveyTemplate(ctx context.Context, t *SurveyTemplate) (*SurveyTemplate, error) {
	return uc.repo.CreateSurveyTemplate(ctx, t)
}

func (uc *SurveyUsecase) GetSurveyTemplate(ctx context.Context, id uuid.UUID) (*SurveyTemplate, error) {
	return uc.repo.GetSurveyTemplate(ctx, id)
}

func (uc *SurveyUsecase) ListSurveyTemplates(ctx context.Context) ([]*SurveyTemplate, error) {

	return uc.repo.ListSurveyTemplates(ctx)
}

func (uc *SurveyUsecase) AssignSurvey(ctx context.Context, s *ApplicationSurvey) (*ApplicationSurvey, error) {
	if err := uc.checkLock(ctx, s.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.AssignSurvey(ctx, s)
}

func (uc *SurveyUsecase) GetSurvey(ctx context.Context, id uuid.UUID) (*ApplicationSurvey, error) {
	return uc.repo.GetSurvey(ctx, id)
}

func (uc *SurveyUsecase) ListSurveysByApplication(ctx context.Context, appID uuid.UUID) ([]*ApplicationSurvey, error) {
	return uc.repo.ListSurveysByApplication(ctx, appID)
}

func (uc *SurveyUsecase) UpdateSurveyStatus(ctx context.Context, id uuid.UUID, status string, userID uuid.UUID) (*ApplicationSurvey, error) {
	return uc.repo.UpdateSurveyStatus(ctx, id, status, userID)
}

func (uc *SurveyUsecase) ListSurveys(ctx context.Context, filter *ListSurveysFilter) ([]*ApplicationSurvey, string, bool, error) {
	return uc.repo.ListSurveys(ctx, filter)
}

func (uc *SurveyUsecase) UpsertSurveyAnswer(ctx context.Context, a *SurveyAnswer) (*SurveyAnswer, error) {
	survey, err := uc.repo.GetSurvey(ctx, a.SurveyID)
	if err != nil {
		return nil, err
	}
	if err := uc.checkLock(ctx, survey.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.UpsertSurveyAnswer(ctx, a)
}

func (uc *SurveyUsecase) CreateSurveyEvidence(ctx context.Context, e *SurveyEvidence) (*SurveyEvidence, error) {
	survey, err := uc.repo.GetSurvey(ctx, e.SurveyID)
	if err != nil {
		return nil, err
	}
	if err := uc.checkLock(ctx, survey.ApplicationID); err != nil {
		return nil, err
	}
	return uc.repo.CreateSurveyEvidence(ctx, e)
}
