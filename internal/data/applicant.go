package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/data/db"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/uuid"
)

type applicantCursorData struct {
	CreatedAt time.Time `json:"t"`
	ID        uuid.UUID `json:"i"`
}

func encodeApplicantCursor(t time.Time, id uuid.UUID) string {
	data, _ := json.Marshal(applicantCursorData{CreatedAt: t, ID: id})
	return base64.StdEncoding.EncodeToString(data)
}

func decodeApplicantCursor(s string) (time.Time, uuid.UUID, error) {
	if s == "" {
		return time.Time{}, uuid.Nil, nil
	}
	data, err := base64.StdEncoding.DecodeString(s)
	if err != nil {
		return time.Time{}, uuid.Nil, err
	}
	var c applicantCursorData
	if err := json.Unmarshal(data, &c); err != nil {
		return time.Time{}, uuid.Nil, err
	}
	return c.CreatedAt, c.ID, nil
}

type applicantRepo struct {
	data *Data
	log  *log.Helper
}

// NewApplicantRepo .
func NewApplicantRepo(data *Data, logger log.Logger) biz.ApplicantRepo {
	return &applicantRepo{
		data: data,
		log:  log.NewHelper(logger),
	}
}

func (r *applicantRepo) Save(ctx context.Context, a *biz.Applicant) (uuid.UUID, error) {
	err := r.data.InTx(ctx, func(q *db.Queries) error {
		applicant, err := q.CreateApplicant(ctx, db.CreateApplicantParams{
			ApplicantType:     a.ApplicantType,
			IdentityNumber:    sql.NullString{String: a.IdentityNumber, Valid: a.IdentityNumber != ""},
			TaxID:             sql.NullString{String: a.TaxID, Valid: a.TaxID != ""},
			FullName:          sql.NullString{String: a.FullName, Valid: a.FullName != ""},
			BirthDate:         sql.NullTime{Time: a.BirthDate, Valid: !a.BirthDate.IsZero()},
			EstablishmentDate: sql.NullTime{Time: a.EstablishmentDate, Valid: !a.EstablishmentDate.IsZero()},
			CreatedBy:         uuid.NullUUID{UUID: a.CreatedBy, Valid: a.CreatedBy != uuid.Nil},
		})
		if err != nil {
			return err
		}
		a.ID = applicant.ID
		for _, attr := range a.Attributes {
			_, err = q.UpsertApplicantAttribute(ctx, db.UpsertApplicantAttributeParams{
				ApplicantID: applicant.ID,
				AttrKey:     attr.Key,
				AttrValue:   sql.NullString{String: attr.Value, Valid: true},
				DataType:    sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return uuid.Nil, err
	}
	return a.ID, nil
}

func (r *applicantRepo) Update(ctx context.Context, a *biz.Applicant) error {
	return r.data.InTx(ctx, func(q *db.Queries) error {
		_, err := q.UpdateApplicant(ctx, db.UpdateApplicantParams{
			ID:                a.ID,
			ApplicantType:     a.ApplicantType,
			IdentityNumber:    sql.NullString{String: a.IdentityNumber, Valid: a.IdentityNumber != ""},
			TaxID:             sql.NullString{String: a.TaxID, Valid: a.TaxID != ""},
			FullName:          sql.NullString{String: a.FullName, Valid: a.FullName != ""},
			BirthDate:         sql.NullTime{Time: a.BirthDate, Valid: !a.BirthDate.IsZero()},
			EstablishmentDate: sql.NullTime{Time: a.EstablishmentDate, Valid: !a.EstablishmentDate.IsZero()},
		})
		if err != nil {
			return err
		}

		for _, attr := range a.Attributes {
			_, err = q.UpsertApplicantAttribute(ctx, db.UpsertApplicantAttributeParams{
				ApplicantID: a.ID,
				AttrKey:     attr.Key,
				AttrValue:   sql.NullString{String: attr.Value, Valid: true},
				DataType:    sql.NullString{String: attr.DataType, Valid: true},
			})
			if err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *applicantRepo) FindByID(ctx context.Context, id uuid.UUID) (*biz.Applicant, error) {
	applicant, err := r.data.db.GetApplicant(ctx, id)
	if err != nil {
		return nil, err
	}

	res := mapApplicantToBiz(&applicant)

	attrs, err := r.data.db.GetApplicantAttributes(ctx, id)
	if err == nil {
		for _, attr := range attrs {
			res.Attributes = append(res.Attributes, biz.ApplicantAttribute{
				Key:      attr.AttrKey,
				Value:    attr.AttrValue.String,
				DataType: attr.DataType.String,
			})
		}
	} else if err != sql.ErrNoRows {
		return nil, err
	}

	return res, nil
}

func (r *applicantRepo) List(ctx context.Context, params biz.PaginationParams) (*biz.PaginatedList[*biz.Applicant], error) {
	limit := params.PageSize
	if limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	cursorTime, cursorID, err := decodeApplicantCursor(params.Cursor)
	if err != nil {
		return nil, fmt.Errorf("invalid cursor: %w", err)
	}

	arg := db.ListApplicantsParams{
		Limit: limit + 1,
	}
	if !cursorTime.IsZero() && cursorID != uuid.Nil {
		arg.CursorCreatedAt = sql.NullTime{Time: cursorTime, Valid: true}
		arg.CursorID = uuid.NullUUID{UUID: cursorID, Valid: true}
	}

	applicants, err := r.data.db.ListApplicants(ctx, arg)
	if err != nil {
		return nil, err
	}

	r.log.Infof("SQL ListApplicants found %d items", len(applicants))

	hasNext := false
	if len(applicants) > int(limit) {
		hasNext = true
		applicants = applicants[:limit]
	}

	if len(applicants) == 0 {
		return &biz.PaginatedList[*biz.Applicant]{Items: []*biz.Applicant{}, HasNext: false}, nil
	}

	ids := make([]uuid.UUID, len(applicants))
	for i, a := range applicants {
		ids[i] = a.ID
	}

	attrMap, err := r.batchGetAttributes(ctx, ids)
	if err != nil {
		return nil, err
	}

	var res []*biz.Applicant
	for _, a := range applicants {
		item := mapApplicantToBiz(&a)
		item.Attributes = attrMap[a.ID]
		res = append(res, item)
	}

	nextCursor := ""
	if hasNext && len(res) > 0 {
		last := res[len(res)-1]
		nextCursor = encodeApplicantCursor(last.CreatedAt, last.ID)
	}

	return &biz.PaginatedList[*biz.Applicant]{
		Items:      res,
		HasNext:    hasNext,
		NextCursor: nextCursor,
	}, nil
}

func (r *applicantRepo) ListAll(ctx context.Context) ([]*biz.Applicant, error) {
	applicants, err := r.data.db.ListApplicants(ctx, db.ListApplicantsParams{Limit: 1000})
	if err != nil {
		return nil, err
	}
	// ... mapper logic
	var res []*biz.Applicant
	for _, a := range applicants {
		res = append(res, mapApplicantToBiz(&a))
	}
	return res, nil
}

func (r *applicantRepo) batchGetAttributes(ctx context.Context, ids []uuid.UUID) (map[uuid.UUID][]biz.ApplicantAttribute, error) {
	attrs, err := r.data.db.ListApplicantAttributesByIDs(ctx, ids)
	if err != nil {
		return nil, err
	}

	res := make(map[uuid.UUID][]biz.ApplicantAttribute)
	for _, attr := range attrs {
		res[attr.ApplicantID] = append(res[attr.ApplicantID], biz.ApplicantAttribute{
			Key:      attr.AttrKey,
			Value:    attr.AttrValue.String,
			DataType: attr.DataType.String,
		})
	}
	return res, nil
}

func mapApplicantToBiz(a *db.Applicant) *biz.Applicant {
	return &biz.Applicant{
		ID:                a.ID,
		ApplicantType:     a.ApplicantType,
		IdentityNumber:    a.IdentityNumber.String,
		TaxID:             a.TaxID.String,
		FullName:          a.FullName.String,
		BirthDate:         a.BirthDate.Time,
		EstablishmentDate: a.EstablishmentDate.Time,
		CreatedBy:         a.CreatedBy.UUID,
		CreatedAt:         a.CreatedAt.Time,
	}
}
