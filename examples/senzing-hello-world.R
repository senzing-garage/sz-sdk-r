#!/usr/bin/env Rscript

library(jsonlite)
library(reticulate)
use_virtualenv("~/.venv")

grpc <- import("grpc")
senzing <- import("senzing_grpc")

grpc_channel <- grpc$insecure_channel("localhost:8261")
sz_abstract_factory <- senzing$SzAbstractFactoryGrpc(grpc_channel)
sz_product <- sz_abstract_factory$create_product()
print(prettify(sz_product$get_version(), indent = 2))
