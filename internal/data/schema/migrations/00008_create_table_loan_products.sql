-- +goose Up
CREATE TABLE IF NOT EXISTS loan_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    product_code VARCHAR(100) UNIQUE,
    product_name VARCHAR(255),
    segment VARCHAR(20),
    -- RETAIL | UMKM | CORPORATE
    active BOOLEAN DEFAULT TRUE,
    assignment_mode VARCHAR(20) DEFAULT 'MANUAL' -- AUTO | CLAIM | MANUAL
);

-- +goose Down
DROP TABLE IF EXISTS loan_products CASCADE;
