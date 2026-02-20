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

-- 3. LOAD REGISTRY (Standard 8 Categories) - This matches attribute_registry.sql
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
('tempat_lahir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Tempat Lahir sesuai KTP'),
('jenis_kelamin', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis Kelamin (L/P)'),
('kewarganegaraan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Kewarganegaraan'),
('status_perkawinan', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Perkawinan'),
('nama_ibu_kandung', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Nama Ibu Kandung'),
('pasangan_nama_lengkap', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama lengkap pasangan'),
('pasangan_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('no_hp_utama', 'BOTH', 'APPLICANT', 'STRING', true, 'No HP Utama'),
('email_pribadi', 'BOTH', 'APPLICANT', 'STRING', false, 'Email Pribadi'),
('pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status pekerjaan'),
('pekerjaan_gaji_bersih', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Gaji bersih bulanan'),
('karakter_riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat gagal bayar');

-- 4. ENTITY: APPLICANTS (CORE fields only)
INSERT INTO applicants (
    id, head_type, identity_number, tax_id, full_name, birth_date
) VALUES
('11111111-1111-1111-1111-111111111111', 'personal', '3171010101900001', '01.234.567.8', 'Budi Santoso', '1990-05-15'),
('22222222-2222-2222-2222-222222222222', 'personal', '3273012008920005', '02.345.678.9', 'Rina Wijaya', '1992-08-20');

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
('22222222-2222-2222-2222-222222222222', 'karakter_riwayat_gagal_bayar', 'false', 'BOOLEAN');

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