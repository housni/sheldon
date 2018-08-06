.DEFAULT_GOAL := all
LINT_FILES ?= $(shell find ./ -name '*.sh')
TEST_NAMES ?=

.PHONY: all
all: build lint test

.PHONY: build
build:
	docker pull koalaman/shellcheck:stable
	docker pull bash:4.3

.PHONY: lint
lint: shellcheck

.PHONY: shellcheck
shellcheck:
	docker run -v "$(CURDIR):/usr/lib/sheldon" -w /usr/lib/sheldon koalaman/shellcheck:stable $(LINT_FILES)

.PHONY: test
test:
	docker run -v "$(CURDIR):/usr/lib/sheldon" -w /usr/lib/sheldon bash:4.3 ./test/test.sh $(TEST_NAMES)

gen-docs: