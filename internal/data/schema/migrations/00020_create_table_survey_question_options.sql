-- +goose Up
CREATE TABLE IF NOT EXISTS survey_question_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    question_id UUID REFERENCES survey_questions(id),
    option_value VARCHAR(255),
    option_label VARCHAR(255),
    sequence INT
);

-- +goose Down
DROP TABLE IF EXISTS survey_question_options CASCADE;
