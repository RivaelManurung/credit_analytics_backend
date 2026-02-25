-- ============================================================
-- FULL INTEGRATED SEED DATA (PRODUCTION-LIKE)
-- Includes all 8 Categories and 74 Attributes via EAV
-- attribute_categories: dinamis via API, icon di sini
-- ============================================================
-- 1. CLEAN UP (urutan penting karena FK)
TRUNCATE TABLE credit_authority_matrices CASCADE;
TRUNCATE TABLE application_decision_conditions CASCADE;
TRUNCATE TABLE application_decisions CASCADE;
TRUNCATE TABLE application_committee_decisions CASCADE;
TRUNCATE TABLE application_committee_votes CASCADE;
TRUNCATE TABLE credit_committee_members CASCADE;
TRUNCATE TABLE application_committee_sessions CASCADE;
TRUNCATE TABLE application_financial_ratios CASCADE;
TRUNCATE TABLE application_liabilities CASCADE;
TRUNCATE TABLE application_assets CASCADE;
TRUNCATE TABLE asset_types CASCADE;
TRUNCATE TABLE application_financial_facts CASCADE;
TRUNCATE TABLE financial_gl_accounts CASCADE;
TRUNCATE TABLE survey_data_mappings CASCADE;
TRUNCATE TABLE survey_evidences CASCADE;
TRUNCATE TABLE survey_answers CASCADE;
TRUNCATE TABLE application_surveys CASCADE;
TRUNCATE TABLE survey_question_options CASCADE;
TRUNCATE TABLE survey_questions CASCADE;
TRUNCATE TABLE survey_sections CASCADE;
TRUNCATE TABLE survey_templates CASCADE;
TRUNCATE TABLE application_parties CASCADE;
TRUNCATE TABLE parties CASCADE;
TRUNCATE TABLE application_status_logs CASCADE;
TRUNCATE TABLE product_status_flows CASCADE;
TRUNCATE TABLE application_status_refs CASCADE;
TRUNCATE TABLE application_attributes CASCADE;
TRUNCATE TABLE applications CASCADE;
TRUNCATE TABLE loan_officers CASCADE;
TRUNCATE TABLE loan_products CASCADE;
TRUNCATE TABLE branches CASCADE;
TRUNCATE TABLE custom_column_attribute_registries CASCADE;
TRUNCATE TABLE attribute_categories CASCADE;
TRUNCATE TABLE applicant_attributes CASCADE;
TRUNCATE TABLE applicants CASCADE;
-- 2. MASTER REFERENCE DATA
INSERT INTO branches (branch_code, branch_name, region_code)
VALUES ('JKT01', 'Jakarta Pusat Utama', 'REG01'),
    ('JKT02', 'Jakarta Selatan Prima', 'REG01'),
    ('SUB01', 'Surabaya Basuki Rahmat', 'REG03');
INSERT INTO loan_products (id, product_code, product_name, segment, active)
VALUES (
        'p001',
        'KUR_MIKRO',
        'KUR Mikro Pemerintah',
        'UMKM',
        true
    ),
    (
        'p002',
        'KMG_KARYAWAN',
        'Kredit Multi Guna Karyawan',
        'RETAIL',
        true
    );
INSERT INTO loan_officers (id, officer_code, branch_code)
VALUES ('u001', 'AO_BUDI', 'JKT01'),
    ('u002', 'AO_SITI', 'JKT02');
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
        'INC001',
        'Gaji Pokok',
        'PL',
        'REVENUE',
        1,
        false,
        true
    ),
    (
        'EXP001',
        'Biaya Rumah Tangga',
        'PL',
        'EXPENSE',
        -1,
        false,
        true
    ),
    (
        'LIA001',
        'Angsuran Bank Lain',
        'BS',
        'LIABILITY',
        -1,
        true,
        false
    );
-- 3. ATTRIBUTE CATEGORIES (Dinamis, icon disimpan di sini)
-- category_code = kunci unik (FK dari registries)
-- ui_icon = nama icon Lucide/Heroicons yang dipakai di frontend
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
-- 4. LOAD REGISTRY (ui_icon TIDAK di sini lagi — ada di attribute_categories)
-- ui_label = label tampilan khusus per atribut (boleh berbeda dari description)
INSERT INTO custom_column_attribute_registries (
        attribute_code,
        applies_to,
        scope,
        value_type,
        category_code,
        ui_label,
        is_required,
        risk_relevant,
        description
    )
VALUES -- 1. Identitas
    (
        'tempat_lahir',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'identitas',
        'Tempat Lahir',
        true,
        false,
        'Tempat Lahir'
    ),
    (
        'jenis_kelamin',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'identitas',
        'Jenis Kelamin',
        true,
        false,
        'Jenis Kelamin'
    ),
    (
        'kewarganegaraan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'identitas',
        'Kewarganegaraan',
        true,
        false,
        'Kewarganegaraan'
    ),
    (
        'status_perkawinan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'identitas',
        'Status Perkawinan',
        true,
        true,
        'Status Perkawinan'
    ),
    (
        'nama_ibu_kandung',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'identitas',
        'Nama Ibu Kandung',
        true,
        true,
        'Nama Ibu Kandung'
    ),
    -- 2. Pasangan
    (
        'pasangan_nama_lengkap',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'Nama Lengkap Pasangan',
        false,
        false,
        'Nama Lengkap Pasangan'
    ),
    (
        'pasangan_nik',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'NIK Pasangan',
        false,
        true,
        'NIK Pasangan'
    ),
    (
        'pasangan_tempat_lahir',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'Tempat Lahir Pasangan',
        false,
        false,
        'Tempat Lahir Pasangan'
    ),
    (
        'pasangan_tanggal_lahir',
        'BOTH',
        'APPLICANT',
        'DATE',
        'pasangan',
        'Tanggal Lahir Pasangan',
        false,
        false,
        'Tanggal Lahir Pasangan'
    ),
    (
        'pasangan_jenis_kelamin',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'Jenis Kelamin Pasangan',
        false,
        false,
        'Jenis Kelamin Pasangan'
    ),
    (
        'pasangan_kewarganegaraan',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'Kewarganegaraan Pasangan',
        false,
        false,
        'Kewarganegaraan Pasangan'
    ),
    (
        'pasangan_nama_ibu_kandung',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'Nama Ibu Kandung Pasangan',
        false,
        false,
        'Nama Ibu Kandung Pasangan'
    ),
    (
        'pasangan_npwp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'pasangan',
        'NPWP Pasangan',
        false,
        false,
        'NPWP Pasangan'
    ),
    (
        'pasangan_perkawinan_ke',
        'BOTH',
        'APPLICANT',
        'NUMBER',
        'pasangan',
        'Perkawinan Ke',
        false,
        false,
        'Perkawinan Ke'
    ),
    -- 3. Kontak & Alamat
    (
        'no_hp_utama',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'No HP Utama',
        true,
        true,
        'No HP Utama'
    ),
    (
        'no_hp_alternatif',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'No HP Alternatif',
        false,
        false,
        'No HP Alternatif'
    ),
    (
        'email_pribadi',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Email',
        true,
        false,
        'Email'
    ),
    (
        'alamat_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Alamat sesuai KTP',
        false,
        false,
        'Alamat sesuai KTP'
    ),
    (
        'kelurahan_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kelurahan (KTP)',
        false,
        false,
        'Kelurahan sesuai KTP'
    ),
    (
        'kecamatan_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kecamatan (KTP)',
        false,
        false,
        'Kecamatan sesuai KTP'
    ),
    (
        'kota_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kota (KTP)',
        false,
        false,
        'Kota sesuai KTP'
    ),
    (
        'provinsi_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Provinsi (KTP)',
        false,
        false,
        'Provinsi sesuai KTP'
    ),
    (
        'kode_pos_ktp',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kode Pos (KTP)',
        false,
        false,
        'Kode Pos sesuai KTP'
    ),
    (
        'alamat_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Alamat Domisili',
        true,
        true,
        'Alamat sesuai Domisili'
    ),
    (
        'kelurahan_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kelurahan (Domisili)',
        false,
        false,
        'Kelurahan sesuai Domisili'
    ),
    (
        'kecamatan_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kecamatan (Domisili)',
        false,
        false,
        'Kecamatan sesuai Domisili'
    ),
    (
        'kota_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kota (Domisili)',
        false,
        false,
        'Kota sesuai Domisili'
    ),
    (
        'provinsi_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Provinsi (Domisili)',
        false,
        false,
        'Provinsi sesuai Domisili'
    ),
    (
        'kode_pos_domisili',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Kode Pos (Domisili)',
        false,
        false,
        'Kode Pos sesuai Domisili'
    ),
    (
        'lama_tinggal_tahun',
        'BOTH',
        'APPLICANT',
        'NUMBER',
        'kontak_alamat',
        'Lama Tinggal (Tahun)',
        false,
        false,
        'Lama tinggal di alamat ini'
    ),
    (
        'status_kepemilikan_rumah',
        'BOTH',
        'APPLICANT',
        'STRING',
        'kontak_alamat',
        'Status Kepemilikan Rumah',
        false,
        true,
        'Status kepemilikan rumah'
    ),
    (
        'jarak_ke_cabang',
        'BOTH',
        'APPLICANT',
        'NUMBER',
        'kontak_alamat',
        'Jarak ke Cabang (KM)',
        false,
        false,
        'Perkiraan jarak kantor cabang'
    ),
    -- 4. Profil Rumah Tangga
    (
        'jumlah_tanggungan',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Jumlah Tanggungan',
        false,
        true,
        'Jumlah tanggungan'
    ),
    (
        'jumlah_anggota_rt',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Jumlah Anggota RT',
        false,
        false,
        'Jumlah anggota rumah tangga'
    ),
    (
        'jumlah_anggota_rt_berpenghasilan',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Anggota RT Berpenghasilan',
        false,
        false,
        'Jumlah anggota rumah tangga berpenghasilan'
    ),
    (
        'jumlah_anggota_rt_berhutang',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Anggota RT Berhutang',
        false,
        true,
        'Jumlah anggota rumah tangga berhutang'
    ),
    (
        'pasangan_pekerjaan_status',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'profil_rt',
        'Pekerjaan Pasangan',
        false,
        false,
        'Status pekerjaan pasangan'
    ),
    (
        'pasangan_penghasilan_bulanan',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Penghasilan Pasangan (Rp)',
        false,
        true,
        'Penghasilan pasangan'
    ),
    (
        'total_penghasilan_rt',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Total Penghasilan RT (Rp)',
        false,
        true,
        'Total penghasilan rumah tangga'
    ),
    (
        'total_pengeluaran_rt',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'profil_rt',
        'Total Pengeluaran RT (Rp)',
        false,
        true,
        'Total pengeluaran rumah tangga'
    ),
    -- 5. Pendidikan & Sosial
    (
        'pendidikan_terakhir',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pendidikan_sosial',
        'Pendidikan Terakhir',
        false,
        false,
        'Pendidikan terakhir'
    ),
    (
        'jurusan_pendidikan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pendidikan_sosial',
        'Jurusan Pendidikan',
        false,
        false,
        'Jurusan pendidikan'
    ),
    (
        'sertifikasi_profesi',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pendidikan_sosial',
        'Sertifikasi Profesi',
        false,
        false,
        'Sertifikasi profesi'
    ),
    (
        'peran_sosial',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pendidikan_sosial',
        'Peran Sosial',
        false,
        false,
        'Peran sosial di masyarakat'
    ),
    (
        'dikenal_lingkungan_sekitar',
        'PERSONAL',
        'APPLICANT',
        'BOOLEAN',
        'pendidikan_sosial',
        'Dikenal Lingkungan',
        false,
        false,
        'Apakah dikenal lingkungan setempat'
    ),
    -- 6. Pekerjaan
    (
        'pekerjaan_status',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Status Pekerjaan',
        false,
        true,
        'Status pekerjaan'
    ),
    (
        'pekerjaan_nama_perusahaan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Nama Perusahaan',
        false,
        false,
        'Nama perusahaan'
    ),
    (
        'pekerjaan_industri',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Industri',
        false,
        false,
        'Industri perusahaan'
    ),
    (
        'pekerjaan_alamat',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Alamat Tempat Kerja',
        false,
        false,
        'Alamat tempat kerja'
    ),
    (
        'pekerjaan_jabatan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Jabatan',
        false,
        false,
        'Jabatan'
    ),
    (
        'pekerjaan_lama_bekerja',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'pekerjaan',
        'Lama Bekerja (Tahun)',
        false,
        false,
        'Lama bekerja (Tahun)'
    ),
    (
        'pekerjaan_telp_perusahaan',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Telp Perusahaan',
        false,
        false,
        'No telp perusahaan'
    ),
    (
        'pekerjaan_gaji_bersih',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'pekerjaan',
        'Gaji Bersih (Rp)',
        false,
        true,
        'Gaji bersih bulanan'
    ),
    (
        'pekerjaan_penghasilan_lain',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'pekerjaan',
        'Penghasilan Lain (Rp)',
        false,
        false,
        'Penghasilan lain rutin'
    ),
    (
        'pekerjaan_metode_pembayaran',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Metode Pembayaran Gaji',
        false,
        false,
        'Metode pembayaran gaji'
    ),
    (
        'pekerjaan_status_verifikasi',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'pekerjaan',
        'Status Verifikasi Pekerjaan',
        false,
        false,
        'Status verifikasi pekerjaan'
    ),
    -- 7. Usaha
    (
        'usaha_nama',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'usaha',
        'Nama Usaha',
        false,
        false,
        'Nama usaha'
    ),
    (
        'usaha_jenis',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'usaha',
        'Jenis Usaha',
        false,
        false,
        'Jenis usaha'
    ),
    (
        'usaha_sektor',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'usaha',
        'Sektor Usaha',
        false,
        false,
        'Sektor usaha'
    ),
    (
        'usaha_lama_berusaha',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'usaha',
        'Lama Berusaha (Tahun)',
        false,
        false,
        'Lama berusaha (Tahun)'
    ),
    (
        'usaha_alamat',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'usaha',
        'Alamat Usaha',
        false,
        false,
        'Alamat usaha'
    ),
    (
        'usaha_status_kepemilikan_tempat',
        'PERSONAL',
        'APPLICANT',
        'STRING',
        'usaha',
        'Status Kepemilikan Tempat Usaha',
        false,
        false,
        'Status kepemilikan tempat usaha'
    ),
    (
        'usaha_jumlah_karyawan',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'usaha',
        'Jumlah Karyawan',
        false,
        false,
        'Jumlah karyawan'
    ),
    (
        'usaha_penghasilan_bulanan',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'usaha',
        'Penghasilan Bulanan Usaha (Rp)',
        false,
        true,
        'Penghasilan bulanan'
    ),
    -- 8. Karakter & Perilaku
    (
        'karakter_disiplin_bayar',
        'BOTH',
        'APPLICANT',
        'STRING',
        'karakter',
        'Kedisiplinan Bayar',
        false,
        true,
        'Persepsi kedisiplinan bayar'
    ),
    (
        'karakter_riwayat_gagal_bayar',
        'BOTH',
        'APPLICANT',
        'BOOLEAN',
        'karakter',
        'Riwayat Gagal Bayar',
        false,
        true,
        'Riwayat gagal bayar (internal)'
    ),
    (
        'karakter_frekuensi_pindah_kerja',
        'PERSONAL',
        'APPLICANT',
        'NUMBER',
        'karakter',
        'Frekuensi Pindah Kerja',
        false,
        true,
        'Frekuensi pindah kerja'
    ),
    (
        'karakter_frekuensi_pindah_alamat',
        'BOTH',
        'APPLICANT',
        'NUMBER',
        'karakter',
        'Frekuensi Pindah Alamat',
        false,
        true,
        'Frekuensi pindah alamat'
    ),
    (
        'karakter_gaya_hidup_mewah',
        'BOTH',
        'APPLICANT',
        'BOOLEAN',
        'karakter',
        'Gaya Hidup Mewah',
        false,
        true,
        'Indikasi gaya hidup lebih besar dari penghasilan'
    ),
    (
        'karakter_indikasi_fraud',
        'BOTH',
        'APPLICANT',
        'BOOLEAN',
        'karakter',
        'Indikasi Fraud',
        false,
        true,
        'Indikasi fraud'
    );
-- 5. ENTITY: APPLICANTS (CORE fields only)
INSERT INTO applicants (
        id,
        applicant_type,
        identity_number,
        tax_id,
        full_name,
        birth_date
    )
VALUES (
        '0195383f-427c-7000-bb34-317101010190',
        'personal',
        '3171010101900001',
        '123456789012345',
        'Budi Santoso',
        '1990-05-15'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        'personal',
        '3273012008920005',
        '987654321098765',
        'Rina Wijaya',
        '1992-08-20'
    ),
    (
        '0195383f-427e-7000-bb34-317202101285',
        'personal',
        '3172021012850002',
        NULL,
        'Agus Prayogo',
        '1985-12-10'
    ),
    (
        '0195383f-427f-7000-bb34-320101440595',
        'personal',
        '3201014405950003',
        '111222333444555',
        'Dewi Lestari',
        '1995-05-04'
    ),
    (
        '0195383f-4280-7000-bb34-337402121288',
        'personal',
        '3374021212880001',
        '222333444555666',
        'Bambang Heru',
        '1988-12-12'
    );
-- 6. VALUE: FULL 8 CATEGORIES ATTRIBUTES (EAV)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type)
VALUES -- Budi Santoso
    -- =========================
    -- 1. IDENTITAS
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'tempat_lahir',
        'Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jenis_kelamin',
        'LAKI-LAKI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kewarganegaraan',
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'status_perkawinan',
        'MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'nama_ibu_kandung',
        'Siti Aminah',
        'STRING'
    ),
    -- =========================
    -- 2. PASANGAN
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_nama_lengkap',
        'Ani Wijaya',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_nik',
        '3171010101920002',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_tempat_lahir',
        'Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_tanggal_lahir',
        '1992-03-10',
        'DATE'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_jenis_kelamin',
        'PEREMPUAN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_kewarganegaraan',
        'WNI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_nama_ibu_kandung',
        'Sri Wahyuni',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_npwp',
        '02.987.654.3',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_perkawinan_ke',
        '1',
        'NUMBER'
    ),
    -- =========================
    -- 3. KONTAK & ALAMAT
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'no_hp_utama',
        '08123456789',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'no_hp_alternatif',
        '08129876543',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'email_pribadi',
        'budi.s@email.com',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'alamat_ktp',
        'Jl. Kebon Jeruk No.45',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kelurahan_ktp',
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kecamatan_ktp',
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kota_ktp',
        'Jakarta Barat',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'provinsi_ktp',
        'DKI Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kode_pos_ktp',
        '11530',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'alamat_domisili',
        'Jl. Kebon Jeruk No.45',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kelurahan_domisili',
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kecamatan_domisili',
        'Kebon Jeruk',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kota_domisili',
        'Jakarta Barat',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'provinsi_domisili',
        'DKI Jakarta',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'kode_pos_domisili',
        '11530',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'lama_tinggal_tahun',
        '8',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'status_kepemilikan_rumah',
        'MILIK SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jarak_ke_cabang',
        '5',
        'NUMBER'
    ),
    -- =========================
    -- 4. PROFIL RUMAH TANGGA
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jumlah_tanggungan',
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jumlah_anggota_rt',
        '4',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jumlah_anggota_rt_berpenghasilan',
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jumlah_anggota_rt_berhutang',
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_pekerjaan_status',
        'IBU RUMAH TANGGA',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pasangan_penghasilan_bulanan',
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'total_penghasilan_rt',
        '17000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'total_pengeluaran_rt',
        '7500000',
        'NUMBER'
    ),
    -- =========================
    -- 5. PENDIDIKAN & SOSIAL
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pendidikan_terakhir',
        'S1',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jurusan_pendidikan',
        'Teknik Informatika',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'sertifikasi_profesi',
        'AWS Certified',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'peran_sosial',
        'Pengurus RT',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'dikenal_lingkungan_sekitar',
        'true',
        'BOOLEAN'
    ),
    -- =========================
    -- 6. PEKERJAAN
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_status',
        'KARYAWAN TETAP',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_nama_perusahaan',
        'PT Maju Bersama',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_industri',
        'Teknologi',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_alamat',
        'Jl. Sudirman No.10',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_jabatan',
        'Senior Engineer',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_lama_bekerja',
        '6',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_telp_perusahaan',
        '0215551234',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_gaji_bersih',
        '15000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_penghasilan_lain',
        '2000000',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_metode_pembayaran',
        'TRANSFER',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_status_verifikasi',
        'TERVERIFIKASI',
        'STRING'
    ),
    -- =========================
    -- 7. USAHA
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_nama',
        'Toko Kelontong Budi',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_jenis',
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_sektor',
        'Retail',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_lama_berusaha',
        '3',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_alamat',
        'Jl. Kebon Jeruk No.20',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_status_kepemilikan_tempat',
        'SEWA',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_jumlah_karyawan',
        '2',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'usaha_penghasilan_bulanan',
        '3000000',
        'NUMBER'
    ),
    -- =========================
    -- 8. KARAKTER & PERILAKU
    -- =========================
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_disiplin_bayar',
        'SANGAT DISIPLIN',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_riwayat_gagal_bayar',
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_frekuensi_pindah_kerja',
        '1',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_frekuensi_pindah_alamat',
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_gaya_hidup_mewah',
        'false',
        'BOOLEAN'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_indikasi_fraud',
        'false',
        'BOOLEAN'
    );
-- Rina Wijaya (0195383f-427d-7000-bb34-327301200892)
-- 1 IDENTITAS
(
    '0195383f-427d-7000-bb34-327301200892',
    'tempat_lahir',
    'Bandung',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jenis_kelamin',
    'PEREMPUAN',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'status_perkawinan',
    'BELUM MENIKAH',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'nama_ibu_kandung',
    'Ratna Sari',
    'STRING'
),
-- 2 PASANGAN
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_nama_lengkap',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_nik',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_tempat_lahir',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_tanggal_lahir',
    '',
    'DATE'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_jenis_kelamin',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_kewarganegaraan',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_nama_ibu_kandung',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_npwp',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_perkawinan_ke',
    '0',
    'NUMBER'
),
-- 3 KONTAK & ALAMAT
(
    '0195383f-427d-7000-bb34-327301200892',
    'no_hp_utama',
    '08134455667',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'no_hp_alternatif',
    '081355667788',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'email_pribadi',
    'rina.w@email.com',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'alamat_ktp',
    'Jl. Sukajadi No.88',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kelurahan_ktp',
    'Sukajadi',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kecamatan_ktp',
    'Sukajadi',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kota_ktp',
    'Bandung',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'provinsi_ktp',
    'Jawa Barat',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kode_pos_ktp',
    '40162',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'alamat_domisili',
    'Jl. Sukajadi No.88',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kelurahan_domisili',
    'Sukajadi',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kecamatan_domisili',
    'Sukajadi',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kota_domisili',
    'Bandung',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'provinsi_domisili',
    'Jawa Barat',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'kode_pos_domisili',
    '40162',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'lama_tinggal_tahun',
    '5',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'status_kepemilikan_rumah',
    'KONTRAK',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jarak_ke_cabang',
    '3',
    'NUMBER'
),
-- 4 PROFIL RUMAH TANGGA
(
    '0195383f-427d-7000-bb34-327301200892',
    'jumlah_tanggungan',
    '0',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jumlah_anggota_rt',
    '1',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jumlah_anggota_rt_berpenghasilan',
    '1',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jumlah_anggota_rt_berhutang',
    '0',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_pekerjaan_status',
    '',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pasangan_penghasilan_bulanan',
    '0',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'total_penghasilan_rt',
    '9000000',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'total_pengeluaran_rt',
    '4000000',
    'NUMBER'
),
-- 5 PENDIDIKAN & SOSIAL
(
    '0195383f-427d-7000-bb34-327301200892',
    'pendidikan_terakhir',
    'S1',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'jurusan_pendidikan',
    'Akuntansi',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'sertifikasi_profesi',
    'Brevet Pajak',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'peran_sosial',
    'Relawan Komunitas',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'dikenal_lingkungan_sekitar',
    'true',
    'BOOLEAN'
),
-- 6 PEKERJAAN
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_status',
    'KARYAWAN TETAP',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_nama_perusahaan',
    'PT Finansial Sejahtera',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_industri',
    'Keuangan',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_alamat',
    'Jl. Asia Afrika No.10',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_jabatan',
    'Account Officer',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_lama_bekerja',
    '4',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_telp_perusahaan',
    '0225551234',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_gaji_bersih',
    '8500000',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_penghasilan_lain',
    '1500000',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_metode_pembayaran',
    'TRANSFER',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'pekerjaan_status_verifikasi',
    'TERVERIFIKASI',
    'STRING'
),
-- 7 USAHA
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_nama',
    'Online Shop Rina',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_jenis',
    'PERDAGANGAN ONLINE',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_sektor',
    'Retail',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_lama_berusaha',
    '2',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_alamat',
    'Online',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_status_kepemilikan_tempat',
    'ONLINE',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_jumlah_karyawan',
    '0',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'usaha_penghasilan_bulanan',
    '1500000',
    'NUMBER'
),
-- 8 KARAKTER
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_disiplin_bayar',
    'BAIK',
    'STRING'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_riwayat_gagal_bayar',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_frekuensi_pindah_kerja',
    '1',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_frekuensi_pindah_alamat',
    '1',
    'NUMBER'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_gaya_hidup_mewah',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427d-7000-bb34-327301200892',
    'karakter_indikasi_fraud',
    'false',
    'BOOLEAN'
);
-- Agus Prayogo (0195383f-427e-7000-bb34-317202101285)
-- 1 IDENTITAS
(
    '0195383f-427e-7000-bb34-317202101285',
    'tempat_lahir',
    'Semarang',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jenis_kelamin',
    'LAKI-LAKI',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'status_perkawinan',
    'MENIKAH',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'nama_ibu_kandung',
    'Sulastri',
    'STRING'
),
-- 2 PASANGAN
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_nama_lengkap',
    'Maya Sari',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_nik',
    '3172021012860002',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_tempat_lahir',
    'Semarang',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_tanggal_lahir',
    '1989-07-12',
    'DATE'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_jenis_kelamin',
    'PEREMPUAN',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_nama_ibu_kandung',
    'Wahyuni',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_npwp',
    '45.123.987.6',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_perkawinan_ke',
    '1',
    'NUMBER'
),
-- 3 KONTAK & ALAMAT
(
    '0195383f-427e-7000-bb34-317202101285',
    'no_hp_utama',
    '081299887766',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'no_hp_alternatif',
    '081211223344',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'email_pribadi',
    'agus.prayogo@email.com',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'alamat_ktp',
    'Jl. Pandanaran No.20',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kelurahan_ktp',
    'Pekunden',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kecamatan_ktp',
    'Semarang Tengah',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kota_ktp',
    'Semarang',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'provinsi_ktp',
    'Jawa Tengah',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kode_pos_ktp',
    '50134',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'alamat_domisili',
    'Jl. Melati No.123',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kelurahan_domisili',
    'Kembangan',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kecamatan_domisili',
    'Kembangan',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kota_domisili',
    'Jakarta Barat',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'provinsi_domisili',
    'DKI Jakarta',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'kode_pos_domisili',
    '11610',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'lama_tinggal_tahun',
    '6',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'status_kepemilikan_rumah',
    'KPR',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jarak_ke_cabang',
    '7',
    'NUMBER'
),
-- 4 PROFIL RUMAH TANGGA
(
    '0195383f-427e-7000-bb34-317202101285',
    'jumlah_tanggungan',
    '1',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jumlah_anggota_rt',
    '3',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jumlah_anggota_rt_berpenghasilan',
    '2',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jumlah_anggota_rt_berhutang',
    '1',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_pekerjaan_status',
    'KARYAWAN',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pasangan_penghasilan_bulanan',
    '5000000',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'total_penghasilan_rt',
    '17500000',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'total_pengeluaran_rt',
    '9000000',
    'NUMBER'
),
-- 5 PENDIDIKAN & SOSIAL
(
    '0195383f-427e-7000-bb34-317202101285',
    'pendidikan_terakhir',
    'S1',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'jurusan_pendidikan',
    'Teknik Industri',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'sertifikasi_profesi',
    'Lean Six Sigma',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'peran_sosial',
    'Pengurus Masjid',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'dikenal_lingkungan_sekitar',
    'true',
    'BOOLEAN'
),
-- 6 PEKERJAAN
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_status',
    'KARYAWAN TETAP',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_nama_perusahaan',
    'PT Teknologi Maju Jaya',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_industri',
    'Teknologi',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_alamat',
    'Jl. Sudirman No.88',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_jabatan',
    'IT Manager',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_lama_bekerja',
    '8',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_telp_perusahaan',
    '021888999',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_gaji_bersih',
    '12500000',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_penghasilan_lain',
    '2500000',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_metode_pembayaran',
    'TRANSFER',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'pekerjaan_status_verifikasi',
    'TERVERIFIKASI',
    'STRING'
),
-- 7 USAHA
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_nama',
    'Rental Mobil Agus',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_jenis',
    'JASA',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_sektor',
    'Transportasi',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_lama_berusaha',
    '4',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_alamat',
    'Jl. Meruya Selatan',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_status_kepemilikan_tempat',
    'MILIK SENDIRI',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_jumlah_karyawan',
    '3',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'usaha_penghasilan_bulanan',
    '4000000',
    'NUMBER'
),
-- 8 KARAKTER
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_disiplin_bayar',
    'SANGAT DISIPLIN',
    'STRING'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_riwayat_gagal_bayar',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_frekuensi_pindah_kerja',
    '1',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_frekuensi_pindah_alamat',
    '2',
    'NUMBER'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_gaya_hidup_mewah',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427e-7000-bb34-317202101285',
    'karakter_indikasi_fraud',
    'false',
    'BOOLEAN'
);
-- Dewi Lestari (0195383f-427f-7000-bb34-320101440595)
-- IDENTITAS
(
    '0195383f-427f-7000-bb34-320101440595',
    'tempat_lahir',
    'Bogor',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jenis_kelamin',
    'PEREMPUAN',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'status_perkawinan',
    'MENIKAH',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'nama_ibu_kandung',
    'Nurhayati',
    'STRING'
),
-- PASANGAN
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_nama_lengkap',
    'Andi Saputra',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_nik',
    '3201014405960003',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_tempat_lahir',
    'Bogor',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_tanggal_lahir',
    '1994-05-21',
    'DATE'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_jenis_kelamin',
    'LAKI-LAKI',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_nama_ibu_kandung',
    'Sri Mulyani',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_npwp',
    '76.555.333.2',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_perkawinan_ke',
    '1',
    'NUMBER'
),
-- KONTAK
(
    '0195383f-427f-7000-bb34-320101440595',
    'no_hp_utama',
    '081233445566',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'no_hp_alternatif',
    '081222333444',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'email_pribadi',
    'dewi.lestari@email.com',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'alamat_ktp',
    'Jl. Pajajaran No.12',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kelurahan_ktp',
    'Babakan',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kecamatan_ktp',
    'Bogor Tengah',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kota_ktp',
    'Bogor',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'provinsi_ktp',
    'Jawa Barat',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kode_pos_ktp',
    '16122',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'alamat_domisili',
    'Jl. Pajajaran No.12',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kelurahan_domisili',
    'Babakan',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kecamatan_domisili',
    'Bogor Tengah',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kota_domisili',
    'Bogor',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'provinsi_domisili',
    'Jawa Barat',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'kode_pos_domisili',
    '16122',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'lama_tinggal_tahun',
    '10',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'status_kepemilikan_rumah',
    'MILIK SENDIRI',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jarak_ke_cabang',
    '4',
    'NUMBER'
),
-- RUMAH TANGGA
(
    '0195383f-427f-7000-bb34-320101440595',
    'jumlah_tanggungan',
    '2',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jumlah_anggota_rt',
    '4',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jumlah_anggota_rt_berpenghasilan',
    '2',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jumlah_anggota_rt_berhutang',
    '1',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_pekerjaan_status',
    'WIRASWASTA',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pasangan_penghasilan_bulanan',
    '4000000',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'total_penghasilan_rt',
    '9000000',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'total_pengeluaran_rt',
    '5000000',
    'NUMBER'
),
-- PENDIDIKAN
(
    '0195383f-427f-7000-bb34-320101440595',
    'pendidikan_terakhir',
    'D3',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'jurusan_pendidikan',
    'Administrasi',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'sertifikasi_profesi',
    '-',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'peran_sosial',
    'PKK',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'dikenal_lingkungan_sekitar',
    'true',
    'BOOLEAN'
),
-- PEKERJAAN
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_status',
    'WIRASWASTA',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_nama_perusahaan',
    'Warung Dewi',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_industri',
    'Kuliner',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_alamat',
    'Jl. Pajajaran No.12',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_jabatan',
    'Pemilik',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_lama_bekerja',
    '6',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_telp_perusahaan',
    '-',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_gaji_bersih',
    '5000000',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_penghasilan_lain',
    '0',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_metode_pembayaran',
    'CASH',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'pekerjaan_status_verifikasi',
    'TERVERIFIKASI',
    'STRING'
),
-- USAHA
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_nama',
    'Warung Dewi',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_jenis',
    'PERDAGANGAN',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_sektor',
    'Kuliner',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_lama_berusaha',
    '6',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_alamat',
    'Jl. Pajajaran No.12',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_status_kepemilikan_tempat',
    'MILIK SENDIRI',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_jumlah_karyawan',
    '1',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'usaha_penghasilan_bulanan',
    '5000000',
    'NUMBER'
),
-- KARAKTER
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_disiplin_bayar',
    'BAIK',
    'STRING'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_riwayat_gagal_bayar',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_frekuensi_pindah_kerja',
    '0',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_frekuensi_pindah_alamat',
    '0',
    'NUMBER'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_gaya_hidup_mewah',
    'false',
    'BOOLEAN'
),
(
    '0195383f-427f-7000-bb34-320101440595',
    'karakter_indikasi_fraud',
    'false',
    'BOOLEAN'
);
-- Bambang Heru (0195383f-4280-7000-bb34-337402121288)
-- IDENTITAS
(
    '0195383f-4280-7000-bb34-337402121288',
    'tempat_lahir',
    'Semarang',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jenis_kelamin',
    'LAKI-LAKI',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'status_perkawinan',
    'MENIKAH',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'nama_ibu_kandung',
    'Kartini',
    'STRING'
),
-- PASANGAN
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_nama_lengkap',
    'Siti Nurhaliza',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_nik',
    '3374021212890004',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_tempat_lahir',
    'Semarang',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_tanggal_lahir',
    '1988-11-02',
    'DATE'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_jenis_kelamin',
    'PEREMPUAN',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_kewarganegaraan',
    'WNI',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_nama_ibu_kandung',
    'Fatimah',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_npwp',
    '11.222.333.4',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_perkawinan_ke',
    '1',
    'NUMBER'
),
-- KONTAK & ALAMAT
(
    '0195383f-4280-7000-bb34-337402121288',
    'no_hp_utama',
    '085611223344',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'no_hp_alternatif',
    '085622334455',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'email_pribadi',
    'bambang.heru@email.com',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'alamat_ktp',
    'Jl. Gajah Mada No.9',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kelurahan_ktp',
    'Kembangsari',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kecamatan_ktp',
    'Semarang Tengah',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kota_ktp',
    'Semarang',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'provinsi_ktp',
    'Jawa Tengah',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kode_pos_ktp',
    '50135',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'alamat_domisili',
    'Jl. Pandanaran No.77',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kelurahan_domisili',
    'Pekunden',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kecamatan_domisili',
    'Semarang Tengah',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kota_domisili',
    'Semarang',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'provinsi_domisili',
    'Jawa Tengah',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'kode_pos_domisili',
    '50134',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'lama_tinggal_tahun',
    '12',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'status_kepemilikan_rumah',
    'MILIK SENDIRI',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jarak_ke_cabang',
    '6',
    'NUMBER'
),
-- PROFIL RUMAH TANGGA
(
    '0195383f-4280-7000-bb34-337402121288',
    'jumlah_tanggungan',
    '3',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jumlah_anggota_rt',
    '5',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jumlah_anggota_rt_berpenghasilan',
    '2',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jumlah_anggota_rt_berhutang',
    '1',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_pekerjaan_status',
    'IBU RUMAH TANGGA',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pasangan_penghasilan_bulanan',
    '0',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'total_penghasilan_rt',
    '9500000',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'total_pengeluaran_rt',
    '7000000',
    'NUMBER'
),
-- PENDIDIKAN & SOSIAL
(
    '0195383f-4280-7000-bb34-337402121288',
    'pendidikan_terakhir',
    'SMA',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'jurusan_pendidikan',
    'IPA',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'sertifikasi_profesi',
    'Teknisi Elektronik',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'peran_sosial',
    'Karang Taruna',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'dikenal_lingkungan_sekitar',
    'true',
    'BOOLEAN'
),
-- PEKERJAAN
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_status',
    'KARYAWAN KONTRAK',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_nama_perusahaan',
    'PT Elektronik Nusantara',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_industri',
    'Elektronik',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_alamat',
    'Jl. Industri No.5',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_jabatan',
    'Teknisi',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_lama_bekerja',
    '3',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_telp_perusahaan',
    '024777888',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_gaji_bersih',
    '7500000',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_penghasilan_lain',
    '1000000',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_metode_pembayaran',
    'TRANSFER',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'pekerjaan_status_verifikasi',
    'TERVERIFIKASI',
    'STRING'
),
-- USAHA
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_nama',
    'Servis Elektronik Bambang',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_jenis',
    'JASA',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_sektor',
    'Elektronik',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_lama_berusaha',
    '5',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_alamat',
    'Jl. Pandanaran No.80',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_status_kepemilikan_tempat',
    'SEWA',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_jumlah_karyawan',
    '1',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'usaha_penghasilan_bulanan',
    '2000000',
    'NUMBER'
),
-- KARAKTER
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_disiplin_bayar',
    'CUKUP',
    'STRING'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_riwayat_gagal_bayar',
    'false',
    'BOOLEAN'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_frekuensi_pindah_kerja',
    '2',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_frekuensi_pindah_alamat',
    '1',
    'NUMBER'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_gaya_hidup_mewah',
    'false',
    'BOOLEAN'
),
(
    '0195383f-4280-7000-bb34-337402121288',
    'karakter_indikasi_fraud',
    'false',
    'BOOLEAN'
);
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
VALUES -- Budi Santoso (sedang ANALYSIS)
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195383f-427c-7000-bb34-317101010190',
        'p002',
        'u001',
        75000000,
        36,
        'ANALYSIS',
        'JKT01',
        CURRENT_TIMESTAMP - interval '2 days'
    ),
    -- Rina Wijaya (baru masuk)
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        '0195383f-427d-7000-bb34-327301200892',
        'p001',
        'u001',
        25000000,
        12,
        'INTAKE',
        'JKT01',
        CURRENT_TIMESTAMP
    );
-- 8. FINANCIAL DATA
INSERT INTO application_financial_facts (
        application_id,
        gl_code,
        period_type,
        period_label,
        amount,
        source
    )
VALUES -- BUDI
    -- INCOME
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'INC_SALARY',
        'MONTHLY',
        '2025-01',
        15000000,
        'SURVEY'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'INC_BUSINESS',
        'MONTHLY',
        '2025-01',
        2000000,
        'SURVEY'
    ),
    -- EXPENSE
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'EXP_LIVING',
        'MONTHLY',
        '2025-01',
        5000000,
        'SURVEY'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'EXP_UTILITIES',
        'MONTHLY',
        '2025-01',
        1500000,
        'SURVEY'
    ),
    -- EXISTING DEBT (SLIK/Bureau)
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    );
-- RINA
-- INCOME
(
    '0195a1a2-0001-7000-bb34-000000000002',
    'INC_SALARY',
    'MONTHLY',
    '2025-01',
    15000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000002',
    'INC_BUSINESS',
    'MONTHLY',
    '2025-01',
    2000000,
    'SURVEY'
),
-- EXPENSE
(
    '0195a1a2-0001-7000-bb34-000000000002',
    'EXP_LIVING',
    'MONTHLY',
    '2025-01',
    5000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000002',
    'EXP_UTILITIES',
    'MONTHLY',
    '2025-01',
    1500000,
    'SURVEY'
),
-- EXISTING DEBT (SLIK/Bureau)
(
    '0195a1a2-0001-7000-bb34-000000000002',
    'DEBT_INSTALLMENT',
    'MONTHLY',
    '2025-01',
    1000000,
    'BUREAU'
);
-- BAMBANG
-- INCOME
(
    '0195a1a2-0001-7000-bb34-000000000003',
    'INC_SALARY',
    'MONTHLY',
    '2025-01',
    15000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000003',
    'INC_BUSINESS',
    'MONTHLY',
    '2025-01',
    2000000,
    'SURVEY'
),
-- EXPENSE
(
    '0195a1a2-0001-7000-bb34-000000000003',
    'EXP_LIVING',
    'MONTHLY',
    '2025-01',
    5000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000003',
    'EXP_UTILITIES',
    'MONTHLY',
    '2025-01',
    1500000,
    'SURVEY'
),
-- EXISTING DEBT (SLIK/Bureau)
(
    '0195a1a2-0001-7000-bb34-000000000003',
    'DEBT_INSTALLMENT',
    'MONTHLY',
    '2025-01',
    1000000,
    'BUREAU'
);
-- SITI
-- INCOME
(
    '0195a1a2-0001-7000-bb34-000000000004',
    'INC_SALARY',
    'MONTHLY',
    '2025-01',
    15000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000004',
    'INC_BUSINESS',
    'MONTHLY',
    '2025-01',
    2000000,
    'SURVEY'
),
-- EXPENSE
(
    '0195a1a2-0001-7000-bb34-000000000004',
    'EXP_LIVING',
    'MONTHLY',
    '2025-01',
    5000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000004',
    'EXP_UTILITIES',
    'MONTHLY',
    '2025-01',
    1500000,
    'SURVEY'
),
-- EXISTING DEBT (SLIK/Bureau)
(
    '0195a1a2-0001-7000-bb34-000000000004',
    'DEBT_INSTALLMENT',
    'MONTHLY',
    '2025-01',
    1000000,
    'BUREAU'
);
-- BUDI
-- INCOME
(
    '0195a1a2-0001-7000-bb34-000000000005',
    'INC_SALARY',
    'MONTHLY',
    '2025-01',
    15000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000005',
    'INC_BUSINESS',
    'MONTHLY',
    '2025-01',
    2000000,
    'SURVEY'
),
-- EXPENSE
(
    '0195a1a2-0001-7000-bb34-000000000005',
    'EXP_LIVING',
    'MONTHLY',
    '2025-01',
    5000000,
    'SURVEY'
),
(
    '0195a1a2-0001-7000-bb34-000000000005',
    'EXP_UTILITIES',
    'MONTHLY',
    '2025-01',
    1500000,
    'SURVEY'
),
-- EXISTING DEBT (SLIK/Bureau)
(
    '0195a1a2-0001-7000-bb34-000000000005',
    'DEBT_INSTALLMENT',
    'MONTHLY',
    '2025-01',
    1000000,
    'BUREAU'
);
-- 9. STATUS LOGS (Realistic history)
INSERT INTO application_status_logs (
        application_id,
        from_status,
        to_status,
        change_reason,
        changed_at
    )
VALUES -- Budi Santoso (History dari INTAKE -> SURVEY -> ANALYSIS)
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        NULL,
        'INTAKE',
        'Pendaftaran baru via CRM',
        CURRENT_TIMESTAMP - interval '2 days 5 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'INTAKE',
        'SURVEY',
        'Dokumen lengkap, lanjut survey lapangan',
        CURRENT_TIMESTAMP - interval '2 days 1 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'SURVEY',
        'ANALYSIS',
        'Survey selesai, masuk tahap analisa kredit',
        CURRENT_TIMESTAMP - interval '1 days 20 hours'
    ),
    -- Rina Wijaya (Baru INTAKE)
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Walk-in',
        CURRENT_TIMESTAMP - interval '2 hours'
    ),
    -- Agus Prayogo (Sampai SURVEY)
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Mobile App',
        CURRENT_TIMESTAMP - interval '1 days 10 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        'INTAKE',
        'SURVEY',
        'Verifikasi telepon berhasil, lanjut survey',
        CURRENT_TIMESTAMP - interval '1 days 2 hours'
    ),
    -- Dewi Lestari (Baru INTAKE)
    (
        '0195a1a2-0001-7000-bb34-000000000004',
        NULL,
        'INTAKE',
        'Aplikasi masuk via Website',
        CURRENT_TIMESTAMP - interval '5 hours'
    ),
    -- Bambang Heru (Sampai ANALYSIS)
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Cabang',
        CURRENT_TIMESTAMP - interval '4 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        'INTAKE',
        'SURVEY',
        'Dokumen terverifikasi',
        CURRENT_TIMESTAMP - interval '3 days 20 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        'SURVEY',
        'ANALYSIS',
        'Data finansial sudah lengkap',
        CURRENT_TIMESTAMP - interval '3 days'
    );