-- +goose Up
INSERT INTO survey_sections (id, template_id, section_code, section_name, sequence)
VALUES 
  -- Grup 1: Data Umum
  ('22222222-2222-2222-2222-200000000001', '11111111-1111-1111-1111-100000000001', 'SEC_KPR_UMUM', 'Data Umum', 1),
  -- Grup 2: Finansial 
  ('22222222-2222-2222-2222-200000000002', '11111111-1111-1111-1111-100000000001', 'SEC_KPR_FIN', 'Finansial & Usaha', 2);

-- +goose Down
DELETE FROM survey_sections;
