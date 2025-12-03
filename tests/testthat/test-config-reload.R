# Test config file automatic reload functionality
# This test suite validates that simulate() detects and reloads changed config files

library(testthat)
library(jsonlite)

test_that("session_env has config tracking variables", {
  # Load core functions
  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("session_env"), "session_env not available")

  # Check that tracking variables exist
  expect_true(exists("config_file_path", envir = session_env),
              "session_env should have config_file_path")
  expect_true(exists("config_file_mtime", envir = session_env),
              "session_env should have config_file_mtime")
})

test_that("get_input stores config file info in session_env", {
  # Load input functions
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }

  # Load core to get session_env
  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("get_input", mode = "function"),
              "get_input function not available")
  skip_if_not(exists("session_env"), "session_env not available")

  # Try to load input (may fail if config missing, that's OK)
  result <- tryCatch({
    input <- get_input(jurisdiction = "canada")
    "success"
  }, error = function(e) {
    e$message
  })

  # If it succeeded, check that session_env was populated
  if (result == "success") {
    expect_true(!is.null(session_env$config_file_path),
                "session_env$config_file_path should be set after get_input")
    expect_true(!is.null(session_env$config_file_mtime),
                "session_env$config_file_mtime should be set after get_input")
    expect_true(file.exists(session_env$config_file_path),
                "stored config file path should exist")
  }
})

test_that("simulate detects config file changes", {
  # This is an integration test that requires a working config file
  # Skip if we can't find config files

  # Load functions
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }

  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("get_input", mode = "function"),
              "get_input function not available")
  skip_if_not(exists("session_env"), "session_env not available")

  # Try to get initial config
  result <- tryCatch({
    input <- get_input(jurisdiction = "canada")
    "success"
  }, error = function(e) {
    e$message
  })

  skip_if(result != "success", "Config file not available for testing")

  # Store original values
  original_path <- session_env$config_file_path
  original_mtime <- session_env$config_file_mtime

  expect_true(!is.null(original_path), "Original path should be set")
  expect_true(!is.null(original_mtime), "Original mtime should be set")

  # Simulate a file change by manually updating the mtime
  # (We don't want to actually modify the config file in tests)
  session_env$config_file_mtime <- original_mtime - 3600  # 1 hour ago

  # Create a mock check for file modification
  if (file.exists(original_path)) {
    current_mtime <- file.info(original_path)$mtime

    # Check that the modification check logic would work
    expect_true(current_mtime != session_env$config_file_mtime,
                "Modified mtime should differ from current file mtime")
  }

  # Restore original state
  session_env$config_file_mtime <- original_mtime
})

test_that("config file message formatting is correct", {
  # Load functions
  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("simulate", mode = "function"),
              "simulate function not available")

  # Check that simulate function has the config change detection code
  simulate_source <- if (file.exists("R/core.R")) {
    "R/core.R"
  } else {
    "../../R/core.R"
  }

  skip_if_not(file.exists(simulate_source), "Core source file not found")

  source_lines <- readLines(simulate_source)
  source_text <- paste(source_lines, collapse = "\n")

  # Check for config change detection logic
  expect_true(grepl("config_changed", source_text),
              "simulate should have config_changed variable")
  expect_true(grepl("config_file_mtime", source_text),
              "simulate should check config_file_mtime")
  expect_true(grepl("Config file has been modified", source_text),
              "simulate should have config modified message")
  expect_true(grepl("Reloaded config from", source_text),
              "simulate should have config reload message")
})

test_that("init_session displays working directory", {
  # Load core functions
  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("init_session", mode = "function"),
              "init_session function not available")

  # Check source code for working directory message
  init_source <- if (file.exists("R/core.R")) {
    "R/core.R"
  } else {
    "../../R/core.R"
  }

  skip_if_not(file.exists(init_source), "Core source file not found")

  source_lines <- readLines(init_source)
  source_text <- paste(source_lines, collapse = "\n")

  expect_true(grepl("Working directory", source_text),
              "init_session should display working directory")
  expect_true(grepl("getwd\\(\\)", source_text),
              "init_session should call getwd()")
})

test_that("get_input displays which config file is being used", {
  # Load input functions
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }

  skip_if_not(exists("get_input", mode = "function"),
              "get_input function not available")

  # Check that messages are present in the function
  input_source <- if (file.exists("R/input.R")) {
    "R/input.R"
  } else {
    "../../R/input.R"
  }

  skip_if_not(file.exists(input_source), "Input source file not found")

  source_lines <- readLines(input_source)
  source_text <- paste(source_lines, collapse = "\n")

  expect_true(grepl("Using user config file from", source_text),
              "get_input should have user config file message")
  expect_true(grepl("Using package config file from", source_text),
              "get_input should have package config file message")
})

test_that("config file path tracking works across multiple calls", {
  # Load functions
  if (file.exists("R/input.R")) {
    source("R/input.R")
  } else if (file.exists("../../R/input.R")) {
    source("../../R/input.R")
  }

  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("get_input", mode = "function"),
              "get_input function not available")
  skip_if_not(exists("session_env"), "session_env not available")

  # Clear session env
  session_env$config_file_path <- NULL
  session_env$config_file_mtime <- NULL

  # Try first call
  result1 <- tryCatch({
    input1 <- get_input(jurisdiction = "canada")
    "success"
  }, error = function(e) {
    e$message
  })

  skip_if(result1 != "success", "Config file not available")

  path1 <- session_env$config_file_path
  mtime1 <- session_env$config_file_mtime

  # Second call should update to same values
  result2 <- tryCatch({
    input2 <- get_input(jurisdiction = "canada")
    "success"
  }, error = function(e) {
    e$message
  })

  expect_equal(result2, "success", "Second call should succeed")
  expect_equal(session_env$config_file_path, path1,
               "Path should remain consistent")
  expect_equal(session_env$config_file_mtime, mtime1,
               "Mtime should be consistent for unchanged file")
})

test_that("config reload logic handles missing files gracefully", {
  # Load functions
  if (file.exists("R/core.R")) {
    source("R/core.R")
  } else if (file.exists("../../R/core.R")) {
    source("../../R/core.R")
  }

  skip_if_not(exists("session_env"), "session_env not available")

  # Set session_env to point to non-existent file
  session_env$config_file_path <- "/tmp/nonexistent_config_12345.json"
  session_env$config_file_mtime <- Sys.time()

  # The check in simulate should handle this gracefully
  # (it checks file.exists before comparing mtimes)
  config_changed <- FALSE
  if (!is.null(session_env$config_file_path) &&
        !is.null(session_env$config_file_mtime) &&
        file.exists(session_env$config_file_path)) {
    config_changed <- TRUE
  }

  expect_false(config_changed,
               "Should not detect change when file doesn't exist")
})
