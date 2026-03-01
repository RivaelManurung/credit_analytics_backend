-- +goose Up
INSERT INTO application_assets (
        application_id,
        asset_type_code,
        asset_name,
        ownership_status,
        estimated_value
    )
VALUES (
        '0195a1a2-0001-7000-bb34-000000000001',
        'LAND_BUILDING',
        'Rumah Tinggal Kebon Jeruk',
        'OWNED',
        1500000000
    );

-- +goose Down
DELETE FROM application_assets;
