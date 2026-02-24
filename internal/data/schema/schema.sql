-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================
-- CORE TABLES
-- ==========================

-- Explicitly drop columns that were removed from schema to ensure live DB is synced
-- (Necessary because CREATE TABLE doesn't remove existing columns)
ALTER TABLE applicants DROP COLUMN IF EXISTS updated_at;
ALTER TABLE applicants DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE applications DROP COLUMN IF EXISTS updated_at;
ALTER TABLE applications DROP COLUMN IF EXISTS deleted_at;


CREATE TABLE applicants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    applicant_type VARCHAR(20) NOT NULL, -- personal | corporate
    identity_number VARCHAR(100),
    tax_id VARCHAR(100),
    full_name VARCHAR(255),
    birth_date DATE,
    establishment_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID
);

CREATE TABLE applicant_attributes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    applicant_id UUID NOT NULL REFERENCES applicants(id) ON DELETE CASCADE,
    attr_key VARCHAR(100) NOT NULL,
    attr_value TEXT,
    data_type VARCHAR(20),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (applicant_id, attr_key)
);

CREATE TABLE custom_column_attribute_registries (
    attribute_code VARCHAR(100) PRIMARY KEY,
    applies_to VARCHAR(20) NOT NULL, -- PERSONAL | CORPORATE | BOTH
    scope VARCHAR(20) NOT NULL,      -- APPLICANT | APPLICATION | BOTH
    value_type VARCHAR(20) NOT NULL, -- STRING | NUMBER | BOOLEAN | DATE
    category VARCHAR(100),           -- UI Grouping
    is_required BOOLEAN DEFAULT FALSE,
    risk_relevant BOOLEAN DEFAULT FALSE,
    description VARCHAR(255)
);


CREATE TABLE branches (
    branch_code VARCHAR(50) PRIMARY KEY,
    branch_name VARCHAR(255),
    region_code VARCHAR(50)
);

CREATE TABLE loan_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_code VARCHAR(100) UNIQUE,
    product_name VARCHAR(255),
    segment VARCHAR(20), -- RETAIL | UMKM | CORPORATE
    active BOOLEAN DEFAULT TRUE,
    assignment_mode VARCHAR(20) DEFAULT 'MANUAL' -- AUTO | CLAIM | MANUAL
);

CREATE TABLE loan_officers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    officer_code VARCHAR(100) UNIQUE,
    branch_code VARCHAR(50) NOT NULL REFERENCES branches(branch_code)
);

CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    applicant_id UUID NOT NULL REFERENCES applicants(id),
    product_id UUID NOT NULL REFERENCES loan_products(id),
    ao_id UUID NOT NULL REFERENCES loan_officers(id),
    loan_amount NUMERIC(20, 2),
    tenor_months INT,
    interest_type VARCHAR(20), -- FIXED | FLOATING
    interest_rate NUMERIC(10, 4),
    loan_purpose VARCHAR(255),
    application_channel VARCHAR(20), -- CRM | WALK_IN | WEBSITE | API
    status VARCHAR(50) NOT NULL,
    branch_code VARCHAR(50) NOT NULL REFERENCES branches(branch_code),
    submitted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID
);

CREATE TABLE application_attributes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    attr_key VARCHAR(100) NOT NULL,
    attr_value TEXT,
    data_type VARCHAR(20),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (application_id, attr_key)
);

CREATE TABLE application_status_refs (
    status_code VARCHAR(50) PRIMARY KEY,
    status_group VARCHAR(20), -- INTAKE | SURVEY | ANALYSIS | DECISION | TERMINAL
    is_terminal BOOLEAN DEFAULT FALSE,
    description VARCHAR(255)
);

CREATE TABLE product_status_flows (
    product_id UUID REFERENCES loan_products(id),
    from_status VARCHAR(50) REFERENCES application_status_refs(status_code),
    to_status VARCHAR(50) REFERENCES application_status_refs(status_code),
    is_default BOOLEAN DEFAULT FALSE,
    requires_role VARCHAR(20), -- AO | ANALYST | COMMITTEE | SYSTEM
    PRIMARY KEY (product_id, from_status, to_status)
);

CREATE TABLE application_status_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    from_status VARCHAR(50),
    to_status VARCHAR(50),
    changed_by UUID,
    change_reason VARCHAR(255),
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    party_type VARCHAR(20), -- PERSON | COMPANY
    identifier VARCHAR(100),
    name VARCHAR(255),
    date_of_birth DATE
);

CREATE TABLE application_parties (
    application_id UUID REFERENCES applications(id),
    party_id UUID REFERENCES parties(id),
    role_code VARCHAR(50), -- BORROWER | SPOUSE | GUARANTOR | DIRECTOR | COMMISSIONER | SHAREHOLDER
    legal_obligation BOOLEAN DEFAULT FALSE,
    slik_required BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (application_id, party_id, role_code)
);

-- ==========================
-- SURVEY TABLES
-- ==========================

CREATE TABLE survey_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_code VARCHAR(100) UNIQUE,
    template_name VARCHAR(255),
    applicant_type VARCHAR(20), -- personal | corporate | both
    product_id UUID REFERENCES loan_products(id),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE survey_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID REFERENCES survey_templates(id),
    section_code VARCHAR(100),
    section_name VARCHAR(255),
    sequence INT
);

CREATE TABLE survey_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID REFERENCES survey_sections(id),
    question_code VARCHAR(100),
    question_text VARCHAR(255),
    answer_type VARCHAR(20), -- TEXT | NUMBER | BOOLEAN | SELECT | DATE
    is_mandatory BOOLEAN DEFAULT FALSE,
    risk_relevant BOOLEAN DEFAULT FALSE,
    sequence INT
);

CREATE TABLE survey_question_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID REFERENCES survey_questions(id),
    option_value VARCHAR(255),
    option_label VARCHAR(255),
    sequence INT
);

CREATE TABLE application_surveys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID REFERENCES applications(id),
    template_id UUID REFERENCES survey_templates(id),
    survey_type VARCHAR(20), -- FIELD | DESK
    status VARCHAR(20),      -- ASSIGNED | IN_PROGRESS | SUBMITTED | VERIFIED
    submitted_by UUID,
    verified_by UUID,
    verified_at TIMESTAMP WITH TIME ZONE,
    assigned_to UUID,
    survey_purpose VARCHAR(50), -- GENERAL | COLLATERAL | MANAGEMENT
    started_at TIMESTAMP WITH TIME ZONE,
    submitted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE survey_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    survey_id UUID REFERENCES application_surveys(id),
    question_id UUID REFERENCES survey_questions(id),
    answer_text VARCHAR(255),
    answer_number NUMERIC(20, 2),
    answer_boolean BOOLEAN,
    answer_date DATE,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (survey_id, question_id)
);

CREATE TABLE survey_evidences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    survey_id UUID REFERENCES application_surveys(id),
    evidence_type VARCHAR(20), -- PHOTO | VIDEO | DOCUMENT
    file_url VARCHAR(255),
    description VARCHAR(255),
    captured_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE survey_data_mappings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES survey_questions(id),
    target_type VARCHAR(20) NOT NULL, -- GL | APPLICANT_ATTR | APPLICATION_ATTR
    target_code VARCHAR(100) NOT NULL,
    transform_rule VARCHAR(50)      -- DIRECT | SUM | AVG | BOOLEAN_MAP
);

-- ==========================
-- FINANCIAL TABLES
-- ==========================

CREATE TABLE financial_gl_accounts (
    gl_code VARCHAR(100) PRIMARY KEY,
    gl_name VARCHAR(255),
    statement_type VARCHAR(10) NOT NULL, -- PL | CF | BS
    category VARCHAR(20) NOT NULL,       -- REVENUE | EXPENSE | ASSET | LIABILITY | EQUITY | CASH_IN | CASH_OUT
    sign INT NOT NULL,                   -- 1 or -1
    is_debt_service BOOLEAN DEFAULT FALSE,
    is_operating BOOLEAN DEFAULT FALSE,
    description VARCHAR(255)
);

CREATE TABLE application_financial_facts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    gl_code VARCHAR(100) NOT NULL REFERENCES financial_gl_accounts(gl_code),
    period_type VARCHAR(10) NOT NULL, -- MONTHLY | YEARLY
    period_label VARCHAR(50) NOT NULL, -- 2025-01, 2025
    amount NUMERIC(20, 2) NOT NULL,
    source VARCHAR(20),               -- SURVEY | MANUAL | IMPORT
    confidence_level VARCHAR(10),     -- LOW | MEDIUM | HIGH
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (application_id, gl_code, period_type, period_label)
);

CREATE TABLE asset_types (
    asset_type_code VARCHAR(100) PRIMARY KEY,
    asset_category VARCHAR(20), -- VEHICLE | PROPERTY | INVENTORY | OTHER
    description VARCHAR(255)
);

CREATE TABLE application_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    asset_type_code VARCHAR(100) REFERENCES asset_types(asset_type_code),
    asset_name VARCHAR(255),
    ownership_status VARCHAR(20), -- OWNED | SPOUSE | JOINT
    acquisition_year INT,
    estimated_value NUMERIC(20, 2),
    valuation_method VARCHAR(20), -- MARKET | NJOP | APPRAISAL
    location_text VARCHAR(255),
    encumbered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE application_liabilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    creditor_name VARCHAR(255),
    liability_type VARCHAR(20), -- BANK | KOPERASI | LEASING | INDIVIDUAL
    outstanding_amount NUMERIC(20, 2),
    monthly_installment NUMERIC(20, 2),
    interest_rate NUMERIC(10, 4),
    maturity_date DATE,
    source VARCHAR(20), -- SLIK | SURVEY | MANUAL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE application_financial_ratios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    ratio_code VARCHAR(50), -- DSR | IDIR | LTV | GPM | NPM
    ratio_value NUMERIC(10, 4),
    calculation_version VARCHAR(50),
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (application_id, ratio_code)
);

-- ==========================
-- COMMITTEE TABLES
-- ==========================

CREATE TABLE application_committee_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    session_sequence INT,
    status VARCHAR(20), -- SCHEDULED | IN_SESSION | COMPLETED | CANCELLED
    scheduled_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE credit_committee_members (
    committee_session_id UUID REFERENCES application_committee_sessions(id),
    user_id UUID,
    role VARCHAR(20), -- CHAIR | MEMBER | SECRETARY
    active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (committee_session_id, user_id)
);

CREATE TABLE application_committee_votes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    committee_session_id UUID NOT NULL REFERENCES application_committee_sessions(id),
    user_id UUID NOT NULL,
    vote VARCHAR(20), -- APPROVE | REJECT | CONDITIONAL
    vote_reason VARCHAR(255),
    voted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE application_committee_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    committee_session_id UUID NOT NULL REFERENCES application_committee_sessions(id),
    decision VARCHAR(20), -- APPROVED | REJECTED | CONDITIONAL
    decision_reason VARCHAR(255),
    approved_amount NUMERIC(20, 2),
    approved_tenor INT,
    approved_interest_rate NUMERIC(10, 4),
    requires_next_committee BOOLEAN DEFAULT FALSE,
    decided_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================
-- DECISION TABLES
-- ==========================

CREATE TABLE application_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id),
    decision VARCHAR(20),        -- APPROVED | REJECTED | CANCELLED
    decision_source VARCHAR(20), -- COMMITTEE | SYSTEM | OVERRIDE
    final_amount NUMERIC(20, 2),
    final_tenor INT,
    final_interest_rate NUMERIC(10, 4),
    decision_reason VARCHAR(255),
    decided_by UUID,
    decided_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE application_decision_conditions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_decision_id UUID NOT NULL REFERENCES application_decisions(id),
    condition_type VARCHAR(20), -- PRE_DISBURSEMENT | POST_DISBURSEMENT
    condition_text VARCHAR(255),
    mandatory BOOLEAN DEFAULT TRUE
);

CREATE TABLE credit_authority_matrices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    committee_level INT, -- 1=Branch, 2=Regional, 3=HO
    product_id UUID REFERENCES loan_products(id),
    max_amount NUMERIC(20, 2),
    max_tenor INT,
    requires_committee BOOLEAN DEFAULT TRUE
);

CREATE TABLE application_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    document_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    document_type VARCHAR(50), -- KTP, NPWP, KK, etc.
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
