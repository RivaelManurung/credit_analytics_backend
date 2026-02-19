package biz

import (
	"context"
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

type SurveyRepo interface {
	CreateSurveyTemplate(context.Context, *SurveyTemplate) (*SurveyTemplate, error)
	ListSurveyTemplates(context.Context) ([]*SurveyTemplate, error)
	AssignSurvey(context.Context, *ApplicationSurvey) (*ApplicationSurvey, error)
	GetSurvey(context.Context, uuid.UUID) (*ApplicationSurvey, error)
	UpdateSurveyStatus(ctx context.Context, id uuid.UUID, status string, userID uuid.UUID) (*ApplicationSurvey, error)
	UpsertSurveyAnswer(context.Context, *SurveyAnswer) (*SurveyAnswer, error)
	CreateSurveyEvidence(context.Context, *SurveyEvidence) (*SurveyEvidence, error)
}

type SurveyUsecase struct {
	repo SurveyRepo
	log  *log.Helper
}

func NewSurveyUsecase(repo SurveyRepo, logger log.Logger) *SurveyUsecase {
	return &SurveyUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *SurveyUsecase) CreateSurveyTemplate(ctx context.Context, t *SurveyTemplate) (*SurveyTemplate, error) {
	return uc.repo.CreateSurveyTemplate(ctx, t)
}

func (uc *SurveyUsecase) ListSurveyTemplates(ctx context.Context) ([]*SurveyTemplate, error) {
	return uc.repo.ListSurveyTemplates(ctx)
}

func (uc *SurveyUsecase) AssignSurvey(ctx context.Context, s *ApplicationSurvey) (*ApplicationSurvey, error) {
	return uc.repo.AssignSurvey(ctx, s)
}

func (uc *SurveyUsecase) GetSurvey(ctx context.Context, id uuid.UUID) (*ApplicationSurvey, error) {
	return uc.repo.GetSurvey(ctx, id)
}

func (uc *SurveyUsecase) UpdateSurveyStatus(ctx context.Context, id uuid.UUID, status string, userID uuid.UUID) (*ApplicationSurvey, error) {
	return uc.repo.UpdateSurveyStatus(ctx, id, status, userID)
}

func (uc *SurveyUsecase) UpsertSurveyAnswer(ctx context.Context, a *SurveyAnswer) (*SurveyAnswer, error) {
	return uc.repo.UpsertSurveyAnswer(ctx, a)
}

func (uc *SurveyUsecase) CreateSurveyEvidence(ctx context.Context, e *SurveyEvidence) (*SurveyEvidence, error) {
	return uc.repo.CreateSurveyEvidence(ctx, e)
}
