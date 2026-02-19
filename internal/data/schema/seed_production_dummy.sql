-- ==========================================
-- SEED PRODUCTION-LIKE DUMMY DATA (VALID UUIDS)
-- ==========================================

BEGIN;

-- 1. Clean up
TRUNCATE TABLE 
    application_decision_conditions,
    application_decisions,
    application_committee_decisions,
    application_committee_votes,
    credit_committee_members,
    application_committee_sessions,
    application_financial_ratios,
    application_liabilities,
    application_assets,
    asset_types,
    application_financial_facts,
    financial_gl_accounts,
    survey_evidences,
    survey_answers,
    application_surveys,
    survey_question_options,
    survey_questions,
    survey_sections,
    survey_templates,
    application_status_logs,
    application_attributes,
    applications,
    loan_officers,
    loan_products,
    branches,
    applicant_attributes,
    custom_column_attribute_registries,
    applicants,
    application_status_refs,
    parties,
    application_parties
CASCADE;

-- 2. Master Data: Branches
INSERT INTO branches (branch_code, branch_name, region_code) VALUES
('B001', 'Kantor Pusat - Jakarta', 'REG01'),
('B002', 'Cabang Bandung', 'REG02'),
('B003', 'Cabang Surabaya', 'REG03'),
('B004', 'Cabang Medan', 'REG04'),
('B005', 'Cabang Makassar', 'REG05');

-- 3. Master Data: Loan Products
INSERT INTO loan_products (id, product_code, product_name, segment, active) VALUES
('11111111-1111-1111-1111-111111111101', 'KMK_RETAIL', 'Kredit Modal Kerja Retail', 'RETAIL', TRUE),
('11111111-1111-1111-1111-111111111102', 'KI_RETAIL', 'Kredit Investasi Retail', 'RETAIL', TRUE),
('11111111-1111-1111-1111-111111111103', 'KUR_MIKRO', 'Kredit Usaha Rakyat Mikro', 'UMKM', TRUE),
('11111111-1111-1111-1111-111111111104', 'KMK_CORPORATE', 'Kredit Modal Kerja Corporate', 'CORPORATE', TRUE);

-- 4. Master Data: Loan Officers (AO)
INSERT INTO loan_officers (id, officer_code, branch_code) VALUES
('22222222-2222-2222-2222-222222222201', 'AO_BUDI', 'B001'),
('22222222-2222-2222-2222-222222222202', 'AO_SITI', 'B001'),
('22222222-2222-2222-2222-222222222203', 'AO_AGUS', 'B002'),
('22222222-2222-2222-2222-222222222204', 'AO_DEWI', 'B003');

-- 5. Status References
INSERT INTO application_status_refs (status_code, status_group, is_terminal, description) VALUES
('DRAFT', 'INTAKE', FALSE, 'Aplikasi Baru / Draft'),
('SUBMITTED', 'INTAKE', FALSE, 'Sudah di-Submit oleh AO'),
('SURVEY_ASSIGNED', 'SURVEY', FALSE, 'Petugas Survey Ditugaskan'),
('SURVEY_IN_PROGRESS', 'SURVEY', FALSE, 'Proses Survey Lapangan'),
('SURVEY_SUBMITTED', 'SURVEY', FALSE, 'Hasil Survey Dikirim'),
('ANALYSIS_IN_PROGRESS', 'ANALYSIS', FALSE, 'Proses Analisis oleh CA'),
('COMMITTEE_PENDING', 'DECISION', FALSE, 'Menunggu Jadwal Komite'),
('COMMITTEE_VOTING', 'DECISION', FALSE, 'Sidang Komite Berjalan'),
('APPROVED', 'TERMINAL', TRUE, 'Aplikasi Disetujui'),
('REJECTED', 'TERMINAL', TRUE, 'Aplikasi Ditolak'),
('CANCELLED', 'TERMINAL', TRUE, 'Aplikasi Dibatalkan');

-- 6. Master Data: GL Accounts
INSERT INTO financial_gl_accounts (gl_code, gl_name, statement_type, category, sign, is_debt_service, is_operating, description) VALUES
('REV_MAIN', 'Penjualan Utama', 'PL', 'REVENUE', 1, FALSE, TRUE, 'Total Pendapatan dari Bisnis Utama'),
('EXP_COGS', 'HPP / COGS', 'PL', 'EXPENSE', -1, FALSE, TRUE, 'Harga Pokok Penjualan'),
('EXP_OPR', 'Biaya Operasional', 'PL', 'EXPENSE', -1, FALSE, TRUE, 'Gaji, Listrik, Sewa, dsb'),
('EXP_FIN', 'Biaya Bunga / Finansial', 'PL', 'EXPENSE', -1, TRUE, FALSE, 'Cicilan Pinjaman Lain'),
('ASSET_CASH', 'Kas dan Setara Kas', 'BS', 'ASSET', 1, FALSE, FALSE, 'Saldo Tunai dan Bank'),
('ASSET_FIXED', 'Aset Tetap', 'BS', 'ASSET', 1, FALSE, FALSE, 'Tanah, Bangunan, Kendaraan');

-- 7. Asset Types
INSERT INTO asset_types (asset_type_code, asset_category, description) VALUES
('VEH_CAR', 'VEHICLE', 'Mobil Pribadi / Operasional'),
('PROP_HOUSE', 'PROPERTY', 'Rumah Tinggal');

-- 8. Registry Atribut
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
('id_sex', 'PERSONAL', 'APPLICANT', 'STRING', FALSE, 'Jenis Kelamin'),
('job_industry', 'PERSONAL', 'APPLICANT', 'STRING', TRUE, 'Industri Pekerjaan'),
('res_ownership', 'PERSONAL', 'APPLICANT', 'STRING', TRUE, 'Status Kepemilikan Rumah');

-- 9. Applicants (10 Orang)
INSERT INTO applicants (id, applicant_type, identity_number, tax_id, full_name, birth_date, establishment_date) VALUES
('33333333-3333-3333-3333-333333333301', 'PERSONAL', '3201010101010001', '01.234.567.8-001.000', 'Budi Santoso', '1985-05-15', NULL),
('33333333-3333-3333-3333-333333333302', 'PERSONAL', '3201010101010002', '01.234.567.8-001.001', 'Siti Aminah', '1990-08-20', NULL),
('33333333-3333-3333-3333-333333333303', 'CORPORATE', '9120001234567', '02.345.678.9-002.000', 'PT. Maju Jaya Bersama', NULL, '2015-03-10'),
('33333333-3333-3333-3333-333333333304', 'PERSONAL', '3201010101010004', '01.234.567.8-001.004', 'Agus Prayogo', '1978-12-05', NULL),
('33333333-3333-3333-3333-333333333305', 'PERSONAL', '3201010101010005', '01.234.567.8-001.005', 'Dewi Lestari', '1992-02-28', NULL),
('33333333-3333-3333-3333-333333333306', 'PERSONAL', '3201010101010006', '01.234.567.8-001.006', 'Eko Saputra', '1988-06-12', NULL),
('33333333-3333-3333-3333-333333333307', 'CORPORATE', '9120009876543', '02.345.678.9-002.007', 'CV. Berkah Abadi', NULL, '2020-01-15'),
('33333333-3333-3333-3333-333333333308', 'PERSONAL', '3201010101010008', '01.234.567.8-001.008', 'Rina Wijaya', '1983-11-25', NULL),
('33333333-3333-3333-3333-333333333309', 'PERSONAL', '3201010101010009', '01.234.567.8-001.009', 'Hendra Gunawan', '1980-04-14', NULL),
('33333333-3333-3333-3333-333333333310', 'PERSONAL', '3201010101010010', '01.234.567.8-001.010', 'Maya Kartika', '1995-10-10', NULL);

-- 10. Applications
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, interest_type, interest_rate, loan_purpose, application_channel, status, branch_code) VALUES
('44444444-4444-4444-4444-444444444401', '33333333-3333-3333-3333-333333333301', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222201', 150000000, 36, 'FIXED', 11.5, 'Modal Kerja Toko Kelontong', 'WALK_IN', 'APPROVED', 'B001'),
('44444444-4444-4444-4444-444444444402', '33333333-3333-3333-3333-333333333302', '11111111-1111-1111-1111-111111111103', '22222222-2222-2222-2222-222222222201', 25000000, 12, 'FIXED', 6.0, 'Modal Jualan Makanan', 'CRM', 'SUBMITTED', 'B001'),
('44444444-4444-4444-4444-444444444403', '33333333-3333-3333-3333-333333333303', '11111111-1111-1111-1111-111111111104', '22222222-2222-2222-2222-222222222202', 2000000000, 60, 'FLOATING', 9.5, 'Pengembangan Pabrik', 'WEBSITE', 'ANALYSIS_IN_PROGRESS', 'B001'),
('44444444-4444-4444-4444-444444444404', '33333333-3333-3333-3333-333333333304', '11111111-1111-1111-1111-111111111102', '22222222-2222-2222-2222-222222222203', 500000000, 48, 'FIXED', 10.0, 'Beli Kendaraan Box', 'WALK_IN', 'COMMITTEE_VOTING', 'B002'),
('44444444-4444-4444-4444-444444444405', '33333333-3333-3333-3333-333333333305', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222204', 75000000, 24, 'FIXED', 12.0, 'Renovasi Tempat Usaha', 'API', 'REJECTED', 'B003'),
('44444444-4444-4444-4444-444444444406', '33333333-3333-3333-3333-333333333306', '11111111-1111-1111-1111-111111111103', '22222222-2222-2222-2222-222222222203', 15000000, 12, 'FIXED', 6.0, 'Beli Bibit Pertanian', 'CRM', 'SURVEY_IN_PROGRESS', 'B002'),
('44444444-4444-4444-4444-444444444407', '33333333-3333-3333-3333-333333333307', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222201', 300000000, 36, 'FIXED', 11.0, 'Stok Barang Gudang', 'WALK_IN', 'SURVEY_SUBMITTED', 'B001'),
('44444444-4444-4444-4444-444444444408', '33333333-3333-3333-3333-333333333308', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222202', 100000000, 24, 'FIXED', 12.0, 'Modal Usaha Salon', 'WALK_IN', 'DRAFT', 'B001'),
('44444444-4444-4444-4444-444444444409', '33333333-3333-3333-3333-333333333309', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222201', 250000000, 36, 'FIXED', 11.5, 'Modal Cafe', 'WALK_IN', 'SURVEY_ASSIGNED', 'B001'),
('44444444-4444-4444-4444-444444444410', '33333333-3333-3333-3333-333333333310', '11111111-1111-1111-1111-111111111101', '22222222-2222-2222-2222-222222222203', 50000000, 12, 'FIXED', 12.0, 'Beli Inventaris Kantor', 'WALK_IN', 'COMMITTEE_PENDING', 'B002');

-- 11. Financial Facts
INSERT INTO application_financial_facts (application_id, gl_code, period_type, period_label, amount, source, confidence_level) VALUES
('44444444-4444-4444-4444-444444444401', 'REV_MAIN', 'MONTHLY', '2025-01', 50000000, 'SURVEY', 'HIGH'),
('44444444-4444-4444-4444-444444444401', 'EXP_COGS', 'MONTHLY', '2025-01', 30000000, 'SURVEY', 'MEDIUM'),
('44444444-4444-4444-4444-444444444403', 'REV_MAIN', 'YEARLY', '2024', 24000000000, 'IMPORT', 'HIGH');

-- 12. Status Logs
INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('44444444-4444-4444-4444-444444444401', 'DRAFT', 'SUBMITTED', 'Dokumen lengkap'),
('44444444-4444-4444-4444-444444444401', 'SUBMITTED', 'ANALYSIS_IN_PROGRESS', 'Mulai analisis mendalam'),
('44444444-4444-4444-4444-444444444401', 'ANALYSIS_IN_PROGRESS', 'APPROVED', 'Sidang komite selesai');

-- 13. Committee Data
INSERT INTO application_committee_sessions (id, application_id, session_sequence, status, scheduled_at) VALUES
('88888888-8888-8888-8888-888888888801', '44444444-4444-4444-4444-444444444401', 1, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '2 days');

INSERT INTO application_committee_decisions (committee_session_id, decision, decision_reason, approved_amount, approved_tenor, approved_interest_rate) VALUES
('88888888-8888-8888-8888-888888888801', 'APPROVED', 'Disetujui sesuai plafon', 150000000, 36, 11.5);

COMMIT;
