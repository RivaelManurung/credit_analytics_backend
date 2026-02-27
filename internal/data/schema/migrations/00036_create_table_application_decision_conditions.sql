-- +goose Up
CREATE TABLE IF NOT EXISTS application_decision_conditions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_decision_id UUID NOT NULL REFERENCES application_decisions(id),
    condition_type VARCHAR(20),
    -- PRE_DISBURSEMENT | POST_DISBURSEMENT
    condition_text VARCHAR(255),
    mandatory BOOLEAN DEFAULT TRUE
);

-- +goose Down
DROP TABLE IF EXISTS application_decision_conditions CASCADE;
