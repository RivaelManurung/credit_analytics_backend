-- +goose Up
CREATE TABLE IF NOT EXISTS application_status_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID NOT NULL REFERENCES applications(id),
    from_status VARCHAR(50),
    to_status VARCHAR(50),
    changed_by UUID,
    change_reason VARCHAR(255),
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE IF EXISTS application_status_logs CASCADE;
