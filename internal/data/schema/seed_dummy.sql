-- ============================================================
-- FULL INTEGRATED SEED DATA (FIXED UUID VERSION)
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CLEAN UP
TRUNCATE TABLE application_status_logs CASCADE;
TRUNCATE TABLE application_financial_facts CASCADE;
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

-- Menggunakan UUID valid untuk Product
INSERT INTO loan_products (id, product_code, product_name, segment, active) VALUES
('00000000-0000-0000-0000-000000000001', 'KUR_MIKRO', 'KUR Mikro Pemerintah', 'UMKM', true),
('00000000-0000-0000-0000-000000000002', 'KMG_KARYAWAN', 'Kredit Multi Guna Karyawan', 'RETAIL', true);

-- Menggunakan UUID valid untuk Officer
INSERT INTO loan_officers (id, officer_code, branch_code) VALUES
('00000000-0000-0000-0000-000000000011', 'AO_BUDI', 'JKT01'),
('00000000-0000-0000-0000-000000000012', 'AO_SITI', 'JKT02');

INSERT INTO financial_gl_accounts (gl_code, gl_name, statement_type, category, sign, is_debt_service, is_operating) VALUES
('INC001', 'Gaji Pokok', 'PL', 'REVENUE', 1, false, true),
('EXP001', 'Biaya Rumah Tangga', 'PL', 'EXPENSE', -1, false, true),
('LIA001', 'Angsuran Bank Lain', 'BS', 'LIABILITY', -1, true, false);

-- 3. CUSTOM ATTRIBUTES REGISTRY
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
('indikasi_fraud', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Flagging Fraud Internal'),
('riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat NPL / Gagal Bayar');

-- 4. ENTITY: APPLICANTS
INSERT INTO applicants (
    id, applicant_type, identity_number, tax_id, full_name, birth_date, created_at, created_by
) VALUES
('11111111-1111-1111-1111-111111111111', 'PERSONAL', '3171010101900001', '01.234.567.8', 'Budi Santoso', '1990-05-15', CURRENT_TIMESTAMP, '00000000-0000-0000-0000-000000000011'),
('22222222-2222-2222-2222-222222222222', 'PERSONAL', '3273012008920005', '02.345.678.9', 'Rina Wijaya', '1992-08-20', CURRENT_TIMESTAMP, '00000000-0000-0000-0000-000000000011'),
('33333333-3333-3333-3333-333333333333', 'PERSONAL', '3578011012850001', '03.456.789.0', 'Agus Prayogo', '1985-12-10', CURRENT_TIMESTAMP, '00000000-0000-0000-0000-000000000012');

-- 5. VALUE: APPLICANT ATTRIBUTES
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES
('11111111-1111-1111-1111-111111111111', 'tempat_lahir', 'Jakarta', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'status_perkawinan', 'Menikah', 'STRING'),
('11111111-1111-1111-1111-111111111111', 'gaji_bersih_bulanan', '15000000', 'NUMBER'),
('22222222-2222-2222-2222-222222222222', 'status_pekerjaan', 'Wiraswasta', 'STRING'),
('33333333-3333-3333-3333-333333333333', 'status_pekerjaan', 'Dokter', 'STRING');

-- 6. APPLICATIONS
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, status, branch_code, submitted_at) VALUES
('cccccccc-1111-1111-1111-cccccccccccc', '11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000011', 75000000, 36, 'ANALYSIS', 'JKT01', CURRENT_TIMESTAMP - interval '2 days'),
('cccccccc-2222-2222-2222-cccccccccccc', '22222222-2222-2222-2222-222222222222', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000011', 25000000, 12, 'INTAKE', 'JKT01', CURRENT_TIMESTAMP);

-- 7. FINANCIAL DATA
INSERT INTO application_financial_facts (application_id, gl_code, period_type, period_label, amount, source) VALUES
('cccccccc-1111-1111-1111-cccccccccccc', 'INC001', 'MONTHLY', '2025-01', 15000000, 'SYSTEM'),
('cccccccc-1111-1111-1111-cccccccccccc', 'EXP001', 'MONTHLY', '2025-01', 5000000, 'SURVEY');

-- 8. STATUS LOGS
INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('cccccccc-1111-1111-1111-cccccccccccc', 'INTAKE', 'SURVEY', 'Dokumen awal valid'),
('cccccccc-1111-1111-1111-cccccccccccc', 'SURVEY', 'ANALYSIS', 'Survey lapangan selesai');