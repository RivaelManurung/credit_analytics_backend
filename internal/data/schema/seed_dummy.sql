-- ============================================================
-- FULL INTEGRATED SEED DATA (COMPLEX EAV VERSION)
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

-- 3. CUSTOM ATTRIBUTES REGISTRY (Definisi Kunci EAV)
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
('nik_pasangan', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('nama_pasangan', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama Lengkap Pasangan'),
('pekerjaan', 'BOTH', 'APPLICANT', 'STRING', true, 'Pekerjaan Utama'),
('nama_perusahaan', 'BOTH', 'APPLICANT', 'STRING', false, 'Tempat Bekerja'),
('pendapatan_bulanan', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Take Home Pay'),
('alamat_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat Tinggal Sekarang');

-- 4. ENTITY: APPLICANTS (Data Pokok Statis)
INSERT INTO applicants (
    id, nik, email, nama_lengkap, nomor_telepon, tempat_lahir, tanggal_lahir, 
    nama_gadis_ibu_kandung, jenis_kelamin, status_perkawinan, npwp, 
    provinsi, kota, kecamatan, kelurahan, alamat, kode_pos, 
    created_date, tenant_id, created_by_id
) VALUES
(1, '3171010101900001', 'budi.s@email.com', 'Budi Santoso', '08123456789', 'Jakarta', '1990-05-15', 'Siti Aminah', 'LAKI-LAKI', 'MENIKAH', '01.234.567.8', 'DKI JAKARTA', 'JAKARTA PUSAT', 'GAMBIR', 'GAMBIR', 'Jl. Merdeka No. 10', '10110', CURRENT_TIMESTAMP, 'TENANT_01', 101),
(2, '3273012008920005', 'rina.w@email.com', 'Rina Wijaya', '08134455667', 'Bandung', '1992-08-20', 'Kartini', 'PEREMPUAN', 'MENIKAH', '02.345.678.9', 'JAWA BARAT', 'BANDUNG', 'COBLONG', 'DAGO', 'Jl. Dago No. 123', '40135', CURRENT_TIMESTAMP, 'TENANT_01', 101),
(3, '3578011012850001', 'agus.p@email.com', 'Agus Prayogo', '08521122334', 'Surabaya', '1985-12-10', 'Suminah', 'LAKI-LAKI', 'BELUM MENIKAH', '03.456.789.0', 'JAWA TIMUR', 'SURABAYA', 'GUBENG', 'AIRLANGGA', 'Jl. Dharmawangsa 5', '60286', CURRENT_TIMESTAMP, 'TENANT_01', 101);

-- 5. VALUE: APPLICANT ATTRIBUTES (Data Dinamis/Kompleks EAV)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES
-- Budi (Karyawan, Detail Pasangan Lengkap)
(1, 'nik_pasangan', '3171014102930005', 'STRING'),
(1, 'nama_pasangan', 'Ani Lestari', 'STRING'),
(1, 'pekerjaan', 'KARYAWAN SWASTA', 'STRING'),
(1, 'nama_perusahaan', 'PT Teknologi Maju', 'STRING'),
(1, 'pendapatan_bulanan', '15000000', 'NUMBER'),
(1, 'alamat_domisili', 'Jl. Merdeka No. 10, Gambir', 'STRING'),

-- Rina (Wiraswasta)
(2, 'nik_pasangan', '3273011505900001', 'STRING'),
(2, 'nama_pasangan', 'Hendra Gunawan', 'STRING'),
(2, 'pekerjaan', 'WIRASWASTA', 'STRING'),
(2, 'nama_perusahaan', 'Kedai Kopi Rina', 'STRING'),
(2, 'pendapatan_bulanan', '25000000', 'NUMBER'),
(2, 'alamat_domisili', 'Perum Dago Asri B-12', 'STRING'),

-- Agus (Single, Profesional)
(3, 'pekerjaan', 'DOKTER SPESIALIS', 'STRING'),
(3, 'nama_perusahaan', 'RS Medika Surabaya', 'STRING'),
(3, 'pendapatan_bulanan', '50000000', 'NUMBER'),
(3, 'alamat_domisili', 'Apartemen Gunawangsa C-10', 'STRING');

-- 6. APPLICATIONS (Menghubungkan ke Applicant ID BigInt)
INSERT INTO applications (id, applicant_id, product_id, ao_id, loan_amount, tenor_months, status, branch_code, submitted_at) VALUES
('APP-001', 1, 'p002', 'u001', 75000000, 36, 'ANALYSIS', 'JKT01', CURRENT_TIMESTAMP - interval '2 days'),
('APP-002', 2, 'p001', 'u001', 25000000, 12, 'INTAKE', 'JKT01', CURRENT_TIMESTAMP);

-- 7. FINANCIAL DATA
INSERT INTO application_financial_facts (application_id, gl_code, period_type, amount, source) VALUES
('APP-001', 'INC001', 'MONTHLY', 15000000, 'SYSTEM'),
('APP-001', 'EXP001', 'MONTHLY', 5000000, 'SURVEY');

-- 8. STATUS LOGS
INSERT INTO application_status_logs (application_id, from_status, to_status, change_reason) VALUES
('APP-001', 'INTAKE', 'SURVEY', 'Dokumen awal valid'),
('APP-001', 'SURVEY', 'ANALYSIS', 'Survey lapangan selesai');