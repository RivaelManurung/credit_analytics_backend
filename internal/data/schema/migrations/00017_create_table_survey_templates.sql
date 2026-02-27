-- +goose Up
CREATE TABLE IF NOT EXISTS survey_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    template_code VARCHAR(100) UNIQUE,
    template_name VARCHAR(255),
    applicant_type VARCHAR(20),
    -- personal | corporate | both
    product_id UUID REFERENCES loan_products(id),
    active BOOLEAN DEFAULT TRUE
);

-- +goose Down
DROP TABLE IF EXISTS survey_templates CASCADE;
