// Package grpcerr translates domain/biz errors into proper gRPC status errors.
package grpcerr

import (
	"credit-analytics-backend/internal/biz"
	"database/sql"
	"errors"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// From converts a domain error to a gRPC status error.
// Callers should use this in every service handler before returning an error.
func From(err error) error {
	if err == nil {
		return nil
	}

	// Domain-typed errors
	var notFound *biz.ErrNotFound
	if errors.As(err, &notFound) {
		return status.Error(codes.NotFound, err.Error())
	}

	var invalid *biz.ErrInvalidArgument
	if errors.As(err, &invalid) {
		return status.Error(codes.InvalidArgument, err.Error())
	}

	var conflict *biz.ErrConflict
	if errors.As(err, &conflict) {
		return status.Error(codes.FailedPrecondition, err.Error())
	}

	var locked *biz.ErrLocked
	if errors.As(err, &locked) {
		return status.Error(codes.FailedPrecondition, err.Error())
	}

	// sql.ErrNoRows → NotFound
	if errors.Is(err, sql.ErrNoRows) {
		return status.Errorf(codes.NotFound, "resource not found")
	}

	// Default: internal error (don't leak details for now we will leak it for debugging)
	return status.Errorf(codes.Internal, "internal server error: %v", err)
}
