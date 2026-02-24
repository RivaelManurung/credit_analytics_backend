// Package validate provides lightweight input validation helpers for service handlers.
package validate

import (
	"credit-analytics-backend/internal/biz"
	"strings"

	"github.com/google/uuid"
)

// UUID validates and parses a UUID string.
// Returns biz.ErrInvalidArgument if the string is empty or not a valid UUID.
func UUID(field, value string) (uuid.UUID, error) {
	if strings.TrimSpace(value) == "" {
		return uuid.Nil, &biz.ErrInvalidArgument{Field: field, Message: "must not be empty"}
	}
	id, err := uuid.Parse(value)
	if err != nil {
		return uuid.Nil, &biz.ErrInvalidArgument{Field: field, Message: "must be a valid UUID"}
	}
	return id, nil
}

// OptionalUUID parses an optional UUID string.
// Returns uuid.Nil without error if empty.
func OptionalUUID(field, value string) (uuid.UUID, error) {
	if strings.TrimSpace(value) == "" {
		return uuid.Nil, nil
	}
	id, err := uuid.Parse(value)
	if err != nil {
		return uuid.Nil, &biz.ErrInvalidArgument{Field: field, Message: "must be a valid UUID if provided"}
	}
	return id, nil
}

// NotEmpty validates a required string field.
func NotEmpty(field, value string) error {
	if strings.TrimSpace(value) == "" {
		return &biz.ErrInvalidArgument{Field: field, Message: "must not be empty"}
	}
	return nil
}

// PageSize validates and normalizes a page size value.
// Returns defaultSize if 0, caps at maxSize.
func PageSize(size, defaultSize, maxSize int32) int32 {
	if size <= 0 {
		return defaultSize
	}
	if size > maxSize {
		return maxSize
	}
	return size
}
