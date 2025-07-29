#!/usr/bin/env Rscript

library(testthat)
library(jsonlite)
library(reticulate)

# Prepare Python environment.

use_virtualenv("~/.venv")
senzing <- import("senzing_core", convert = FALSE)
senzing_flags <- import("senzing", convert = FALSE)

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

test_that("sz_configmanager.create_config_from_config_id", {
    config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(config_id)
    result <- sz_config$export()
    print_result("sz_configmanager.create_config_from_config_id")
})

test_that("sz_configmanager.create_config_from_string", {
    config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(config_id)
    config_definition <- sz_config$export()
    new_sz_config <- sz_configmanager$create_config_from_string(config_definition)
    result <- new_sz_config$export()
    print_result("sz_configmanager.create_config_from_string")
})

test_that("sz_configmanager.create_config_from_template", {
    sz_config <- sz_configmanager$create_config_from_template()
    result <- sz_config$export()
    print_result("sz_configmanager.create_config_from_template")
})

test_that("sz_configmanager.get_config_registry", {
    result <- sz_configmanager$get_config_registry()
    print_result("sz_configmanager.get_config_registry", prettify(result, indent = 2))
})

test_that("sz_configmanager.get_default_config_id", {
    result <- sz_configmanager$get_default_config_id()
    print_result("sz_configmanager.get_default_config_id", prettify(result, indent = 2))
})

test_that("sz_configmanager.register_config", {
    current_default_config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(current_default_config_id)
    sz_config$register_data_source("DATA_SOURCE_REGISTER_CONFIG")
    config_definition <- sz_config$export()
    new_default_config_id <- sz_configmanager$register_config(
        config_definition,
        "Add DATA_SOURCE_REGISTER_CONFIG"
    )
    print_result("sz_configmanager.register_config", new_default_config_id)
})

test_that("sz_configmanager.replace_default_config_id", {
    old_default_config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(old_default_config_id)
    sz_config$register_data_source("DATA_SOURCE_REPLACE_DEFAULT_CONFIG_ID")
    config_definition <- sz_config$export()
    new_default_config_id <- sz_configmanager$register_config(
        config_definition,
        "Add DATA_SOURCE_REPLACE_DEFAULT_CONFIG_ID"
    )
    sz_configmanager$replace_default_config_id(old_default_config_id, new_default_config_id)
    result <- sz_configmanager$get_default_config_id()
    print_result("sz_configmanager.replace_default_config_id", old_default_config_id, new_default_config_id, result)
})

test_that("sz_configmanager.set_default_config", {
    old_default_config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(old_default_config_id)
    sz_config$register_data_source("DATA_SOURCE_SET_DEFAULT_CONFIG")
    config_definition <- sz_config$export()
    new_default_config_id <- sz_configmanager$set_default_config(
        config_definition,
        "Add DATA_SOURCE_SET_DEFAULT_CONFIG"
    )
    print_result("sz_configmanager.set_default_config", old_default_config_id, new_default_config_id)
})

test_that("sz_configmanager.set_default_config_id", {
    old_default_config_id <- sz_configmanager$get_default_config_id()
    sz_config <- sz_configmanager$create_config_from_config_id(old_default_config_id)
    sz_config$register_data_source("DATA_SOURCE_SET_DEFAULT_CONFIG_ID")
    config_definition <- sz_config$export()
    new_default_config_id <- sz_configmanager$set_default_config(
        config_definition,
        "Add DATA_SOURCE_SET_DEFAULT_CONFIG_ID"
    )
    result <- sz_configmanager$set_default_config_id(new_default_config_id)
    print_result("sz_configmanager.set_default_config_id", prettify(result, indent = 2))
})
