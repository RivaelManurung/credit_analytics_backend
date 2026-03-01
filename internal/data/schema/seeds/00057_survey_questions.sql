-- +goose Up
INSERT INTO survey_questions (
        id,
        section_id,
        question_code,
        question_text,
        answer_type,
        is_mandatory,
        risk_relevant,
        sequence
    )
VALUES (
        '0195a1a2-0003-7002-bb34-000000000001',
        '0195a1a2-0003-7001-bb34-000000000001',
        'Q_HOME_OWNER',
        'Apakah benar rumah milik sendiri?',
        'BOOLEAN',
        true,
        true,
        1
    ),
    (
        '0195a1a2-0003-7002-bb34-000000000002',
        '0195a1a2-0003-7001-bb34-000000000002',
        'Q_BUSINESS_YEARS',
        'Sudah berapa lama usaha berjalan?',
        'NUMBER',
        true,
        true,
        1
    );

-- +goose Down
DELETE FROM survey_questions;
