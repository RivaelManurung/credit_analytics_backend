-- +goose Up
CREATE TABLE IF NOT EXISTS survey_data_mappings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    question_id UUID NOT NULL REFERENCES survey_questions(id),
    target_type VARCHAR(20) NOT NULL,
    -- GL | APPLICANT_ATTR | APPLICATION_ATTR
    target_code VARCHAR(100) NOT NULL,
    transform_rule VARCHAR(50) -- DIRECT | SUM | AVG | BOOLEAN_MAP
);

-- +goose Down
DROP TABLE IF EXISTS survey_data_mappings CASCADE;
