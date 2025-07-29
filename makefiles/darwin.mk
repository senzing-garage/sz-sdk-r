# Makefile extensions for darwin.

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

SENZING_DIR ?= /opt/senzing/er
SENZING_TOOLS_SENZING_DIRECTORY ?= $(SENZING_DIR)
LD_LIBRARY_PATH ?= $(SENZING_TOOLS_SENZING_DIRECTORY)/lib:$(SENZING_TOOLS_SENZING_DIRECTORY)/lib/macos
DYLD_LIBRARY_PATH := $(LD_LIBRARY_PATH)
PATH := $(MAKEFILE_DIRECTORY)/bin:/$(HOME)/go/bin:$(PATH)
SENZING_TOOLS_DATABASE_URL ?= sqlite3://na:na@nowhere/tmp/sqlite/G2C.db

# -----------------------------------------------------------------------------
# OS specific targets
# -----------------------------------------------------------------------------

.PHONY: clean-osarch-specific
clean-osarch-specific:
	@rm -fr /tmp/sqlite || true


.PHONY: dependencies-for-development-osarch-specific
dependencies-for-development-osarch-specific:


.PHONY: hello-world-osarch-specific
hello-world-osarch-specific:
	$(info Hello World, from darwin.)


.PHONY: run-osarch-specific
run-osarch-specific:


.PHONY: setup-osarch-specific
setup-osarch-specific:
	@mkdir /tmp/sqlite
	@cp testdata/sqlite/G2C.db /tmp/sqlite/G2C.db


.PHONY: test-osarch-specific
test-osarch-specific:

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-darwin
only-darwin:
	$(info Only darwin has this Makefile target.)
