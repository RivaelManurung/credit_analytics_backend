package biz

import "github.com/google/wire"

// ProviderSet is biz providers.
var ProviderSet = wire.NewSet(NewGreeterUsecase, NewApplicationUsecase, NewApplicantUsecase, NewReferenceUsecase, NewSurveyUsecase, NewFinancialUsecase, NewDecisionUsecase)
