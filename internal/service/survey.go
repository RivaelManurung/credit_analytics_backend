package service

import (
	"context"
	"time"

	pb "credit-analytics-backend/api/survey/v1"
	"credit-analytics-backend/internal/biz"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type SurveyService struct {
	pb.UnimplementedSurveyServiceServer
	uc  *biz.SurveyUsecase
	log *log.Helper
}

func NewSurveyService(uc *biz.SurveyUsecase, logger log.Logger) *SurveyService {
	return &SurveyService{
		uc:  uc,
		log: log.NewHelper(logger),
	}
}

func (s *SurveyService) ListSurveysByApplication(ctx context.Context, req *pb.ListSurveysByApplicationRequest) (*pb.ListSurveysResponse, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	surveys, err := s.uc.ListSurveysByApplication(ctx, appID)
	if err != nil {
		return nil, err
	}
	var res []*pb.ApplicationSurvey
	for _, sv := range surveys {
		res = append(res, mapSurveyToPb(sv))
	}
	return &pb.ListSurveysResponse{Surveys: res}, nil
}

// Keep These but they are not in the gRPC service interface
func (s *SurveyService) CreateSurveyTemplate(ctx context.Context, req *pb.CreateSurveyTemplateRequest) (*pb.SurveyTemplate, error) {
	productID, _ := uuid.Parse(req.ProductId)
	t, err := s.uc.CreateSurveyTemplate(ctx, &biz.SurveyTemplate{
		TemplateCode:  req.TemplateCode,
		TemplateName:  req.TemplateName,
		ApplicantType: req.ApplicantType,
		ProductID:     productID,
		Active:        req.Active,
	})
	if err != nil {
		return nil, err
	}
	return &pb.SurveyTemplate{
		Id:            t.ID.String(),
		TemplateCode:  t.TemplateCode,
		TemplateName:  t.TemplateName,
		ApplicantType: t.ApplicantType,
		ProductId:     t.ProductID.String(),
		Active:        t.Active,
	}, nil
}

func (s *SurveyService) ListSurveyTemplates(ctx context.Context, req *pb.ListSurveyTemplatesRequest) (*pb.ListSurveyTemplatesResponse, error) {
	templates, err := s.uc.ListSurveyTemplates(ctx)
	if err != nil {
		return nil, err
	}
	var res []*pb.SurveyTemplate
	for _, t := range templates {
		res = append(res, &pb.SurveyTemplate{
			Id:            t.ID.String(),
			TemplateCode:  t.TemplateCode,
			TemplateName:  t.TemplateName,
			ApplicantType: t.ApplicantType,
			ProductId:     t.ProductID.String(),
			Active:        t.Active,
		})
	}
	return &pb.ListSurveyTemplatesResponse{Templates: res}, nil
}

func (s *SurveyService) AssignSurvey(ctx context.Context, req *pb.AssignSurveyRequest) (*pb.ApplicationSurvey, error) {
	appID, _ := uuid.Parse(req.ApplicationId)
	tplID, _ := uuid.Parse(req.TemplateId)
	assignedTo, _ := uuid.Parse(req.AssignedTo)

	res, err := s.uc.AssignSurvey(ctx, &biz.ApplicationSurvey{
		ApplicationID: appID,
		TemplateID:    tplID,
		SurveyType:    req.SurveyType,
		AssignedTo:    assignedTo,
		SurveyPurpose: req.SurveyPurpose,
	})
	if err != nil {
		return nil, err
	}
	return mapSurveyToPb(res), nil
}

func (s *SurveyService) GetSurvey(ctx context.Context, req *pb.GetSurveyRequest) (*pb.ApplicationSurvey, error) {
	id, _ := uuid.Parse(req.Id)
	res, err := s.uc.GetSurvey(ctx, id)
	if err != nil {
		return nil, err
	}
	return mapSurveyToPb(res), nil
}

func (s *SurveyService) StartSurvey(ctx context.Context, req *pb.StartSurveyRequest) (*pb.ApplicationSurvey, error) {
	id, _ := uuid.Parse(req.Id)
	userID, _ := uuid.Parse(req.UserId)
	res, err := s.uc.UpdateSurveyStatus(ctx, id, "IN_PROGRESS", userID)
	if err != nil {
		return nil, err
	}
	return mapSurveyToPb(res), nil
}

func (s *SurveyService) SubmitSurvey(ctx context.Context, req *pb.SubmitSurveyRequest) (*pb.ApplicationSurvey, error) {
	id, _ := uuid.Parse(req.Id)
	userID, _ := uuid.Parse(req.UserId)
	res, err := s.uc.UpdateSurveyStatus(ctx, id, "SUBMITTED", userID)
	if err != nil {
		return nil, err
	}
	return mapSurveyToPb(res), nil
}

func (s *SurveyService) VerifySurvey(ctx context.Context, req *pb.VerifySurveyRequest) (*pb.ApplicationSurvey, error) {
	id, _ := uuid.Parse(req.Id)
	userID, _ := uuid.Parse(req.UserId)
	res, err := s.uc.UpdateSurveyStatus(ctx, id, "VERIFIED", userID)
	if err != nil {
		return nil, err
	}
	return mapSurveyToPb(res), nil
}

func (s *SurveyService) SubmitSurveyAnswer(ctx context.Context, req *pb.SubmitSurveyAnswerRequest) (*pb.SurveyAnswer, error) {
	surveyID, _ := uuid.Parse(req.SurveyId)
	questionID, _ := uuid.Parse(req.QuestionId)
	var date time.Time
	if req.AnswerDate != "" {
		date, _ = time.Parse(time.RFC3339, req.AnswerDate)
	}

	res, err := s.uc.UpsertSurveyAnswer(ctx, &biz.SurveyAnswer{
		SurveyID:      surveyID,
		QuestionID:    questionID,
		AnswerText:    req.AnswerText,
		AnswerNumber:  req.AnswerNumber,
		AnswerBoolean: req.AnswerBoolean,
		AnswerDate:    date,
	})
	if err != nil {
		return nil, err
	}
	return &pb.SurveyAnswer{
		Id:            res.ID.String(),
		SurveyId:      res.SurveyID.String(),
		QuestionId:    res.QuestionID.String(),
		AnswerText:    res.AnswerText,
		AnswerNumber:  res.AnswerNumber,
		AnswerBoolean: res.AnswerBoolean,
		AnswerDate:    res.AnswerDate.Format(time.RFC3339),
	}, nil
}

func (s *SurveyService) UploadSurveyEvidence(ctx context.Context, req *pb.UploadSurveyEvidenceRequest) (*pb.SurveyEvidence, error) {
	surveyID, _ := uuid.Parse(req.SurveyId)
	res, err := s.uc.CreateSurveyEvidence(ctx, &biz.SurveyEvidence{
		SurveyID:     surveyID,
		EvidenceType: req.EvidenceType,
		FileURL:      req.FileUrl,
		Description:  req.Description,
	})
	if err != nil {
		return nil, err
	}
	return &pb.SurveyEvidence{
		Id:           res.ID.String(),
		SurveyId:     res.SurveyID.String(),
		EvidenceType: res.EvidenceType,
		FileUrl:      res.FileURL,
		Description:  res.Description,
		CapturedAt:   timestamppb.New(res.CapturedAt),
	}, nil
}

func mapSurveyToPb(s *biz.ApplicationSurvey) *pb.ApplicationSurvey {
	return &pb.ApplicationSurvey{
		Id:            s.ID.String(),
		ApplicationId: s.ApplicationID.String(),
		TemplateId:    s.TemplateID.String(),
		SurveyType:    s.SurveyType,
		Status:        s.Status,
		AssignedTo:    s.AssignedTo.String(),
		SurveyPurpose: s.SurveyPurpose,
		StartedAt:     timestamppb.New(s.StartedAt),
		SubmittedAt:   timestamppb.New(s.SubmittedAt),
		SubmittedBy:   s.SubmittedBy.String(),
	}
}
