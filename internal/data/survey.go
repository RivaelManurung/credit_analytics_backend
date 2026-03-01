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

type surveyRepo struct {
	data *Data
	log  *log.Helper
}

func NewSurveyRepo(data *Data, logger log.Logger) biz.SurveyRepo {
	return &surveyRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *surveyRepo) CreateSurveyTemplate(ctx context.Context, t *biz.SurveyTemplate) (*biz.SurveyTemplate, error) {
	res, err := r.data.db.CreateSurveyTemplate(ctx, db.CreateSurveyTemplateParams{
		TemplateCode:  sql.NullString{String: t.TemplateCode, Valid: t.TemplateCode != ""},
		TemplateName:  sql.NullString{String: t.TemplateName, Valid: t.TemplateName != ""},
		ApplicantType: sql.NullString{String: t.ApplicantType, Valid: t.ApplicantType != ""},
		ProductID:     uuid.NullUUID{UUID: t.ProductID, Valid: t.ProductID != uuid.Nil},
		Active:        sql.NullBool{Bool: t.Active, Valid: true},
	})
	if err != nil {
		return nil, err
	}
	return &biz.SurveyTemplate{
		ID:            res.ID,
		TemplateCode:  res.TemplateCode.String,
		TemplateName:  res.TemplateName.String,
		ApplicantType: res.ApplicantType.String,
		ProductID:     res.ProductID.UUID,
		Active:        res.Active.Bool,
	}, nil
}

func (r *surveyRepo) ListSurveyTemplates(ctx context.Context) ([]*biz.SurveyTemplate, error) {
	templates, err := r.data.db.ListSurveyTemplates(ctx)
	if err != nil {
		return nil, err
	}
	var res []*biz.SurveyTemplate
	for _, t := range templates {
		res = append(res, &biz.SurveyTemplate{
			ID:            t.ID,
			TemplateCode:  t.TemplateCode.String,
			TemplateName:  t.TemplateName.String,
			ApplicantType: t.ApplicantType.String,
			ProductID:     t.ProductID.UUID,
			Active:        t.Active.Bool,
		})
	}
	return res, nil
}

func (r *surveyRepo) GetSurveyTemplate(ctx context.Context, id uuid.UUID) (*biz.SurveyTemplate, error) {
	// 1. Get Template
	var t db.SurveyTemplate
	err := r.data.sqlDB.QueryRowContext(ctx, "SELECT id, template_code, template_name, applicant_type, product_id, active FROM survey_templates WHERE id = $1", id).Scan(
		&t.ID, &t.TemplateCode, &t.TemplateName, &t.ApplicantType, &t.ProductID, &t.Active,
	)
	if err != nil {
		return nil, err
	}

	res := &biz.SurveyTemplate{
		ID:            t.ID,
		TemplateCode:  t.TemplateCode.String,
		TemplateName:  t.TemplateName.String,
		ApplicantType: t.ApplicantType.String,
		ProductID:     t.ProductID.UUID,
		Active:        t.Active.Bool,
	}

	// 2. Get Sections
	rows, err := r.data.sqlDB.QueryContext(ctx, "SELECT id, template_id, section_name, sequence FROM survey_sections WHERE template_id = $1 ORDER BY sequence", id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var s db.SurveySection
		if err := rows.Scan(&s.ID, &s.TemplateID, &s.SectionName, &s.Sequence); err != nil {
			return nil, err
		}

		bizSection := &biz.SurveySection{
			ID:         s.ID,
			TemplateID: s.TemplateID.UUID,
			Name:       s.SectionName.String,
			Sequence:   s.Sequence.Int32,
		}

		// 3. Get Questions
		qRows, err := r.data.sqlDB.QueryContext(ctx, "SELECT id, section_id, question_text, answer_type, is_mandatory, sequence FROM survey_questions WHERE section_id = $1 ORDER BY sequence", s.ID)
		if err == nil {
			for qRows.Next() {
				var q db.SurveyQuestion
				if err := qRows.Scan(&q.ID, &q.SectionID, &q.QuestionText, &q.AnswerType, &q.IsMandatory, &q.Sequence); err != nil {
					continue
				}

				bizQuestion := &biz.SurveyQuestion{
					ID:         q.ID,
					SectionID:  q.SectionID.UUID,
					Text:       q.QuestionText.String,
					AnswerType: q.AnswerType.String,
					Sequence:   q.Sequence.Int32,
					IsRequired: q.IsMandatory.Bool,
				}

				// 4. Get Options
				oRows, err := r.data.sqlDB.QueryContext(ctx, "SELECT id, question_id, option_label, option_value FROM survey_question_options WHERE question_id = $1 ORDER BY sequence", q.ID)
				if err == nil {
					for oRows.Next() {
						var o db.SurveyQuestionOption
						if err := oRows.Scan(&o.ID, &o.QuestionID, &o.OptionLabel, &o.OptionValue); err != nil {
							continue
						}
						bizQuestion.Options = append(bizQuestion.Options, &biz.SurveyQuestionOption{
							ID:         o.ID,
							QuestionID: o.QuestionID.UUID,
							Text:       o.OptionLabel.String,
							Value:      o.OptionValue.String,
						})
					}
					oRows.Close()
				}
				bizSection.Questions = append(bizSection.Questions, bizQuestion)
			}
			qRows.Close()
		}

		res.Sections = append(res.Sections, bizSection)
	}

	return res, nil
}

func (r *surveyRepo) AssignSurvey(ctx context.Context, s *biz.ApplicationSurvey) (*biz.ApplicationSurvey, error) {
	res, err := r.data.db.AssignSurvey(ctx, db.AssignSurveyParams{
		ApplicationID: uuid.NullUUID{UUID: s.ApplicationID, Valid: s.ApplicationID != uuid.Nil},
		TemplateID:    uuid.NullUUID{UUID: s.TemplateID, Valid: s.TemplateID != uuid.Nil},
		SurveyType:    sql.NullString{String: s.SurveyType, Valid: s.SurveyType != ""},
		AssignedTo:    uuid.NullUUID{UUID: s.AssignedTo, Valid: s.AssignedTo != uuid.Nil},
		SurveyPurpose: sql.NullString{String: s.SurveyPurpose, Valid: s.SurveyPurpose != ""},
	})
	if err != nil {
		return nil, err
	}
	return mapSurveyToBiz(&res), nil
}

func (r *surveyRepo) GetSurvey(ctx context.Context, id uuid.UUID) (*biz.ApplicationSurvey, error) {
	res, err := r.data.db.GetSurvey(ctx, id)
	if err != nil {
		return nil, err
	}
	return mapSurveyToBiz(&res), nil
}

func (r *surveyRepo) ListSurveysByApplication(ctx context.Context, appID uuid.UUID) ([]*biz.ApplicationSurvey, error) {
	surveys, err := r.data.db.ListSurveysByApplication(ctx, uuid.NullUUID{UUID: appID, Valid: true})
	if err != nil {
		return nil, err
	}
	var res []*biz.ApplicationSurvey
	for _, s := range surveys {
		res = append(res, mapSurveyToBiz(&s))
	}
	return res, nil
}

func (r *surveyRepo) UpdateSurveyStatus(ctx context.Context, id uuid.UUID, status string, userID uuid.UUID) (*biz.ApplicationSurvey, error) {
	res, err := r.data.db.UpdateSurveyStatus(ctx, db.UpdateSurveyStatusParams{
		ID:          id,
		Status:      sql.NullString{String: status, Valid: true},
		SubmittedBy: uuid.NullUUID{UUID: userID, Valid: userID != uuid.Nil},
	})
	if err != nil {
		return nil, err
	}
	return mapSurveyToBiz(&res), nil
}

func (r *surveyRepo) UpsertSurveyAnswer(ctx context.Context, a *biz.SurveyAnswer) (*biz.SurveyAnswer, error) {
	var numStr string
	if a.AnswerNumber != "" {
		n, err := decimal.NewFromString(a.AnswerNumber)
		if err == nil {
			numStr = n.String()
		}
	}

	res, err := r.data.db.UpsertSurveyAnswer(ctx, db.UpsertSurveyAnswerParams{
		SurveyID:      uuid.NullUUID{UUID: a.SurveyID, Valid: a.SurveyID != uuid.Nil},
		QuestionID:    uuid.NullUUID{UUID: a.QuestionID, Valid: a.QuestionID != uuid.Nil},
		AnswerText:    sql.NullString{String: a.AnswerText, Valid: true},
		AnswerNumber:  sql.NullString{String: numStr, Valid: numStr != ""},
		AnswerBoolean: sql.NullBool{Bool: a.AnswerBoolean, Valid: true},
		AnswerDate:    sql.NullTime{Time: a.AnswerDate, Valid: !a.AnswerDate.IsZero()},
	})
	if err != nil {
		return nil, err
	}
	return &biz.SurveyAnswer{
		ID:            res.ID,
		SurveyID:      res.SurveyID.UUID,
		QuestionID:    res.QuestionID.UUID,
		AnswerText:    res.AnswerText.String,
		AnswerNumber:  res.AnswerNumber.String,
		AnswerBoolean: res.AnswerBoolean.Bool,
		AnswerDate:    res.AnswerDate.Time,
	}, nil
}

func (r *surveyRepo) CreateSurveyEvidence(ctx context.Context, e *biz.SurveyEvidence) (*biz.SurveyEvidence, error) {
	res, err := r.data.db.CreateSurveyEvidence(ctx, db.CreateSurveyEvidenceParams{
		SurveyID:     uuid.NullUUID{UUID: e.SurveyID, Valid: e.SurveyID != uuid.Nil},
		EvidenceType: sql.NullString{String: e.EvidenceType, Valid: true},
		FileUrl:      sql.NullString{String: e.FileURL, Valid: true},
		Description:  sql.NullString{String: e.Description, Valid: e.Description != ""},
	})
	if err != nil {
		return nil, err
	}
	return &biz.SurveyEvidence{
		ID:           res.ID,
		SurveyID:     res.SurveyID.UUID,
		EvidenceType: res.EvidenceType.String,
		FileURL:      res.FileUrl.String,
		Description:  res.Description.String,
		CapturedAt:   res.CapturedAt.Time,
	}, nil
}

func (r *surveyRepo) ListSurveys(ctx context.Context, filter *biz.ListSurveysFilter) ([]*biz.ApplicationSurvey, string, bool, error) {
	var cursorID uuid.NullUUID
	if filter.Cursor != "" {
		id, err := uuid.Parse(filter.Cursor)
		if err == nil {
			cursorID = uuid.NullUUID{UUID: id, Valid: true}
		}
	}

	rows, err := r.data.db.ListSurveys(ctx, db.ListSurveysParams{
		Limit:         filter.PageSize + 1,
		Status:        sql.NullString{String: filter.Status, Valid: filter.Status != ""},
		ApplicationID: uuid.NullUUID{UUID: filter.ApplicationID, Valid: filter.ApplicationID != uuid.Nil},
		AssignedTo:    uuid.NullUUID{UUID: filter.AssignedTo, Valid: filter.AssignedTo != uuid.Nil},
		SurveyType:    sql.NullString{String: filter.SurveyType, Valid: filter.SurveyType != ""},
		CursorID:      cursorID,
	})
	if err != nil {
		return nil, "", false, err
	}

	var res []*biz.ApplicationSurvey
	hasNext := false
	if len(rows) > int(filter.PageSize) {
		hasNext = true
		rows = rows[:filter.PageSize]
	}

	for _, row := range rows {
		res = append(res, &biz.ApplicationSurvey{
			ID:                row.ID,
			ApplicationID:     row.ApplicationID.UUID,
			TemplateID:        row.TemplateID.UUID,
			SurveyType:        row.SurveyType.String,
			Status:            row.Status.String,
			SubmittedBy:       row.SubmittedBy.UUID,
			VerifiedBy:        row.VerifiedBy.UUID,
			VerifiedAt:        row.VerifiedAt.Time,
			AssignedTo:        row.AssignedTo.UUID,
			SurveyPurpose:     row.SurveyPurpose.String,
			StartedAt:         row.StartedAt.Time,
			SubmittedAt:       row.SubmittedAt.Time,
			ApplicationStatus: row.ApplicationStatus,
			ApplicantName:     row.ApplicantName.String,
		})
	}

	nextCursor := ""
	if hasNext && len(res) > 0 {
		nextCursor = res[len(res)-1].ID.String()
	}

	return res, nextCursor, hasNext, nil
}

func mapSurveyToBiz(s *db.ApplicationSurvey) *biz.ApplicationSurvey {
	return &biz.ApplicationSurvey{
		ID:            s.ID,
		ApplicationID: s.ApplicationID.UUID,
		TemplateID:    s.TemplateID.UUID,
		SurveyType:    s.SurveyType.String,
		Status:        s.Status.String,
		SubmittedBy:   s.SubmittedBy.UUID,
		VerifiedBy:    s.VerifiedBy.UUID,
		VerifiedAt:    s.VerifiedAt.Time,
		AssignedTo:    s.AssignedTo.UUID,
		SurveyPurpose: s.SurveyPurpose.String,
		StartedAt:     s.StartedAt.Time,
		SubmittedAt:   s.SubmittedAt.Time,
	}
}
