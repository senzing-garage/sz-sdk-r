# Makefile extensions for linux.

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

LD_LIBRARY_PATH ?= /opt/senzing/er/lib
SENZING_TOOLS_DATABASE_URL ?= sqlite3://na:na@nowhere/tmp/sqlite/G2C.db
PATH := $(MAKEFILE_DIRECTORY)/bin:/$(HOME)/go/bin:$(PATH)

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
	$(info Hello World, from linux.)


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

.PHONY: only-linux
only-linux:
	$(info Only linux has this Makefile target.)
