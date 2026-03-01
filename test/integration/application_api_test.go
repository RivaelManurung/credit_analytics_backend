package integration

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	applicationV1 "credit-analytics-backend/api/application/v1"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/service"

	"github.com/go-kratos/kratos/v2/log"
	khttp "github.com/go-kratos/kratos/v2/transport/http"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// Reuse biz mock from biz_test.go if available, or redefine
type mockRepo struct {
	mock.Mock
}

func (m *mockRepo) FindByID(ctx context.Context, id uuid.UUID) (*biz.Application, error) {
	args := m.Called(ctx, id)
	return args.Get(0).(*biz.Application), args.Error(1)
}
func (m *mockRepo) IsTerminalStatus(ctx context.Context, s string) (bool, error) {
	args := m.Called(ctx, s)
	return args.Bool(0), args.Error(1)
}
func (m *mockRepo) IsTransitionAllowed(ctx context.Context, pid uuid.UUID, f, t string) (bool, error) {
	args := m.Called(ctx, pid, f, t)
	return args.Bool(0), args.Error(1)
}
func (m *mockRepo) Update(ctx context.Context, a *biz.Application) error {
	return m.Called(ctx, a).Error(0)
}

// Stub remaining to satisfy interface
func (m *mockRepo) Save(ctx context.Context, a *biz.Application) (uuid.UUID, error) {
	return uuid.Nil, nil
}
func (m *mockRepo) List(ctx context.Context, p biz.PaginationParams, s string, aid uuid.UUID) (*biz.PaginatedList[*biz.Application], error) {
	return nil, nil
}
func (m *mockRepo) ListAll(ctx context.Context, l int32) ([]*biz.Application, error) { return nil, nil }
func (m *mockRepo) SaveParty(ctx context.Context, p *biz.Party) (uuid.UUID, error) {
	return uuid.Nil, nil
}
func (m *mockRepo) AddPartyToApplication(ctx context.Context, aid, pid uuid.UUID, r string, s bool) error {
	return nil
}
func (m *mockRepo) GetParties(ctx context.Context, aid uuid.UUID) ([]biz.ApplicationParty, error) {
	return nil, nil
}
func (m *mockRepo) ListAvailableAOs(ctx context.Context, b string) ([]uuid.UUID, error) {
	return nil, nil
}
func (m *mockRepo) GetInitialStatus(ctx context.Context, pid uuid.UUID) (string, error) {
	return "", nil
}
func (m *mockRepo) SaveDocument(ctx context.Context, d *biz.ApplicationDocument) error { return nil }
func (m *mockRepo) ListDocuments(ctx context.Context, aid uuid.UUID) ([]biz.ApplicationDocument, error) {
	return nil, nil
}

func TestApplicationAPI_Integration(t *testing.T) {
	// 1. Setup Mock & Usecase
	repo := new(mockRepo)
	uc := biz.NewApplicationUsecase(repo, nil, log.DefaultLogger)
	svc := service.NewApplicationService(uc)

	// 2. Setup Kratos HTTP Server
	srv := khttp.NewServer()
	applicationV1.RegisterApplicationServiceHTTPServer(srv, svc)

	t.Run("API Endpoint - Change Status Flow", func(t *testing.T) {
		appID := uuid.New()
		prodID := uuid.New()

		// Expected domain behavior
		app := &biz.Application{ID: appID, ProductID: prodID, Status: biz.StatusIntake}
		repo.On("FindByID", mock.Anything, appID).Return(app, nil)
		repo.On("IsTerminalStatus", mock.Anything, "INTAKE").Return(false, nil)
		repo.On("IsTransitionAllowed", mock.Anything, prodID, "INTAKE", "SURVEY").Return(true, nil)
		repo.On("Update", mock.Anything, mock.Anything).Return(nil)

		// API Request
		payload := map[string]interface{}{
			"new_status": "SURVEY",
		}
		body, _ := json.Marshal(payload)
		url := "/v1/applications/" + appID.String() + "/status"

		req := httptest.NewRequest("PUT", url, bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		srv.ServeHTTP(resp, req)

		// Assertions
		assert.Equal(t, http.StatusOK, resp.Code)

		var result map[string]interface{}
		json.Unmarshal(resp.Body.Bytes(), &result)
		assert.Equal(t, "SURVEY", result["status"])

		repo.AssertExpectations(t)
	})
}
