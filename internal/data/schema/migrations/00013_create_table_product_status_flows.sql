-- +goose Up
CREATE TABLE IF NOT EXISTS product_status_flows (
    product_id UUID REFERENCES loan_products(id),
    from_status VARCHAR(50) REFERENCES application_status_refs(status_code),
    to_status VARCHAR(50) REFERENCES application_status_refs(status_code),
    is_default BOOLEAN DEFAULT FALSE,
    requires_role VARCHAR(20),
    -- AO | ANALYST | COMMITTEE | SYSTEM
    PRIMARY KEY (product_id, from_status, to_status)
);

-- +goose Down
DROP TABLE IF EXISTS product_status_flows CASCADE;
