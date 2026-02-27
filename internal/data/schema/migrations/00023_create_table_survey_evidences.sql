-- +goose Up
CREATE TABLE IF NOT EXISTS survey_evidences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    survey_id UUID REFERENCES application_surveys(id),
    evidence_type VARCHAR(20),
    -- PHOTO | VIDEO | DOCUMENT
    file_url VARCHAR(255),
    description VARCHAR(255),
    captured_at TIMESTAMP WITH TIME ZONE
);

-- +goose Down
DROP TABLE IF EXISTS survey_evidences CASCADE;
