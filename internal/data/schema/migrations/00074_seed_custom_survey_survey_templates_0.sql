-- +goose Up
INSERT INTO survey_templates (id, template_code, template_name, applicant_type, active) 
VALUES 
  ('11111111-1111-1111-1111-100000000001', 'TPL_KPR_NEW', 'Survei Calon Nasabah KPR Baru', 'PERSONAL', true);

-- +goose Down
DELETE FROM survey_templates;
