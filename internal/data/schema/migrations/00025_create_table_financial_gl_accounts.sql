-- +goose Up
CREATE TABLE IF NOT EXISTS financial_gl_accounts (
    gl_code VARCHAR(100) PRIMARY KEY,
    gl_name VARCHAR(255),
    statement_type VARCHAR(10) NOT NULL,
    -- PL | CF | BS
    category VARCHAR(20) NOT NULL,
    -- REVENUE | EXPENSE | ASSET | LIABILITY | EQUITY | CASH_IN | CASH_OUT
    sign INT NOT NULL,
    -- 1 or -1
    is_debt_service BOOLEAN DEFAULT FALSE,
    is_operating BOOLEAN DEFAULT FALSE,
    description VARCHAR(255)
);

-- +goose Down
DROP TABLE IF EXISTS financial_gl_accounts CASCADE;
