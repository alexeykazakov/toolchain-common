.PHONY: test
## runs the tests *with* coverage
test: 
	@echo "running the tests with coverage..."
	@-mkdir -p $(COV_DIR)
	@-rm $(COV_DIR)/coverage.txt
	$(Q)go test -vet off ${V_FLAG} $(shell go list ./... | grep -v /test/e2e) -coverprofile=$(COV_DIR)/profile.out -covermode=atomic ./...
ifeq (,$(wildcard $(COV_DIR)/profile.out))
	cat $(COV_DIR)/profile.out >> $(COV_DIR)/coverage.txt
	rm $(COV_DIR)/profile.out
endif
	# Upload coverage to codecov.io
	bash <(curl -s https://codecov.io/bash) -f $(COV_DIR)/coverage.txt -t 543cc327-510b-4e3e-9574-2c9cba1f2bc7

# Output directory for coverage information
COV_DIR = $(OUT_DIR)/coverage

.PHONY: test-without-coverage
## runs the tests without coverage and excluding E2E tests
test-without-coverage:
	@echo "running the tests without coverage and excluding E2E tests..."
	$(Q)go test ${V_FLAG} -race $(shell go list ./... | grep -v /test/e2e) -failfast