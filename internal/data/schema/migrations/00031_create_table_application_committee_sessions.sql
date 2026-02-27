-- +goose Up
CREATE TABLE IF NOT EXISTS application_committee_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    session_sequence INT,
    status VARCHAR(20),
    -- SCHEDULED | IN_SESSION | COMPLETED | CANCELLED
    scheduled_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_committee_sessions CASCADE;
