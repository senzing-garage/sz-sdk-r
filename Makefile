# Makefile for Go project

# Detect the operating system and architecture.

include makefiles/osdetect.mk

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

# "Simple expanded" variables (':=')

# PROGRAM_NAME is the name of the GIT repository.
PROGRAM_NAME := $(shell basename `git rev-parse --show-toplevel`)
MAKEFILE_PATH := $(abspath $(firstword $(MAKEFILE_LIST)))
MAKEFILE_DIRECTORY := $(shell dirname $(MAKEFILE_PATH))
TARGET_DIRECTORY := $(MAKEFILE_DIRECTORY)/target
DIST_DIRECTORY := $(MAKEFILE_DIRECTORY)/dist
BUILD_TAG := $(shell git describe --always --tags --abbrev=0  | sed 's/v//')
BUILD_ITERATION := $(shell git log $(BUILD_TAG)..HEAD --oneline | wc -l | sed 's/^ *//')
BUILD_VERSION := $(shell git describe --always --tags --abbrev=0 --dirty  | sed 's/v//')
GIT_REMOTE_URL := $(shell git config --get remote.origin.url)
GIT_REPOSITORY_NAME := $(shell basename `git rev-parse --show-toplevel`)
GIT_VERSION := $(shell git describe --always --tags --long --dirty | sed -e 's/\-0//' -e 's/\-g.......//')
PATH := $(MAKEFILE_DIRECTORY)/bin:$(PATH)

# Recursive assignment ('=')


# Conditional assignment. ('?=')
# Can be overridden with "export"
# Example: "export LD_LIBRARY_PATH=/path/to/my/senzing/er/lib"

LD_LIBRARY_PATH ?= /opt/senzing/er/lib

# Export environment variables.

.EXPORT_ALL_VARIABLES:

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: default
default: help

# -----------------------------------------------------------------------------
# Operating System / Architecture targets
# -----------------------------------------------------------------------------

-include makefiles/$(OSTYPE).mk
-include makefiles/$(OSTYPE)_$(OSARCH).mk


.PHONY: hello-world
hello-world: hello-world-osarch-specific

# -----------------------------------------------------------------------------
# Dependency management
# -----------------------------------------------------------------------------

.PHONY: dependencies-for-development
dependencies-for-development: dependencies-for-development-osarch-specific


.PHONY: dependencies
dependencies:
    @sudo Rscript -e 'install.packages("bit64", repos="https://cloud.r-project.org")'
    @sudo Rscript -e 'install.packages("dplyr", repos="https://cloud.r-project.org")'
    @sudo Rscript -e 'install.packages("httr", repos="https://cloud.r-project.org")'
    @sudo Rscript -e 'install.packages("reticulate", repos="https://cloud.r-project.org")'
	$(activate-venv); \
		python3 -m pip install --upgrade pip; \
		python3 -m pip install --requirement requirements.txt

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

.PHONY: setup
setup: setup-osarch-specific

# -----------------------------------------------------------------------------
# Lint
# -----------------------------------------------------------------------------

.PHONY: lint
lint: cspell

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Run
# -----------------------------------------------------------------------------

.PHONY: run
run: run-osarch-specific

# -----------------------------------------------------------------------------
# Test
# -----------------------------------------------------------------------------

.PHONY: test
test: test-osarch-specific
	@$(activate-venv); ./test.r

# -----------------------------------------------------------------------------
# Coverage
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Documentation
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Clean
# -----------------------------------------------------------------------------

.PHONY: clean
clean: clean-osarch-specific

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: help
help:
	$(info Build $(PROGRAM_NAME) version $(BUILD_VERSION)-$(BUILD_ITERATION))
	$(info Makefile targets:)
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs


.PHONY: print-make-variables
print-make-variables:
	@$(foreach V,$(sort $(.VARIABLES)), \
		$(if $(filter-out environment% default automatic, \
		$(origin $V)),$(info $V=$($V) ($(value $V)))))

# -----------------------------------------------------------------------------
# Specific programs
# -----------------------------------------------------------------------------

.PHONY: cspell
cspell:
	@cspell lint --dot .
