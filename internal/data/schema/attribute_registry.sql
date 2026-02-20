-- ============================================================
-- REGISTER CUSTOM ATTRIBUTES (8 CATEGORIES)
-- ============================================================

-- Clean up existing registry to avoid conflicts
TRUNCATE TABLE custom_column_attribute_registries CASCADE;

INSERT INTO custom_column_attribute_registries (attribute_code, applies_to, scope, value_type, risk_relevant, description) VALUES

-- 1. Identitas
('tempat_lahir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Tempat Lahir Sesuai KTP'),
('jenis_kelamin', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis Kelamin (L/P)'),
('kewarganegaraan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Kewarganegaraan'),
('status_perkawinan', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Perkawinan'),
('nama_ibu_kandung', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Nama Ibu Kandung Lengkap'),

-- 2. Pasangan
('pasangan_nama', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama Lengkap Pasangan'),
('pasangan_nik', 'BOTH', 'APPLICANT', 'STRING', true, 'NIK Pasangan'),
('pasangan_tempat_lahir', 'BOTH', 'APPLICANT', 'STRING', false, 'Tempat Lahir Pasangan'),
('pasangan_tanggal_lahir', 'BOTH', 'APPLICANT', 'DATE', false, 'Tanggal Lahir Pasangan'),
('pasangan_jenis_kelamin', 'BOTH', 'APPLICANT', 'STRING', false, 'Jenis Kelamin Pasangan'),
('pasangan_kewarganegaraan', 'BOTH', 'APPLICANT', 'STRING', false, 'Kewarganegaraan Pasangan'),
('pasangan_nama_ibu_kandung', 'BOTH', 'APPLICANT', 'STRING', false, 'Nama Ibu Kandung Pasangan'),
('pasangan_npwp', 'BOTH', 'APPLICANT', 'STRING', false, 'NPWP Pasangan'),
('pasangan_perkawinan_ke', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Tahap Perkawinan ke-n'),

-- 3. Kontak & Alamat
('no_hp_utama', 'BOTH', 'APPLICANT', 'STRING', true, 'Nomor HP Utama'),
('no_hp_alternatif', 'BOTH', 'APPLICANT', 'STRING', false, 'Nomor HP Alternatif'),
('email_applicant', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat Email'),
('alamat_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Alamat Lengkap Sesuai KTP'),
('kelurahan_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kelurahan Sesuai KTP'),
('kecamatan_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kecamatan Sesuai KTP'),
('kota_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kota/Kabupaten Sesuai KTP'),
('provinsi_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Provinsi Sesuai KTP'),
('kode_pos_ktp', 'BOTH', 'APPLICANT', 'STRING', false, 'Kode Pos Sesuai KTP'),
('alamat_domisili', 'BOTH', 'APPLICANT', 'STRING', true, 'Alamat Lengkap Domisili'),
('kelurahan_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kelurahan Domisili'),
('kecamatan_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kecamatan Domisili'),
('kota_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kota/Kabupaten Domisili'),
('provinsi_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Provinsi Domisili'),
('kode_pos_domisili', 'BOTH', 'APPLICANT', 'STRING', false, 'Kode Pos Domisili'),
('lama_tinggal', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Lama Tinggal (Tahun)'),
('status_kepemilikan_rumah', 'BOTH', 'APPLICANT', 'STRING', true, 'Status Kepemilikan Rumah'),
('jarak_kantor_cabang', 'BOTH', 'APPLICANT', 'NUMBER', false, 'Perkiraan Jarak ke Kantor Cabang (km)'),

-- 4. Profil Rumah Tangga
('jumlah_tanggungan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Jumlah Tanggungan'),
('jumlah_anggota_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah Anggota Rumah Tangga'),
('jumlah_anggota_rt_berpenghasilan', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah Anggota RT Berpenghasilan'),
('jumlah_anggota_rt_berhutang', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Jumlah Anggota RT Memiliki Hutang'),
('status_pekerjaan_pasangan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status Pekerjaan Pasangan'),
('penghasilan_pasangan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Penghasilan Bulanan Pasangan'),
('total_penghasilan_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Total Penghasilan Rumah Tangga'),
('total_pengeluaran_rt', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Total Pengeluaran Rumah Tangga'),

-- 5. Pendidikan & Sosial
('pendidikan_terakhir', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Pendidikan Terakhir'),
('jurusan_pendidikan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jurusan Pendidikan'),
('sertifikasi_profesi', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Sertifikasi Profesi'),
('peran_sosial', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Peran Sosial di Masyarakat'),
('dikenal_lingkungan', 'PERSONAL', 'APPLICANT', 'BOOLEAN', false, 'Apakah Dikenal di Lingkungan Setempat'),

-- 6. Pekerjaan
('pekerjaan_status', 'PERSONAL', 'APPLICANT', 'STRING', true, 'Status Pekerjaan (Tetap/Kontrak/PNS)'),
('pekerjaan_nama_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama Perusahaan'),
('pekerjaan_industri', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Bidang Industri'),
('pekerjaan_alamat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Alamat Tempat Kerja'),
('pekerjaan_jabatan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jabatan/Posisi Pekerjaan'),
('pekerjaan_lama_bekerja', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Lama Bekerja (Tahun)'),
('pekerjaan_telp_perusahaan', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nomor Telepon Perusahaan'),
('pekerjaan_gaji_bersih', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Gaji Bersih Bulanan (THP)'),
('pekerjaan_penghasilan_lain', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Penghasilan Rutin Lainnya'),
('pekerjaan_metode_pembayaran', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Metode Pembayaran Gaji'),
('pekerjaan_status_verifikasi', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status Verifikasi Pekerjaan'),

-- 7. Usaha
('usaha_nama', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Nama Usaha'),
('usaha_jenis', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Jenis Usaha'),
('usaha_sektor', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Sektor Usaha'),
('usaha_lama_berusaha', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Lama Berusaha (Tahun)'),
('usaha_alamat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Alamat Usaha'),
('usaha_status_kepemilikan_tempat', 'PERSONAL', 'APPLICANT', 'STRING', false, 'Status Kepemilikan Tempat Usaha'),
('usaha_jumlah_karyawan', 'PERSONAL', 'APPLICANT', 'NUMBER', false, 'Jumlah Karyawan'),
('usaha_penghasilan_bulanan', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Penghasilan Bulanan Usaha (Omzet/Profit)'),

-- 8. Karakter & Perilaku
('karakter_persepsi_disiplin', 'BOTH', 'APPLICANT', 'STRING', true, 'Persepsi Kedisiplinan Bayar'),
('karakter_riwayat_gagal_bayar', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Riwayat Gagal Bayar Internal'),
('karakter_frekuensi_pindah_kerja', 'PERSONAL', 'APPLICANT', 'NUMBER', true, 'Frekuensi Pindah Kerja'),
('karakter_frekuensi_pindah_alamat', 'BOTH', 'APPLICANT', 'NUMBER', true, 'Frekuensi Pindah Alamat'),
('karakter_gaya_hidup_vs_penghasilan', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Gaya Hidup > Penghasilan'),
('karakter_indikasi_fraud', 'BOTH', 'APPLICANT', 'BOOLEAN', true, 'Indikasi Fraud');
