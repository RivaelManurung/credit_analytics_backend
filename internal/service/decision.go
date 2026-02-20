package service

import (
	"context"

	pb "credit-analytics-backend/api/decision/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type DecisionService struct {
	pb.UnimplementedDecisionServiceServer
	uc  *biz.DecisionUsecase
	log *log.Helper
}

func NewDecisionService(uc *biz.DecisionUsecase, logger log.Logger) *DecisionService {
	return &DecisionService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

type CommitteeService struct {
	pb.UnimplementedCommitteeServiceServer
	uc  *biz.DecisionUsecase
	log *log.Helper
}

func NewCommitteeService(uc *biz.DecisionUsecase, logger log.Logger) *CommitteeService {
	return &CommitteeService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

func (s *CommitteeService) CreateCommitteeSession(ctx context.Context, req *pb.CreateCommitteeSessionRequest) (*pb.CommitteeSession, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	res, err := s.uc.CreateCommitteeSession(ctx, &biz.CommitteeSession{
		ApplicationID:   appID,
		SessionSequence: req.SessionSequence,
		ScheduledAt:     req.ScheduledAt.AsTime(),
	})
	if err != nil {
		return nil, err
	}
	return &pb.CommitteeSession{
		Id:              res.ID.String(),
		ApplicationId:   res.ApplicationID.String(),
		SessionSequence: res.SessionSequence,
		Status:          res.Status,
		ScheduledAt:     timestamppb.New(res.ScheduledAt),
		StartedAt:       timestamppb.New(res.StartedAt),
		CompletedAt:     timestamppb.New(res.CompletedAt),
	}, nil
}

func (s *CommitteeService) SubmitCommitteeVote(ctx context.Context, req *pb.SubmitCommitteeVoteRequest) (*pb.CommitteeVote, error) {
	sessionID, _ := uuid.Parse(req.CommitteeSessionId)
	userID, _ := uuid.Parse(req.UserId)
	res, err := s.uc.SubmitCommitteeVote(ctx, &biz.CommitteeVote{
		CommitteeSessionID: sessionID,
		UserID:             userID,
		Vote:               req.Vote,
		VoteReason:         req.VoteReason,
	})
	if err != nil {
		return nil, err
	}
	return &pb.CommitteeVote{
		Id:                 res.ID.String(),
		CommitteeSessionId: res.CommitteeSessionID.String(),
		UserId:             res.UserID.String(),
		Vote:               res.Vote,
		VoteReason:         res.VoteReason,
		VotedAt:            timestamppb.New(res.VotedAt),
	}, nil
}

func (s *CommitteeService) FinalizeCommitteeDecision(ctx context.Context, req *pb.FinalizeCommitteeDecisionRequest) (*pb.CommitteeDecision, error) {
	sessionID, _ := uuid.Parse(req.CommitteeSessionId)
	res, err := s.uc.FinalizeCommitteeDecision(ctx, &biz.CommitteeDecision{
		CommitteeSessionID:    sessionID,
		Decision:              req.Decision,
		DecisionReason:        req.DecisionReason,
		ApprovedAmount:        req.ApprovedAmount,
		ApprovedTenor:         req.ApprovedTenor,
		ApprovedInterestRate:  req.ApprovedInterestRate,
		RequiresNextCommittee: req.RequiresNextCommittee,
	})
	if err != nil {
		return nil, err
	}
	return &pb.CommitteeDecision{
		Id:                    res.ID.String(),
		CommitteeSessionId:    res.CommitteeSessionID.String(),
		Decision:              res.Decision,
		DecisionReason:        res.DecisionReason,
		ApprovedAmount:        res.ApprovedAmount,
		ApprovedTenor:         res.ApprovedTenor,
		ApprovedInterestRate:  res.ApprovedInterestRate,
		RequiresNextCommittee: res.RequiresNextCommittee,
		DecidedAt:             timestamppb.New(res.DecidedAt),
	}, nil
}

func (s *CommitteeService) GetCommitteeSession(ctx context.Context, req *pb.GetCommitteeSessionRequest) (*pb.CommitteeSession, error) {
	return &pb.CommitteeSession{}, nil
}

func (s *CommitteeService) ListCommitteeSessionsByApplication(ctx context.Context, req *pb.ListCommitteeSessionsByApplicationRequest) (*pb.ListCommitteeSessionsResponse, error) {
	return &pb.ListCommitteeSessionsResponse{}, nil
}

func (s *DecisionService) RecordFinalDecision(ctx context.Context, req *pb.RecordFinalDecisionRequest) (*pb.ApplicationDecision, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	decidedBy, _ := uuid.Parse(req.DecidedBy)
	res, err := s.uc.RecordFinalDecision(ctx, &biz.FinalDecision{
		ApplicationID:     appID,
		Decision:          req.Decision,
		DecisionSource:    req.DecisionSource,
		FinalAmount:       req.FinalAmount,
		FinalTenor:        req.FinalTenor,
		FinalInterestRate: req.FinalInterestRate,
		DecisionReason:    req.DecisionReason,
		DecidedBy:         decidedBy,
	})
	if err != nil {
		return nil, err
	}
	return mapFinalDecisionToPb(res), nil
}

func (s *DecisionService) GetApplicationDecision(ctx context.Context, req *pb.GetApplicationDecisionRequest) (*pb.ApplicationDecision, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	res, err := s.uc.GetApplicationDecision(ctx, appID)
	if err != nil {
		return nil, err
	}
	return mapFinalDecisionToPb(res), nil
}

func (s *DecisionService) AddDecisionCondition(ctx context.Context, req *pb.AddDecisionConditionRequest) (*pb.DecisionCondition, error) {
	return &pb.DecisionCondition{}, nil
}

func (s *DecisionService) ListDecisionConditions(ctx context.Context, req *pb.ListDecisionConditionsRequest) (*pb.ListDecisionConditionsResponse, error) {
	return &pb.ListDecisionConditionsResponse{}, nil
}

func mapFinalDecisionToPb(d *biz.FinalDecision) *pb.ApplicationDecision {
	return &pb.ApplicationDecision{
		Id:                d.ID.String(),
		ApplicationId:     d.ApplicationID.String(),
		Decision:          d.Decision,
		DecisionSource:    d.DecisionSource,
		FinalAmount:       d.FinalAmount,
		FinalTenor:        d.FinalTenor,
		FinalInterestRate: d.FinalInterestRate,
		DecisionReason:    d.DecisionReason,
		DecidedBy:         d.DecidedBy.String(),
		DecidedAt:         timestamppb.New(d.DecidedAt),
	}
}
