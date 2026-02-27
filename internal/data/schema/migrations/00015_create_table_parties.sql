-- +goose Up
CREATE TABLE IF NOT EXISTS parties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    party_type VARCHAR(20),
    -- PERSON | COMPANY
    identifier VARCHAR(100),
    name VARCHAR(255),
    date_of_birth DATE
);

-- +goose Down
DROP TABLE IF EXISTS parties CASCADE;
