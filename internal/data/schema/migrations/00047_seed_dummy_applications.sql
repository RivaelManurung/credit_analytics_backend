-- +goose Up
INSERT INTO applications (
        id,
        applicant_id,
        product_id,
        ao_id,
        loan_amount,
        tenor_months,
        status,
        branch_code,
        submitted_at
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195383f-427c-7000-bb34-317101010190',
        '0195b1b2-0001-7000-bb34-000000000002',
        '0195c1c2-0001-7000-bb34-000000000001',
        75000000,
        36,
        'ANALYSIS',
        'JKT01',
        CURRENT_TIMESTAMP - interval '2 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        '0195383f-427d-7000-bb34-327301200892',
        '0195b1b2-0001-7000-bb34-000000000001',
        '0195c1c2-0001-7000-bb34-000000000001',
        25000000,
        12,
        'INTAKE',
        'JKT01',
        CURRENT_TIMESTAMP
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        '0195383f-427e-7000-bb34-317202101285',
        '0195b1b2-0001-7000-bb34-000000000001',
        '0195c1c2-0001-7000-bb34-000000000001',
        50000000,
        24,
        'SURVEY',
        'JKT01',
        CURRENT_TIMESTAMP - interval '3 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000004',
        '0195383f-427f-7000-bb34-320101440595',
        '0195b1b2-0001-7000-bb34-000000000001',
        '0195c1c2-0001-7000-bb34-000000000002',
        30000000,
        18,
        'SURVEY',
        'JKT02',
        CURRENT_TIMESTAMP - interval '1 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        '0195383f-4280-7000-bb34-337402121288',
        '0195b1b2-0001-7000-bb34-000000000001',
        '0195c1c2-0001-7000-bb34-000000000001',
        100000000,
        48,
        'ANALYSIS',
        'JKT01',
        CURRENT_TIMESTAMP - interval '4 days'
    );

-- +goose Down
DELETE FROM applications;
