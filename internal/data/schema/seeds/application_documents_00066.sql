-- +goose Up
INSERT INTO application_documents (
        application_id,
        document_name,
        file_url,
        document_type
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        'KTP_Budi.pdf',
        'https://storage.cloud/docs/ktp_budi.pdf',
        'KTP'
    ),
    (
        '0195a1a2-0001-7000-bb34-000000000001',
        'NPWP_Budi.pdf',
        'https://storage.cloud/docs/npwp_budi.pdf',
        'NPWP'
    );

-- +goose Down
DELETE FROM application_documents;
