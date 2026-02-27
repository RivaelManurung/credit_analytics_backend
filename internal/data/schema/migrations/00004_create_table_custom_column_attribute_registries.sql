-- +goose Up
CREATE TABLE IF NOT EXISTS custom_column_attribute_registries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    attribute_code VARCHAR(100) UNIQUE NOT NULL,
    applies_to VARCHAR(20) NOT NULL,
    -- PERSONAL | CORPORATE | BOTH
    scope VARCHAR(20) NOT NULL,
    -- APPLICANT | APPLICATION | BOTH
    value_type VARCHAR(20) NOT NULL,
    -- STRING | NUMBER | BOOLEAN | DATE | SELECT
    category_code VARCHAR(100) REFERENCES attribute_categories(category_code) ON UPDATE CASCADE ON DELETE
    SET NULL,
        ui_label VARCHAR(255),
        -- Label yang tampil di UI per atribut
        is_required BOOLEAN DEFAULT FALSE,
        risk_relevant BOOLEAN DEFAULT FALSE,
        is_active BOOLEAN DEFAULT TRUE,
        display_order INT DEFAULT 0,
        description VARCHAR(255)
);

-- +goose Down
DROP TABLE IF EXISTS custom_column_attribute_registries CASCADE;
