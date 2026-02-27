-- +goose Up
CREATE TABLE IF NOT EXISTS credit_authority_matrices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    committee_level INT,
    -- 1=Branch, 2=Regional, 3=HO
    product_id UUID REFERENCES loan_products(id),
    max_amount NUMERIC(20, 2),
    max_tenor INT,
    requires_committee BOOLEAN DEFAULT TRUE
);

-- +goose Down
DROP TABLE IF EXISTS credit_authority_matrices CASCADE;
