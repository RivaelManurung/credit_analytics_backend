-- +goose Up
CREATE TABLE IF NOT EXISTS application_parties (
    application_id UUID REFERENCES applications(id),
    party_id UUID REFERENCES parties(id),
    role_code VARCHAR(50),
    -- BORROWER | SPOUSE | GUARANTOR | DIRECTOR | COMMISSIONER | SHAREHOLDER
    legal_obligation BOOLEAN DEFAULT FALSE,
    slik_required BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (application_id, party_id, role_code)
);

-- +goose Down
DROP TABLE IF EXISTS application_parties CASCADE;
