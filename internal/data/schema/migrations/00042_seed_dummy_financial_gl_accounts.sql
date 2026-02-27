-- +goose Up
INSERT INTO financial_gl_accounts (
        gl_code,
        gl_name,
        statement_type,
        category,
        sign,
        is_debt_service,
        is_operating
    )
VALUES (
        'INC_SALARY',
        'Gaji Pokok',
        'PL',
        'REVENUE',
        1,
        false,
        true
    ),
    (
        'INC_BUSINESS',
        'Penghasilan Usaha',
        'PL',
        'REVENUE',
        1,
        false,
        true
    ),
    (
        'EXP_LIVING',
        'Biaya Hidup Rutin',
        'PL',
        'EXPENSE',
        -1,
        false,
        true
    ),
    (
        'EXP_UTILITIES',
        'Biaya Listrik/Air/Tlp',
        'PL',
        'EXPENSE',
        -1,
        false,
        true
    ),
    (
        'DEBT_INSTALLMENT',
        'Angsuran Pinjaman Lain',
        'BS',
        'LIABILITY',
        -1,
        true,
        false
    );

-- +goose Down
DELETE FROM financial_gl_accounts;
