-- +goose Up
INSERT INTO survey_question_options (id, question_id, option_value, option_label, sequence)
VALUES 
  (uuid_generate_v7(), (SELECT id FROM survey_questions WHERE question_code = 'Q_UM_1'), 'PERMANENT', 'Permanen (Batu Bata/Cor)', 1),
  (uuid_generate_v7(), (SELECT id FROM survey_questions WHERE question_code = 'Q_UM_1'), 'SEMI_PERMANENT', 'Semi Permanen', 2),
  (uuid_generate_v7(), (SELECT id FROM survey_questions WHERE question_code = 'Q_UM_1'), 'NON_PERMANENT', 'Tidak Permanen (Kayu/Triplek)', 3);

-- +goose Down
DELETE FROM survey_question_options;
