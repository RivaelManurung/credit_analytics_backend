-- +goose Up
INSERT INTO application_parties (
        application_id,
        party_id,
        role_code,
        legal_obligation,
        slik_required
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        '0195a1a2-0002-7000-bb34-000000000001',
        'SPOUSE',
        true,
        true
    );

-- +goose Down
DELETE FROM application_parties;
