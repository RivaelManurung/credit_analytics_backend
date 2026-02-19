package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type decisionRepo struct {
	data *Data
	log  *log.Helper
}

func NewDecisionRepo(data *Data, logger log.Logger) biz.DecisionRepo {
	return &decisionRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *decisionRepo) CreateCommitteeSession(ctx context.Context, s *biz.CommitteeSession) (*biz.CommitteeSession, error) {
	res, err := r.data.db.CreateCommitteeSession(ctx, db.CreateCommitteeSessionParams{
		ApplicationID:   s.ApplicationID,
		SessionSequence: sql.NullInt32{Int32: s.SessionSequence, Valid: true},
		ScheduledAt:     sql.NullTime{Time: s.ScheduledAt, Valid: !s.ScheduledAt.IsZero()},
	})
	if err != nil {
		return nil, err
	}
	return &biz.CommitteeSession{
		ID:              res.ID,
		ApplicationID:   res.ApplicationID,
		SessionSequence: res.SessionSequence.Int32,
		Status:          res.Status.String,
		ScheduledAt:     res.ScheduledAt.Time,
		StartedAt:       res.StartedAt.Time,
		CompletedAt:     res.CompletedAt.Time,
	}, nil
}

func (r *decisionRepo) SubmitCommitteeVote(ctx context.Context, v *biz.CommitteeVote) (*biz.CommitteeVote, error) {
	res, err := r.data.db.SubmitCommitteeVote(ctx, db.SubmitCommitteeVoteParams{
		CommitteeSessionID: v.CommitteeSessionID,
		UserID:             v.UserID,
		Vote:               sql.NullString{String: v.Vote, Valid: true},
		VoteReason:         sql.NullString{String: v.VoteReason, Valid: v.VoteReason != ""},
	})
	if err != nil {
		return nil, err
	}
	return &biz.CommitteeVote{
		ID:                 res.ID,
		CommitteeSessionID: res.CommitteeSessionID,
		UserID:             res.UserID,
		Vote:               res.Vote.String,
		VoteReason:         res.VoteReason.String,
		VotedAt:            res.VotedAt.Time,
	}, nil
}

func (r *decisionRepo) FinalizeCommitteeDecision(ctx context.Context, d *biz.CommitteeDecision) (*biz.CommitteeDecision, error) {
	amount, _ := decimal.NewFromString(d.ApprovedAmount)
	rate, _ := decimal.NewFromString(d.ApprovedInterestRate)

	res, err := r.data.db.FinalizeCommitteeDecision(ctx, db.FinalizeCommitteeDecisionParams{
		CommitteeSessionID:    d.CommitteeSessionID,
		Decision:              sql.NullString{String: d.Decision, Valid: true},
		DecisionReason:        sql.NullString{String: d.DecisionReason, Valid: d.DecisionReason != ""},
		ApprovedAmount:        sql.NullString{String: amount.String(), Valid: true},
		ApprovedTenor:         sql.NullInt32{Int32: d.ApprovedTenor, Valid: d.ApprovedTenor != 0},
		ApprovedInterestRate:  sql.NullString{String: rate.String(), Valid: true},
		RequiresNextCommittee: sql.NullBool{Bool: d.RequiresNextCommittee, Valid: true},
	})
	if err != nil {
		return nil, err
	}
	return &biz.CommitteeDecision{
		ID:                    res.ID,
		CommitteeSessionID:    res.CommitteeSessionID,
		Decision:              res.Decision.String,
		DecisionReason:        res.DecisionReason.String,
		ApprovedAmount:        res.ApprovedAmount.String,
		ApprovedTenor:         res.ApprovedTenor.Int32,
		ApprovedInterestRate:  res.ApprovedInterestRate.String,
		RequiresNextCommittee: res.RequiresNextCommittee.Bool,
		DecidedAt:             res.DecidedAt.Time,
	}, nil
}

func (r *decisionRepo) RecordFinalDecision(ctx context.Context, d *biz.FinalDecision) (*biz.FinalDecision, error) {
	amount, _ := decimal.NewFromString(d.FinalAmount)
	rate, _ := decimal.NewFromString(d.FinalInterestRate)

	res, err := r.data.db.RecordFinalDecision(ctx, db.RecordFinalDecisionParams{
		ApplicationID:     d.ApplicationID,
		Decision:          sql.NullString{String: d.Decision, Valid: true},
		DecisionSource:    sql.NullString{String: d.DecisionSource, Valid: true},
		FinalAmount:       sql.NullString{String: amount.String(), Valid: true},
		FinalTenor:        sql.NullInt32{Int32: d.FinalTenor, Valid: d.FinalTenor != 0},
		FinalInterestRate: sql.NullString{String: rate.String(), Valid: true},
		DecisionReason:    sql.NullString{String: d.DecisionReason, Valid: d.DecisionReason != ""},
		DecidedBy:         uuid.NullUUID{UUID: d.DecidedBy, Valid: d.DecidedBy != uuid.Nil},
	})
	if err != nil {
		return nil, err
	}
	return &biz.FinalDecision{
		ID:                res.ID,
		ApplicationID:     res.ApplicationID,
		Decision:          res.Decision.String,
		DecisionSource:    res.DecisionSource.String,
		FinalAmount:       res.FinalAmount.String,
		FinalTenor:        res.FinalTenor.Int32,
		FinalInterestRate: res.FinalInterestRate.String,
		DecisionReason:    res.DecisionReason.String,
		DecidedBy:         res.DecidedBy.UUID,
		DecidedAt:         res.DecidedAt.Time,
	}, nil
}

func (r *decisionRepo) GetApplicationDecision(ctx context.Context, appID uuid.UUID) (*biz.FinalDecision, error) {
	res, err := r.data.db.GetApplicationDecision(ctx, appID)
	if err != nil {
		return nil, err
	}
	return &biz.FinalDecision{
		ID:                res.ID,
		ApplicationID:     res.ApplicationID,
		Decision:          res.Decision.String,
		DecisionSource:    res.DecisionSource.String,
		FinalAmount:       res.FinalAmount.String,
		FinalTenor:        res.FinalTenor.Int32,
		FinalInterestRate: res.FinalInterestRate.String,
		DecisionReason:    res.DecisionReason.String,
		DecidedBy:         res.DecidedBy.UUID,
		DecidedAt:         res.DecidedAt.Time,
	}, nil
}
