-- +goose Up
CREATE TABLE IF NOT EXISTS attribute_categories (
    category_code VARCHAR(100) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    ui_icon VARCHAR(100),
    -- Lucide / Heroicons icon name
    display_order INT DEFAULT 0,
    description VARCHAR(255)
);

-- +goose Down
DROP TABLE IF EXISTS attribute_categories CASCADE;
