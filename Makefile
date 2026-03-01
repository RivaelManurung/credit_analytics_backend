GOHOSTOS:=$(shell go env GOHOSTOS)
GOPATH:=$(shell go env GOPATH)
VERSION=$(shell git describe --tags --always 2>/dev/null || echo "undefined")

ifeq ($(GOHOSTOS), windows)
	# Find git.exe and convert to bash.exe path using simple string replacement
	Git_Bash := $(shell powershell -NoProfile -Command "$$p = (Get-Command git.exe -ErrorAction SilentlyContinue | Select-Object -First 1).Source; if ($$p) { $$p.Replace('cmd\git.exe', 'bin\bash.exe').Replace('\', '/') }")
	
	INTERNAL_PROTO_FILES=$(shell "$(Git_Bash)" -c "find internal -name *.proto")
	API_PROTO_FILES=$(shell "$(Git_Bash)" -c "find api -name *.proto")
else
	INTERNAL_PROTO_FILES=$(shell find internal -name *.proto)
	API_PROTO_FILES=$(shell find api -name *.proto)
endif

.PHONY: init
# init env
init:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/go-kratos/kratos/cmd/kratos/v2@latest
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
	go install github.com/google/gnostic/cmd/protoc-gen-openapi@latest
	go install github.com/google/wire/cmd/wire@latest

.PHONY: config
# generate internal proto
config:
	protoc --proto_path=./internal \
	       --proto_path=./third_party \
 	       --go_out=paths=source_relative:./internal \
	       $(INTERNAL_PROTO_FILES)

.PHONY: api
# generate api proto using protoc
api:
	protoc --proto_path=./api \
	       --proto_path=./third_party \
 	       --go_out=paths=source_relative:./api \
 	       --go-http_out=paths=source_relative:./api \
 	       --go-grpc_out=paths=source_relative:./api \
	       --openapi_out=fq_schema_naming=true,default_response=false:internal/server \
	       $(API_PROTO_FILES)

.PHONY: buf
# generate api proto using buf
buf:
	buf generate

.PHONY: push
# push to buf schema registry
push:
	buf push

.PHONY: build
# build
build:
	mkdir -p bin/ && go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/ ./...

.PHONY: generate
# generate
generate:
	go generate ./...
	go mod tidy

.PHONY: all
# generate all
all:
	make api
	make config
	make generate

# Load environment variables from .env if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

DB_USER ?= postgres
DB_PASSWORD ?= password
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= credit_analytics
DB_SSLMODE ?= disable

# If DATABASE_URL is set (from Railway or shell), use it as the primary DB_URL
ifneq ($(DATABASE_URL),)
    DB_URL ?= $(DATABASE_URL)
else
    DB_URL ?= "postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)"
endif

.PHONY: migrate-up
# Run goose migrations up
migrate-up:
	goose -dir internal/data/schema/migrations postgres $(DB_URL) up

.PHONY: migrate-down
# Rollback the last goose migration
migrate-down:
	goose -dir internal/data/schema/migrations postgres $(DB_URL) down

.PHONY: migrate-status
# Show goose migration status
migrate-status:
	goose -dir internal/data/schema/migrations postgres $(DB_URL) status

.PHONY: seed-up
# Run dummy data seeds
seed-up:
	goose -dir internal/data/schema/seeds postgres $(DB_URL) up

.PHONY: seed-status
# Show seed status
seed-status:
	goose -dir internal/data/schema/seeds postgres $(DB_URL) status

.PHONY: db-setup
# Run migrations and seeds sequentially
db-setup:
	make migrate-up
	make seed-up

# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
