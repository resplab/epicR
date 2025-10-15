# Test config JSON file structure validation
# This test ensures all config files maintain consistent structure and metadata

library(jsonlite)

# Load the package functions for testing
if (exists("get_input", mode = "function")) {
  # Function already available
} else if (file.exists("R/input.R")) {
  # Development mode - source the input file
  source("R/input.R")
} else {
  # Try to load from package
  tryCatch({
    get_input <- epicR::get_input
  }, error = function(e) {
    # Function not available - tests will be skipped
  })
}

# Test config structure validation function
test_config_structure <- function(config_file, jurisdiction_name) {
  
  # Check file exists
  expect_true(file.exists(config_file), 
              info = paste("Config file should exist:", config_file))
  
  # Load and parse JSON
  expect_error({
    config <- jsonlite::fromJSON(config_file, simplifyVector = FALSE)
  }, regexp = NA, info = paste("Config file should be valid JSON:", config_file))
  
  # Check required top-level structure
  expect_true("jurisdiction" %in% names(config),
              info = "Config should have 'jurisdiction' field")
  
  expect_equal(config$jurisdiction, jurisdiction_name,
               info = paste("Jurisdiction should be", jurisdiction_name))
  
  # Required sections
  required_sections <- c(
    "global_parameters", "agent", "smoking", "COPD", "lung_function", 
    "exacerbation", "symptoms", "outpatient", "diagnosis", "medication", 
    "comorbidity", "cost", "utility", "manual", "test_values"
  )
  
  for (section in required_sections) {
    expect_true(section %in% names(config),
                info = paste("Config should have section:", section))
  }
  
  # Check each section has proper metadata structure
  check_section_metadata <- function(section_name, section_data, path = "") {
    current_path <- if (path == "") section_name else paste(path, section_name, sep = ".")
    
    if (!is.list(section_data)) return()
    
    for (key in names(section_data)) {
      if (endsWith(key, "_metadata")) next  # Skip metadata entries themselves
      
      value <- section_data[[key]]
      metadata_key <- paste0(key, "_metadata")
      
      # Determine if this should have metadata
      should_have_metadata <- FALSE
      
      if (is.numeric(value) || is.character(value) || is.logical(value)) {
        should_have_metadata <- TRUE
      } else if (is.list(value)) {
        # Check if it's a list with names (not an array)
        if (!is.null(names(value)) && length(names(value)) > 0) {
          # Check if it's a by_sex or by_gold structure (should have metadata)
          if (any(names(value) %in% c("male", "female", "gold1", "gold2", "gold3", "gold4"))) {
            should_have_metadata <- TRUE
          } else {
            # Check if it's a collection (medication types, case detection methods)
            collection_indicators <- c("None", "SABA", "LABA", "ICS", "LAMA", "CDQ17", "FlowMeter")
            if (any(names(value) %in% collection_indicators)) {
              should_have_metadata <- TRUE
            } else {
              # It's a nested section, recurse
              check_section_metadata(key, value, current_path)
            }
          }
        } else {
          # It's a list without names (array), should have metadata
          should_have_metadata <- TRUE
        }
      }
      
      # Check metadata exists if it should
      if (should_have_metadata) {
        expect_true(metadata_key %in% names(section_data),
                    info = paste("Parameter should have metadata:", paste(current_path, key, sep = ".")))
        
        if (metadata_key %in% names(section_data)) {
          metadata <- section_data[[metadata_key]]
          expect_true(is.list(metadata),
                      info = paste("Metadata should be a list:", paste(current_path, metadata_key, sep = ".")))
          expect_true("help" %in% names(metadata),
                      info = paste("Metadata should have 'help' field:", paste(current_path, metadata_key, sep = ".")))
          expect_true("ref" %in% names(metadata),
                      info = paste("Metadata should have 'ref' field:", paste(current_path, metadata_key, sep = ".")))
          expect_true(is.character(metadata$help),
                      info = paste("Metadata 'help' should be character:", paste(current_path, metadata_key, sep = ".")))
          expect_true(is.character(metadata$ref),
                      info = paste("Metadata 'ref' should be character:", paste(current_path, metadata_key, sep = ".")))
        }
      }
    }
  }
  
  # Check metadata for all sections
  for (section_name in required_sections) {
    if (section_name %in% names(config)) {
      check_section_metadata(section_name, config[[section_name]])
    }
  }
  
  return(TRUE)
}

# Test that checks structural consistency between configs
test_config_consistency <- function(config1_file, config2_file, config1_name, config2_name) {
  config1 <- jsonlite::fromJSON(config1_file, simplifyVector = FALSE)
  config2 <- jsonlite::fromJSON(config2_file, simplifyVector = FALSE)
  
  # Remove jurisdiction for comparison
  config1$jurisdiction <- NULL
  config2$jurisdiction <- NULL
  
  # Get parameter keys (non-metadata) for both configs
  get_param_keys <- function(config_data, path = "") {
    keys <- c()
    if (!is.list(config_data)) return(keys)
    
    for (name in names(config_data)) {
      if (endsWith(name, "_metadata")) next
      
      current_path <- if (path == "") name else paste(path, name, sep = ".")
      
      value <- config_data[[name]]
      # Check if it's a list with names (not an array)
      if (is.list(value) && !is.null(names(value)) && length(names(value)) > 0) {
        # Check if it's a by_sex or by_gold structure
        if (any(names(value) %in% c("male", "female", "gold1", "gold2", "gold3", "gold4"))) {
          keys <- c(keys, current_path)
        } else {
          # Check if it's a collection
          collection_indicators <- c("None", "SABA", "LABA", "ICS", "LAMA", "CDQ17", "FlowMeter")
          if (any(names(value) %in% collection_indicators)) {
            keys <- c(keys, current_path)
          } else {
            # Recurse for nested sections
            keys <- c(keys, get_param_keys(value, current_path))
          }
        }
      } else {
        # It's either not a list, or it's a list without names (array), or it's a by_sex/by_gold structure
        keys <- c(keys, current_path)
      }
    }
    return(keys)
  }
  
  keys1 <- sort(get_param_keys(config1))
  keys2 <- sort(get_param_keys(config2))
  
  expect_equal(keys1, keys2, 
               info = paste("Parameter structure should match between", config1_name, "and", config2_name))
  
  return(TRUE)
}

# Test helper function to validate JSON syntax
test_json_syntax <- function(config_file) {
  expect_error({
    jsonlite::validate(readLines(config_file, warn = FALSE))
  }, regexp = NA, info = paste("JSON syntax should be valid:", config_file))
}

# Main test cases
test_that("Canada config has correct structure", {
  config_file <- system.file("config", "config_canada.json", package = "epicR")
  
  # If package not installed, try development mode path
  if (!file.exists(config_file) || config_file == "") {
    # Find package root directory (go up from tests/testthat)
    pkg_root <- file.path(dirname(dirname(getwd())))
    config_file <- file.path(pkg_root, "inst", "config", "config_canada.json")
  }
  
  skip_if_not(file.exists(config_file), "Canada config file not found")
  
  test_json_syntax(config_file)
  test_config_structure(config_file, "canada")
})

test_that("US config has correct structure", {
  config_file <- system.file("config", "config_us.json", package = "epicR")
  
  # If package not installed, try development mode path
  if (!file.exists(config_file) || config_file == "") {
    # Find package root directory (go up from tests/testthat)
    pkg_root <- file.path(dirname(dirname(getwd())))
    config_file <- file.path(pkg_root, "inst", "config", "config_us.json")
  }
  
  skip_if_not(file.exists(config_file), "US config file not found")
  
  test_json_syntax(config_file)
  test_config_structure(config_file, "us")
})

test_that("Config files have consistent structure", {
  canada_file <- system.file("config", "config_canada.json", package = "epicR")
  us_file <- system.file("config", "config_us.json", package = "epicR")
  
  # If package not installed, try development mode paths
  if (!file.exists(canada_file) || canada_file == "") {
    pkg_root <- file.path(dirname(dirname(getwd())))
    canada_file <- file.path(pkg_root, "inst", "config", "config_canada.json")
  }
  if (!file.exists(us_file) || us_file == "") {
    pkg_root <- file.path(dirname(dirname(getwd())))
    us_file <- file.path(pkg_root, "inst", "config", "config_us.json")
  }
  
  skip_if_not(file.exists(canada_file) && file.exists(us_file), 
              "Both config files must exist for consistency test")
  
  test_config_consistency(canada_file, us_file, "Canada", "US")
})

test_that("All discovered config files have correct structure", {
  # Find all config files in the package
  config_dir <- system.file("config", package = "epicR")
  
  # If package not installed, try development mode path
  if (!dir.exists(config_dir) || config_dir == "") {
    pkg_root <- file.path(dirname(dirname(getwd())))
    config_dir <- file.path(pkg_root, "inst", "config")
  }
  
  skip_if_not(dir.exists(config_dir), "Config directory not found")
  
  config_files <- list.files(config_dir, pattern = "^config_.*\\.json$", full.names = TRUE)
  
  expect_true(length(config_files) >= 2, 
              info = "Should have at least 2 config files (canada and us)")
  
  for (config_file in config_files) {
    # Extract jurisdiction from filename
    jurisdiction <- gsub("^config_|\\.json$", "", basename(config_file))
    
    test_json_syntax(config_file)
    test_config_structure(config_file, jurisdiction)
  }
})

test_that("Config loading works with get_input function", {
  # Skip if get_input function is not available
  skip_if_not(exists("get_input", mode = "function"), "get_input function not available")
  
  # Test that configs can actually be loaded by the get_input function
  # Default should work (canada config)
  expect_error({
    canada_input <- get_input()
  }, regexp = NA, info = "Default config should load successfully")
  
  # Test with specific jurisdiction parameter if supported
  if (exists("get_input", mode = "function") && "jurisdiction" %in% names(formals(get_input))) {
    expect_error({
      canada_input <- get_input(jurisdiction = "canada")
    }, regexp = NA, info = "Canada config should load successfully")
    
    # US config should fail with placeholder error (expected behavior)
    expect_error({
      us_input <- get_input(jurisdiction = "us")
    }, regexp = "PLACEHOLDER", info = "US config should fail on placeholder values")
  }
})

test_that("Config metadata coverage is complete", {
  canada_file <- system.file("config", "config_canada.json", package = "epicR")
  
  # If package not installed, try development mode path
  if (!file.exists(canada_file) || canada_file == "") {
    pkg_root <- file.path(dirname(dirname(getwd())))
    canada_file <- file.path(pkg_root, "inst", "config", "config_canada.json")
  }
  
  skip_if_not(file.exists(canada_file), "Canada config file not found")
  
  config <- jsonlite::fromJSON(canada_file, simplifyVector = FALSE)
  
  # Count parameters and metadata
  count_items <- function(section_data, path = "") {
    params <- 0
    metadata <- 0
    
    if (!is.list(section_data)) return(list(params = 0, metadata = 0))
    
    for (key in names(section_data)) {
      if (endsWith(key, "_metadata")) {
        metadata <- metadata + 1
      } else {
        value <- section_data[[key]]
        # Check if it's a list with names (not an array)
        if (is.list(value) && !is.null(names(value)) && length(names(value)) > 0) {
          # Check if it's a by_sex or by_gold structure
          if (any(names(value) %in% c("male", "female", "gold1", "gold2", "gold3", "gold4"))) {
            params <- params + 1
          } else {
            # Check if it's a collection
            collection_indicators <- c("None", "SABA", "LABA", "ICS", "LAMA", "CDQ17", "FlowMeter")
            if (any(names(value) %in% collection_indicators)) {
              params <- params + 1
            } else {
              # Recurse for nested sections
              nested_counts <- count_items(value, paste(path, key, sep = "."))
              params <- params + nested_counts$params
              metadata <- metadata + nested_counts$metadata
            }
          }
        } else {
          # It's either not a list, or it's a list without names (array), or it's a by_sex/by_gold structure
          params <- params + 1
        }
      }
    }
    
    return(list(params = params, metadata = metadata))
  }
  
  # Remove jurisdiction for counting
  config$jurisdiction <- NULL
  
  counts <- count_items(config)
  
  # We expect complete metadata coverage
  expect_equal(counts$params, counts$metadata,
               info = paste("Metadata coverage should be 100%. Found", counts$metadata, "metadata entries for", counts$params, "parameters"))
  
  expect_true(counts$params > 90,
              info = paste("Should have substantial number of parameters. Found:", counts$params))
})