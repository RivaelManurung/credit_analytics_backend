-- +goose Up
CREATE TABLE IF NOT EXISTS application_liabilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    creditor_name VARCHAR(255),
    liability_type VARCHAR(20),
    -- BANK | KOPERASI | LEASING | INDIVIDUAL
    outstanding_amount NUMERIC(20, 2),
    monthly_installment NUMERIC(20, 2),
    interest_rate NUMERIC(10, 4),
    maturity_date DATE,
    source VARCHAR(20),
    -- SLIK | SURVEY | MANUAL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_liabilities CASCADE;
