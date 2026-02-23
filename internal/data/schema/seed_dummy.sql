-- ============================================================
-- FULL INTEGRATED SEED DATA (PRODUCTION-LIKE)
-- Includes all 8 Categories and 74 Attributes via EAV
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
TRUNCATE TABLE custom_column_attribute_registries CASCADE; 
TRUNCATE TABLE applicant_attributes CASCADE;
TRUNCATE TABLE applicants CASCADE;


-- 2. MASTER REFERENCE DATA
INSERT INTO branches (branch_code, branch_name, region_code) VALUES
('JKT01', 'Jakarta Pusat Utama', 'REG01'),
('JKT02', 'Jakarta Selatan Prima', 'REG01'),
('SUB01', 'Surabaya Basuki Rahmat', 'REG03');

INSERT INTO loan_products (id, product_code, product_name, segment, active) VALUES
('p001', 'KUR_MIKRO', 'KUR Mikro Pemerintah', 'UMKM', true),
('p002', 'KMG_KARYAWAN', 'Kredit Multi Guna Karyawan', 'RETAIL', true);

INSERT INTO loan_officers (id, officer_code, branch_code) VALUES
('u001', 'AO_BUDI', 'JKT01'),
('u002', 'AO_SITI', 'JKT02');

INSERT INTO financial_gl_accounts (gl_code, gl_name, statement_type, category, sign, is_debt_service, is_operating) VALUES
('INC001', 'Gaji Pokok', 'PL', 'REVENUE', 1, false, true),
('EXP001', 'Biaya Rumah Tangga', 'PL', 'EXPENSE', -1, false, true),
('LIA001', 'Angsuran Bank Lain', 'BS', 'LIABILITY', -1, true, false);

-- 3. LOAD REGISTRY (Full 8 Categories)
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, category, is_required, risk_relevant, description) VALUES

-- 1. Identitas (Core fields like Nama, NIK, Tgl Lahir are usually in CORE table but we keep registry for labeling)
('tempat_lahir', 'PERSONAL', 'APPLICANT', 'STRING', '1. Identitas', true, false, 'Tempat Lahir'),
('jenis_kelamin', 'PERSONAL', 'APPLICANT', 'STRING', '1. Identitas', true, false, 'Jenis Kelamin'),
('kewarganegaraan', 'PERSONAL', 'APPLICANT', 'STRING', '1. Identitas', true, false, 'Kewarganegaraan'),
('status_perkawinan', 'PERSONAL', 'APPLICANT', 'STRING', '1. Identitas', true, true, 'Status Perkawinan'),
('nama_ibu_kandung', 'PERSONAL', 'APPLICANT', 'STRING', '1. Identitas', true, true, 'Nama Ibu Kandung'),

-- 2. Pasangan (Optional)
('pasangan_nama_lengkap', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'Nama Lengkap Pasangan'),
('pasangan_nik', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, true, 'NIK Pasangan'),
('pasangan_tempat_lahir', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'Tempat Lahir Pasangan'),
('pasangan_tanggal_lahir', 'BOTH', 'APPLICANT', 'DATE', '2. Pasangan', false, false, 'Tanggal Lahir Pasangan'),
('pasangan_jenis_kelamin', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'Jenis Kelamin Pasangan'),
('pasangan_kewarganegaraan', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'Kewarganegaraan Pasangan'),
('pasangan_nama_ibu_kandung', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'Nama Ibu Kandung Pasangan'),
('pasangan_npwp', 'BOTH', 'APPLICANT', 'STRING', '2. Pasangan', false, false, 'NPWP Pasangan'),
('pasangan_perkawinan_ke', 'BOTH', 'APPLICANT', 'NUMBER', '2. Pasangan', false, false, 'Perkawinan Ke'),

-- 3. Kontak & Alamat
('no_hp_utama', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', true, true, 'No HP Utama'),
('no_hp_alternatif', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'No HP Alternatif'),
('email_pribadi', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', true, false, 'Email'),
('alamat_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Alamat sesuai KTP'),
('kelurahan_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kelurahan sesuai KTP'),
('kecamatan_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kecamatan sesuai KTP'),
('kota_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kota sesuai KTP'),
('provinsi_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Provinsi sesuai KTP'),
('kode_pos_ktp', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kode Pos sesuai KTP'),
('alamat_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', true, true, 'Alamat sesuai Domisili'),
('kelurahan_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kelurahan sesuai Domisili'),
('kecamatan_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kecamatan sesuai Domisili'),
('kota_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kota sesuai Domisili'),
('provinsi_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Provinsi sesuai Domisili'),
('kode_pos_domisili', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, false, 'Kode Pos sesuai Domisili'),
('lama_tinggal_tahun', 'BOTH', 'APPLICANT', 'NUMBER', '3. Kontak & Alamat', false, false, 'Lama tinggal di alamat ini'),
('status_kepemilikan_rumah', 'BOTH', 'APPLICANT', 'STRING', '3. Kontak & Alamat', false, true, 'Status kepemilikan rumah'),
('jarak_ke_cabang', 'BOTH', 'APPLICANT', 'NUMBER', '3. Kontak & Alamat', false, false, 'Perkiraan jarak kantor cabang'),

-- 4. Profil Rumah Tangga (Optional)
('jumlah_tanggungan', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, true, 'Jumlah tanggungan'),
('jumlah_anggota_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, false, 'Jumlah anggota rumah tangga'),
('jumlah_anggota_rt_berpenghasilan', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, false, 'Jumlah anggota rumah tangga berpenghasilan'),
('jumlah_anggota_rt_berhutang', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, true, 'Jumlah anggota rumah tangga berhutang'),
('pasangan_pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', '4. Profil Rumah Tangga', false, false, 'Status pekerjaan pasangan'),
('pasangan_penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, true, 'Penghasilan pasangan'),
('total_penghasilan_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, true, 'Total penghasilan rumah tangga'),
('total_pengeluaran_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', '4. Profil Rumah Tangga', false, true, 'Total pengeluaran rumah tangga'),

-- 5. Pendidikan & Sosial
('pendidikan_terakhir', 'PERSONAL', 'APPLICANT', 'STRING', '5. Pendidikan & Sosial', false, false, 'Pendidikan terakhir'),
('jurusan_pendidikan', 'PERSONAL', 'APPLICANT', 'STRING', '5. Pendidikan & Sosial', false, false, 'Jurusan pendidikan'),
('sertifikasi_profesi', 'PERSONAL', 'APPLICANT', 'STRING', '5. Pendidikan & Sosial', false, false, 'Sertifikasi profesi'),
('peran_sosial', 'PERSONAL', 'APPLICANT', 'STRING', '5. Pendidikan & Sosial', false, false, 'Peran sosial di masyarakat'),
('dikenal_lingkungan_sekitar', 'PERSONAL', 'APPLICANT', 'BOOLEAN', '5. Pendidikan & Sosial', false, false, 'Apakah dikenal lingkungan setempat'),

-- 6. Pekerjaan
('pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, true, 'Status pekerjaan'),
('pekerjaan_nama_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Nama perusahaan'),
('pekerjaan_industri', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Industri perusahaan'),
('pekerjaan_alamat', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Alamat tempat kerja'),
('pekerjaan_jabatan', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Jabatan'),
('pekerjaan_lama_bekerja', 'PERSONAL', 'APPLICANT', 'NUMBER', '6. Pekerjaan', false, false, 'Lama bekerja (Tahun)'),
('pekerjaan_telp_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'No telp perusahaan'),
('pekerjaan_gaji_bersih', 'PERSONAL', 'APPLICANT', 'NUMBER', '6. Pekerjaan', false, true, 'Gaji bersih bulanan'),
('pekerjaan_penghasilan_lain', 'PERSONAL', 'APPLICANT', 'NUMBER', '6. Pekerjaan', false, false, 'Penghasilan lain rutin'),
('pekerjaan_metode_pembayaran', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Metode pembayaran gaji (bulanan/2 minggu)'),
('pekerjaan_status_verifikasi', 'PERSONAL', 'APPLICANT', 'STRING', '6. Pekerjaan', false, false, 'Status verifikasi pekerjaan'),

-- 7. Usaha
('usaha_nama', 'PERSONAL', 'APPLICANT', 'STRING', '7. Usaha', false, false, 'Nama usaha'),
('usaha_jenis', 'PERSONAL', 'APPLICANT', 'STRING', '7. Usaha', false, false, 'Jenis usaha'),
('usaha_sektor', 'PERSONAL', 'APPLICANT', 'STRING', '7. Usaha', false, false, 'Sektor usaha'),
('usaha_lama_berusaha', 'PERSONAL', 'APPLICANT', 'NUMBER', '7. Usaha', false, false, 'lama berusaha (Tahun)'),
('usaha_alamat', 'PERSONAL', 'APPLICANT', 'STRING', '7. Usaha', false, false, 'Alamat usaha'),
('usaha_status_kepemilikan_tempat', 'PERSONAL', 'APPLICANT', 'STRING', '7. Usaha', false, false, 'Status kepemilikan tempat usaha'),
('usaha_jumlah_karyawan', 'PERSONAL', 'APPLICANT', 'NUMBER', '7. Usaha', false, false, 'Jumlah karyawan'),
('usaha_penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', '7. Usaha', false, true, 'Penghasilan bulanan'),

-- 8. Karakter & Perilaku
('karakter_disiplin_bayar', 'BOTH', 'APPLICANT', 'STRING', '8. Karakter & Perilaku', false, true, 'Persepsi kedisipinan bayar'),
('karakter_riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', '8. Karakter & Perilaku', false, true, 'Riwayat gagal bayar (internal)'),
('karakter_frekuensi_pindah_kerja', 'PERSONAL', 'APPLICANT', 'NUMBER', '8. Karakter & Perilaku', false, true, 'Frekuensi pindah kerja'),
('karakter_frekuensi_pindah_alamat', 'BOTH', 'APPLICANT', 'NUMBER', '8. Karakter & Perilaku', false, true, 'Frekuensi pindah alamat'),
('karakter_gaya_hidup_mewah', 'BOTH', 'APPLICANT', 'BOOLEAN', '8. Karakter & Perilaku', false, true, 'Indikasi gaya hidup lebih besar dari penghasilan'),
('karakter_indikasi_fraud', 'BOTH', 'APPLICANT', 'BOOLEAN', '8. Karakter & Perilaku', false, true, 'Indikasi fraud');


-- 4. ENTITY: APPLICANTS (CORE fields only)
INSERT INTO applicants (
    id, applicant_type, identity_number, tax_id, full_name, birth_date
) VALUES
('11111111-1111-1111-1111-111111111111', 'personal', '3171010101900001', '01.234.567.8', 'Budi Santoso', '1990-05-15'),
('22222222-2222-2222-2222-222222222222', 'personal', '3273012008920005', '02.345.678.9', 'Rina Wijaya', '1992-08-20'),
('33333333-3333-3333-3333-333333333333', 'personal', '3172021012850002', '03.456.789.0', 'Agus Prayogo', '1985-12-10');

-- 5. VALUE: FULL 8 CATEGORIES ATTRIBUTES (EAV)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES
-- Budi Santoso
('11111111-1111-1111-1111-111111111111', 'tempat_lahir', 'Jakarta', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'jenis_kelamin', 'LAKI-LAKI', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'kewarganegaraan', 'WNI', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'status_perkawinan', 'MENIKAH', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'nama_ibu_kandung', 'Siti Aminah', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'no_hp_utama', '08123456789', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'email_pribadi', 'budi.s@email.com', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'pekerjaan_status', 'KARYAWAN TETAP', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'pekerjaan_gaji_bersih', '15000000', 'NUMBER'),

-- Rina Wijaya
('22222222-2222-2222-2222-222222222222', 'tempat_lahir', 'Bandung', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'no_hp_utama', '08134455667', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'email_pribadi', 'rina.w@email.com', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'karakter_riwayat_gagal_bayar', 'false', 'BOOLEAN'),

-- Agus Prayogo
('33333333-3333-3333-3333-333333333333', 'tempat_lahir', 'Semarang', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'status_perkawinan', 'MENIKAH', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'no_hp_utama', '081299887766', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'email_pribadi', 'agus.prayogo@email.com', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'alamat_domisili', 'Jl. Melati No. 123, Jakarta Barat', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'pekerjaan_status', 'KARYAWAN TETAP', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'pekerjaan_nama_perusahaan', 'PT Teknologi Maju Jaya', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'pekerjaan_gaji_bersih', '12500000', 'NUMBER'),
('33333333-3333-3333-3333-333333333333', 'karakter_disiplin_bayar', 'SANGAT DISIPLIN', 'STRING');

-- 6. APPLICATIONS
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, status, branch_code, submitted_at) VALUES
('APP-001', '11111111-1111-1111-1111-111111111111', 'p002', 'u001', 75000000, 36, 'ANALYSIS', 'JKT01', CURRENT_TIMESTAMP - interval '2 days'),
('APP-002', '22222222-2222-2222-2222-222222222222', 'p001', 'u001', 25000000, 12, 'INTAKE', 'JKT01', CURRENT_TIMESTAMP);

-- 7. FINANCIAL DATA
INSERT INTO application_financial_facts (application_id, gl_code, period_type, amount, source) VALUES
('APP-001', 'INC001', 'MONTHLY', 15000000, 'SYSTEM');

-- 8. STATUS LOGS
INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('APP-001', 'INTAKE', 'SURVEY', 'Dokumen awal valid');