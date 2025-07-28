# Makefile extensions for windows.

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

SENZING_TOOLS_DATABASE_URL ?= sqlite3://na:na@nowhere/C:\Temp\sqlite\G2C.db

# -----------------------------------------------------------------------------
# OS specific targets
# -----------------------------------------------------------------------------

.PHONY: clean-osarch-specific
clean-osarch-specific:
	@del /F /S /Q C:\Temp\sqlite


.PHONY: dependencies-for-development-osarch-specific
dependencies-for-development-osarch-specific:


.PHONY: hello-world-osarch-specific
hello-world-osarch-specific:
	$(info Hello World, from windows.)


.PHONY: run-osarch-specific
run-osarch-specific:


.PHONY: setup-osarch-specific
setup-osarch-specific:
	@mkdir C:\Temp\sqlite
	@copy testdata\sqlite\G2C.db C:\Temp\sqlite\G2C.db


.PHONY: test-osarch-specific
test-osarch-specific:

# -----------------------------------------------------------------------------
# Makefile targets supported only by this platform.
# -----------------------------------------------------------------------------

.PHONY: only-windows
only-windows:
	$(info Only windows has this Makefile target.)
