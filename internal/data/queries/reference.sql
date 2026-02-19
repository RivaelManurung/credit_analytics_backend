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
