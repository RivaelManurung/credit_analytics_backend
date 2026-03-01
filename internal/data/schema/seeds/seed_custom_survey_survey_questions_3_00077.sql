-- +goose Up
INSERT INTO survey_questions (id, section_id, question_code, question_text, answer_type, sequence, is_mandatory)
VALUES 
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000002', 'Q_FIN_1', 'Rata-rata penghasilan/omset per bulan (Rp)?', 'NUMBER', 1, true),
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000002', 'Q_FIN_2', 'Estimasi pengeluaran rutin per bulan (Rp)?', 'NUMBER', 2, true),
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000002', 'Q_FIN_3', 'Sebutkan jenis usaha atau bidang pekerjaan detail?', 'TEXT', 3, false);

-- +goose Down
DELETE FROM survey_questions;
