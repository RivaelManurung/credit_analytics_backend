-- +goose Up
INSERT INTO application_committee_sessions (
        id,
        application_id,
        session_sequence,
        status,
        scheduled_at
    )
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0001-7000-bb34-000000000001',
        1,
        'COMPLETED',
        CURRENT_TIMESTAMP - interval '1 days'
    );

-- +goose Down
DELETE FROM application_committee_sessions;
