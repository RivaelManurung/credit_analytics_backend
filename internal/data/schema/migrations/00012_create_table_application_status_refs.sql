-- +goose Up
CREATE TABLE IF NOT EXISTS application_status_refs (
    status_code VARCHAR(50) PRIMARY KEY,
    status_group VARCHAR(20),
    -- INTAKE | SURVEY | ANALYSIS | DECISION | TERMINAL
    is_terminal BOOLEAN DEFAULT FALSE,
    description VARCHAR(255)
);

-- +goose Down
DROP TABLE IF EXISTS application_status_refs CASCADE;
