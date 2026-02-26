-- ============================================================
-- FULL INTEGRATED SEED DATA (PRODUCTION-LIKE) TEST EDIT 2
-- Format: COMPACT / MULTI-ROW INSERT (100% Original Data)
-- ============================================================
-- 1. CLEAN UP
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
TRUNCATE TABLE attribute_options CASCADE;
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
-- 3. ATTRIBUTE CATEGORIES & REGISTRIES
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
VALUES (
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
        'SELECT',
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
        'SELECT',
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
        'SELECT',
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
    (
        'pendidikan_terakhir',
        'PERSONAL',
        'APPLICANT',
        'SELECT',
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
    (
        'pekerjaan_status',
        'PERSONAL',
        'APPLICANT',
        'SELECT',
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
        'BOTH',
        'APPLICANT',
        'SELECT',
        'usaha',
        'Sektor Usaha',
        false,
        false,
        'Sektor usaha'
    ),
    (
        'usaha_lama_berusaha',
        'BOTH',
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
        'BOTH',
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
        'BOTH',
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
        'BOTH',
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
        'BOTH',
        'APPLICANT',
        'NUMBER',
        'usaha',
        'Penghasilan Bulanan Usaha (Rp)',
        false,
        true,
        'Penghasilan bulanan'
    ),
    (
        'bentuk_badan_usaha',
        'CORPORATE',
        'APPLICANT',
        'SELECT',
        'identitas',
        'Bentuk Badan Usaha',
        true,
        false,
        'PT, CV, dll'
    ),
    (
        'nib_number',
        'CORPORATE',
        'APPLICANT',
        'STRING',
        'identitas',
        'Nomor NIB',
        true,
        true,
        'Nomor Induk Berusaha'
    ),
    (
        'tanggal_pengesahan_menkumham',
        'CORPORATE',
        'APPLICANT',
        'DATE',
        'identitas',
        'Tgl Pengesahan Menkumham',
        false,
        false,
        'Tanggal pengesahan legalitas'
    ),
    (
        'karakter_disiplin_bayar',
        'BOTH',
        'APPLICANT',
        'SELECT',
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
        'PERSONAL',
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
INSERT INTO attribute_options (
        attribute_code,
        option_value,
        option_label,
        display_order
    )
VALUES ('jenis_kelamin', 'LAKI-LAKI', 'Laki-laki', 1),
    ('jenis_kelamin', 'PEREMPUAN', 'Perempuan', 2),
    (
        'status_perkawinan',
        'BELUM_MENIKAH',
        'Belum Menikah',
        1
    ),
    ('status_perkawinan', 'MENIKAH', 'Menikah', 2),
    (
        'status_perkawinan',
        'DUDA_JANDA',
        'Duda / Janda',
        3
    ),
    (
        'status_kepemilikan_rumah',
        'MILIK_SENDIRI',
        'Milik Sendiri',
        1
    ),
    (
        'status_kepemilikan_rumah',
        'MILIK_KELUARGA',
        'Milik Keluarga',
        2
    ),
    (
        'status_kepemilikan_rumah',
        'SEWA_KONTRAK',
        'Sewa / Kontrak',
        3
    ),
    (
        'status_kepemilikan_rumah',
        'DINAS',
        'Rumah Dinas',
        4
    ),
    ('pendidikan_terakhir', 'SD', 'SD', 1),
    ('pendidikan_terakhir', 'SMP', 'SMP', 2),
    ('pendidikan_terakhir', 'SMA', 'SMA / SMK', 3),
    ('pendidikan_terakhir', 'D3', 'Diploma (D3)', 4),
    ('pendidikan_terakhir', 'S1', 'Sarjana (S1)', 5),
    (
        'pendidikan_terakhir',
        'S2_S3',
        'Pascasarjana (S2/S3)',
        6
    ),
    ('pekerjaan_status', 'TETAP', 'Karyawan Tetap', 1),
    (
        'pekerjaan_status',
        'KONTRAK',
        'Karyawan Kontrak',
        2
    ),
    (
        'pekerjaan_status',
        'OUTSOURCING',
        'Outsourcing',
        3
    ),
    ('pekerjaan_status', 'HONORER', 'Honorer', 4),
    (
        'pekerjaan_status',
        'PROFESIONAL',
        'Profesional / Freelance',
        5
    ),
    (
        'usaha_sektor',
        'PERDAGANGAN',
        'Perdagangan / Ritel',
        1
    ),
    ('usaha_sektor', 'JASA', 'Jasa', 2),
    ('usaha_sektor', 'MANUFAKTUR', 'Manufaktur', 3),
    (
        'usaha_sektor',
        'PERTANIAN',
        'Pertanian / Peternakan',
        4
    ),
    (
        'usaha_sektor',
        'KULINER',
        'Makanan & Minuman',
        5
    ),
    (
        'usaha_sektor',
        'TEKNOLOGI',
        'Teknologi & Informasi',
        6
    ),
    (
        'bentuk_badan_usaha',
        'PT',
        'Perseroan Terbatas (PT)',
        1
    ),
    (
        'bentuk_badan_usaha',
        'CV',
        'Persekutuan Komanditer (CV)',
        2
    ),
    (
        'bentuk_badan_usaha',
        'UD',
        'Usaha Dagang (UD)',
        3
    ),
    ('bentuk_badan_usaha', 'KOPERASI', 'Koperasi', 4),
    (
        'karakter_disiplin_bayar',
        'SANGAT_DISIPLIN',
        'Sangat Disiplin',
        1
    ),
    (
        'karakter_disiplin_bayar',
        'DISIPLIN',
        'Disiplin',
        2
    ),
    (
        'karakter_disiplin_bayar',
        'KURANG_DISIPLIN',
        'Kurang Disiplin',
        3
    ),
    (
        'karakter_disiplin_bayar',
        'TIDAK_DISIPLIN',
        'Tidak Disiplin / Macet',
        4
    );
-- 4. ENTITY: APPLICANTS
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
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'company',
        '8120101234567',
        '012345678091000',
        'PT Maju Bersama',
        '2015-08-17'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        'company',
        '9120202345678',
        '023456789092000',
        'CV Karya Mandiri',
        '2018-03-10'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        'company',
        '7120303456789',
        '034567890093000',
        'PT Teknologi Nusantara',
        '2020-11-01'
    );
-- 5. ENTITY: APPLICATIONS
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
-- 6. VALUE: FULL 8 CATEGORIES ATTRIBUTES (EAV)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type)
VALUES (
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
        'MILIK_SENDIRI',
        'STRING'
    ),
    (
        '0195383f-427c-7000-bb34-317101010190',
        'jarak_ke_cabang',
        '5',
        'NUMBER'
    ),
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
    (
        '0195383f-427c-7000-bb34-317101010190',
        'pekerjaan_status',
        'TETAP',
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
        'PERDAGANGAN',
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
    (
        '0195383f-427c-7000-bb34-317101010190',
        'karakter_disiplin_bayar',
        'SANGAT_DISIPLIN',
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
    ),
    -- RINA WIJAYA (0195383f-427d-7000-bb34-327301200892)
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
        'BELUM_MENIKAH',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        'nama_ibu_kandung',
        'Ratna Sari',
        'STRING'
    ),
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
        'SEWA_KONTRAK',
        'STRING'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        'jarak_ke_cabang',
        '3',
        'NUMBER'
    ),
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
    (
        '0195383f-427d-7000-bb34-327301200892',
        'pekerjaan_status',
        'TETAP',
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
        'PERDAGANGAN',
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
        '2000000',
        'NUMBER'
    ),
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
        '0',
        'NUMBER'
    ),
    (
        '0195383f-427d-7000-bb34-327301200892',
        'karakter_frekuensi_pindah_alamat',
        '0',
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
    ),
    -- AGUS PRAYOGO (0195383f-427e-7000-bb34-317202101285)
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
    (
        '0195383f-427e-7000-bb34-317202101285',
        'pekerjaan_status',
        'TETAP',
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
    (
        '0195383f-427e-7000-bb34-317202101285',
        'karakter_disiplin_bayar',
        'SANGAT_DISIPLIN',
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
    ),
    -- DEWI LESTARI (0195383f-427f-7000-bb34-320101440595)
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
    ),
    -- BAMBANG HERU (0195383f-4280-7000-bb34-337402121288)
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
    ),
    -- PT MAJU BERSAMA (0195383f-4281-7000-bb34-812010123456)
    (
        '0195383f-4281-7000-bb34-812010123456',
        'bentuk_badan_usaha',
        'PT',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'nib_number',
        '8120101234567',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'usaha_sektor',
        'MANUFAKTUR',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'usaha_lama_berusaha',
        '9',
        'NUMBER'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'usaha_jumlah_karyawan',
        '150',
        'NUMBER'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'no_hp_utama',
        '0215556677',
        'STRING'
    ),
    (
        '0195383f-4281-7000-bb34-812010123456',
        'email_pribadi',
        'info@majubersama.co.id',
        'STRING'
    ),
    -- CV KARYA MANDIRI (0195383f-4282-7000-bb34-912020234567)
    (
        '0195383f-4282-7000-bb34-912020234567',
        'bentuk_badan_usaha',
        'CV',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        'nib_number',
        '9120202345678',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        'usaha_sektor',
        'PERDAGANGAN',
        'STRING'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        'usaha_lama_berusaha',
        '6',
        'NUMBER'
    ),
    (
        '0195383f-4282-7000-bb34-912020234567',
        'usaha_jumlah_karyawan',
        '25',
        'NUMBER'
    ),
    -- PT TEKNOLOGI NUSANTARA (0195383f-4283-7000-bb34-712030345678)
    (
        '0195383f-4283-7000-bb34-712030345678',
        'bentuk_badan_usaha',
        'PT',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        'nib_number',
        '7120303456789',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        'usaha_sektor',
        'TEKNOLOGI',
        'STRING'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        'usaha_lama_berusaha',
        '4',
        'NUMBER'
    ),
    (
        '0195383f-4283-7000-bb34-712030345678',
        'usaha_jumlah_karyawan',
        '40',
        'NUMBER'
    );
-- 7. FINANCIAL DATA
INSERT INTO application_financial_facts (
        application_id,
        gl_code,
        period_type,
        period_label,
        amount,
        source
    )
VALUES (
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
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    ),
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
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    ),
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
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    ),
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
    (
        '0195a1a2-0001-7000-bb34-000000000004',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    ),
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
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        'DEBT_INSTALLMENT',
        'MONTHLY',
        '2025-01',
        1000000,
        'BUREAU'
    );
-- 8. STATUS LOGS
INSERT INTO application_status_logs (
        application_id,
        from_status,
        to_status,
        change_reason,
        changed_at
    )
VALUES (
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
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Walk-in',
        CURRENT_TIMESTAMP - interval '2 hours'
    ),
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
    (
        '0195a1a2-0001-7000-bb34-000000000004',
        NULL,
        'INTAKE',
        'Aplikasi masuk via Website',
        CURRENT_TIMESTAMP - interval '5 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Cabang',
        CURRENT_TIMESTAMP - interval '4 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        'SURVEY',
        'ANALYSIS',
        'Data finansial sudah lengkap',
        CURRENT_TIMESTAMP - interval '3 days'
    );
-- 9. STATUS REFERENCES & FLOWS
INSERT INTO application_status_refs (
        status_code,
        status_group,
        is_terminal,
        description
    )
VALUES ('INTAKE', 'INTAKE', false, 'Input data awal'),
    (
        'SURVEY',
        'SURVEY',
        false,
        'Survey lapangan/desk survey'
    ),
    (
        'ANALYSIS',
        'ANALYSIS',
        false,
        'Analisa kelayakan kredit'
    ),
    (
        'COMMITTEE',
        'DECISION',
        false,
        'Sidang komite kredit'
    ),
    ('APPROVED', 'TERMINAL', true, 'Disetujui'),
    ('REJECTED', 'TERMINAL', true, 'Ditolak'),
    ('CANCELLED', 'TERMINAL', true, 'Dibatalkan');
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
-- 10. PARTIES (Spouse, Guarantor, etc)
INSERT INTO parties (id, party_type, identifier, name, date_of_birth)
VALUES (
        '0195a1a2-0002-7000-bb34-000000000001',
        'PERSON',
        '3171010101920002',
        'Ani Wijaya',
        '1992-03-10'
    ),
    (
        '0195a1a2-0002-7000-bb34-000000000002',
        'PERSON',
        '3171010101950005',
        'Slamet Utomo',
        '1975-10-20'
    );
INSERT INTO application_parties (
        application_id,
        party_id,
        role_code,
        legal_obligation,
        slik_required
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195a1a2-0002-7000-bb34-000000000001',
        'SPOUSE',
        true,
        true
    );
-- 11. SURVEY TEMPLATES & QUESTIONS
INSERT INTO survey_templates (
        id,
        template_code,
        template_name,
        applicant_type,
        product_id,
        active
    )
VALUES (
        '0195a1a2-0003-7000-bb34-000000000001',
        'SURVEY_RETAIL',
        'Template Survey Retail',
        'personal',
        '0195b1b2-0001-7000-bb34-000000000002',
        true
    );
INSERT INTO survey_sections (
        id,
        template_id,
        section_code,
        section_name,
        sequence
    )
VALUES (
        '0195a1a2-0003-7001-bb34-000000000001',
        '0195a1a2-0003-7000-bb34-000000000001',
        'SEC_IDENTITY',
        'Verifikasi Identitas',
        1
    ),
    (
        '0195a1a2-0003-7001-bb34-000000000002',
        '0195a1a2-0003-7000-bb34-000000000001',
        'SEC_BUSINESS',
        'Kondisi Usaha',
        2
    );
INSERT INTO survey_questions (
        id,
        section_id,
        question_code,
        question_text,
        answer_type,
        is_mandatory,
        risk_relevant,
        sequence
    )
VALUES (
        '0195a1a2-0003-7002-bb34-000000000001',
        '0195a1a2-0003-7001-bb34-000000000001',
        'Q_HOME_OWNER',
        'Apakah benar rumah milik sendiri?',
        'BOOLEAN',
        true,
        true,
        1
    ),
    (
        '0195a1a2-0003-7002-bb34-000000000002',
        '0195a1a2-0003-7001-bb34-000000000002',
        'Q_BUSINESS_YEARS',
        'Sudah berapa lama usaha berjalan?',
        'NUMBER',
        true,
        true,
        1
    );
INSERT INTO application_surveys (
        id,
        application_id,
        template_id,
        survey_type,
        status,
        submitted_at
    )
VALUES (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195a1a2-0003-7000-bb34-000000000001',
        'FIELD',
        'SUBMITTED',
        CURRENT_TIMESTAMP - interval '2 days'
    );
INSERT INTO survey_answers (
        survey_id,
        question_id,
        answer_boolean,
        answer_number
    )
VALUES (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0003-7002-bb34-000000000001',
        true,
        NULL
    ),
    (
        '0195a1a2-0003-7003-bb34-000000000001',
        '0195a1a2-0003-7002-bb34-000000000002',
        NULL,
        5
    );
-- 12. ASSETS & LIABILITIES
INSERT INTO asset_types (asset_type_code, asset_category, description)
VALUES (
        'LAND_BUILDING',
        'PROPERTY',
        'Tanah dan Bangunan'
    ),
    ('VEHICLE_CAR', 'VEHICLE', 'Kendaraan Roda 4');
INSERT INTO application_assets (
        application_id,
        asset_type_code,
        asset_name,
        ownership_status,
        estimated_value
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        'LAND_BUILDING',
        'Rumah Tinggal Kebon Jeruk',
        'OWNED',
        1500000000
    );
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
-- 13. COMMITTEE & DECISIONS
INSERT INTO application_committee_sessions (
        id,
        application_id,
        session_sequence,
        status,
        scheduled_at
    )
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0001-7000-bb34-000000000001',
        1,
        'COMPLETED',
        CURRENT_TIMESTAMP - interval '1 days'
    );
INSERT INTO credit_committee_members (committee_session_id, user_id, role)
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000001',
        'CHAIR'
    ),
    (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000002',
        'MEMBER'
    );
INSERT INTO application_committee_votes (committee_session_id, user_id, vote, vote_reason)
VALUES (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000001',
        'APPROVE',
        'Kapasitas bayar memadai'
    ),
    (
        '0195a1a2-0004-7000-bb34-000000000001',
        '0195a1a2-0005-7000-bb34-000000000002',
        'APPROVE',
        'Aset jaminan solid'
    );
-- 14. DOCUMENTS
INSERT INTO application_documents (
        application_id,
        document_name,
        file_url,
        document_type
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        'KTP_Budi.pdf',
        'https://storage.cloud/docs/ktp_budi.pdf',
        'KTP'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'NPWP_Budi.pdf',
        'https://storage.cloud/docs/npwp_budi.pdf',
        'NPWP'
    );