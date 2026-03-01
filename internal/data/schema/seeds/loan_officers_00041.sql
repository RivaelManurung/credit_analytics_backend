-- +goose Up
INSERT INTO loan_officers (id, officer_code, branch_code)
VALUES (
        '0195c1c2-0001-7000-bb34-000000000001',
        'AO_BUDI',
        'JKT01'
    ),
    (
        '0195c1c2-0001-7000-bb34-000000000002',
        'AO_SITI',
        'JKT02'
    );

-- +goose Down
DELETE FROM loan_officers;
