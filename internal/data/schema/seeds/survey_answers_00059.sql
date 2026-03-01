-- +goose Up
INSERT INTO survey_answers (
        survey_id,
        question_id,
        answer_boolean,
        answer_number
    )
VALUES (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0003-7002-bb34-000000000001',
        true,
        NULL
    ),
    (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0003-7002-bb34-000000000002',
        NULL,
        5
    );

-- +goose Down
DELETE FROM survey_answers;
