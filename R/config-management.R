#' Get user config directory path
#' @return Path to user config directory
#' @export
get_user_config_dir <- function() {
  config_dir <- file.path(Sys.getenv("HOME"), ".epicR", "config")
  return(config_dir)
}

#' Check if user config exists
#' @param jurisdiction Jurisdiction name (e.g., "canada", "us")
#' @return TRUE if user config exists, FALSE otherwise
#' @export
user_config_exists <- function(jurisdiction = "canada") {
  config_file <- file.path(get_user_config_dir(), paste0("config_", jurisdiction, ".json"))
  return(file.exists(config_file))
}

#' Copy default configs to user directory
#' @param overwrite Whether to overwrite existing user configs (default FALSE)
#' @return TRUE if successful, FALSE otherwise
#' @export
copy_configs_to_user <- function(overwrite = FALSE) {
  user_dir <- get_user_config_dir()

  # Create directory if it doesn't exist
  if (!dir.exists(user_dir)) {
    dir.create(user_dir, recursive = TRUE, showWarnings = FALSE)
  }

  # Get list of config files from package
  pkg_config_dir <- system.file("config", package = "epicR")

  # If package not installed (development mode), try inst/config
  if (!dir.exists(pkg_config_dir) || pkg_config_dir == "") {
    pkg_config_dir <- file.path("inst", "config")
    if (!dir.exists(pkg_config_dir)) {
      warning("Could not find package config directory")
      return(FALSE)
    }
  }

  config_files <- list.files(pkg_config_dir, pattern = "config_.*\\.json$", full.names = TRUE)

  if (length(config_files) == 0) {
    warning("No config files found in package")
    return(FALSE)
  }

  # Copy each config file
  for (config_file in config_files) {
    basename_file <- basename(config_file)
    user_config_file <- file.path(user_dir, basename_file)

    if (file.exists(user_config_file) && !overwrite) {
      message(paste("User config already exists:", basename_file, "(skipping)"))
    } else {
      file.copy(config_file, user_config_file, overwrite = overwrite)
      message(paste("Copied config to:", user_config_file))
    }
  }

  message(paste("User config directory:", user_dir))
  return(TRUE)
}

#' Reset user configs to package defaults
#' @param jurisdiction Specific jurisdiction to reset, or NULL for all (default NULL)
#' @return TRUE if successful, FALSE otherwise
#' @export
reset_user_configs <- function(jurisdiction = NULL) {
  if (is.null(jurisdiction)) {
    # Reset all configs
    return(copy_configs_to_user(overwrite = TRUE))
  } else {
    # Reset specific jurisdiction
    user_dir <- get_user_config_dir()
    pkg_config_dir <- system.file("config", package = "epicR")

    if (!dir.exists(pkg_config_dir) || pkg_config_dir == "") {
      pkg_config_dir <- file.path("inst", "config")
    }

    config_file <- file.path(pkg_config_dir, paste0("config_", jurisdiction, ".json"))
    user_config_file <- file.path(user_dir, paste0("config_", jurisdiction, ".json"))

    if (!file.exists(config_file)) {
      warning(paste("Config file for jurisdiction", jurisdiction, "not found in package"))
      return(FALSE)
    }

    # Create directory if needed
    if (!dir.exists(user_dir)) {
      dir.create(user_dir, recursive = TRUE, showWarnings = FALSE)
    }

    file.copy(config_file, user_config_file, overwrite = TRUE)
    message(paste("Reset config for", jurisdiction, "to package defaults"))
    return(TRUE)
  }
}

#' Open user config directory in file explorer
#' @export
open_user_config_dir <- function() {
  user_dir <- get_user_config_dir()

  if (!dir.exists(user_dir)) {
    message("User config directory does not exist yet. Creating it now...")
    copy_configs_to_user()
  }

  # Try to open in file explorer based on OS
  if (Sys.info()["sysname"] == "Windows") {
    shell(paste("explorer", gsub("/", "\\\\", user_dir)))
  } else if (Sys.info()["sysname"] == "Darwin") {
    system(paste("open", user_dir))
  } else {
    # Linux
    system(paste("xdg-open", user_dir))
  }

  message(paste("Config directory location:", user_dir))
}

#' List available config jurisdictions
#' @return Character vector of available jurisdictions
#' @export
list_available_jurisdictions <- function() {
  user_dir <- get_user_config_dir()

  # Check user directory first
  if (dir.exists(user_dir)) {
    user_configs <- list.files(user_dir, pattern = "config_(.*)\\.json$")
    if (length(user_configs) > 0) {
      jurisdictions <- gsub("config_|\\.json", "", user_configs)
      return(jurisdictions)
    }
  }

  # Fall back to package configs
  pkg_config_dir <- system.file("config", package = "epicR")
  if (!dir.exists(pkg_config_dir) || pkg_config_dir == "") {
    pkg_config_dir <- file.path("inst", "config")
  }

  if (dir.exists(pkg_config_dir)) {
    pkg_configs <- list.files(pkg_config_dir, pattern = "config_(.*)\\.json$")
    jurisdictions <- gsub("config_|\\.json", "", pkg_configs)
    return(jurisdictions)
  }

  return(character(0))
}

#' Validate a config file
#' @param jurisdiction Jurisdiction to validate
#' @param user Whether to validate user config (TRUE) or package config (FALSE)
#' @return TRUE if valid, FALSE otherwise (with warnings about issues)
#' @export
validate_config <- function(jurisdiction = "canada", user = TRUE) {
  if (user) {
    config_file <- file.path(get_user_config_dir(), paste0("config_", jurisdiction, ".json"))
  } else {
    config_file <- system.file("config", paste0("config_", jurisdiction, ".json"), package = "epicR")
    if (!file.exists(config_file) || config_file == "") {
      config_file <- file.path("inst", "config", paste0("config_", jurisdiction, ".json"))
    }
  }

  if (!file.exists(config_file)) {
    warning(paste("Config file not found:", config_file))
    return(FALSE)
  }

  tryCatch({
    config <- jsonlite::fromJSON(config_file, simplifyVector = FALSE)

    # Check for required top-level sections
    required_sections <- c("jurisdiction", "global_parameters", "agent", "smoking",
                          "COPD", "lung_function", "exacerbation", "symptoms",
                          "outpatient", "diagnosis", "medication", "cost",
                          "utility", "manual")

    missing_sections <- setdiff(required_sections, names(config))
    if (length(missing_sections) > 0) {
      warning(paste("Missing required sections:", paste(missing_sections, collapse = ", ")))
      return(FALSE)
    }

    # Check jurisdiction matches filename
    if (config$jurisdiction != jurisdiction) {
      warning(paste("Jurisdiction mismatch: file says", jurisdiction, "but content says", config$jurisdiction))
      return(FALSE)
    }

    message(paste("Config for", jurisdiction, "is valid"))
    return(TRUE)

  }, error = function(e) {
    warning(paste("Error parsing config file:", e$message))
    return(FALSE)
  })
}