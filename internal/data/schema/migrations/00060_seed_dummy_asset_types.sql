-- +goose Up
INSERT INTO asset_types (asset_type_code, asset_category, description)
VALUES (
        'LAND_BUILDING',
        'PROPERTY',
        'Tanah dan Bangunan'
    ),
    ('VEHICLE_CAR', 'VEHICLE', 'Kendaraan Roda 4');

-- +goose Down
DELETE FROM asset_types;
