# Project: Sheldon (https://github.com/housni/Sheldon)
# Author: Housni Yakoob <housni.yakoob@gmail.com>
# License: MIT (See 'LICENSE.txt')

# Need help? Just do:
#
#    make help
#
# That will list all the make targets. To get details about a specific target:
#
#    make HELP_TARGET=check.lint.shellcheck help
#
# The above will show you the detailed documentation in a man like format for
# the target 'check.lint.shellcheck'.
#
# IMPORTANT:
# Make sure all new targets are properly documented. Not documenting them means
# they will not be discoverable via `make help` or `make HELP_TARGET=my_target_here help`.
#
# To debug:
#     $ make -rRd <my_target>

# Credits: http://clarkgrubb.com/makefile-style-guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

# Install executable
INSTALL ?= install
INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA ?= $(INSTALL) -m 644

# Docker executable. Used for linting, testing, etc.
DOCKER ?= docker

# Directory Sheldon will be bind mounted to in Docker.
MOUNT_PATH ?= /sheldon

# Find the shell scripts to run 'shellcheck' against.
# Default: All scripts ending with '.sh' in the project.
SHELL_SCRIPTS ?= $(shell find ./ -name '*.sh')

# Files to run 'yamllint' against.
YAML_FILES ?= .travis.yml

# Name of test(s) to run.
# Default: null
TEST_NAMES ?=

# Version of Bash to test against.
BASH_VERSION ?= 4.3

NAME = $(shell basename $(CURDIR))

# Path to Sheldon lib in this project.
SHELDON_LIBS = ./lib/$(NAME)

# To stop '--warn-undefined-variables' from whining.
# See: https://www.gnu.org/prep/standards/html_node/DESTDIR.html
DESTDIR ?=

# A few install paths.
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/
MANDIR = $(PREFIX)/share/man

# Target for detailed help.
HELP_TARGET :=

# Name of target for the banner.
TARGET_NAME ?= 
# Characters to use when drawing a header/banner.
BANNER_CHAR ?= \#
# The prefix, in the banner, before displaying the name of the target.
BANNER_PREFIX ?= TARGET: 

# Returns the length of any string.
strlen = "$(shell declare some; some=$1; echo $${\#some}; )"

# NAME
#     prepare - Pulls down Docker images.
#
# SYNOPSIS
#     make [OPTION]... prepare
#
# DESCRIPTION
#     Prepares project for lint and test targets by pulling down Docker images
#     that will later be used for running linters and unit tests.
#
#     DOCKER
#         Docker executable.
#         Don't change this unless you know what you're doing.
#
# EXAMPLES
#     make prepare
#         Runs Dockers 'pull' command to pull down the default images for
#         linter and running unit tests.
#
.PHONY: prepare
prepare:
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) pull "sdesbure/yamllint"
	@$(DOCKER) build --rm -t sheldon ./
	@$(DOCKER) pull "koalaman/shellcheck:stable"

# NAME
#     check - See targets 'check.lint' and 'check.test.unit'.
#
# SYNOPSIS
#     make [OPTION]... check
#
# DESCRIPTION
#     See targets 'check.lint' and 'check.test.unit'.
#
.PHONY: check
check: check.lint check.test.unit

# NAME
#     check.lint - See target 'check.lint.shellcheck' and 'check.lint.yamllint'.
#
# SYNOPSIS
#     make [OPTION]... check.lint
#
# DESCRIPTION
#     See target 'shellcheck'.
#
.PHONY: check.lint
check.lint: check.lint.shellcheck check.lint.yamllint check.lint.sheldon

# NAME
#     check.lint.shellcheck - Runs 'shellcheck' against shell scripts.
#
# SYNOPSIS
#     make [OPTION]... check.lint.shellcheck
#
# DESCRIPTION
#     Runs a Docker container using the official 'shellcheck' Docker image
#     and runs 'shellcheck' against all shell scripts in SHELL_SCRIPTS.
#
#     MOUNT_PATH
#         Location on the Docker container where Sheldon will be mounted.
#         This is the location from which shellcheck will run. It's also the
#         directory the container will start in and it will be mounted as
#         read-only.
#
#     SHELL_SCRIPTS
#         Files to run 'shellcheck' against. These files may be space or
#         new-line delimited and must be relative to MOUNT_PATH.
#
#     DOCKER
#         Docker executable.
#         Don't change this unless you know what you're doing.
#
#     CURDIR
#         Absolute pathname of the current working directory.
#         See: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html
#
# EXAMPLES
#     make check.lint.shellcheck
#         Runs 'shellcheck' against all files.
#
#     make MOUNT_PATH="/usr/lib/sheldon/" check.lint.shellcheck
#         Mounts Sheldon to '/usr/lib/sheldon/' in the Docker container and runs
#         'shellcheck' against all files ending with '.sh' in that directory.
#
#     make SHELL_SCRIPTS="./core/Sheldon.sh ./util/String.sh" check.lint.shellcheck
#         Runs 'shellcheck' against only './core/Sheldon.sh' and './util/String.sh'.
#
#     make SHELL_SCRIPTS=$(find ./core/ -name '*.sh') check.lint.shellcheck
#         Runs 'shellcheck' against the files in './core/' that end with ".sh".
#
#     make MOUNT_PATH="/root/.local/lib/" SHELL_SCRIPTS=$(find ./core/ -name '*.sh') check.lint.shellcheck
#         Mounts Sheldon to '/root/.local/lib/' in the Docker container and
#         runs 'shellcheck' against the files in './core/' that end with ".sh".
#
.PHONY: check.lint.shellcheck
check.lint.shellcheck: prepare
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) run \
		--rm \
		--mount type=bind,source="$(CURDIR)",target=$(MOUNT_PATH),readonly \
		-w "$(MOUNT_PATH)" \
		"koalaman/shellcheck:stable" \
		$(SHELL_SCRIPTS)

# NAME
#     check.lint.sheldon - Runs Sheldon specific checks against shell scripts.
#
# SYNOPSIS
#     make [OPTION]... check.lint.sheldon
#
# DESCRIPTION
#     Sheldon has some specific rules (e.g.: https://github.com/housni/Sheldon/issues/12)
#     and so a tool was written to check for these rules.
#
#     CURDIR
#         Absolute pathname of the current working directory.
#         See: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html
#
# EXAMPLES
#     make check.lint.sheldon
#         Runs Sheldon checker against all files.
#
#     make SHELL_SCRIPTS="./core/Sheldon.sh ./util/String.sh" check.lint.sheldon
#         Runs Sheldon checker against only './core/Sheldon.sh' and './util/String.sh'.
#
#     make SHELL_SCRIPTS=$(find ./core/ -name '*.sh') check.lint.sheldon
#         Runs Sheldon checker against the files in './core/' that end with ".sh".
#
.PHONY: check.lint.sheldon
check.lint.sheldon:
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) run \
		--rm \
		--mount type=bind,source="$(CURDIR)",target=$(MOUNT_PATH),readonly \
		-w "$(MOUNT_PATH)" \
		sheldon \
		./bin/check-convention

# NAME
#     check.lint.yamllint - Runs 'yamllint' against YAML files.
#
# SYNOPSIS
#     make [OPTION]... check.lint.yamllint
#
# DESCRIPTION
#     Runs a Docker container using an image with 'yamllint' installed and runs
#     it against files in YAML_FILES.
#
#     MOUNT_PATH
#         Location on the Docker container where Sheldon will be mounted.
#         This is the location from which yamllint will run. It's also the
#         directory the container will start in and it will be mounted as
#         read-only.
#
#         See: https://hub.docker.com/r/sdesbure/yamllint/
#
#     YAML_FILES
#         Files to run 'yamllint' against. These files may be space or
#         new-line delimited and must be relative to MOUNT_PATH.
#
#     DOCKER
#         Docker executable.
#         Don't change this unless you know what you're doing.
#
#     CURDIR
#         Absolute pathname of the current working directory.
#         See: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html
#
# EXAMPLES
#     make check.lint.yamllint
#         Runs 'yamllint' against files in YAML_FILES.
#
#     make MOUNT_PATH="/usr/lib/sheldon/" check.lint.yamllint
#         Mounts Sheldon to '/usr/lib/sheldon/' in the Docker container and runs
#         'yamllint' against all files in YAML_FILES.
#
#     make YAML_FILES="./foobar.yaml" check.lint.yamllint
#         Runs 'yamllint' against only './foobar.yaml'.
#
#     make YAML_FILES=$(find ./ -regex '.*\.ya?ml') check.lint.yamllint
#         Runs 'yamllint' against all files in './' that end with either ".yml"
#         or ".yaml".
#
.PHONY: check.lint.yamllint
check.lint.yamllint: prepare
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) run \
		--rm --mount type=bind,source="$(CURDIR)",target=$(MOUNT_PATH),readonly \
		-w "$(MOUNT_PATH)" \
		"sdesbure/yamllint" \
		yamllint $(YAML_FILES)

# NAME
#     check.test - See target 'check.test.unit'.
#
# SYNOPSIS
#     make [OPTION]... check.test
#
# DESCRIPTION
#     See target 'check.test.unit'.
#
.PHONY: check.test
check.test: check.test.unit

# NAME
#     check.test.unit - Runs Sheldon unit tests inside a Docker container.
#
# SYNOPSIS
#     make [OPTION]... check.test.unit
#
# DESCRIPTION
#     Runs a Docker container using the official 'bash' Docker image
#     and runs Sheldons unit tests defined in TEST_NAMES. By default,
#     the Docker image used is version BASH_VERSION.
#
#     MOUNT_PATH
#         Location on the Docker container where Sheldon will be mounted.
#         This is the location from which the tests will run. It's also the
#         directory the container will start in and it will be mounted as
#         read-only.
#
#     TEST_NAMES
#         The names of the tests to run. These names may be space or new-line
#         delimited. See ./test/test.sh for more info.
#
#     BASH_VERSION
#         The tag of the Bash Docker image to run unit tests against.
#         You shouldn't be changing this unless you know what you're doing.
#         See: https://hub.docker.com/r/library/bash/tags/
#
#     DOCKER
#         Docker executable.
#         Don't change this unless you know what you're doing.
#
#     CURDIR
#         Absolute pathname of the current working directory.
#         See: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html
#
# EXAMPLES
#     make check.test.unit
#         Runs all unit tests.
#
#     make MOUNT_PATH="/root/.local/lib/" check.test.unit
#         Mounts Sheldon to '/usr/lib/sheldon/' in the Docker container and runs
#         all unit tests.
#
#     make TEST_NAMES="StringTest.testJoin" check.test.unit
#         Runs the 'StringTest.testJoin' test in ./tests/StringTest.sh.
#
#     make TEST_NAMES="ArrayTest" check.test.unit
#         Runs all the tests in ./tests/ArrayTest.sh.
#
#     make MOUNT_PATH="/root/.local/lib/" TEST_NAMES="ArrayTest" check.test.unit
#         Mounts Sheldon to '/root/.local/lib/' in the Docker container and
#         runs all the tests in ./tests/ArrayTest.sh.
#
.PHONY: check.test.unit
check.test.unit: prepare
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) run \
		--rm \
		--mount type=bind,source="$(CURDIR)",target=$(MOUNT_PATH),readonly \
		-w "$(MOUNT_PATH)" \
		sheldon \
		./lib/sheldon/test/test.sh $(TEST_NAMES)

# NAME
#     stats - Gathers and displays stats about Sheldon.
#
# SYNOPSIS
#     make stats
#
# DESCRIPTION
#     Displays various stats about Sheldon such as the occrrences of 'eval's in the code.
#
.PHONY: stats
stats: prepare
	@$(MAKE) --no-print-directory TARGET_NAME=$@ _output.banner
	@$(DOCKER) run \
		--rm \
		--mount type=bind,source="$(CURDIR)",target=$(MOUNT_PATH),readonly \
		-w "$(MOUNT_PATH)" \
		sheldon \
		./bin/check-evals

# NAME
#     all - See targets 'check', 'clean' and 'install'.
#
# SYNOPSIS
#     make [OPTION]... all
#
# DESCRIPTION
#     See targets See targets 'check', 'clean' and 'install'.
#
.PHONY: all
all: check clean install stats

# NAME
#     _output.banner - Display a prominent banner.
#
# SYNOPSIS
#     make TARGET_NAME=CALlING_TARGET _output.banner
#
# DESCRIPTION
#     This is really just meant for internal use. Since I'm colourblind, visual
#     markers help a lot especially when viewing a ton of output in a CI tool
#     like Jenkins or TravisCI, for example.
#
#     This displays a prominent banner and is totally customizable.
#     The banner consists of a string of characters, $(BANNER_CHAR), on the first
#     line, the next line starts with a prefix, $(BANNER_PREFIX), followed by
#     $(TARGET_NAME). The next line is the final one and it's identical to the
#     first. The length is determined baseed on the length of $(BANNER_PREFIX)
#     and $(TARGET_NAME), which is a required argument.
#
#     TARGET_NAME
#         The name of the target for which the banner will be displayed.
#         The variable passed in is usually '$@'.' This argument is required.
#
#     BANNER_PREFIX
#         The prefix text in the banner which appears just before and on the
#         same line as $(TARGET_NAME).
#
#     BANNER_CHAR
#         The character for the banner which will form a line above and below
#         $(TARGET_NAME).
#
# EXAMPLES
#     make TARGET_NAME=$@ _output.banner
#         Displays a banner for the target '$(TARGET_NAME)':
#
#             $ make TARGET_NAME="foobar" _output.banner
#             ##############
#             TARGET: foobar
#             ##############
#
#     make BANNER_CHAR="-" BANNER_PREFIX="> " TARGET_NAME=$@ _output.banner
#         Displays a banner with hyphens at the top and bottom and a prefix
#         of "> ":
#             $ make BANNER_CHAR="-" BANNER_PREFIX="> " TARGET_NAME=foobar _output.banner
#             --------
#             > foobar
#             --------
#
.PHONY: _output.banner
_output.banner:
ifndef TARGET_NAME
	$(error TARGET_NAME is undefined in _output.banner())
endif
	@{ \
		declare -i target_len ;\
		declare -i total_len ;\
		declare -i prefix_len ;\
		# Get length of text to display, minus prefix. \
		target_len="$(call strlen,$(TARGET_NAME))" ;\
		# Get length of prefix. \
		prefix_len="$(call strlen,"$(BANNER_PREFIX)")" ;\
		# Concatenate the two together. \
		total_len=$$(( prefix_len + target_len )) ;\
		# Print $(BANNER_CHAR) until it's the length of $${total_len} \
		# Print $(BANNER_PREFIX) followed by $(TARGET_NAME) \
		# Print $(BANNER_CHAR) until it's the length of $${total_len} \
		printf "%$${total_len}s\n" | tr " " "$(BANNER_CHAR)" ;\
		printf "%s%b\n" "$(BANNER_PREFIX)" "$(TARGET_NAME)" ;\
		printf "%$${total_len}s\n" | tr " " "$(BANNER_CHAR)" ;\
	}

# NAME
#     help - Display callable targets as well as manuals for individual targets using HELP_TARGET.
#
# SYNOPSIS
#     make [OPTION]... help
#
# DESCRIPTION
#     Displays all the callable targets in this Makefile. If HELP_TARGET is
#     given, the documentation above the target (like this one you're reading
#     right now) for that corresponding target, HELP_TARGET, is displayed.
#
#     This is a pure Bash implementation without the use of cat, grep, sed,
#     awk, etc...well, what do you expect, this IS Sheldon!
#
#     HELP_TARGET
#         The target to to display the documentation for.
#
# EXAMPLES
#     make help
#         Displays all callable targets.
#
#     make HELP_TARGET=check.lint.shellcheck help
#         Displays the documentation for the 'shellcheck' target.
#
#     make HELP_TARGET=check.lint.shel help
#         Displays the documentation for any tagets that begin with 'shel' target.
#
.PHONY: help
help:
	@HELP_BANNER="$@\n'usage: make [HELP_TARGET=<target_name>] help\nexample: make HELP_TARGET=check.test.unit help'"; \
	$(MAKE) --no-print-directory TARGET_NAME="$${HELP_BANNER}" _output.banner
	@{ \
		start="# NAME" ;\
		state=0 ;\
		mapfile -t contents < [Mm]akefile ;\
		regexp="^#\s{5}$(HELP_TARGET)" ;\
		for content in "$${contents[@]}"; do \
			if [[ $$state -gt 0 ]] && [[ "$$content" =~ $$regexp ]]; then \
				# We are at the beginning of a documentation block. \
				if [[ ! -z "$(HELP_TARGET)" ]]; then \
					state=2 ;\
					echo "" ;\
					echo "$${start:2}" ;\
				else \
					# Set state back to zero so we don't output anything later on \
					# and output the target name for discovery, in the next line. \
					state=0 ;\
				fi ;\
				echo "$${content:2}" ;\
			elif [[ $$state -eq 2 ]] && [[ "$${content:0:1}" = '#' ]] && [[ ! -z "$(HELP_TARGET)" ]]; then \
				# We are in the middle of a documentation block. \
				echo "$${content:2}" ;\
			fi ;\
			if [[ $$state -eq 2 ]] && [[ "$${content:0:1}" != '#' ]] && [[ ! -z "$(HELP_TARGET)" ]]; then \
				# We are at the end of a documentation block. \
				echo "" ;\
				break ;\
			fi ;\
			if [[ "$${content}" = "$$start" ]]; then \
				state=1 ;\
			fi ;\
		done ;\
	}

# TODO: Remove code coverage dir
.PHONY: clean
clean:

# NAME
#     install - Installs Sheldon.
#
# SYNOPSIS
#     make install
#
# DESCRIPTION
#     Installs Sheldon to 'LIBDIR'.
#
.PHONY: install
install: $(SHELDON_LIBS)
	@mkdir -p $(LIBDIR)/$(NAME)
	@cp -r $(CURDIR)/lib/$(NAME) $(LIBDIR)

# NAME
#     uninstall - Uninstalls Sheldon.
#
# SYNOPSIS
#     make uninstall
#
# DESCRIPTION
#     Uninstalls Sheldon from 'LIBDIR'.
#
.PHONY: uninstall
uninstall:
	@rm -rf $(LIBDIR)/$(NAME)

# NAME
#     hooks - See target 'hooks.git.precommit'.
#
# SYNOPSIS
#     make hooks
#
# DESCRIPTION
#     See target 'hooks.git.precommit'.
#
.PHONY: hooks
hooks: hooks.git.precommit

# NAME
#     hooks.git.precommit - Installs git pre-commit hooks.
#
# SYNOPSIS
#     make hooks.git.precommit
#
# DESCRIPTION
#     Installs git precommit hooks by creating symlinks to them.
#     These hooks do things like lint code and run unit tests.
#
.PHONY: hooks.git.precommit
hooks.git.precommit:
	@ln -s $(CURDIR)/hooks/pre-commit $(CURDIR)/.git/hooks/pre-commit

# TODO
## target: build-docs - Generate docs (Sphinx -> readthedocs/man pages).
#build-docs: | docs
#   -rm -rf $@
#   mkdir -p $@
