-- +goose Up
INSERT INTO application_liabilities (
        application_id,
        creditor_name,
        liability_type,
        outstanding_amount,
        monthly_installment
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        'Bank Mandiri',
        'BANK',
        50000000,
        2500000
    );

-- +goose Down
DELETE FROM application_liabilities;
