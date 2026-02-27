-- +goose Up
INSERT INTO survey_sections (
        id,
        template_id,
        section_code,
        section_name,
        sequence
    )
VALUES (
        '0195e1e2-0001-7000-bb34-000000000001',
        '0195d1d2-0001-7000-bb34-000000000001',
        'IDENTITY_CHECK',
        'Verifikasi Identitas & Lingkungan',
        1
    ),
    (
        '0195e1e2-0001-7000-bb34-000000000002',
        '0195d1d2-0001-7000-bb34-000000000001',
        'INCOME_VERIFICATION',
        'Verifikasi Pekerjaan & Penghasilan',
        2
    ),
    (
        '0195e1e2-0001-7000-bb34-000000000003',
        '0195d1d2-0001-7000-bb34-000000000002',
        'BUSINESS_OPS',
        'Operasional Usaha',
        1
    );

-- +goose Down
DELETE FROM survey_sections;
