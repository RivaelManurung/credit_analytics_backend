-- name: CreateApplicant :one
INSERT INTO applicants (
        applicant_type,
        identity_number,
        tax_id,
        full_name,
        birth_date,
        establishment_date,
        created_by
    )
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;
-- name: GetApplicant :one
SELECT *
FROM applicants
WHERE id = $1
LIMIT 1;
-- name: UpdateApplicant :one
UPDATE applicants
SET applicant_type = $2,
    identity_number = $3,
    tax_id = $4,
    full_name = $5,
    birth_date = $6,
    establishment_date = $7
WHERE id = $1
RETURNING *;
-- name: UpsertApplicantAttribute :one
INSERT INTO applicant_attributes (
        applicant_id,
        attribute_id,
        attribute_option_id,
        attr_value,
        data_type
    )
VALUES ($1, $2, $3, $4, $5) ON CONFLICT (applicant_id, attribute_id) DO
UPDATE
SET attribute_option_id = EXCLUDED.attribute_option_id,
    attr_value = EXCLUDED.attr_value,
    data_type = EXCLUDED.data_type,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;
-- name: ListApplicants :many
SELECT *
FROM applicants
WHERE (
        (
            sqlc.narg('cursor_created_at')::timestamp IS NULL
            AND sqlc.narg('cursor_id')::uuid IS NULL
        )
        OR (created_at, id) < (
            sqlc.narg('cursor_created_at')::timestamp,
            sqlc.narg('cursor_id')::uuid
        )
    )
ORDER BY created_at DESC,
    id DESC
LIMIT $1;
-- name: GetApplicantAttributes :many
SELECT *
FROM applicant_attributes
WHERE applicant_id = $1;
-- name: ListApplicantAttributesByIDs :many
SELECT *
FROM applicant_attributes
WHERE applicant_id = ANY($1::text[]::uuid[]);
-- name: DeleteApplicantAttributes :exec
DELETE FROM applicant_attributes
WHERE applicant_id = $1;