-- name: ListFinancialFacts :many
SELECT * FROM application_financial_facts WHERE application_id = $1;

-- name: UpsertFinancialFact :one
INSERT INTO application_financial_facts (
    application_id, gl_code, period_type, period_label, amount, source, confidence_level
) VALUES ($1, $2, $3, $4, $5, $6, $7)
ON CONFLICT (application_id, gl_code, period_type, period_label) DO UPDATE SET
    amount = EXCLUDED.amount,
    source = EXCLUDED.source,
    confidence_level = EXCLUDED.confidence_level
RETURNING *;

-- name: CreateAsset :one
INSERT INTO application_assets (
    application_id, asset_type_code, asset_name, ownership_status, 
    acquisition_year, estimated_value, valuation_method, location_text, encumbered
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *;

-- name: ListAssets :many
SELECT * FROM application_assets WHERE application_id = $1;

-- name: CreateLiability :one
INSERT INTO application_liabilities (
    application_id, creditor_name, liability_type, outstanding_amount, 
    monthly_installment, interest_rate, maturity_date, source
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *;

-- name: ListLiabilities :many
SELECT * FROM application_liabilities WHERE application_id = $1;

-- name: UpsertFinancialRatio :one
INSERT INTO application_financial_ratios (
    application_id, ratio_code, ratio_value, calculation_version
) VALUES ($1, $2, $3, $4)
ON CONFLICT (application_id, ratio_code) DO UPDATE SET
    ratio_value = EXCLUDED.ratio_value,
    calculation_version = EXCLUDED.calculation_version,
    calculated_at = CURRENT_TIMESTAMP
RETURNING *;

-- name: ListGLAccounts :many
SELECT * FROM financial_gl_accounts;
