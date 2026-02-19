-- name: CreateSurveyTemplate :one
INSERT INTO survey_templates (
    template_code, template_name, applicant_type, product_id, active
) VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: ListSurveyTemplates :many
SELECT * FROM survey_templates WHERE active = TRUE;

-- name: GetSurveyTemplateWithSections :many
SELECT 
    t.template_name, s.section_name, q.question_text, q.answer_type
FROM survey_templates t
JOIN survey_sections s ON s.template_id = t.id
JOIN survey_questions q ON q.section_id = s.id
WHERE t.id = $1
ORDER BY s.sequence, q.sequence;

-- name: AssignSurvey :one
INSERT INTO application_surveys (
    application_id, template_id, survey_type, status, assigned_to, survey_purpose
) VALUES ($1, $2, $3, 'ASSIGNED', $4, $5) RETURNING *;

-- name: GetSurvey :one
SELECT * FROM application_surveys WHERE id = $1;

-- name: UpdateSurveyStatus :one
UPDATE application_surveys SET 
    status = $2,
    started_at = CASE WHEN $2 = 'IN_PROGRESS' AND started_at IS NULL THEN CURRENT_TIMESTAMP ELSE started_at END,
    submitted_at = CASE WHEN $2 = 'SUBMITTED' THEN CURRENT_TIMESTAMP ELSE submitted_at END,
    submitted_by = CASE WHEN $2 = 'SUBMITTED' THEN $3 ELSE submitted_by END
WHERE id = $1 RETURNING *;

-- name: UpsertSurveyAnswer :one
INSERT INTO survey_answers (
    survey_id, question_id, answer_text, answer_number, answer_boolean, answer_date
) VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (survey_id, question_id) DO UPDATE SET
    answer_text = EXCLUDED.answer_text,
    answer_number = EXCLUDED.answer_number,
    answer_boolean = EXCLUDED.answer_boolean,
    answer_date = EXCLUDED.answer_date,
    answered_at = CURRENT_TIMESTAMP
RETURNING *;

-- name: CreateSurveyEvidence :one
INSERT INTO survey_evidences (
    survey_id, evidence_type, file_url, description
) VALUES ($1, $2, $3, $4) RETURNING *;
