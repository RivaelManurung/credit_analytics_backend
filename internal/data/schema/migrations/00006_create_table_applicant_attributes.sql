-- +goose Up
CREATE TABLE IF NOT EXISTS applicant_attributes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    applicant_id UUID NOT NULL REFERENCES applicants(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES custom_column_attribute_registries(id) ON DELETE CASCADE,
    attribute_option_id UUID REFERENCES attribute_options(id) ON DELETE
    SET NULL,
        attr_value TEXT,
        data_type VARCHAR(20),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        UNIQUE (applicant_id, attribute_id)
);

-- +goose Down
DROP TABLE IF EXISTS applicant_attributes CASCADE;
