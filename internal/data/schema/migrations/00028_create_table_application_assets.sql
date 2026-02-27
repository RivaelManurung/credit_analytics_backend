-- +goose Up
CREATE TABLE IF NOT EXISTS application_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    asset_type_code VARCHAR(100) REFERENCES asset_types(asset_type_code),
    asset_name VARCHAR(255),
    ownership_status VARCHAR(20),
    -- OWNED | SPOUSE | JOINT
    acquisition_year INT,
    estimated_value NUMERIC(20, 2),
    valuation_method VARCHAR(20),
    -- MARKET | NJOP | APPRAISAL
    location_text VARCHAR(255),
    encumbered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_assets CASCADE;
