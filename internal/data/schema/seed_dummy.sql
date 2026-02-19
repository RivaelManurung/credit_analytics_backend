-- ============================================================
-- FULL INTEGRATED SEED DATA FOR ALL SQLC TABLES
-- This script hydrates every single table in the schema
-- ============================================================

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
('BDG01', 'Bandung Merdeka', 'REG02'),
('SUB01', 'Surabaya Basuki Rahmat', 'REG03');

INSERT INTO loan_products (id, product_code, product_name, segment, active) VALUES
('p0000000-0000-0000-0000-000000000001', 'KUR_MIKRO', 'KUR Mikro Pemerintah', 'UMKM', true),
('p0000000-0000-0000-0000-000000000002', 'KMG_KARYAWAN', 'Kredit Multi Guna Karyawan', 'RETAIL', true),
('p0000000-0000-0000-0000-000000000003', 'INV_CORP', 'Kredit Investasi Korporasi', 'CORPORATE', true);

INSERT INTO loan_officers (id, officer_code, branch_code) VALUES
('u0000000-0000-0000-0000-000000000001', 'AO_BUDI', 'JKT01'),
('u0000000-0000-0000-0000-000000000002', 'AO_SITI', 'JKT02'),
('u0000000-0000-0000-0000-000000000101', 'AN_HARRY', 'JKT01');

INSERT INTO asset_types (asset_type_code, asset_category, description) VALUES
('VEH_MOTOR', 'VEHICLE', 'Sepeda Motor'),
('VEH_CAR', 'VEHICLE', 'Mobil Pribadi'),
('PROP_LAND', 'PROPERTY', 'Tanah dan Bangunan'),
('INV_STOCK', 'INVENTORY', 'Stok Barang Dagangan');

INSERT INTO financial_gl_accounts (gl_code, gl_name, statement_type, category, sign, is_debt_service, is_operating, description) VALUES
('INC001', 'Gaji Pokok / Omzet Utama', 'PL', 'REVENUE', 1, false, true, 'Penghasilan utama'),
('INC002', 'Penghasilan Tambahan', 'PL', 'REVENUE', 1, false, true, 'Usaha sampingan'),
('EXP001', 'Biaya Rumah Tangga', 'PL', 'EXPENSE', -1, false, true, 'Biaya hidup'),
('EXP002', 'Biaya Operasional Usaha', 'PL', 'EXPENSE', -1, false, true, 'HPP dan overhead'),
('AST001', 'Tabungan / Kas', 'BS', 'ASSET', 1, false, false, 'Simpanan bank'),
('LIA001', 'Angsuran Bank Lain', 'BS', 'LIABILITY', -1, true, false, 'Kewajiban existing');

INSERT INTO application_status_refs (status_code, status_group, is_terminal, description) VALUES
('INTAKE', 'INTAKE', false, 'Data baru masuk'),
('SURVEY', 'SURVEY', false, 'Proses verifikasi lapangan'),
('ANALYSIS', 'ANALYSIS', false, 'Proses analisa kredit'),
('COMMITTEE', 'DECISION', false, 'Proses komite kredit'),
('APPROVED', 'TERMINAL', true, 'Disetujui'),
('REJECTED', 'TERMINAL', true, 'Ditolak'),
('CANCELLED', 'TERMINAL', true, 'Dibatalkan');

INSERT INTO product_status_flows (product_id, from_status, to_status, is_default, requires_role) VALUES
('p0000000-0000-0000-0000-000000000001', 'INTAKE', 'SURVEY', true, 'AO'),
('p0000000-0000-0000-0000-000000000001', 'SURVEY', 'ANALYSIS', true, 'AO'),
('p0000000-0000-0000-0000-000000000001', 'ANALYSIS', 'COMMITTEE', true, 'ANALYST'),
('p0000000-0000-0000-0000-000000000001', 'COMMITTEE', 'APPROVED', true, 'COMMITTEE');

-- 3. CUSTOM ATTRIBUTES REGISTRY
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
('id_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'Identity Number (KTP)'),
('job_status', 'BOTH', 'APPLICANT', 'STRING', true, 'Employment Status'),
('rt_dependents', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Number of Tanggungan'),
('biz_legality', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Has NIB/Business License');

-- 4. APPLICANTS & PARTIES
INSERT INTO applicants (id, applicant_type, full_name, birth_date, identity_number) VALUES
('a0000000-0000-0000-0000-000000000001', 'PERSONAL', 'Budi Santoso', '1990-05-15', '3171010101900001'),
('a0000000-0000-0000-0000-000000000002', 'PERSONAL', 'Siti Aminah', '1992-08-20', '3171010208920002');

INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES
('a0000000-0000-0000-0000-000000000001', 'job_status', 'PERMANENT_STAFF', 'STRING'),
('a0000000-0000-0000-0000-000000000001', 'rt_dependents', '2', 'NUMBER');

INSERT INTO parties (id, party_type, identifier, name, date_of_birth) VALUES
('party000-0000-0000-0000-000000000001', 'PERSON', '3171010101900002', 'Ani Lestari', '1993-02-10'); -- Spouses

-- 5. APPLICATIONS
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, interest_type, interest_rate, status, branch_code, submitted_at) VALUES
('app00000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'p0000000-0000-0000-0000-000000000002', 'u0000000-0000-0000-0000-000000000001', 75000000, 36, 'FIXED', 12.5, 'COMMITTEE', 'JKT01', CURRENT_TIMESTAMP - interval '5 days');

INSERT INTO application_attributes (application_id, attr_key, attr_value, data_type) VALUES
('app00000-0000-0000-0000-000000000001', 'purpose_detail', 'Renovasi rumah bagian dapur', 'STRING');

INSERT INTO application_parties (application_id, party_id, role_code, legal_obligation, slik_required) VALUES
('app00000-0000-0000-0000-000000000001', 'party000-0000-0000-0000-000000000001', 'SPOUSE', true, true);

INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('app00000-0000-0000-0000-000000000001', 'INTAKE', 'SURVEY', 'Data lengkap'),
('app00000-0000-0000-0000-000000000001', 'SURVEY', 'ANALYSIS', 'Survey selesai'),
('app00000-0000-0000-0000-000000000001', 'ANALYSIS', 'COMMITTEE', 'Analisa layak');

-- 6. SURVEY MODULE
INSERT INTO survey_templates (id, template_code, template_name, applicant_type, active) VALUES
('st000000-0000-0000-0000-000000000001', 'TPL_PERSONAL', 'Standard Personal Survey', 'PERSONAL', true);

INSERT INTO survey_sections (id, template_id, section_code, section_name, sequence) VALUES
('sec00000-0000-0000-0000-000000000001', 'st000000-0000-0000-0000-000000000001', 'SEC_HOME', 'Kondisi Rumah', 1);

INSERT INTO survey_questions (id, section_id, question_code, question_text, answer_type, sequence) VALUES
('q0000000-0000-0000-0000-000000000001', 'sec00000-0000-0000-0000-000000000001', 'Q_HOME_TYPE', 'Jenis Bangunan', 'SELECT', 1);

INSERT INTO survey_question_options (id, question_id, option_value, option_label, sequence) VALUES
('opt00000-0000-0000-0000-000000000001', 'q0000000-0000-0000-0000-000000000001', 'PERMANENT', 'Permanen', 1),
('opt00000-0000-0000-0000-000000000002', 'q0000000-0000-0000-0000-000000000001', 'SEMI', 'Semi Permanen', 2);

INSERT INTO application_surveys (id, application_id, template_id, survey_type, status) VALUES
('srv00000-0000-0000-0000-000000000001', 'app00000-0000-0000-0000-000000000001', 'st000000-0000-0000-0000-000000000001', 'FIELD', 'VERIFIED');

INSERT INTO survey_answers (id, survey_id, question_id, answer_text) VALUES
('ans00000-0000-0000-0000-000000000001', 'srv00000-0000-0000-0000-000000000001', 'q0000000-0000-0000-0000-000000000001', 'PERMANENT');

INSERT INTO survey_evidences (id, survey_id, evidence_type, file_url, description) VALUES
('evd00000-0000-0000-0000-000000000001', 'srv00000-0000-0000-0000-000000000001', 'PHOTO', 'https://storage.bank.co.id/survey/srv001_home.jpg', 'Foto Rumah Tampak Depan');

INSERT INTO survey_data_mappings (id, question_id, target_type, target_code) VALUES
('map00000-0000-0000-0000-000000000001', 'q0000000-0000-0000-0000-000000000001', 'APPLICATION_ATTR', 'home_status');

-- 7. FINANCIAL MODULE
INSERT INTO application_financial_facts (application_id, gl_code, period_type, period_label, amount, source) VALUES
('app00000-0000-0000-0000-000000000001', 'INC001', 'MONTHLY', '2024-01', 12000000, 'SURVEY'),
('app00000-0000-0000-0000-000000000001', 'EXP001', 'MONTHLY', '2024-01', 5000000, 'SURVEY');

INSERT INTO application_assets (application_id, asset_type_code, asset_name, ownership_status, estimated_value) VALUES
('app00000-0000-0000-0000-000000000001', 'VEH_MOTOR', 'Honda Vario 2022', 'SPOUSE', 18000000);

INSERT INTO application_liabilities (application_id, creditor_name, liability_type, outstanding_amount, monthly_installment) VALUES
('app00000-0000-0000-0000-000000000001', 'Bank ABC', 'BANK', 120000000, 2500000);

INSERT INTO application_financial_ratios (application_id, ratio_code, ratio_value) VALUES
('app00000-0000-0000-0000-000000000001', 'DSR', 0.35); -- Debt Service Ratio

-- 8. COMMITTEE & DECISION
INSERT INTO application_committee_sessions (id, application_id, session_sequence, status, scheduled_at) VALUES
('com00000-0000-0000-0000-000000000001', 'app00000-0000-0000-0000-000000000001', 1, 'IN_SESSION', CURRENT_TIMESTAMP);

INSERT INTO credit_committee_members (committee_session_id, user_id, role) VALUES
('com00000-0000-0000-0000-000000000001', 'u0000000-0000-0000-0000-000000001001', 'CHAIR'), -- Head of Branch
('com00000-0000-0000-0000-000000001002', 'u0000000-0000-0000-0000-000000001002', 'MEMBER');

INSERT INTO application_committee_votes (id, committee_session_id, user_id, vote, vote_reason) VALUES
('vote0000-0000-0000-0000-000000000001', 'com00000-0000-0000-0000-000000000001', 'u0000000-0000-0000-0000-000000001002', 'APPROVE', 'Karakter nasabah baik dan DSR masuk');

INSERT INTO application_committee_decisions (id, committee_session_id, decision, approved_amount, approved_tenor) VALUES
('dec00000-0000-0000-0000-000000000001', 'com00000-0000-0000-0000-000000000001', 'APPROVED', 75000000, 36);

INSERT INTO application_decisions (id, application_id, decision, decision_source, final_amount, final_tenor, decision_reason) VALUES
('fdec0000-0000-0000-0000-000000000001', 'app00000-0000-0000-0000-000000000001', 'APPROVED', 'COMMITTEE', 75000000, 36, 'Sesuai hasil komite cabang JKT01');

INSERT INTO application_decision_conditions (application_decision_id, condition_type, condition_text) VALUES
('fdec0000-0000-0000-0000-000000000001', 'PRE_DISBURSEMENT', 'Wajib melampirkan IMB asli');

INSERT INTO credit_authority_matrices (committee_level, product_id, max_amount, max_tenor) VALUES
(1, 'p0000000-0000-0000-0000-000000000002', 100000000, 60);

-- End of full seed
