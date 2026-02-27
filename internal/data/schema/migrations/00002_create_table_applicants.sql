-- +goose Up
CREATE TABLE IF NOT EXISTS applicants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    applicant_type VARCHAR(20) NOT NULL,
    -- personal | corporate
    identity_number VARCHAR(100) UNIQUE,
    tax_id VARCHAR(100) UNIQUE,
    full_name VARCHAR(255),
    birth_date DATE,
    establishment_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID
);

-- +goose Down
DROP TABLE IF EXISTS applicants CASCADE;
