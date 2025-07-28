#!/usr/bin/env Rscript

library(testthat)
library(jsonlite)
library(reticulate)
use_virtualenv("~/.venv")

grpc <- import("grpc")
senzing <- import("senzing_grpc")
grpc_channel <- grpc$insecure_channel("localhost:8261")
sz_abstract_factory <- senzing$SzAbstractFactoryGrpc(grpc_channel)
sz_product <- sz_abstract_factory$create_product()

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

test_that("sz_product.get_version", {
    result <- sz_product$get_version()
    print_result("sz_product.get_version", prettify(result, indent = 2))

    # expect_equal(my_sum(1, 1), 2)
    # expect_equal(my_sum(0, 5), 5)
    # expect_equal(my_sum(-2, 3), 1)
    # expect_equal(my_sum(100, -50), 50)
})

test_that("sz_product.get_license", {
    result <- sz_product$get_license()
    print_result("sz_product.get_license", prettify(result, indent = 2))
})
