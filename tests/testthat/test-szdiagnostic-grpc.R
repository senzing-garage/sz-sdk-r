#!/usr/bin/env Rscript

library(testthat)
library(jsonlite)
library(reticulate)
use_virtualenv("~/.venv")

grpc <- import("grpc")
senzing <- import("senzing_grpc")
grpc_channel <- grpc$insecure_channel("localhost:8261")
sz_abstract_factory <- senzing$SzAbstractFactoryGrpc(grpc_channel)
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
