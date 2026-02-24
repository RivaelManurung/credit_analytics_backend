-- name: ListLoanProducts :many
SELECT * FROM loan_products WHERE active = TRUE;

-- name: GetLoanProduct :one
SELECT * FROM loan_products WHERE id = $1;

-- name: ListBranches :many
SELECT * FROM branches;

-- name: ListLoanOfficers :many
SELECT * FROM loan_officers WHERE branch_code = $1;

-- name: ListApplicationStatuses :many
SELECT * FROM application_status_refs;

-- name: ListFinancialGLAccounts :many
SELECT * FROM financial_gl_accounts;

-- name: ListAttributeRegistry :many
SELECT * FROM custom_column_attribute_registries ORDER BY category, attribute_code;

-- name: CreateAttributeRegistry :exec
INSERT INTO custom_column_attribute_registries (
    attribute_code, applies_to, scope, value_type, category, is_required, risk_relevant, description, ui_icon, ui_label
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
);

-- name: UpdateAttributeRegistry :exec
UPDATE custom_column_attribute_registries SET
    applies_to = $2,
    scope = $3,
    value_type = $4,
    category = $5,
    is_required = $6,
    risk_relevant = $7,
    description = $8,
    ui_icon = $9,
    ui_label = $10
WHERE attribute_code = $1;
