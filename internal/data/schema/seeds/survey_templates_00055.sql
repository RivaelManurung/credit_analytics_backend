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
        '0195a1a2-0003-7000-bb34-000000000001',
        'SURVEY_RETAIL',
        'Template Survey Retail',
        'personal',
        '0195b1b2-0001-7000-bb34-000000000002',
        true
    );

-- +goose Down
DELETE FROM survey_templates;
