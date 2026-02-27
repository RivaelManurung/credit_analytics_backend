-- +goose Up
CREATE TABLE IF NOT EXISTS survey_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    survey_id UUID REFERENCES application_surveys(id),
    question_id UUID REFERENCES survey_questions(id),
    answer_text VARCHAR(255),
    answer_number NUMERIC(20, 2),
    answer_boolean BOOLEAN,
    answer_date DATE,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (survey_id, question_id)
);

-- +goose Down
DROP TABLE IF EXISTS survey_answers CASCADE;
