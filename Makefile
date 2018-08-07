.DEFAULT_GOAL := all

# Default shell is bash.
SHELL := /bin/bash

# list of shell scripts to run against shellcheck.
SHELLCHECK_FILES ?= $(shell find ./ -name '*.sh')

# Name of test(s) to run.
TEST_NAMES ?=

# Docker executable.
DOCKER ?= docker

# Version of Bash to test against.
BASH_VERSION ?= 4.3

# Directory Sheldon will be mounted to in Docker.
VOLUME ?= /usr/lib/sheldon

# target: all - Run all targets.
.PHONY: all
all: prepare lint test

# target: prepare - Prepare for lint/test targets by pulling Docker images.
.PHONY: prepare
prepare:
	$(DOCKER) pull "koalaman/shellcheck:stable"
	$(DOCKER) pull "bash:$(BASH_VERSION)"

# target: lint - Run linters.
.PHONY: lint
lint: shellcheck

# target: shellcheck - Run 'shellcheck' against *.sh files in a Docker container.
.PHONY: shellcheck
shellcheck:
	$(DOCKER) run -v "$(CURDIR):$(VOLUME)" -w "$(VOLUME)" "koalaman/shellcheck:stable" $(SHELLCHECK_FILES)

# target: test - Run Sheldon unit tests in a Docker container.
.PHONY: test
test:
	$(DOCKER) run -v "$(CURDIR):$(VOLUME)" -w "$(VOLUME)" "bash:$(BASH_VERSION)" ./test/test.sh $(TEST_NAMES)

## target: gen-docs - Generate Sphinx docs.
# gen-docs:
# 	-rm -rf docs

# target: help - Display callable targets.
.PHONY: help
help:
	egrep "^# target:" [Mm]akefile