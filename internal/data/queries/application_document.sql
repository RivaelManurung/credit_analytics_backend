-- name: CreateApplicationDocument :one
INSERT INTO application_documents (
    id, application_id, document_name, file_url, document_type, uploaded_at
) VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: ListApplicationDocuments :many
SELECT * FROM application_documents
WHERE application_id = $1
ORDER BY uploaded_at DESC;

-- name: DeleteApplicationDocument :exec
DELETE FROM application_documents
WHERE id = $1;
