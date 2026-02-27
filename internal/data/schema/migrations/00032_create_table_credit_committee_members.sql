-- +goose Up
CREATE TABLE IF NOT EXISTS credit_committee_members (
    committee_session_id UUID REFERENCES application_committee_sessions(id),
    user_id UUID,
    role VARCHAR(20),
    -- CHAIR | MEMBER | SECRETARY
    active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (committee_session_id, user_id)
);

-- +goose Down
DROP TABLE IF EXISTS credit_committee_members CASCADE;
