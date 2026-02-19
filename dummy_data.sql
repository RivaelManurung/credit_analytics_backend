-- 1. Buat Branch Dummy
INSERT INTO branch (branch_code, branch_name, region_code)
VALUES ('HO', 'Head Office', 'JKT')
ON CONFLICT (branch_code) DO NOTHING;

-- 2. Buat Loan Officer Dummy
INSERT INTO loan_officer (id, officer_code, branch_code)
VALUES ('550e8400-e29b-41d4-a716-446655440003', 'AO001', 'HO')
ON CONFLICT (id) DO NOTHING;

-- 3. Buat Applicant Dummy
INSERT INTO applicant (id, applicant_type, full_name, created_at)
VALUES ('550e8400-e29b-41d4-a716-446655440001', 'INDIVIDUAL', 'Budi Santoso', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- 4. Buat Loan Product Dummy
INSERT INTO loan_product (id, product_code, product_name, active)
VALUES ('550e8400-e29b-41d4-a716-446655440002', 'KPR-01', 'KPR Mantap', true)
ON CONFLICT (id) DO NOTHING;

-- 5. Buat Application Dummy
INSERT INTO application (id, applicant_id, product_id, ao_id, status, branch_code, created_at)
VALUES (
    '550e8400-e29b-41d4-a716-446655440000', 
    '550e8400-e29b-41d4-a716-446655440001', 
    '550e8400-e29b-41d4-a716-446655440002', 
    '550e8400-e29b-41d4-a716-446655440003',
    'DRAFT', 
    'HO', 
    CURRENT_TIMESTAMP
)
ON CONFLICT (id) DO NOTHING;

-- 6. Masukkan Atribut Aplikasi (EAV Tradisional)
INSERT INTO application_attribute (application_id, attr_key, attr_value, data_type) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'identitas_nama_lengkap', 'Budi Santoso', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_nik', '3171010101010001', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_tempat_lahir', 'Jakarta', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_tanggal_lahir', '1990-05-15', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_jenis_kelamin', 'Laki-laki', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_kewarganegaraan', 'WNI', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_status_perkawinan', 'Kawin', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_nama_ibu_kandung', 'Siti Aminah', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'identitas_npwp', '12.345.678.9-123.000', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'pasangan_nama_lengkap', 'Ani Lestari', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'kontak_no_hp_utama', '081234567890', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'alamat_ktp_lengkap', 'Jl. Sudirman No.45', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'status_pekerjaan', 'Karyawan Swasta', 'string'),
('550e8400-e29b-41d4-a716-446655440000', 'gaji_bersih_bulanan', '12000000', 'number'),
('550e8400-e29b-41d4-a716-446655440000', 'total_penghasilan_rumah_tangga', '15000000', 'number')
ON CONFLICT (application_id, attr_key) DO UPDATE SET 
    attr_value = EXCLUDED.attr_value,
    data_type = EXCLUDED.data_type,
    updated_at = CURRENT_TIMESTAMP;