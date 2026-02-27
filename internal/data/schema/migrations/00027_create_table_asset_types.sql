-- +goose Up
CREATE TABLE IF NOT EXISTS asset_types (
    asset_type_code VARCHAR(100) PRIMARY KEY,
    asset_category VARCHAR(20),
    -- VEHICLE | PROPERTY | INVENTORY | OTHER
    description VARCHAR(255)
);

-- +goose Down
DROP TABLE IF EXISTS asset_types CASCADE;
