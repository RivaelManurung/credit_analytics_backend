-- +goose Up
INSERT INTO survey_templates (
        id,
        template_code,
        template_name,
        applicant_type,
        product_id,
        active
    )
VALUES (
        '0195d1d2-0001-7000-bb34-000000000001',
        'SURVEY_PERSONAL',
        'Survey Personal (Karyawan/Retail)',
        'personal',
        '0195b1b2-0001-7000-bb34-000000000002',
        true
    ),
    (
        '0195d1d2-0001-7000-bb34-000000000002',
        'SURVEY_BUSINESS',
        'Survey Usaha (UMKM/Commercial)',
        'corporate',
        '0195b1b2-0001-7000-bb34-000000000001',
        true
    );

-- +goose Down
DELETE FROM survey_templates;
