-- +goose Up
INSERT INTO application_surveys (
        id,
        application_id,
        template_id,
        survey_type,
        status,
        submitted_at
    )
VALUES (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195a1a2-0003-7000-bb34-000000000001',
        'FIELD',
        'SUBMITTED',
        CURRENT_TIMESTAMP - interval '2 days'
    );

-- +goose Down
DELETE FROM application_surveys;
