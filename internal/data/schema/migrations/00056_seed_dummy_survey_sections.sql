-- +goose Up
INSERT INTO survey_sections (
        id,
        template_id,
        section_code,
        section_name,
        sequence
    )
VALUES (
        '0195a1a2-0003-7001-bb34-000000000001',
        '0195a1a2-0003-7000-bb34-000000000001',
        'SEC_IDENTITY',
        'Verifikasi Identitas',
        1
    ),
    (
        '0195a1a2-0003-7001-bb34-000000000002',
        '0195a1a2-0003-7000-bb34-000000000001',
        'SEC_BUSINESS',
        'Kondisi Usaha',
        2
    );

-- +goose Down
DELETE FROM survey_sections;
