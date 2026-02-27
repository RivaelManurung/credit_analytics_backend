-- +goose Up
CREATE TABLE IF NOT EXISTS application_committee_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    committee_session_id UUID NOT NULL REFERENCES application_committee_sessions(id),
    decision VARCHAR(20),
    -- APPROVED | REJECTED | CONDITIONAL
    decision_reason VARCHAR(255),
    approved_amount NUMERIC(20, 2),
    approved_tenor INT,
    approved_interest_rate NUMERIC(10, 4),
    requires_next_committee BOOLEAN DEFAULT FALSE,
    decided_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_committee_decisions CASCADE;
