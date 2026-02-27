-- +goose Up
INSERT INTO attribute_categories (
        category_code,
        category_name,
        ui_icon,
        display_order,
        description
    )
VALUES (
        'identitas',
        '1. Identitas',
        'id-card',
        1,
        'Data identitas pribadi debitur'
    ),
    (
        'pasangan',
        '2. Pasangan',
        'users',
        2,
        'Data pasangan hidup atau suami/istri'
    ),
    (
        'kontak_alamat',
        '3. Kontak & Alamat',
        'map-pin',
        3,
        'Nomor kontak dan alamat tinggal'
    ),
    (
        'profil_rt',
        '4. Profil Rumah Tangga',
        'home',
        4,
        'Data komposisi dan keuangan rumah tangga'
    ),
    (
        'pendidikan_sosial',
        '5. Pendidikan & Sosial',
        'graduation-cap',
        5,
        'Riwayat pendidikan dan peran sosial'
    ),
    (
        'pekerjaan',
        '6. Pekerjaan',
        'briefcase',
        6,
        'Data pekerjaan dan penghasilan'
    ),
    (
        'usaha',
        '7. Usaha',
        'store',
        7,
        'Data usaha atau bisnis yang dijalankan'
    ),
    (
        'karakter',
        '8. Karakter & Perilaku',
        'shield-check',
        8,
        'Penilaian karakter dan rekam jejak perilaku'
    );

-- +goose Down
DELETE FROM attribute_categories;
