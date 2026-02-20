-- ============================================================
-- REGISTER CUSTOM ATTRIBUTES (8 CATEGORIES - 74 TOTAL ITEMS)
-- Following "Credit Analysis" standard requirement
-- ============================================================

-- Clean up existing registry to avoid conflicts
TRUNCATE TABLE custom_column_attribute_registries CASCADE;

INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES

-- 1. Identitas (Nama, NIK, Tgl Lahir, NPWP are in CORE applicants table)
('tempat_lahir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Tempat Lahir sesuai KTP'),
('jenis_kelamin', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis Kelamin (L/P)'),
('kewarganegaraan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Kewarganegaraan'),
('status_perkawinan', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Perkawinan'),
('nama_ibu_kandung', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Nama Ibu Kandung'),

-- 2. Pasangan
('pasangan_nama_lengkap', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama lengkap pasangan sesuai KTP'),
('pasangan_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('pasangan_tempat_lahir', 'BOTH', 'APPLICANT', 'STRING', false, 'Tempat lahir Pasangan'),
('pasangan_tanggal_lahir', 'BOTH', 'APPLICANT', 'DATE', false, 'Tanggal lahir Pasangan'),
('pasangan_jenis_kelamin', 'BOTH', 'APPLICANT', 'STRING', false, 'Jenis kelamin Pasangan'),
('pasangan_kewarganegaraan', 'BOTH', 'APPLICANT', 'STRING', false, 'Kewarganegaraan Pasangan'),
('pasangan_nama_ibu_kandung', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama ibu kandung Pasangan'),
('pasangan_npwp', 'BOTH', 'APPLICANT', 'STRING', false, 'NPWP Pasangan'),
('pasangan_perkawinan_ke', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Perkawinan ke (Urutan)'),

-- 3. Kontak & Alamat
('no_hp_utama', 'BOTH', 'APPLICANT', 'STRING', true, 'No HP Utama'),
('no_hp_alternatif', 'BOTH', 'APPLICANT', 'STRING', false, 'No HP Alternatif'),
('email_pribadi', 'BOTH', 'APPLICANT', 'STRING', false, 'Email Pribadi'),
('alamat_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat sesuai KTP'),
('kelurahan_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kelurahan sesuai KTP'),
('kecamatan_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kecamatan sesuai KTP'),
('kota_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kota sesuai KTP'),
('provinsi_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Provinsi sesuai KTP'),
('kode_pos_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kode Pos sesuai KTP'),
('alamat_domisili', 'BOTH', 'APPLICANT', 'STRING', true, 'Alamat sesuai Domisili'),
('kelurahan_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kelurahan sesuai Domisili'),
('kecamatan_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kecamatan sesuai Domisili'),
('kota_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kota sesuai Domisili'),
('provinsi_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Provinsi sesuai Domisili'),
('kode_pos_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kode Pos sesuai Domisili'),
('lama_tinggal_tahun', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Lama tinggal di alamat ini (Tahun)'),
('status_kepemilikan_rumah', 'BOTH', 'APPLICANT', 'STRING', true, 'Status kepemilikan rumah'),
('jarak_ke_cabang', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Perkiraan jarak kantor cabang (km)'),

-- 4. Profil Rumah Tangga
('jumlah_tanggungan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Jumlah tanggungan'),
('jumlah_anggota_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah anggota rumah tangga'),
('jumlah_anggota_rt_berpenghasilan', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah anggota rumah tangga berpenghasilan'),
('jumlah_anggota_rt_berhutang', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Jumlah anggota rumah tangga berhutang'),
('pasangan_pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status pekerjaan pasangan'),
('pasangan_penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Penghasilan pasangan'),
('total_penghasilan_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Total penghasilan rumah tangga'),
('total_pengeluaran_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Total pengeluaran rumah tangga'),

-- 5. Pendidikan & Sosial
('pendidikan_terakhir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Pendidikan terakhir'),
('jurusan_pendidikan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jurusan pendidikan'),
('sertifikasi_profesi', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Sertifikasi profesi'),
('peran_sosial', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Peran sosial di masyarakat'),
('dikenal_lingkungan_sekitar', 'PERSONAL', 'APPLICANT', 'BOOLEAN', false, 'Apakah dikenal lingkungan setempat'),

-- 6. Pekerjaan
('pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status pekerjaan'),
('pekerjaan_nama_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama perusahaan'),
('pekerjaan_industri', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Industri perusahaan'),
('pekerjaan_alamat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Alamat tempat kerja'),
('pekerjaan_jabatan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jabatan'),
('pekerjaan_lama_bekerja', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Lama bekerja (Tahun)'),
('pekerjaan_telp_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'No telp perusahaan'),
('pekerjaan_gaji_bersih', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Gaji bersih bulanan'),
('pekerjaan_penghasilan_lain', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Penghasilan lain rutin'),
('pekerjaan_metode_pembayaran', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Metode pembayaran gaji (bulanan/2 minggu)'),
('pekerjaan_status_verifikasi', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status verifikasi pekerjaan'),

-- 7. Usaha
('usaha_nama', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama usaha'),
('usaha_jenis', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis usaha'),
('usaha_sektor', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Sektor usaha'),
('usaha_lama_berusaha', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'lama berusaha (Tahun)'),
('usaha_alamat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Alamat usaha'),
('usaha_status_kepemilikan_tempat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status kepemilikan tempat usaha'),
('usaha_jumlah_karyawan', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah karyawan'),
('usaha_penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Penghasilan bulanan'),

-- 8. Karakter & Perilaku
('karakter_disiplin_bayar', 'BOTH', 'APPLICANT', 'STRING', true, 'Persepsi kedisiplinan bayar'),
('karakter_riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat gagal bayar (internal)'),
('karakter_frekuensi_pindah_kerja', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Frekuensi pindah kerja'),
('karakter_frekuensi_pindah_alamat', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Frekuensi pindah alamat'),
('karakter_gaya_hidup_mewah', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Indikasi gaya hidup lebih besar dari penghasilan'),
('karakter_indikasi_fraud', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Indikasi fraud');
