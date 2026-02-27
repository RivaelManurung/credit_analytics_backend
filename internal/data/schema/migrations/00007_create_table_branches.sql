-- +goose Up
CREATE TABLE IF NOT EXISTS branches (
    branch_code VARCHAR(50) PRIMARY KEY,
    branch_name VARCHAR(255),
    region_code VARCHAR(50)
);

-- +goose Down
DROP TABLE IF EXISTS branches CASCADE;
