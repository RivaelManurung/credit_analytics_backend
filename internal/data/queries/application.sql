-- name: CreateApplication :one
INSERT INTO applications (
    applicant_id, product_id, ao_id, loan_amount, tenor_months, 
    interest_type, interest_rate, loan_purpose, application_channel, 
    status, branch_code, created_by
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
) RETURNING *;

-- name: GetApplication :one
SELECT * FROM applications WHERE id = $1 AND deleted_at IS NULL LIMIT 1;

-- name: ListApplications :many
SELECT * FROM applications WHERE deleted_at IS NULL;

-- name: UpdateApplication :one
UPDATE applications SET 
    applicant_id = $2, 
    product_id = $3, 
    ao_id = $4,
    loan_amount = $5,
    tenor_months = $6,
    interest_type = $7,
    interest_rate = $8,
    loan_purpose = $9,
    status = $10,
    updated_at = CURRENT_TIMESTAMP 
WHERE id = $1 RETURNING *;

-- name: SoftDeleteApplication :exec
UPDATE applications SET deleted_at = CURRENT_TIMESTAMP WHERE id = $1;

-- name: GetApplicationAttributes :many
SELECT * FROM application_attributes WHERE application_id = $1;

-- name: UpsertApplicationAttribute :one
INSERT INTO application_attributes (application_id, attr_key, attr_value, data_type)
VALUES ($1, $2, $3, $4)
ON CONFLICT (application_id, attr_key) DO UPDATE SET 
    attr_value = EXCLUDED.attr_value,
    data_type = EXCLUDED.data_type,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;

-- name: ListApplicationAttributesByIDs :many
SELECT * FROM application_attributes WHERE application_id = ANY($1::uuid[]);

-- name: DeleteApplicationAttributes :exec
DELETE FROM application_attributes WHERE application_id = $1;

-- name: CreateStatusLog :one
INSERT INTO application_status_logs (
    application_id, from_status, to_status, changed_by, change_reason
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: ListStatusLogs :many
SELECT * FROM application_status_logs WHERE application_id = $1 ORDER BY changed_at DESC;
