#!/usr/bin/env Rscript

library(bit64)
library(dplyr)
library(httr)
library(jsonlite)
library(reticulate)
library(rlang)

# Prepare Python environment.

use_virtualenv("~/.venv")
grpc <- import("grpc")
senzing <- import("senzing_core", convert = FALSE)
senzing_flags <- import("senzing", convert = FALSE)

# Set environment specific variables.

home_path <- "./"
truth_set_url_prefix <- "https://raw.githubusercontent.com/Senzing/truth-sets/refs/heads/main/truthsets/demo/"
truth_set_filenames <- list("customers.json", "reference.json", "watchlist.json")

# Download truth-set files.

for (truth_set_filename in truth_set_filenames) {
    url <- paste0(truth_set_url_prefix, truth_set_filename)
    filepath <- paste0(home_path, truth_set_filename)
    response <- GET(url)
    text_content <- content(response, "text")
    write(text_content, filepath)
}

# Discover `DATA_SOURCE` values in records.

aggregate_json <- data.frame()
for (truth_set_filename in truth_set_filenames) {
    filepath <- paste0(home_path, truth_set_filename)
    your_data <- stream_in(file(filepath))
    aggregate_json <- append(aggregate_json, your_data$DATA_SOURCE)
}
unique_data_sources <- unique(aggregate_json)

# Create an abstract factory for accessing Senzing.

instance_name <- "Example"
settings <- '{"PIPELINE":{"CONFIGPATH":"/etc/opt/senzing","RESOURCEPATH":"/opt/senzing/er/resources","SUPPORTPATH":"/opt/senzing/data"},"SQL":{"CONNECTION":"sqlite3://na:na@/tmp/sqlite/G2C.db"}}'
sz_abstract_factory <- senzing$SzAbstractFactoryCore(instance_name, settings)

# Create Senzing objects.

sz_configmanager <- sz_abstract_factory$create_configmanager()
sz_diagnostic <- sz_abstract_factory$create_diagnostic()
sz_engine <- sz_abstract_factory$create_engine()

# Get current Senzing configuration.

sz_default_config_id <- sz_configmanager$get_default_config_id()
sz_config <- sz_configmanager$create_config_from_config_id(sz_default_config_id)

# Add DataSources to Senzing configuration.

for (unique_data_source in unique_data_sources) {
    tryCatch({
        sz_config$register_data_source(unique_data_source)
    }, warning = function(w) {}, error = function(e) {}, finally = {})
}

# Persist new Senzing configuration.

new_json_config <- sz_config$export()
new_config_id <- sz_configmanager$register_config(new_json_config, "Add TruthSet datasources")
sz_configmanager$replace_default_config_id(sz_default_config_id, new_config_id)

# With the change in Senzing configuration, Senzing objects need to be updated.

sz_abstract_factory$reinitialize(new_config_id)

# Call Senzing to add records.

for (truth_set_filename in truth_set_filenames) {
    filepath <- paste0(home_path, truth_set_filename)
    lines <- readLines(filepath)
    for (line in lines) {
        if (line != "") {
            parsed_data <- fromJSON(line)
            info <- sz_engine$add_record(
                parsed_data$DATA_SOURCE,
                parsed_data$RECORD_ID,
                line,
                senzing_flags$SzEngineFlags$SZ_WITH_INFO
            )
        }
    }
}
