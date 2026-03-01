-- +goose Up
INSERT INTO parties (id, party_type, identifier, name, date_of_birth)
VALUES (
        '0195a1a2-0002-7000-bb34-000000000001',
        'PERSON',
        '3171010101920002',
        'Ani Wijaya',
        '1992-03-10'
    ),
    (
        '0195a1a2-0002-7000-bb34-000000000002',
        'PERSON',
        '3171010101950005',
        'Slamet Utomo',
        '1975-10-20'
    );

-- +goose Down
DELETE FROM parties;
