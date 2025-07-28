#!/usr/bin/env Rscript

library(testthat)
library(jsonlite)
library(reticulate)

# Prepare Python environment.

use_virtualenv("~/.venv")
senzing <- import("senzing_core")
senzing_flags <- import("senzing", convert = FALSE)

# Create an abstract factory.

instance_name <- "Example"
settings <- '{"PIPELINE":{"CONFIGPATH":"/etc/opt/senzing","RESOURCEPATH":"/opt/senzing/er/resources","SUPPORTPATH":"/opt/senzing/data"},"SQL":{"CONNECTION":"sqlite3://na:na@/tmp/sqlite/G2C.db"}}'
sz_abstract_factory <- senzing$SzAbstractFactoryCore(instance_name, settings)

# Create Senzing objects.

sz_engine <- sz_abstract_factory$create_engine()

# Create records.
record_test_one_list <- list(
    DATA_SOURCE = "TEST",
    RECORD_ID = "1"
)
record_test_one <- toJSON(record_test_one_list, pretty = TRUE, auto_unbox = TRUE)

# Create helper functions

get_entity_id_from_record_id <- function(data_source_code, record_id) {
    entity <- sz_engine$get_entity_by_record_id(data_source_code, record_id)
    entity_list <- fromJSON(entity)
    entity_list$RESOLVED_ENTITY$ENTITY_ID # Implicit return value
}

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

test_that("sz_engine.add_record", {
    result <- sz_engine$add_record(
        record_test_one_list$DATA_SOURCE,
        record_test_one_list$RECORD_ID,
        record_test_one,
        senzing_flags$SzEngineFlags$SZ_WITH_INFO
    )
    print_result("sz_engine.add_record", prettify(result, indent = 2))
})

test_that("sz_engine.count_redo_records", {
    result <- sz_engine$count_redo_records()
    print_result("sz_engine.count_redo_records", result)
})

test_that("sz_engine.delete_record", {
    result <- sz_engine$delete_record(
        record_test_one_list$DATA_SOURCE,
        record_test_one_list$RECORD_ID,
        senzing_flags$SzEngineFlags$SZ_WITH_INFO
    )
    print_result("sz_engine.delete_record", prettify(result, indent = 2))
})

test_that("sz_engine.find_interesting_entities_by_entity_id", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_INTERESTING_ENTITIES_DEFAULT_FLAGS
    entity_id <- get_entity_id_from_record_id(data_source_code, record_id)
    result <- sz_engine$find_interesting_entities_by_entity_id(entity_id, flags)
    print_result("sz_engine.find_interesting_entities_by_entity_id", prettify(result, indent = 2))
})

test_that("sz_engine.find_interesting_entities_by_record_id", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_INTERESTING_ENTITIES_DEFAULT_FLAGS
    result <- sz_engine$find_interesting_entities_by_record_id(data_source_code, record_id, flags)
    print_result("sz_engine.find_interesting_entities_by_record_id", prettify(result, indent = 2))
})

test_that("sz_engine.find_network_by_entity_id", {
    entity_ids <- c(
        get_entity_id_from_record_id("CUSTOMERS", "1001"),
        get_entity_id_from_record_id("CUSTOMERS", "1002")
    )
    max_degrees <- 2L
    build_out_degrees <- 1L
    build_out_max_entities <- 10L
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_NETWORK_DEFAULT_FLAGS
    result <- sz_engine$find_network_by_entity_id(entity_ids, max_degrees, build_out_degrees, build_out_max_entities, flags)
    print_result("sz_engine.find_network_by_entity_id", prettify(result, indent = 2))
})

test_that("sz_engine.find_network_by_record_id", {
    record_list <- list(
        c("CUSTOMERS", "1001"),
        c("CUSTOMERS", "1002")
    )
    max_degrees <- 2L
    build_out_degrees <- 1L
    build_out_max_entities <- 10L
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_NETWORK_DEFAULT_FLAGS
    result <- sz_engine$find_network_by_record_id(record_list, max_degrees, build_out_degrees, build_out_max_entities, flags)
    print_result("sz_engine.find_network_by_record_id", prettify(result, indent = 2))
})

test_that("sz_engine.find_path_by_entity_id", {
    start_entity_id <- get_entity_id_from_record_id("CUSTOMERS", "1001")
    end_entity_id <- get_entity_id_from_record_id("CUSTOMERS", "1002")
    max_degrees <- 1L
    avoid_entity_ids <- list(0)
    required_data_sources <- list("CUSTOMERS")
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_PATH_DEFAULT_FLAGS
    result <- sz_engine$find_path_by_entity_id(
        start_entity_id,
        end_entity_id,
        max_degrees,
        avoid_entity_ids,
        required_data_sources,
        flags
    )
    print_result("sz_engine.find_path_by_entity_id", prettify(result, indent = 2))
})

test_that("sz_engine.find_path_by_record_id", {
    start_data_source_code <- "CUSTOMERS"
    start_record_id <- "1001"
    end_data_source_code <- "CUSTOMERS"
    end_record_id <- "1002"
    max_degrees <- 1L
    avoid_record_keys <- list(
        list("CUSTOMERS", "0000")
    )
    required_data_sources <- list("CUSTOMERS")
    flags <- senzing_flags$SzEngineFlags$SZ_FIND_PATH_DEFAULT_FLAGS
    result <- sz_engine$find_path_by_record_id(
        start_data_source_code,
        start_record_id,
        end_data_source_code,
        end_record_id,
        max_degrees,
        avoid_record_keys,
        required_data_sources,
        flags
    )
    print_result("sz_engine.find_path_by_record_id", prettify(result, indent = 2))
})

test_that("sz_engine.get_active_config_id", {
    result <- sz_engine$get_active_config_id()
    print_result("sz_engine.get_active_config_id", result)
})

test_that("sz_engine.get_entity_by_entity_id", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_ENTITY_DEFAULT_FLAGS
    entity_id <- get_entity_id_from_record_id(data_source_code, record_id)
    result <- sz_engine$get_entity_by_entity_id(entity_id, flags)
    print_result("sz_engine.get_entity_by_entity_id", prettify(result, indent = 2))
})

test_that("sz_engine.get_entity_by_record_id", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_ENTITY_DEFAULT_FLAGS
    result <- sz_engine$get_entity_by_record_id(data_source_code, record_id, flags)
    print_result("sz_engine.get_entity_by_record_id", prettify(result, indent = 2))
})

test_that("sz_engine.get_record", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_RECORD_DEFAULT_FLAGS
    result <- sz_engine$get_record(data_source_code, record_id, flags)
    print_result("sz_engine.get_record", prettify(result, indent = 2))
})

test_that("sz_engine.get_record_preview", {
    record_definition_list <- list(
        RECORD_TYPE = "PERSON",
        PRIMARY_NAME_LAST = "Smith",
        PRIMARY_NAME_FIRST = "Robert",
        DATE_OF_BIRTH = "12/11/1978"
    )
    record_definition <- toJSON(record_definition_list, pretty = TRUE, auto_unbox = TRUE)
    flags <- senzing_flags$SzEngineFlags$SZ_RECORD_PREVIEW_DEFAULT_FLAGS
    result <- sz_engine$get_record_preview(record_definition)
    print_result("sz_engine.get_record", prettify(result, indent = 2))
})

test_that("sz_engine.get_redo_record", {
    result <- sz_engine$get_redo_record()
    print_result("sz_engine.get_redo_record", prettify(result, indent = 2))
})

test_that("sz_engine.get_stats", {
    result <- sz_engine$get_stats()
    print_result("sz_engine.get_stats", prettify(result, indent = 2))
})

test_that("sz_engine.get_virtual_entity_by_record_id", {
    record_list <- list(
        c("CUSTOMERS", "1001"),
        c("CUSTOMERS", "1002")
    )
    flags <- senzing_flags$SzEngineFlags$SZ_VIRTUAL_ENTITY_DEFAULT_FLAGS
    result <- sz_engine$get_virtual_entity_by_record_id(record_list, flags)
    print_result("sz_engine.get_virtual_entity_by_record_id", prettify(result, indent = 2))
})

test_that("sz_engine.how_entity_by_entity_id", {
    entity_id <- get_entity_id_from_record_id("CUSTOMERS", "1001")
    flags <- senzing_flags$SzEngineFlags$SZ_ENTITY_DEFAULT_FLAGS
    result <- sz_engine$how_entity_by_entity_id(entity_id, flags)
    print_result("sz_engine.how_entity_by_entity_id", prettify(result, indent = 2))
})

test_that("sz_engine.prime_engine", {
    sz_engine$prime_engine()
    print_result("sz_engine.prime_engine")
})

test_that("sz_engine.get_redo_record", {
    redo_record <- sz_engine$get_redo_record()
    flags <- senzing_flags$SZ_WITHOUT_INFO
    result <- sz_engine$process_redo_record(redo_record, flags)
    print_result("sz_engine.get_redo_record", prettify(result, indent = 2))
})

test_that("sz_engine.reevaluate_entity", {
    entity_id <- get_entity_id_from_record_id("CUSTOMERS", "1001")
    flags <- senzing_flags$SZ_WITHOUT_INFO
    result <- sz_engine$reevaluate_entity(entity_id, flags)
    print_result("sz_engine.reevaluate_entity", prettify(result, indent = 2))
})

test_that("sz_engine.reevaluate_record", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SZ_WITHOUT_INFO
    result <- sz_engine$reevaluate_record(data_source_code, record_id, flags)
    print_result("sz_engine.reevaluate_record", prettify(result, indent = 2))
})

test_that("sz_engine.search_by_attributes", {
    attributes_list <- list(
        NAME_FULL = "BOB SMITH",
        EMAIL_ADDRESS = "bsmith@work.com"
    )
    attributes <- toJSON(attributes_list, pretty = TRUE, auto_unbox = TRUE)
    flags <- senzing_flags$SzEngineFlags$SZ_SEARCH_BY_ATTRIBUTES_DEFAULT_FLAGS
    search_profile <- ""
    result <- sz_engine$search_by_attributes(attributes, flags, search_profile)
    print_result("sz_engine.search_by_attributes", prettify(result, indent = 2))
})

test_that("sz_engine.search_by_attributes", {
    entity_id_1 <- get_entity_id_from_record_id("CUSTOMERS", "1001")
    entity_id_2 <- get_entity_id_from_record_id("CUSTOMERS", "1002")
    flags <- senzing_flags$SzEngineFlags$SZ_WHY_ENTITIES_DEFAULT_FLAGS
    result <- sz_engine$why_entities(entity_id_1, entity_id_2, flags)
    print_result("sz_engine.search_by_attributes", prettify(result, indent = 2))
})

test_that("sz_engine.why_record_in_entity", {
    data_source_code <- "CUSTOMERS"
    record_id <- "1001"
    flags <- senzing_flags$SzEngineFlags$SZ_WHY_ENTITIES_DEFAULT_FLAGS
    result <- sz_engine$why_record_in_entity(data_source_code, record_id)
    print_result("sz_engine.why_record_in_entity", prettify(result, indent = 2))
})

test_that("sz_engine.why_records", {
    data_source_code_1 <- "CUSTOMERS"
    record_id_1 <- "1001"
    data_source_code_2 <- "CUSTOMERS"
    record_id_2 <- "1002"
    flags <- senzing_flags$SzEngineFlags$SZ_WHY_RECORDS_DEFAULT_FLAGS
    result <- sz_engine$why_records(data_source_code_1, record_id_1, data_source_code_2, record_id_2, flags)
    print_result("sz_engine.why_records", prettify(result, indent = 2))
})

test_that("sz_engine.why_search", {
    attributes_list <- list(
        NAME_FULL = "BOB SMITH",
        EMAIL_ADDRESS = "bsmith@work.com"
    )
    attributes <- toJSON(attributes_list, pretty = TRUE, auto_unbox = TRUE)
    entity_id <- get_entity_id_from_record_id("CUSTOMERS", "1001")
    flags <- senzing_flags$SzEngineFlags$SZ_WHY_SEARCH_DEFAULT_FLAGS
    search_profile <- "SEARCH"
    result <- sz_engine$why_search(attributes, entity_id, flags, search_profile)
    print_result("sz_engine.why_search", prettify(result, indent = 2))
})
