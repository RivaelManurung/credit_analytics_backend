-- +goose Up
INSERT INTO application_status_refs (
        status_code,
        status_group,
        is_terminal,
        description
    )
VALUES ('INTAKE', 'INTAKE', false, 'Input data awal'),
    (
        'SURVEY',
        'SURVEY',
        false,
        'Survey lapangan/desk survey'
    ),
    (
        'ANALYSIS',
        'ANALYSIS',
        false,
        'Analisa kelayakan kredit'
    ),
    (
        'COMMITTEE',
        'DECISION',
        false,
        'Sidang komite kredit'
    ),
    ('APPROVED', 'TERMINAL', true, 'Disetujui'),
    ('REJECTED', 'TERMINAL', true, 'Ditolak'),
    ('CANCELLED', 'TERMINAL', true, 'Dibatalkan');

-- +goose Down
DELETE FROM application_status_refs;
