-- +goose Up
INSERT INTO attribute_options (
        attribute_id,
        option_value,
        option_label,
        display_order
    )
VALUES ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'), 'LAKI-LAKI', 'Laki-laki', 1),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'), 'PEREMPUAN', 'Perempuan', 2),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'BELUM_MENIKAH',
        'Belum Menikah',
        1
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'), 'MENIKAH', 'Menikah', 2),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'DUDA_JANDA',
        'Duda / Janda',
        3
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'MILIK_SENDIRI',
        'Milik Sendiri',
        1
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'MILIK_KELUARGA',
        'Milik Keluarga',
        2
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'SEWA_KONTRAK',
        'Sewa / Kontrak',
        3
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'DINAS',
        'Rumah Dinas',
        4
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'), 'SD', 'SD', 1),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'), 'SMP', 'SMP', 2),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'), 'SMA', 'SMA / SMK', 3),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'), 'D3', 'Diploma (D3)', 4),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'), 'S1', 'Sarjana (S1)', 5),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'S2_S3',
        'Pascasarjana (S2/S3)',
        6
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'), 'TETAP', 'Karyawan Tetap', 1),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'KONTRAK',
        'Karyawan Kontrak',
        2
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'OUTSOURCING',
        'Outsourcing',
        3
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'), 'HONORER', 'Honorer', 4),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'PROFESIONAL',
        'Profesional / Freelance',
        5
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'PERDAGANGAN',
        'Perdagangan / Ritel',
        1
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'), 'JASA', 'Jasa', 2),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'), 'MANUFAKTUR', 'Manufaktur', 3),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'PERTANIAN',
        'Pertanian / Peternakan',
        4
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'KULINER',
        'Makanan & Minuman',
        5
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'TEKNOLOGI',
        'Teknologi & Informasi',
        6
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'PT',
        'Perseroan Terbatas (PT)',
        1
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'CV',
        'Persekutuan Komanditer (CV)',
        2
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'UD',
        'Usaha Dagang (UD)',
        3
    ),
    ((SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'), 'KOPERASI', 'Koperasi', 4),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'SANGAT_DISIPLIN',
        'Sangat Disiplin',
        1
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'DISIPLIN',
        'Disiplin',
        2
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'KURANG_DISIPLIN',
        'Kurang Disiplin',
        3
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'TIDAK_DISIPLIN',
        'Tidak Disiplin / Macet',
        4
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'TRANSFER',
        'Transfer Bank',
        1
    ),
    (
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'CASH',
        'Tunai / Cash',
        2
    );

-- +goose Down
DELETE FROM attribute_options;
