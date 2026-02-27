-- +goose Up
INSERT INTO product_status_flows (
        product_id,
        from_status,
        to_status,
        is_default,
        requires_role
    )
VALUES (
        '0195b1b2-0001-7000-bb34-000000000001',
        'INTAKE',
        'SURVEY',
        true,
        'AO'
    ),
    (
        '0195b1b2-0001-7000-bb34-000000000001',
        'SURVEY',
        'ANALYSIS',
        true,
        'AO'
    ),
    (
        '0195b1b2-0001-7000-bb34-000000000001',
        'ANALYSIS',
        'APPROVED',
        false,
        'ANALYST'
    ),
    (
        '0195b1b2-0001-7000-bb34-000000000001',
        'ANALYSIS',
        'COMMITTEE',
        true,
        'ANALYST'
    ),
    (
        '0195b1b2-0001-7000-bb34-000000000002',
        'INTAKE',
        'SURVEY',
        true,
        'AO'
    );

-- +goose Down
DELETE FROM product_status_flows;
