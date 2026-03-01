-- +goose Up
INSERT INTO loan_products (id, product_code, product_name, segment, active)
VALUES (
        '0195b1b2-0001-7000-bb34-000000000001',
        'KUR_MIKRO',
        'KUR Mikro Pemerintah',
        'UMKM',
        true
    ),
    (
        '0195b1b2-0001-7000-bb34-000000000002',
        'KMG_KARYAWAN',
        'Kredit Multi Guna Karyawan',
        'RETAIL',
        true
    );

-- +goose Down
DELETE FROM loan_products;
