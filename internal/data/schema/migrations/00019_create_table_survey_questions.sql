-- +goose Up
CREATE TABLE IF NOT EXISTS survey_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    section_id UUID REFERENCES survey_sections(id),
    question_code VARCHAR(100),
    question_text VARCHAR(255),
    answer_type VARCHAR(20),
    -- TEXT | NUMBER | BOOLEAN | SELECT | DATE
    is_mandatory BOOLEAN DEFAULT FALSE,
    risk_relevant BOOLEAN DEFAULT FALSE,
    sequence INT
);

-- +goose Down
DROP TABLE IF EXISTS survey_questions CASCADE;
