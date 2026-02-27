-- +goose Up
INSERT INTO credit_committee_members (committee_session_id, user_id, role)
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000001',
        'CHAIR'
    ),
    (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000002',
        'MEMBER'
    );

-- +goose Down
DELETE FROM credit_committee_members;
