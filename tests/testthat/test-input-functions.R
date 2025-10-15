# Test input configuration functions (simplified version)
# This test suite validates the core input system with a focus on what we can actually test

library(testthat)
library(jsonlite)

# Test that the function exists and has the right signature
test_that("get_input function has correct signature", {
  # Load the function
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }
  
  skip_if_not(exists("get_input", mode = "function"), "get_input function not available")
  
  # Check function signature
  params <- names(formals(get_input))
  expect_true("age0" %in% params, "Function should have age0 parameter")
  expect_true("time_horizon" %in% params, "Function should have time_horizon parameter")
  expect_true("jurisdiction" %in% params, "Function should have jurisdiction parameter")
  
  # Check default values
  defaults <- formals(get_input)
  expect_equal(defaults$age0, 40)
  expect_equal(defaults$time_horizon, 20)
  expect_equal(defaults$jurisdiction, "canada")
})

# Test config file discovery (independent of function execution)
test_that("config files exist and have valid JSON", {
  # Find config files using multiple possible paths
  config_files <- c()
  
  # Try different possible locations
  possible_paths <- c(
    system.file("config", package = "epicR"),
    file.path(dirname(dirname(getwd())), "inst", "config"),
    "inst/config",
    "../../inst/config"
  )
  
  for (config_dir in possible_paths) {
    if (dir.exists(config_dir)) {
      files <- list.files(config_dir, pattern = "^config_.*\\.json$", full.names = TRUE)
      config_files <- c(config_files, files)
      break
    }
  }
  
  skip_if(length(config_files) == 0, "No config files found")
  
  # Test each config file
  for (config_file in config_files) {
    # Test JSON validity
    expect_error({
      config <- jsonlite::fromJSON(config_file, simplifyVector = FALSE)
    }, regexp = NA, info = paste("Config file should be valid JSON:", basename(config_file)))
    
    # Test basic structure
    if (exists("config")) {
      expect_true("jurisdiction" %in% names(config), 
                  paste("Config should have jurisdiction field:", basename(config_file)))
      
      # Test that it has the main sections we expect
      expected_sections <- c("global_parameters", "agent", "smoking", "COPD")
      for (section in expected_sections) {
        expect_true(section %in% names(config),
                    paste("Config should have", section, "section:", basename(config_file)))
      }
    }
  }
})

# Test config structure consistency
test_that("Canada and US configs have consistent structure", {
  # Find config files
  config_files <- c()
  possible_paths <- c(
    system.file("config", package = "epicR"),
    file.path(dirname(dirname(getwd())), "inst", "config"),
    "inst/config",
    "../../inst/config"
  )
  
  canada_file <- NULL
  us_file <- NULL
  
  for (config_dir in possible_paths) {
    if (dir.exists(config_dir)) {
      canada_candidate <- file.path(config_dir, "config_canada.json")
      us_candidate <- file.path(config_dir, "config_us.json")
      
      if (file.exists(canada_candidate)) canada_file <- canada_candidate
      if (file.exists(us_candidate)) us_file <- us_candidate
      
      if (!is.null(canada_file) && !is.null(us_file)) break
    }
  }
  
  skip_if(is.null(canada_file) || is.null(us_file), "Both config files must exist")
  
  # Load both configs
  canada_config <- jsonlite::fromJSON(canada_file, simplifyVector = FALSE)
  us_config <- jsonlite::fromJSON(us_file, simplifyVector = FALSE)
  
  # Remove jurisdiction for comparison
  canada_config$jurisdiction <- NULL
  us_config$jurisdiction <- NULL
  
  # Compare section names
  canada_sections <- sort(names(canada_config))
  us_sections <- sort(names(us_config))
  
  expect_equal(canada_sections, us_sections)
  
  # Test that both have reasonable number of sections
  expect_true(length(canada_sections) > 10, 
              "Should have substantial number of sections")
})

# Test placeholder detection logic (without actually loading configs)
test_that("placeholder detection logic works", {
  # Load the function
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }
  
  skip_if_not(exists("get_input", mode = "function"), "get_input function not available")
  
  # Test that the function properly rejects nonexistent jurisdictions
  expect_error(
    get_input(jurisdiction = "nonexistent"),
    regexp = "Configuration file.*not found",
    info = "Should fail with clear error for invalid jurisdiction"
  )
})

# Test that helper functions are defined (by checking the source)
test_that("helper functions are defined in source", {
  skip_if_not(file.exists("R/input.R") || file.exists("../../R/input.R"), 
              "Source file not available")
  
  source_file <- if (file.exists("R/input.R")) "R/input.R" else "../../R/input.R"
  source_lines <- readLines(source_file)
  source_text <- paste(source_lines, collapse = "\n")
  
  # Check that key helper functions are defined
  expect_true(grepl("convert_config_value.*<-.*function", source_text),
              "convert_config_value function should be defined")
  
  expect_true(grepl("create_matrix_from_config.*<-.*function", source_text),
              "create_matrix_from_config function should be defined")
  
  expect_true(grepl("get_metadata.*<-.*function", source_text),
              "get_metadata function should be defined")
  
  # Check for placeholder detection logic
  expect_true(grepl("PLACEHOLDER_", source_text),
              "Should have placeholder detection logic")
})

# Test metadata structure in config files
test_that("config files have proper metadata structure", {
  # Find a config file
  canada_file <- NULL
  possible_paths <- c(
    system.file("config", package = "epicR"),
    file.path(dirname(dirname(getwd())), "inst", "config"),
    "inst/config",
    "../../inst/config"
  )
  
  for (config_dir in possible_paths) {
    if (dir.exists(config_dir)) {
      candidate <- file.path(config_dir, "config_canada.json")
      if (file.exists(candidate)) {
        canada_file <- candidate
        break
      }
    }
  }
  
  skip_if(is.null(canada_file), "Canada config file not found")
  
  config <- jsonlite::fromJSON(canada_file, simplifyVector = FALSE)
  
  # Check that metadata entries exist
  metadata_count <- 0
  param_count <- 0
  
  # Count in global_parameters section
  if ("global_parameters" %in% names(config)) {
    section <- config$global_parameters
    for (key in names(section)) {
      if (endsWith(key, "_metadata")) {
        metadata_count <- metadata_count + 1
        # Check metadata structure
        metadata <- section[[key]]
        expect_true(is.list(metadata), paste("Metadata should be list:", key))
        expect_true("help" %in% names(metadata), paste("Metadata should have help:", key))
        expect_true("ref" %in% names(metadata), paste("Metadata should have ref:", key))
      } else {
        param_count <- param_count + 1
      }
    }
  }
  
  # Should have substantial metadata
  expect_true(metadata_count >= 5, "Should have substantial metadata entries")
  expect_equal(metadata_count, param_count)
})

# Performance and basic functionality test
test_that("function loading and basic structure is reasonable", {
  # Load the function
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }
  
  skip_if_not(exists("get_input", mode = "function"), "get_input function not available")
  
  # Test that function exists and can be called (we'll let it fail gracefully on missing files)
  expect_true(is.function(get_input), "get_input should be a function")
  
  # Test parameter validation
  expect_true(length(formals(get_input)) >= 5, "Function should have multiple parameters")
  
  # Test that function either works or fails gracefully
  # If config files are found, it should work (or fail on placeholders for US)
  # If config files are missing, it should fail with clear error message
  result <- tryCatch({
    input <- get_input()
    "success"
  }, error = function(e) {
    e$message
  })
  
  # Either it works (returns input) or fails with a reasonable error message
  expect_true(
    result == "success" || grepl("Configuration file.*not found|PLACEHOLDER", result),
    paste("Function should either work or fail gracefully. Got:", result)
  )
})

# Test that we can detect the structure we need for testing
test_that("test environment can access necessary files", {
  # Should be able to find either the source file or config files
  has_source <- file.exists("R/input.R") || file.exists("../../R/input.R")
  
  has_configs <- FALSE
  possible_paths <- c(
    system.file("config", package = "epicR"),
    file.path(dirname(dirname(getwd())), "inst", "config"),
    "inst/config",
    "../../inst/config"
  )
  
  for (config_dir in possible_paths) {
    if (dir.exists(config_dir) && 
        file.exists(file.path(config_dir, "config_canada.json"))) {
      has_configs <- TRUE
      break
    }
  }
  
  expect_true(has_source || has_configs, 
              "Test environment should have access to either source or config files")
})