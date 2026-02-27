-- +goose Up
CREATE TABLE IF NOT EXISTS survey_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    template_id UUID REFERENCES survey_templates(id),
    section_code VARCHAR(100),
    section_name VARCHAR(255),
    sequence INT
);

-- +goose Down
DROP TABLE IF EXISTS survey_sections CASCADE;
