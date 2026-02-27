-- +goose Up
CREATE TABLE IF NOT EXISTS applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    applicant_id UUID NOT NULL REFERENCES applicants(id),
    product_id UUID NOT NULL REFERENCES loan_products(id),
    ao_id UUID NOT NULL REFERENCES loan_officers(id),
    loan_amount NUMERIC(20, 2),
    tenor_months INT,
    interest_type VARCHAR(20),
    -- FIXED | FLOATING
    interest_rate NUMERIC(10, 4),
    loan_purpose VARCHAR(255),
    application_channel VARCHAR(20),
    -- CRM | WALK_IN | WEBSITE | API
    status VARCHAR(50) NOT NULL,
    branch_code VARCHAR(50) NOT NULL REFERENCES branches(branch_code),
    submitted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID
);

-- +goose Down
DROP TABLE IF EXISTS applications CASCADE;
