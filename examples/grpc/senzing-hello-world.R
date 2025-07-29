#!/usr/bin/env Rscript

library(jsonlite)
library(reticulate)

# Prepare Python environment.

use_virtualenv("~/.venv")
senzing <- import("senzing_grpc")
grpc <- import("grpc")

# Create an abstract factory for accessing Senzing.

grpc_channel <- grpc$insecure_channel("localhost:8261")
sz_abstract_factory <- senzing$SzAbstractFactoryGrpc(grpc_channel)

# Create Senzing objects.

sz_product <- sz_abstract_factory$create_product()
print(prettify(sz_product$get_version(), indent = 2))
