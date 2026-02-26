-- name: ListLoanProducts :many
SELECT *
FROM loan_products
WHERE active = TRUE;
-- name: GetLoanProduct :one
SELECT *
FROM loan_products
WHERE id = $1;
-- name: ListBranches :many
SELECT *
FROM branches;
-- name: ListLoanOfficers :many
SELECT *
FROM loan_officers
WHERE branch_code = $1;
-- name: ListApplicationStatuses :many
SELECT *
FROM application_status_refs;
-- name: ListFinancialGLAccounts :many
SELECT *
FROM financial_gl_accounts;
-- ==============================================================
-- ATTRIBUTE CATEGORIES (dinamis: icon ada di sini)
-- ==============================================================
-- name: ListAttributeCategories :many
SELECT category_code,
    category_name,
    ui_icon,
    display_order,
    description
FROM attribute_categories
ORDER BY display_order,
    category_code;
-- name: GetAttributeCategory :one
SELECT category_code,
    category_name,
    ui_icon,
    display_order,
    description
FROM attribute_categories
WHERE category_code = $1;
-- name: CreateAttributeCategory :exec
INSERT INTO attribute_categories (
        category_code,
        category_name,
        ui_icon,
        display_order,
        description
    )
VALUES ($1, $2, $3, $4, $5);
-- name: UpdateAttributeCategory :exec
UPDATE attribute_categories
SET category_name = $2,
    ui_icon = $3,
    display_order = $4,
    description = $5
WHERE category_code = $1;
-- name: DeleteAttributeCategory :exec
DELETE FROM attribute_categories
WHERE category_code = $1;
-- ==============================================================
-- ATTRIBUTE REGISTRIES (category_code = FK, icon tidak di sini)
-- ==============================================================
-- name: ListAttributeRegistry :many
SELECT r.attribute_code,
    r.applies_to,
    r.scope,
    r.value_type,
    r.category_code,
    r.ui_label,
    r.is_required,
    r.risk_relevant,
    r.description,
    c.category_name,
    c.ui_icon AS category_icon
FROM custom_column_attribute_registries r
    LEFT JOIN attribute_categories c ON r.category_code = c.category_code
ORDER BY c.display_order,
    r.attribute_code;
-- name: ListAttributeRegistryByCategory :many
SELECT r.attribute_code,
    r.applies_to,
    r.scope,
    r.value_type,
    r.category_code,
    r.ui_label,
    r.is_required,
    r.risk_relevant,
    r.description,
    c.category_name,
    c.ui_icon AS category_icon
FROM custom_column_attribute_registries r
    LEFT JOIN attribute_categories c ON r.category_code = c.category_code
WHERE r.category_code = $1
ORDER BY r.attribute_code;
-- name: CreateAttributeRegistry :exec
INSERT INTO custom_column_attribute_registries (
        attribute_code,
        applies_to,
        scope,
        value_type,
        category_code,
        ui_label,
        is_required,
        risk_relevant,
        description
    )
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);
-- name: UpdateAttributeRegistry :exec
UPDATE custom_column_attribute_registries
SET applies_to = $2,
    scope = $3,
    value_type = $4,
    category_code = $5,
    ui_label = $6,
    is_required = $7,
    risk_relevant = $8,
    description = $9
WHERE attribute_code = $1;
-- name: DeleteAttributeRegistry :exec
DELETE FROM custom_column_attribute_registries
WHERE attribute_code = $1;
-- ==============================================================
-- ATTRIBUTE OPTIONS
-- ==============================================================
-- name: ListAttributeOptions :many
SELECT id,
    attribute_code,
    option_value,
    option_label,
    display_order,
    is_active
FROM attribute_options
WHERE is_active = TRUE
ORDER BY attribute_code,
    display_order;
-- name: ListAttributeOptionsByAttribute :many
SELECT id,
    attribute_code,
    option_value,
    option_label,
    display_order,
    is_active
FROM attribute_options
WHERE attribute_code = $1
    AND is_active = TRUE
ORDER BY display_order;