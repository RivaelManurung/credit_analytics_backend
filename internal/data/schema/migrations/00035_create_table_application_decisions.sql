-- +goose Up
CREATE TABLE IF NOT EXISTS application_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    decision VARCHAR(20),
    -- APPROVED | REJECTED | CANCELLED
    decision_source VARCHAR(20),
    -- COMMITTEE | SYSTEM | OVERRIDE
    final_amount NUMERIC(20, 2),
    final_tenor INT,
    final_interest_rate NUMERIC(10, 4),
    decision_reason VARCHAR(255),
    decided_by UUID,
    decided_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_decisions CASCADE;
