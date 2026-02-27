-- +goose Up
INSERT INTO application_surveys (
        id,
        application_id,
        template_id,
        survey_type,
        status,
        assigned_to,
        survey_purpose,
        started_at,
        submitted_at
    )
VALUES (
        '01951112-0001-7000-bb34-000000000001',
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195d1d2-0001-7000-bb34-000000000001',
        'FIELD',
        'VERIFIED',
        '0195c1c2-0001-7000-bb34-000000000001',
        'GENERAL',
        CURRENT_TIMESTAMP - interval '2 days',
        CURRENT_TIMESTAMP - interval '1 days 22 hours'
    ),
    (
        '01951112-0001-7000-bb34-000000000002',
        '0195a1a2-0001-7000-bb34-000000000002',
        '0195d1d2-0001-7000-bb34-000000000002',
        'FIELD',
        'IN_PROGRESS',
        '0195c1c2-0001-7000-bb34-000000000002',
        'COLLATERAL',
        CURRENT_TIMESTAMP - interval '5 hours',
        NULL
    );

-- +goose Down
DELETE FROM application_surveys;
