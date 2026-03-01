-- +goose Up
INSERT INTO survey_question_options (
        id,
        question_id,
        option_value,
        option_label,
        sequence
    )
VALUES (
        uuid_generate_v7(),
        '0195f1f2-0001-7000-bb34-000000000002',
        'BAIK',
        'Baik / Positif',
        1
    ),
    (
        uuid_generate_v7(),
        '0195f1f2-0001-7000-bb34-000000000002',
        'RESIKO_SEDANG',
        'Cukup / Ada catatan kecil',
        2
    ),
    (
        uuid_generate_v7(),
        '0195f1f2-0001-7000-bb34-000000000002',
        'BURUK',
        'Buruk / Negatif',
        3
    );

-- +goose Down
DELETE FROM survey_question_options;
