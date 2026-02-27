-- +goose Up
CREATE TABLE IF NOT EXISTS application_committee_votes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    committee_session_id UUID NOT NULL REFERENCES application_committee_sessions(id),
    user_id UUID NOT NULL,
    vote VARCHAR(20),
    -- APPROVE | REJECT | CONDITIONAL
    vote_reason VARCHAR(255),
    voted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_committee_votes CASCADE;
