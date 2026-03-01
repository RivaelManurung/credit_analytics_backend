-- +goose Up
INSERT INTO branches (branch_code, branch_name, region_code)
VALUES ('JKT01', 'Jakarta Pusat Utama', 'REG01'),
    ('JKT02', 'Jakarta Selatan Prima', 'REG01'),
    ('SUB01', 'Surabaya Basuki Rahmat', 'REG03');

-- +goose Down
DELETE FROM branches;
