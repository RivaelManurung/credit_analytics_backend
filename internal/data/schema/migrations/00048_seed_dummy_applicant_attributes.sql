-- +goose Up
INSERT INTO applicant_attributes (
        applicant_id,
        attribute_id,
        attr_value,
        data_type
    )
VALUES -- BUDI SANTOSO (0195383f-427c-7000-bb34-317101010190)
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'tempat_lahir'),
        'Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'),
        'LAKI-LAKI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nama_ibu_kandung'),
        'Siti Aminah',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_lengkap'),
        'Ani Wijaya',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nik'),
        '3171010101920002',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tempat_lahir'),
        'Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tanggal_lahir'),
        '1992-03-10',
        'DATE'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_jenis_kelamin'),
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_ibu_kandung'),
        'Sri Wahyuni',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_npwp'),
        '02.987.654.3',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_perkawinan_ke'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '08123456789',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_alternatif'),
        '08129876543',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'budi.s@email.com',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_ktp'),
        'Jl. Kebon Jeruk No.45',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_ktp'),
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_ktp'),
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_ktp'),
        'Jakarta Barat',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_ktp'),
        'DKI Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_ktp'),
        '11530',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_domisili'),
        'Jl. Kebon Jeruk No.45',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_domisili'),
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_domisili'),
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_domisili'),
        'Jakarta Barat',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_domisili'),
        'DKI Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_domisili'),
        '11530',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'lama_tinggal_tahun'),
        '8',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'MILIK_SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jarak_ke_cabang'),
        '5',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_tanggungan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berpenghasilan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berhutang'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_pekerjaan_status'),
        'IBU RUMAH TANGGA',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_penghasilan_bulanan'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_penghasilan_rt'),
        '17000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_pengeluaran_rt'),
        '7500000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'S1',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jurusan_pendidikan'),
        'Teknik Informatika',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'sertifikasi_profesi'),
        'AWS Certified',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'peran_sosial'),
        'Pengurus RT',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'dikenal_lingkungan_sekitar'),
        'true',
        'BOOLEAN'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'TETAP',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_nama_perusahaan'),
        'PT Maju Bersama',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_industri'),
        'Teknologi',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_alamat'),
        'Jl. Sudirman No.10',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_jabatan'),
        'Senior Engineer',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_lama_bekerja'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_telp_perusahaan'),
        '0215551234',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_gaji_bersih'),
        '15000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_penghasilan_lain'),
        '2000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'TRANSFER',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status_verifikasi'),
        'TERVERIFIKASI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_nama'),
        'Toko Kelontong Budi',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jenis'),
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_alamat'),
        'Jl. Kebon Jeruk No.20',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_status_kepemilikan_tempat'),
        'SEWA',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_penghasilan_bulanan'),
        '3000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'SANGAT_DISIPLIN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_riwayat_gagal_bayar'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_kerja'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_alamat'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_gaya_hidup_mewah'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_indikasi_fraud'),
        'false',
        'BOOLEAN'
    ),
    -- RINA WIJAYA (0195383f-427d-7000-bb34-327301200892)
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'tempat_lahir'),
        'Bandung',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'),
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'BELUM_MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nama_ibu_kandung'),
        'Ratna Sari',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_lengkap'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nik'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tempat_lahir'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tanggal_lahir'),
        '',
        'DATE'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_jenis_kelamin'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_kewarganegaraan'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_ibu_kandung'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_npwp'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_perkawinan_ke'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '08134455667',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_alternatif'),
        '081355667788',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'rina.w@email.com',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_ktp'),
        'Jl. Sukajadi No.88',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_ktp'),
        'Sukajadi',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_ktp'),
        'Sukajadi',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_ktp'),
        'Bandung',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_ktp'),
        'Jawa Barat',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_ktp'),
        '40162',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_domisili'),
        'Jl. Sukajadi No.88',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_domisili'),
        'Sukajadi',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_domisili'),
        'Sukajadi',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_domisili'),
        'Bandung',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_domisili'),
        'Jawa Barat',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_domisili'),
        '40162',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'lama_tinggal_tahun'),
        '5',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'SEWA_KONTRAK',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jarak_ke_cabang'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_tanggungan'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berpenghasilan'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berhutang'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_pekerjaan_status'),
        '',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_penghasilan_bulanan'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_penghasilan_rt'),
        '9000000',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_pengeluaran_rt'),
        '4000000',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'S1',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jurusan_pendidikan'),
        'Akuntansi',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'sertifikasi_profesi'),
        'Brevet Pajak',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'peran_sosial'),
        'Relawan Komunitas',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'dikenal_lingkungan_sekitar'),
        'true',
        'BOOLEAN'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'TETAP',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_nama_perusahaan'),
        'PT Finansial Sejahtera',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_industri'),
        'Keuangan',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_alamat'),
        'Jl. Asia Afrika No.10',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_jabatan'),
        'Account Officer',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_lama_bekerja'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_telp_perusahaan'),
        '0225551234',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_gaji_bersih'),
        '8500000',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_penghasilan_lain'),
        '1500000',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'TRANSFER',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status_verifikasi'),
        'TERVERIFIKASI',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_nama'),
        'Online Shop Rina',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jenis'),
        'PERDAGANGAN ONLINE',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_alamat'),
        'Online',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_status_kepemilikan_tempat'),
        'ONLINE',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_penghasilan_bulanan'),
        '2000000',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'BAIK',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_riwayat_gagal_bayar'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_kerja'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_alamat'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_gaya_hidup_mewah'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_indikasi_fraud'),
        'false',
        'BOOLEAN'
    ),
    -- AGUS PRAYOGO (0195383f-427e-7000-bb34-317202101285)
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'tempat_lahir'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'),
        'LAKI-LAKI',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nama_ibu_kandung'),
        'Sulastri',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_lengkap'),
        'Maya Sari',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nik'),
        '3172021012860002',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tempat_lahir'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tanggal_lahir'),
        '1989-07-12',
        'DATE'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_jenis_kelamin'),
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_ibu_kandung'),
        'Wahyuni',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_npwp'),
        '45.123.987.6',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_perkawinan_ke'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '081299887766',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_alternatif'),
        '081211223344',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'agus.prayogo@email.com',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_ktp'),
        'Jl. Pandanaran No.20',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_ktp'),
        'Pekunden',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_ktp'),
        'Semarang Tengah',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_ktp'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_ktp'),
        'Jawa Tengah',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_ktp'),
        '50134',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_domisili'),
        'Jl. Melati No.123',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_domisili'),
        'Kembangan',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_domisili'),
        'Kembangan',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_domisili'),
        'Jakarta Barat',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_domisili'),
        'DKI Jakarta',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_domisili'),
        '11610',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'lama_tinggal_tahun'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'KPR',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jarak_ke_cabang'),
        '7',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_tanggungan'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berpenghasilan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berhutang'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_pekerjaan_status'),
        'KARYAWAN',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_penghasilan_bulanan'),
        '5000000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_penghasilan_rt'),
        '17500000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_pengeluaran_rt'),
        '9000000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'S1',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jurusan_pendidikan'),
        'Teknik Industri',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'sertifikasi_profesi'),
        'Lean Six Sigma',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'peran_sosial'),
        'Pengurus Masjid',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'dikenal_lingkungan_sekitar'),
        'true',
        'BOOLEAN'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'TETAP',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_nama_perusahaan'),
        'PT Teknologi Maju Jaya',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_industri'),
        'Teknologi',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_alamat'),
        'Jl. Sudirman No.88',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_jabatan'),
        'IT Manager',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_lama_bekerja'),
        '8',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_telp_perusahaan'),
        '021888999',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_gaji_bersih'),
        '12500000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_penghasilan_lain'),
        '2500000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'TRANSFER',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status_verifikasi'),
        'TERVERIFIKASI',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_nama'),
        'Rental Mobil Agus',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jenis'),
        'JASA',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'Transportasi',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_alamat'),
        'Jl. Meruya Selatan',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_status_kepemilikan_tempat'),
        'MILIK SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_penghasilan_bulanan'),
        '4000000',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'SANGAT_DISIPLIN',
        'STRING'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_riwayat_gagal_bayar'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_kerja'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_alamat'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_gaya_hidup_mewah'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_indikasi_fraud'),
        'false',
        'BOOLEAN'
    ),
    -- DEWI LESTARI (0195383f-427f-7000-bb34-320101440595)
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'tempat_lahir'),
        'Bogor',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'),
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nama_ibu_kandung'),
        'Nurhayati',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_lengkap'),
        'Andi Saputra',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nik'),
        '3201014405960003',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tempat_lahir'),
        'Bogor',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tanggal_lahir'),
        '1994-05-21',
        'DATE'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_jenis_kelamin'),
        'LAKI-LAKI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_ibu_kandung'),
        'Sri Mulyani',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_npwp'),
        '76.555.333.2',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_perkawinan_ke'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '081233445566',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_alternatif'),
        '081222333444',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'dewi.lestari@email.com',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_ktp'),
        'Jl. Pajajaran No.12',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_ktp'),
        'Babakan',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_ktp'),
        'Bogor Tengah',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_ktp'),
        'Bogor',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_ktp'),
        'Jawa Barat',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_ktp'),
        '16122',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_domisili'),
        'Jl. Pajajaran No.12',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_domisili'),
        'Babakan',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_domisili'),
        'Bogor Tengah',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_domisili'),
        'Bogor',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_domisili'),
        'Jawa Barat',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_domisili'),
        '16122',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'lama_tinggal_tahun'),
        '10',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'MILIK SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jarak_ke_cabang'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_tanggungan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berpenghasilan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berhutang'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_pekerjaan_status'),
        'WIRASWASTA',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_penghasilan_bulanan'),
        '4000000',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_penghasilan_rt'),
        '9000000',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_pengeluaran_rt'),
        '5000000',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'D3',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jurusan_pendidikan'),
        'Administrasi',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'sertifikasi_profesi'),
        '-',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'peran_sosial'),
        'PKK',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'dikenal_lingkungan_sekitar'),
        'true',
        'BOOLEAN'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'WIRASWASTA',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_nama_perusahaan'),
        'Warung Dewi',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_industri'),
        'Kuliner',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_alamat'),
        'Jl. Pajajaran No.12',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_jabatan'),
        'Pemilik',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_lama_bekerja'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_telp_perusahaan'),
        '-',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_gaji_bersih'),
        '5000000',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_penghasilan_lain'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'CASH',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status_verifikasi'),
        'TERVERIFIKASI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_nama'),
        'Warung Dewi',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jenis'),
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'Kuliner',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_alamat'),
        'Jl. Pajajaran No.12',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_status_kepemilikan_tempat'),
        'MILIK SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_penghasilan_bulanan'),
        '5000000',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'BAIK',
        'STRING'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_riwayat_gagal_bayar'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_kerja'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_alamat'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_gaya_hidup_mewah'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_indikasi_fraud'),
        'false',
        'BOOLEAN'
    ),
    -- BAMBANG HERU (0195383f-4280-7000-bb34-337402121288)
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'tempat_lahir'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jenis_kelamin'),
        'LAKI-LAKI',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_perkawinan'),
        'MENIKAH',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nama_ibu_kandung'),
        'Kartini',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_lengkap'),
        'Siti Nurhaliza',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nik'),
        '3374021212890004',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tempat_lahir'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_tanggal_lahir'),
        '1988-11-02',
        'DATE'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_jenis_kelamin'),
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_kewarganegaraan'),
        'WNI',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_nama_ibu_kandung'),
        'Fatimah',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_npwp'),
        '11.222.333.4',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_perkawinan_ke'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '085611223344',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_alternatif'),
        '085622334455',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'bambang.heru@email.com',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_ktp'),
        'Jl. Gajah Mada No.9',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_ktp'),
        'Kembangsari',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_ktp'),
        'Semarang Tengah',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_ktp'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_ktp'),
        'Jawa Tengah',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_ktp'),
        '50135',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'alamat_domisili'),
        'Jl. Pandanaran No.77',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kelurahan_domisili'),
        'Pekunden',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kecamatan_domisili'),
        'Semarang Tengah',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kota_domisili'),
        'Semarang',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'provinsi_domisili'),
        'Jawa Tengah',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'kode_pos_domisili'),
        '50134',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'lama_tinggal_tahun'),
        '12',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'status_kepemilikan_rumah'),
        'MILIK SENDIRI',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jarak_ke_cabang'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_tanggungan'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt'),
        '5',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berpenghasilan'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jumlah_anggota_rt_berhutang'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_pekerjaan_status'),
        'IBU RUMAH TANGGA',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pasangan_penghasilan_bulanan'),
        '0',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_penghasilan_rt'),
        '9500000',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'total_pengeluaran_rt'),
        '7000000',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pendidikan_terakhir'),
        'SMA',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'jurusan_pendidikan'),
        'IPA',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'sertifikasi_profesi'),
        'Teknisi Elektronik',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'peran_sosial'),
        'Karang Taruna',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'dikenal_lingkungan_sekitar'),
        'true',
        'BOOLEAN'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status'),
        'KARYAWAN KONTRAK',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_nama_perusahaan'),
        'PT Elektronik Nusantara',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_industri'),
        'Elektronik',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_alamat'),
        'Jl. Industri No.5',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_jabatan'),
        'Teknisi',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_lama_bekerja'),
        '3',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_telp_perusahaan'),
        '024777888',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_gaji_bersih'),
        '7500000',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_penghasilan_lain'),
        '1000000',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_metode_pembayaran'),
        'TRANSFER',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'pekerjaan_status_verifikasi'),
        'TERVERIFIKASI',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_nama'),
        'Servis Elektronik Bambang',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jenis'),
        'JASA',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'Elektronik',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '5',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_alamat'),
        'Jl. Pandanaran No.80',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_status_kepemilikan_tempat'),
        'SEWA',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_penghasilan_bulanan'),
        '2000000',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_disiplin_bayar'),
        'CUKUP',
        'STRING'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_riwayat_gagal_bayar'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_kerja'),
        '2',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_frekuensi_pindah_alamat'),
        '1',
        'NUMBER'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_gaya_hidup_mewah'),
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'karakter_indikasi_fraud'),
        'false',
        'BOOLEAN'
    ),
    -- PT MAJU BERSAMA (0195383f-4281-7000-bb34-812010123456)
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'PT',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nib_number'),
        '8120101234567',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'MANUFAKTUR',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '9',
        'NUMBER'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '150',
        'NUMBER'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'no_hp_utama'),
        '0215556677',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'email_pribadi'),
        'info@majubersama.co.id',
        'STRING'
    ),
    -- CV KARYA MANDIRI (0195383f-4282-7000-bb34-912020234567)
    (
        '0195383f-4282-7000-bb34-912020234567',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'CV',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nib_number'),
        '9120202345678',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '6',
        'NUMBER'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '25',
        'NUMBER'
    ),
    -- PT TEKNOLOGI NUSANTARA (0195383f-4283-7000-bb34-712030345678)
    (
        '0195383f-4283-7000-bb34-712030345678',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'bentuk_badan_usaha'),
        'PT',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'nib_number'),
        '7120303456789',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_sektor'),
        'TEKNOLOGI',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_lama_berusaha'),
        '4',
        'NUMBER'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        (SELECT id FROM custom_column_attribute_registries WHERE attribute_code = 'usaha_jumlah_karyawan'),
        '40',
        'NUMBER'
    );

-- +goose Down
DELETE FROM applicant_attributes;
