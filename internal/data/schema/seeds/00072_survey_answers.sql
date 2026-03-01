-- +goose Up
INSERT INTO survey_answers (
        id,
        survey_id,
        question_id,
        answer_text,
        answer_number,
        answer_boolean,
        answer_date
    )
VALUES -- Survey 1 (Verified)
    (
        uuid_generate_v7(),
        '01951112-0001-7000-bb34-000000000001',
        '0195f1f2-0001-7000-bb34-000000000001',
        NULL,
        NULL,
        true,
        NULL
    ),
    (
        uuid_generate_v7(),
        '01951112-0001-7000-bb34-000000000001',
        '0195f1f2-0001-7000-bb34-000000000002',
        'BAIK',
        NULL,
        NULL,
        NULL
    ),
    (
        uuid_generate_v7(),
        '01951112-0001-7000-bb34-000000000001',
        '0195f1f2-0001-7000-bb34-000000000003',
        NULL,
        8,
        NULL,
        NULL
    );

-- +goose Down
DELETE FROM survey_answers;
