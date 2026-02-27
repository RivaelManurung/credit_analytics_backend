-- +goose Up
INSERT INTO survey_questions (id, section_id, question_code, question_text, answer_type, sequence, is_mandatory)
VALUES 
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000001', 'Q_UM_1', 'Kondisi bangunan rumah?', 'SELECT', 1, true),
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000001', 'Q_UM_2', 'Apakah terdapat akses mobil ke lokasi?', 'BOOLEAN', 2, true),
  (uuid_generate_v7(), '22222222-2222-2222-2222-200000000001', 'Q_UM_3', 'Jumlah lantai bangunan?', 'NUMBER', 3, false);

-- +goose Down
DELETE FROM survey_questions;
