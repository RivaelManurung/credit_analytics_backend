-- +goose Up
CREATE TABLE IF NOT EXISTS attribute_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    attribute_id UUID NOT NULL REFERENCES custom_column_attribute_registries(id) ON DELETE CASCADE,
    option_value VARCHAR(100) NOT NULL,
    option_label VARCHAR(255) NOT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE (attribute_id, option_value)
);

-- +goose Down
DROP TABLE IF EXISTS attribute_options CASCADE;
