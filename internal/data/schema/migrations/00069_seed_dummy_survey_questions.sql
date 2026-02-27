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
VALUES -- Section 1 (Personal)
    (
        '0195f1f2-0001-7000-bb34-000000000001',
        '0195e1e2-0001-7000-bb34-000000000001',
        'Q_ADDR_VALID',
        'Apakah alamat tinggal sesuai dengan KTP?',
        'BOOLEAN',
        true,
        true,
        1
    ),
    (
        '0195f1f2-0001-7000-bb34-000000000002',
        '0195e1e2-0001-7000-bb34-000000000001',
        'Q_ENV_REPUTATION',
        'Bagaimana reputasi debitur di mata lingkungan sekitar?',
        'SELECT',
        true,
        true,
        2
    ),
    -- Section 2 (Personal)
    (
        '0195f1f2-0001-7000-bb34-000000000003',
        '0195e1e2-0001-7000-bb34-000000000002',
        'Q_WORK_TENURE',
        'Sudah berapa lama bekerja di perusahaan saat ini?',
        'NUMBER',
        true,
        false,
        1
    ),
    -- Section 3 (Business)
    (
        '0195f1f2-0001-7000-bb34-000000000004',
        '0195e1e2-0001-7000-bb34-000000000003',
        'Q_BIZ_OWNERSHIP',
        'Apakah tempat usaha milik pribadi?',
        'BOOLEAN',
        true,
        true,
        1
    ),
    (
        '0195f1f2-0001-7000-bb34-000000000005',
        '0195e1e2-0001-7000-bb34-000000000003',
        'Q_BIZ_DAILY_TURNOVER',
        'Rata-rata omzet harian yang terobservasi?',
        'NUMBER',
        true,
        true,
        2
    );

-- +goose Down
DELETE FROM survey_questions;
