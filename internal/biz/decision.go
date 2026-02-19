package biz

import (
	"context"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type CommitteeSession struct {
	ID              uuid.UUID
	ApplicationID   uuid.UUID
	SessionSequence int32
	Status          string
	ScheduledAt     time.Time
	StartedAt       time.Time
	CompletedAt     time.Time
}

type CommitteeVote struct {
	ID                 uuid.UUID
	CommitteeSessionID uuid.UUID
	UserID             uuid.UUID
	Vote               string
	VoteReason         string
	VotedAt            time.Time
}

type CommitteeDecision struct {
	ID                    uuid.UUID
	CommitteeSessionID    uuid.UUID
	Decision              string
	DecisionReason        string
	ApprovedAmount        string // decimal
	ApprovedTenor         int32
	ApprovedInterestRate  string // decimal
	RequiresNextCommittee bool
	DecidedAt             time.Time
}

type FinalDecision struct {
	ID                uuid.UUID
	ApplicationID     uuid.UUID
	Decision          string
	DecisionSource    string
	FinalAmount       string // decimal
	FinalTenor        int32
	FinalInterestRate string // decimal
	DecisionReason    string
	DecidedBy         uuid.UUID
	DecidedAt         time.Time
}

type DecisionRepo interface {
	CreateCommitteeSession(context.Context, *CommitteeSession) (*CommitteeSession, error)
	SubmitCommitteeVote(context.Context, *CommitteeVote) (*CommitteeVote, error)
	FinalizeCommitteeDecision(context.Context, *CommitteeDecision) (*CommitteeDecision, error)
	RecordFinalDecision(context.Context, *FinalDecision) (*FinalDecision, error)
	GetApplicationDecision(ctx context.Context, appID uuid.UUID) (*FinalDecision, error)
}

type DecisionUsecase struct {
	repo DecisionRepo
	log  *log.Helper
}

func NewDecisionUsecase(repo DecisionRepo, logger log.Logger) *DecisionUsecase {
	return &DecisionUsecase{repo: repo, log: log.NewHelper(logger)}
}

func (uc *DecisionUsecase) CreateCommitteeSession(ctx context.Context, s *CommitteeSession) (*CommitteeSession, error) {
	return uc.repo.CreateCommitteeSession(ctx, s)
}

func (uc *DecisionUsecase) SubmitCommitteeVote(ctx context.Context, v *CommitteeVote) (*CommitteeVote, error) {
	return uc.repo.SubmitCommitteeVote(ctx, v)
}

func (uc *DecisionUsecase) FinalizeCommitteeDecision(ctx context.Context, d *CommitteeDecision) (*CommitteeDecision, error) {
	return uc.repo.FinalizeCommitteeDecision(ctx, d)
}

func (uc *DecisionUsecase) RecordFinalDecision(ctx context.Context, d *FinalDecision) (*FinalDecision, error) {
	return uc.repo.RecordFinalDecision(ctx, d)
}

func (uc *DecisionUsecase) GetApplicationDecision(ctx context.Context, appID uuid.UUID) (*FinalDecision, error) {
	return uc.repo.GetApplicationDecision(ctx, appID)
}
