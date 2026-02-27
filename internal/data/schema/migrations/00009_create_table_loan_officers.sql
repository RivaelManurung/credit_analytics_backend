-- +goose Up
CREATE TABLE IF NOT EXISTS loan_officers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    officer_code VARCHAR(100) UNIQUE,
    branch_code VARCHAR(50) NOT NULL REFERENCES branches(branch_code)
);

-- +goose Down
DROP TABLE IF EXISTS loan_officers CASCADE;
