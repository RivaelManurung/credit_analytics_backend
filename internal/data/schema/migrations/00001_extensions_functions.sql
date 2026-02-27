-- +goose Up
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION uuid_generate_v7() RETURNS uuid AS $$
DECLARE v_unix_t BIGINT;
v_uuid_bytes BYTEA;
BEGIN v_unix_t := (
    EXTRACT(
        EPOCH
        FROM NOW()
    ) * 1000
)::BIGINT;
v_uuid_bytes := decode(lpad(to_hex(v_unix_t), 12, '0'), 'hex') || gen_random_bytes(10);
v_uuid_bytes := set_byte(
    v_uuid_bytes,
    6,
    (get_byte(v_uuid_bytes, 6) & 15) | 112
);
v_uuid_bytes := set_byte(
    v_uuid_bytes,
    8,
    (get_byte(v_uuid_bytes, 8) & 63) | 128
);
RETURN encode(v_uuid_bytes, 'hex')::uuid;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- +goose Down
DROP FUNCTION IF EXISTS uuid_generate_v7();
DROP EXTENSION IF EXISTS "pgcrypto";
DROP EXTENSION IF EXISTS "uuid-ossp";