-- ============================================================
-- FULL INTEGRATED SEED DATA (STRICT SCHEMA & 8 CATEGORIES EAV)
-- ============================================================

-- Pastikan extension UUID aktif
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CLEAN UP (TRUNCATE ALL)
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

-- 3. CUSTOM ATTRIBUTES REGISTRY (Pendaftaran Kunci EAV 8 Kategori)
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
('tempat_lahir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Tempat Lahir Sesuai KTP'),
('jenis_kelamin', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis Kelamin'),
('kewarganegaraan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'WNI / WNA'),
('status_perkawinan', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Perkawinan'),
('nama_ibu_kandung', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Nama Ibu Kandung Lengkap'),
('pasangan_nama', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama Lengkap Pasangan'),
('pasangan_nik', 'PERSONAL', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('no_hp_utama', 'BOTH', 'APPLICANT', 'STRING', true, 'Nomor HP Utama'),
('alamat_domisili', 'BOTH', 'APPLICANT', 'STRING', true, 'Alamat Domisili Sekarang'),
('status_kepemilikan_rumah', 'BOTH', 'APPLICANT', 'STRING', true, 'Status Kepemilikan Rumah'),
('jumlah_tanggungan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Jumlah Tanggungan Keluarga'),
('pendidikan_terakhir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Pendidikan Terakhir'),
('status_pekerjaan', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Pekerjaan Saat Ini'),
('nama_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama Perusahaan Tempat Bekerja'),
('gaji_bersih_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Take Home Pay'),
('nama_usaha', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama Usaha (Jika Wiraswasta)'),
('penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Omzet / Penghasilan Usaha'),
('indikasi_fraud', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Flagging Fraud Internal'),
('riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat NPL / Gagal Bayar');

-- 4. ENTITY: APPLICANTS (Data Pokok Statis dengan UUID Hardcoded agar mudah direlasikan)
INSERT INTO applicants (
    id, applicant_type, identity_number, tax_id, full_name, birth_date, created_at, created_by
) VALUES
('11111111-1111-1111-1111-111111111111', 'PERSONAL', '3171010101900001', '01.234.567.8', 'Budi Santoso', '1990-05-15', CURRENT_TIMESTAMP, 'u001'::uuid),
('22222222-2222-2222-2222-222222222222', 'PERSONAL', '3273012008920005', '02.345.678.9', 'Rina Wijaya', '1992-08-20', CURRENT_TIMESTAMP, 'u001'::uuid),
('33333333-3333-3333-3333-333333333333', 'PERSONAL', '3578011012850001', '03.456.789.0', 'Agus Prayogo', '1985-12-10', CURRENT_TIMESTAMP, 'u002'::uuid);

-- 5. VALUE: APPLICANT ATTRIBUTES (Integrasi 8 Kategori EAV)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES

-- ==========================================
-- APPLICANT 1: BUDI SANTOSO (KARYAWAN)
-- ==========================================
-- 1. Identitas
('11111111-1111-1111-1111-111111111111', 'tempat_lahir', 'Jakarta', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'jenis_kelamin', 'Laki-laki', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'kewarganegaraan', 'WNI', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'status_perkawinan', 'Menikah', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'nama_ibu_kandung', 'Siti Aminah', 'STRING'),
-- 2. Pasangan
('11111111-1111-1111-1111-111111111111', 'pasangan_nama', 'Ani Lestari', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'pasangan_nik', '3171014102930005', 'STRING'),
-- 3. Kontak & Alamat
('11111111-1111-1111-1111-111111111111', 'no_hp_utama', '08123456789', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'alamat_domisili', 'Jl. Merdeka No. 10, Gambir', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'status_kepemilikan_rumah', 'Milik Sendiri', 'STRING'),
-- 4. Profil Rumah Tangga
('11111111-1111-1111-1111-111111111111', 'jumlah_tanggungan', '2', 'NUMBER'),
-- 5. Pendidikan
('11111111-1111-1111-1111-111111111111', 'pendidikan_terakhir', 'S1', 'STRING'),
-- 6. Pekerjaan
('11111111-1111-1111-1111-111111111111', 'status_pekerjaan', 'Karyawan Swasta', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'nama_perusahaan', 'PT Teknologi Maju', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'gaji_bersih_bulanan', '15000000', 'NUMBER'),
-- 8. Karakter & Perilaku
('11111111-1111-1111-1111-111111111111', 'indikasi_fraud', 'false', 'BOOLEAN'),
('11111111-1111-1111-1111-111111111111', 'riwayat_gagal_bayar', 'false', 'BOOLEAN'),

-- ==========================================
-- APPLICANT 2: RINA WIJAYA (WIRASWASTA)
-- ==========================================
('22222222-2222-2222-2222-222222222222', 'tempat_lahir', 'Bandung', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'status_perkawinan', 'Menikah', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'pasangan_nama', 'Hendra Gunawan', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'no_hp_utama', '08134455667', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'alamat_domisili', 'Perum Dago Asri B-12', 'STRING'),
-- 7. Usaha
('22222222-2222-2222-2222-222222222222', 'status_pekerjaan', 'Wiraswasta', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'nama_usaha', 'Kedai Kopi Rina', 'STRING'),
('22222222-2222-2222-2222-222222222222', 'penghasilan_bulanan', '25000000', 'NUMBER'),

-- ==========================================
-- APPLICANT 3: AGUS PRAYOGO (SINGLE, PROFESIONAL)
-- ==========================================
('33333333-3333-3333-3333-333333333333', 'tempat_lahir', 'Surabaya', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'status_perkawinan', 'Belum Menikah', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'status_pekerjaan', 'Profesional / Dokter', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'nama_perusahaan', 'RS Medika Surabaya', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'gaji_bersih_bulanan', '50000000', 'NUMBER'),
('33333333-3333-3333-3333-333333333333', 'indikasi_fraud', 'false', 'BOOLEAN');

-- 6. APPLICATIONS (Menggunakan UUID yang sama)
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, status, branch_code, submitted_at) VALUES
('APP-001', '11111111-1111-1111-1111-111111111111', 'p002', 'u001', 75000000, 36, 'ANALYSIS', 'JKT01', CURRENT_TIMESTAMP - interval '2 days'),
('APP-002', '22222222-2222-2222-2222-222222222222', 'p001', 'u001', 25000000, 12, 'INTAKE', 'JKT01', CURRENT_TIMESTAMP);

-- 7. FINANCIAL DATA
INSERT INTO application_financial_facts (application_id, gl_code, period_type, amount, source) VALUES
('APP-001', 'INC001', 'MONTHLY', 15000000, 'SYSTEM'),
('APP-001', 'EXP001', 'MONTHLY', 5000000, 'SURVEY');

-- 8. STATUS LOGS
INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('APP-001', 'INTAKE', 'SURVEY', 'Dokumen awal valid'),
('APP-001', 'SURVEY', 'ANALYSIS', 'Survey lapangan selesai');