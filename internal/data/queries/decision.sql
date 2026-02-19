-- name: CreateCommitteeSession :one
INSERT INTO application_committee_sessions (
    application_id, session_sequence, status, scheduled_at
) VALUES ($1, $2, 'SCHEDULED', $3) RETURNING *;

-- name: SubmitCommitteeVote :one
INSERT INTO application_committee_votes (
    committee_session_id, user_id, vote, vote_reason
) VALUES ($1, $2, $3, $4) RETURNING *;

-- name: FinalizeCommitteeDecision :one
INSERT INTO application_committee_decisions (
    committee_session_id, decision, decision_reason, approved_amount, 
    approved_tenor, approved_interest_rate, requires_next_committee
) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;

-- name: RecordFinalDecision :one
INSERT INTO application_decisions (
    application_id, decision, decision_source, final_amount, 
    final_tenor, final_interest_rate, decision_reason, decided_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *;

-- name: GetApplicationDecision :one
SELECT * FROM application_decisions WHERE application_id = $1 LIMIT 1;
