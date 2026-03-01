package biz

import (
	"context"
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockApplicationRepo implements biz.ApplicationRepo for testing
type MockApplicationRepo struct {
	mock.Mock
}

func (m *MockApplicationRepo) Save(ctx context.Context, a *Application) (uuid.UUID, error) {
	args := m.Called(ctx, a)
	return args.Get(0).(uuid.UUID), args.Error(1)
}

func (m *MockApplicationRepo) Update(ctx context.Context, a *Application) error {
	args := m.Called(ctx, a)
	return args.Error(0)
}

func (m *MockApplicationRepo) FindByID(ctx context.Context, id uuid.UUID) (*Application, error) {
	args := m.Called(ctx, id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*Application), args.Error(1)
}

func (m *MockApplicationRepo) IsTerminalStatus(ctx context.Context, status string) (bool, error) {
	args := m.Called(ctx, status)
	return args.Bool(0), args.Error(1)
}

func (m *MockApplicationRepo) IsTransitionAllowed(ctx context.Context, productID uuid.UUID, from, to string) (bool, error) {
	args := m.Called(ctx, productID, from, to)
	return args.Bool(0), args.Error(1)
}

func (m *MockApplicationRepo) GetInitialStatus(ctx context.Context, productID uuid.UUID) (string, error) {
	args := m.Called(ctx, productID)
	return args.String(0), args.Error(1)
}

// Satisfy Remaining interface methods
func (m *MockApplicationRepo) List(ctx context.Context, params PaginationParams, status string, applicantID uuid.UUID) (*PaginatedList[*Application], error) {
	return nil, nil
}
func (m *MockApplicationRepo) ListAll(ctx context.Context, limit int32) ([]*Application, error) {
	return nil, nil
}
func (m *MockApplicationRepo) SaveParty(ctx context.Context, p *Party) (uuid.UUID, error) {
	return uuid.Nil, nil
}
func (m *MockApplicationRepo) AddPartyToApplication(ctx context.Context, appID uuid.UUID, partyID uuid.UUID, role string, slikRequired bool) error {
	return nil
}
func (m *MockApplicationRepo) GetParties(ctx context.Context, appID uuid.UUID) ([]ApplicationParty, error) {
	return nil, nil
}
func (m *MockApplicationRepo) ListAvailableAOs(ctx context.Context, branchCode string) ([]uuid.UUID, error) {
	return nil, nil
}
func (m *MockApplicationRepo) SaveDocument(ctx context.Context, doc *ApplicationDocument) error {
	return nil
}
func (m *MockApplicationRepo) ListDocuments(ctx context.Context, appID uuid.UUID) ([]ApplicationDocument, error) {
	return nil, nil
}

func TestApplicationUsecase_ChangeStatus(t *testing.T) {
	repo := new(MockApplicationRepo)
	uc := NewApplicationUsecase(repo, nil, nil) // log placeholder

	appID := uuid.New()
	prodID := uuid.New()
	ctx := context.Background()

	t.Run("Successfully Change Status", func(t *testing.T) {
		t.Logf("Starting Test: Successfully Change Status from %s to SURVEY", StatusIntake)
		app := &Application{
			ID:        appID,
			ProductID: prodID,
			Status:    StatusIntake,
		}

		repo.On("FindByID", ctx, appID).Return(app, nil).Once()
		repo.On("IsTerminalStatus", ctx, "INTAKE").Return(false, nil).Once()
		repo.On("IsTransitionAllowed", ctx, prodID, "INTAKE", "SURVEY").Return(true, nil).Once()
		repo.On("Update", ctx, mock.Anything).Return(nil).Once()

		err := uc.ChangeStatus(ctx, appID, "SURVEY")
		assert.NoError(t, err)
		t.Logf("Success: Transition allowed and application updated to SURVEY")
		repo.AssertExpectations(t)
	})

	t.Run("Failed - Terminal State Locked", func(t *testing.T) {
		t.Logf("Starting Test: Attempting transition from Terminal Status %s", StatusApproved)
		app := &Application{
			ID:        appID,
			ProductID: prodID,
			Status:    StatusApproved,
		}

		repo.On("FindByID", ctx, appID).Return(app, nil).Once()
		repo.On("IsTerminalStatus", ctx, string(StatusApproved)).Return(true, nil).Once()

		err := uc.ChangeStatus(ctx, appID, "CANCELLED")
		assert.Error(t, err)
		t.Logf("Caught Expected Error: %v", err)
		assert.Contains(t, err.Error(), "locked")
		repo.AssertExpectations(t)
	})
}
