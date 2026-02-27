-- +goose Up
INSERT INTO application_status_logs (
        application_id,
        from_status,
        to_status,
        change_reason,
        changed_at
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        NULL,
        'INTAKE',
        'Pendaftaran baru via CRM',
        CURRENT_TIMESTAMP - interval '2 days 5 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'INTAKE',
        'SURVEY',
        'Dokumen lengkap, lanjut survey lapangan',
        CURRENT_TIMESTAMP - interval '2 days 1 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'SURVEY',
        'ANALYSIS',
        'Survey selesai, masuk tahap analisa kredit',
        CURRENT_TIMESTAMP - interval '1 days 20 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000002',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Walk-in',
        CURRENT_TIMESTAMP - interval '2 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Mobile App',
        CURRENT_TIMESTAMP - interval '1 days 10 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000003',
        'INTAKE',
        'SURVEY',
        'Verifikasi telepon berhasil, lanjut survey',
        CURRENT_TIMESTAMP - interval '1 days 2 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000004',
        NULL,
        'INTAKE',
        'Aplikasi masuk via Website',
        CURRENT_TIMESTAMP - interval '5 hours'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        NULL,
        'INTAKE',
        'Pendaftaran baru via Cabang',
        CURRENT_TIMESTAMP - interval '4 days'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000005',
        'SURVEY',
        'ANALYSIS',
        'Data finansial sudah lengkap',
        CURRENT_TIMESTAMP - interval '3 days'
    );

-- +goose Down
DELETE FROM application_status_logs;
