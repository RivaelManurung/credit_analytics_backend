package biz

import "fmt"

// ErrNotFound is returned when a resource is not found.
type ErrNotFound struct {
	Resource string
	ID       string
}

func (e *ErrNotFound) Error() string {
	return fmt.Sprintf("%s with id %s not found", e.Resource, e.ID)
}

// ErrInvalidArgument is returned when input validation fails.
type ErrInvalidArgument struct {
	Field   string
	Message string
}

func (e *ErrInvalidArgument) Error() string {
	return fmt.Sprintf("invalid argument: field=%s, reason=%s", e.Field, e.Message)
}

// ErrConflict is returned when a state transition or business rule is violated.
type ErrConflict struct {
	Message string
}

func (e *ErrConflict) Error() string {
	return fmt.Sprintf("conflict: %s", e.Message)
}

// ErrLocked is returned when an entity is locked and cannot be modified.
type ErrLocked struct {
	Resource string
	ID       string
	Status   string
}

func (e *ErrLocked) Error() string {
	return fmt.Sprintf("%s %s is locked (status: %s) and cannot be modified", e.Resource, e.ID, e.Status)
}
