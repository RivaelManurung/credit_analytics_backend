-- +goose Up
INSERT INTO survey_evidences (
        id,
        survey_id,
        evidence_type,
        file_url,
        description,
        captured_at
    )
VALUES (
        uuid_generate_v7(),
        '01951112-0001-7000-bb34-000000000001',
        'PHOTO',
        'https://storage.cloud/surveys/budi_house.jpg',
        'Foto Rumah Tampak Depan',
        CURRENT_TIMESTAMP - interval '1 days 23 hours'
    ),
    (
        uuid_generate_v7(),
        '01951112-0001-7000-bb34-000000000001',
        'PHOTO',
        'https://storage.cloud/surveys/budi_interview.jpg',
        'Foto Wawancara dengan Tetangga',
        CURRENT_TIMESTAMP - interval '1 days 22 hours 30 minutes'
    );

-- +goose Down
DELETE FROM survey_evidences;
