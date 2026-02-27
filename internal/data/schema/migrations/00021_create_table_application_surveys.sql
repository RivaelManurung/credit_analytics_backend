-- +goose Up
CREATE TABLE IF NOT EXISTS application_surveys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    application_id UUID REFERENCES applications(id),
    template_id UUID REFERENCES survey_templates(id),
    survey_type VARCHAR(20),
    -- FIELD | DESK
    status VARCHAR(20) DEFAULT 'UNASSIGNED',
    -- UNASSIGNED | ASSIGNED | IN_PROGRESS | SUBMITTED | VERIFIED
    submitted_by UUID,
    verified_by UUID,
    verified_at TIMESTAMP WITH TIME ZONE,
    assigned_to UUID,
    survey_purpose VARCHAR(50),
    -- GENERAL | COLLATERAL | MANAGEMENT
    started_at TIMESTAMP WITH TIME ZONE,
    submitted_at TIMESTAMP WITH TIME ZONE
);

-- +goose Down
DROP TABLE IF EXISTS application_surveys CASCADE;
