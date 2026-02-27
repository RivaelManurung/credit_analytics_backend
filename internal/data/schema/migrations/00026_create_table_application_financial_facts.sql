-- +goose Up
CREATE TABLE IF NOT EXISTS application_financial_facts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    gl_code VARCHAR(100) NOT NULL REFERENCES financial_gl_accounts(gl_code),
    period_type VARCHAR(10) NOT NULL,
    -- MONTHLY | YEARLY
    period_label VARCHAR(50) NOT NULL,
    -- 2025-01, 2025
    amount NUMERIC(20, 2) NOT NULL,
    source VARCHAR(20),
    -- SURVEY | MANUAL | IMPORT
    confidence_level VARCHAR(10),
    -- LOW | MEDIUM | HIGH
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (
        application_id,
        gl_code,
        period_type,
        period_label
    )
);

-- +goose Down
DROP TABLE IF EXISTS application_financial_facts CASCADE;
