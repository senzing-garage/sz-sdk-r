#!/usr/bin/env Rscript

library(testthat)
library(jsonlite)
library(reticulate)

# Prepare Python environment.

use_virtualenv("~/.venv")
senzing <- import("senzing_core")

# Create an abstract factory.

instance_name <- "Example"
settings <- '{"PIPELINE":{"CONFIGPATH":"/etc/opt/senzing","RESOURCEPATH":"/opt/senzing/er/resources","SUPPORTPATH":"/opt/senzing/data"},"SQL":{"CONNECTION":"sqlite3://na:na@/tmp/sqlite/G2C.db"}}'
sz_abstract_factory <- senzing$SzAbstractFactoryCore(instance_name, settings)

# Create Senzing objects.

sz_diagnostic <- sz_abstract_factory$create_diagnostic()

print_result <- function(name, ...) {
    string_length <- nchar(name)
    suffix <- strrep("-", 80 - string_length)
    print(paste("---", name, suffix))
    tryCatch({
        print(...)
    }, warning = function(w) {}, error = function(e) {}, finally = {})
}

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

test_that("sz_diagnostic.check_repository_performance", {
    result <- sz_diagnostic$check_repository_performance(3L)
    print_result("sz_diagnostic.check_repository_performance", prettify(result, indent = 2))
})

test_that("sz_diagnostic.get_repository_info", {
    result <- sz_diagnostic$get_repository_info()
    print_result("sz_diagnostic.get_repository_info", prettify(result, indent = 2))
})

# test_that("sz_diagnostic.get_feature", {
#     result <- sz_diagnostic$get_feature(0L)
#     print(prettify(result, indent = 2))
# })
