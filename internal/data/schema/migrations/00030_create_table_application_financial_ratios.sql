-- +goose Up
CREATE TABLE IF NOT EXISTS application_financial_ratios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    ratio_code VARCHAR(50),
    -- DSR | IDIR | LTV | GPM | NPM
    ratio_value NUMERIC(10, 4),
    calculation_version VARCHAR(50),
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (application_id, ratio_code)
);

-- +goose Down
DROP TABLE IF EXISTS application_financial_ratios CASCADE;
