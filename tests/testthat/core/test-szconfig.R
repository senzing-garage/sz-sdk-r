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

sz_configmanager <- sz_abstract_factory$create_configmanager()

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

test_that("sz_config.export", {
    sz_config <- sz_configmanager$create_config_from_template()
    result <- sz_config$export()
    # print_result("sz_config.export", result)
})

test_that("sz_config.get_data_source_registry", {
    sz_config <- sz_configmanager$create_config_from_template()
    result <- sz_config$get_data_source_registry()
    print_result("sz_config.get_data_source_registry", prettify(result, indent = 2))
})

test_that("sz_config.register_data_source", {
    sz_config <- sz_configmanager$create_config_from_template()
    result <- sz_config$register_data_source("DATA_SOURCE_REGISTER_DATA_SOURCE")
    print_result("sz_config.register_data_source", prettify(result, indent = 2))
})

test_that("sz_config.unregister_data_source", {
    sz_config <- sz_configmanager$create_config_from_template()
    result <- sz_config$register_data_source("DATA_SOURCE_UNREGISTER_DATA_SOURCE")
    result <- sz_config$unregister_data_source("DATA_SOURCE_UNREGISTER_DATA_SOURCE")
    print_result("sz_config.unregister_data_source")
})
