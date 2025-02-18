GOLANGCI_LINT = v1.24.0

.PHONY: dependency
dependency:
	@go mod download

.PHONY: verify
verify: go-fmt go-vet lint test

.PHONY: go-vet
go-vet:
	@go vet -v ./...

.PHONY: go-fmt
go-fmt:
	@git ls-files '*.go' | grep -v 'vendor/' | xargs gofmt -s -w

.PHONY: install-lint
install-lint:
	@test -f ./bin/golangci-lint || curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${GOLANGCI_LINT}

.PHONY: lint
lint: install-lint
	@bin/golangci-lint run

.PHONY: clean-vendor
clean-vendor:
	@find ./vendor -type d | xargs rm -rf

.PHONY: test
test:
	@go test -v ./... -cover -coverprofile=coverage.out -race -run ./...

.PHONY: code-coverage
code-coverage:
	@go tool cover -html=coverage.out
