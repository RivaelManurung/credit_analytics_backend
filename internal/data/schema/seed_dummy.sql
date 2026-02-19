-- 1. CLEAN UP
TRUNCATE TABLE applicant_attributes CASCADE;
TRUNCATE TABLE applicants CASCADE;
TRUNCATE TABLE custom_column_attribute_registries CASCADE;

-- 2. REGISTER ALL KEYS FROM 8 CATEGORIES
INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES
-- 1. Identitas
('id_nama', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama lengkap sesuai dengan KTP'),
('id_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK'),
('id_tempat_lahir', 'BOTH', 'APPLICANT', 'STRING', false, 'Tempat lahir'),
('id_tgl_lahir', 'BOTH', 'APPLICANT', 'DATE', false, 'Tanggal lahir'),
('id_jkel', 'BOTH', 'APPLICANT', 'STRING', false, 'Jenis kelamin'),
('id_wn', 'BOTH', 'APPLICANT', 'STRING', false, 'Kewarganegaraan'),
('id_status_kawin', 'BOTH', 'APPLICANT', 'STRING', false, 'Status perkawinan'),
('id_ibu', 'BOTH', 'APPLICANT', 'STRING', true, 'Nama ibu kandung'),
('id_npwp', 'BOTH', 'APPLICANT', 'STRING', false, 'NPWP'),
-- 2. Pasangan
('sp_nama', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama lengkap pasangan'),
('sp_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('sp_ibu', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama ibu kandung pasangan'),
('sp_ke', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Perkawinan ke'),
-- 3. Kontak & Alamat
('c_hp1', 'BOTH', 'APPLICANT', 'STRING', true, 'No HP Utama'),
('c_hp2', 'BOTH', 'APPLICANT', 'STRING', false, 'No HP Alternatif'),
('c_email', 'BOTH', 'APPLICANT', 'STRING', false, 'Email'),
('a_ktp_lengkap', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat sesuai KTP'),
('a_dom_lengkap', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat sesuai Domisili'),
('a_status_rumah', 'BOTH', 'APPLICANT', 'STRING', false, 'Status kepemilikan rumah'),
('a_jarak_cabang', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Perkiraan jarak kantor cabang'),
-- 4. Profil Rumah Tangga
('rt_tanggungan', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Jumlah tanggungan'),
('rt_total_penghasilan', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Total penghasilan rumah tangga'),
('rt_total_pengeluaran', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Total pengeluaran rumah tangga'),
-- 5. Pendidikan & Sosial
('edu_terakhir', 'BOTH', 'APPLICANT', 'STRING', false, 'Pendidikan terakhir'),
('edu_jurusan', 'BOTH', 'APPLICANT', 'STRING', false, 'Jurusan pendidikan'),
('soc_peran', 'BOTH', 'APPLICANT', 'STRING', false, 'Peran sosial di masyarakat'),
-- 6. Pekerjaan
('job_status', 'BOTH', 'APPLICANT', 'STRING', false, 'Status pekerjaan'),
('job_perusahaan', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama perusahaan'),
('job_jabatan', 'BOTH', 'APPLICANT', 'STRING', false, 'Jabatan'),
('job_gaji_bersih', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Gaji bersih bulanan'),
-- 7. Usaha
('biz_nama', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama usaha'),
('biz_sektor', 'BOTH', 'APPLICANT', 'STRING', false, 'Sektor usaha'),
('biz_penghasilan', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Penghasilan bulanan usaha'),
-- 8. Karakter & Perilaku
('beh_disiplin', 'BOTH', 'APPLICANT', 'STRING', true, 'Persepsi kedisiplinan bayar'),
('beh_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat gagal bayar (internal)'),
('beh_lifestyle', 'BOTH', 'APPLICANT', 'STRING', true, 'Indikasi gaya hidup lebih besar dari penghasilan');

-- 3. INSERT 10 APPLICANTS
INSERT INTO applicants (id, applicant_type, full_name, birth_date, created_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'PERSONAL', 'Budi Santoso', '1990-05-15', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'PERSONAL', 'Siti Aminah', '1992-08-20', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'PERSONAL', 'Agus Prayogo', '1985-12-10', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'PERSONAL', 'Dewi Lestari', '1995-03-25', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'PERSONAL', 'Eko Saputra', '1988-07-30', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'PERSONAL', 'Rina Wijaya', '1993-11-12', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'PERSONAL', 'Hendra Gunawan', '1980-01-05', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'PERSONAL', 'Maya Kartika', '1998-09-18', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'PERSONAL', 'Fajar Ramadhan', '1991-06-22', CURRENT_TIMESTAMP),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'PERSONAL', 'Linda Permata', '1987-04-14', CURRENT_TIMESTAMP);

-- 4. INSERT ATTRIBUTES FOR ALL 10 APPLICANTS (EAV)
-- Using a pattern: (ID, KEY, VALUE, TYPE)
INSERT INTO applicant_attributes (applicant_id, attr_key, attr_value, data_type) VALUES
-- 1. Budi Santoso (Karyawan, Menikah)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'id_nik', '3171010101010001', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'id_status_kawin', 'Kawin', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'sp_nama', 'Ani Lestari', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c_hp1', '081122334455', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'job_status', 'Karyawan Tetap', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'job_gaji_bersih', '15000000', 'number'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'beh_disiplin', 'Sangat Baik', 'string'),

-- 2. Siti Aminah (Wirausaha)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'id_nik', '3171010101010002', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'id_status_kawin', 'Lajang', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'c_hp1', '081298765432', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'biz_nama', 'Warung Berkah', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'biz_penghasilan', '20000000', 'number'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'rt_total_pengeluaran', '10000000', 'number'),

-- 3. Agus Prayogo (Profesional)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'id_nik', '3171010101010003', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'job_perusahaan', 'PT Teknologi Maju', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'job_gaji_bersih', '45000000', 'number'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'a_status_rumah', 'Milik Sendiri', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'beh_lifestyle', 'Normal', 'string'),

-- 4. Dewi Lestari (Karyawan)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'id_nik', '3171010101010004', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'id_ibu', 'Siti Maryam', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'job_gaji_bersih', '8000000', 'number'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'rt_tanggungan', '2', 'number'),

-- 5. Eko Saputra (Driver / Freelance)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'id_nik', '3171010101010005', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'job_status', 'Freelance', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'job_gaji_bersih', '6000000', 'number'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'beh_gagal_bayar', 'false', 'boolean'),

-- 6-10 (Filling with basic variety)
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'id_nama', 'Rina Wijaya', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'job_gaji_bersih', '11000000', 'number'),

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'id_nama', 'Hendra Gunawan', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'biz_penghasilan', '50000000', 'number'),

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'id_nama', 'Maya Kartika', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'edu_terakhir', 'S1', 'string'),

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'id_nama', 'Fajar Ramadhan', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'a_jarak_cabang', '5', 'number'),

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'id_nama', 'Linda Permata', 'string'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'soc_peran', 'Ketua RT', 'string');
