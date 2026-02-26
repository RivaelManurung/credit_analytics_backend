-- name: CreateApplication :one
INSERT INTO applications (
        applicant_id,
        product_id,
        ao_id,
        loan_amount,
        tenor_months,
        interest_type,
        interest_rate,
        loan_purpose,
        application_channel,
        status,
        branch_code,
        created_by
    )
VALUES (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12
    )
RETURNING *;
-- name: GetApplication :one
SELECT a.*,
    app.full_name AS applicant_name
FROM applications a
    JOIN applicants app ON a.applicant_id = app.id
WHERE a.id = $1
LIMIT 1;
-- name: ListApplications :many
SELECT a.*,
    app.full_name AS applicant_name
FROM applications a
    JOIN applicants app ON a.applicant_id = app.id
WHERE (
        sqlc.narg('status')::text IS NULL
        OR a.status = sqlc.narg('status')
    )
    AND (
        sqlc.narg('applicant_id')::uuid IS NULL
        OR a.applicant_id = sqlc.narg('applicant_id')
    )
    AND (
        (
            sqlc.narg('cursor_created_at')::timestamp IS NULL
            AND sqlc.narg('cursor_id')::uuid IS NULL
        )
        OR (a.created_at, a.id) < (
            sqlc.narg('cursor_created_at')::timestamp,
            sqlc.narg('cursor_id')::uuid
        )
    )
ORDER BY a.created_at DESC,
    a.id DESC
LIMIT $1;
-- name: UpdateApplication :one
UPDATE applications
SET applicant_id = $2,
    product_id = $3,
    ao_id = $4,
    loan_amount = $5,
    tenor_months = $6,
    interest_type = $7,
    interest_rate = $8,
    loan_purpose = $9,
    status = $10
WHERE id = $1
RETURNING *;
-- name: GetApplicationAttributes :many
SELECT *
FROM application_attributes
WHERE application_id = $1;
-- name: UpsertApplicationAttribute :one
INSERT INTO application_attributes (
        application_id,
        attribute_id,
        attribute_option_id,
        attr_value,
        data_type
    )
VALUES ($1, $2, $3, $4, $5) ON CONFLICT (application_id, attribute_id) DO
UPDATE
SET attribute_option_id = EXCLUDED.attribute_option_id,
    attr_value = EXCLUDED.attr_value,
    data_type = EXCLUDED.data_type,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;
-- name: ListApplicationAttributesByIDs :many
SELECT *
FROM application_attributes
WHERE application_id = ANY($1::uuid []);
-- name: DeleteApplicationAttributes :exec
DELETE FROM application_attributes
WHERE application_id = $1;
-- name: CreateStatusLog :one
INSERT INTO application_status_logs (
        application_id,
        from_status,
        to_status,
        changed_by,
        change_reason
    )
VALUES ($1, $2, $3, $4, $5)
RETURNING *;
-- name: ListStatusLogs :many
SELECT *
FROM application_status_logs
WHERE application_id = $1
ORDER BY changed_at DESC;
-- name: CreateParty :one
INSERT INTO parties (
        party_type,
        identifier,
        name,
        date_of_birth
    )
VALUES ($1, $2, $3, $4)
RETURNING *;
-- name: CreateApplicationParty :one
INSERT INTO application_parties (
        application_id,
        party_id,
        role_code,
        legal_obligation,
        slik_required
    )
VALUES ($1, $2, $3, $4, $5)
RETURNING *;
-- name: GetPartiesByApplication :many
SELECT p.*,
    ap.role_code,
    ap.legal_obligation,
    ap.slik_required
FROM parties p
    JOIN application_parties ap ON p.id = ap.party_id
WHERE ap.application_id = $1;