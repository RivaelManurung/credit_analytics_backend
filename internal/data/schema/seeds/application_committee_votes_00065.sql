-- +goose Up
INSERT INTO application_committee_votes (committee_session_id, user_id, vote, vote_reason)
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000001',
        'APPROVE',
        'Kapasitas bayar memadai'
    ),
    (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000002',
        'APPROVE',
        'Aset jaminan solid'
    );

-- +goose Down
DELETE FROM application_committee_votes;
