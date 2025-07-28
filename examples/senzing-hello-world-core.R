#!/usr/bin/env Rscript

library(jsonlite)
library(reticulate)
use_virtualenv("~/.venv")

x <- import("senzing")
senzing <- import("senzing_core")

instance_name <- "Example"
settings <- '{"PIPELINE":{"CONFIGPATH":"/etc/opt/senzing","RESOURCEPATH":"/opt/senzing/er/resources","SUPPORTPATH":"/opt/senzing/data"},"SQL":{"CONNECTION":"sqlite3://na:na@/tmp/sqlite/G2C.db"}}'
sz_abstract_factory <- senzing$SzAbstractFactoryCore(instance_name, settings)

sz_product <- sz_abstract_factory$create_product()
print(prettify(sz_product$get_version(), indent = 2))
