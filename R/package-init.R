#' @useDynLib epicR, .registration=TRUE
#' @importFrom stats lm time
#' @importFrom Rcpp sourceCpp
#' @importFrom Rcpp evalCpp
#' @importFrom graphics barplot legend lines pie plot title
#' @importFrom stats aggregate binomial coefficients glm optim runif confint
#' @importFrom utils packageVersion
#' @importFrom utils write.csv
#' @import ggplot2
#' @import ggthemes
#' @import dplyr
#' @importFrom scales pretty_breaks
#' @importFrom reshape2 melt
#' @import jsonlite
NULL

# Package environment to store cached model_input
.epicR_env <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  # Check if user configs exist, if not copy them
  user_dir <- file.path(Sys.getenv("HOME"), ".epicR", "config")

  if (!dir.exists(user_dir)) {
    # First time loading - copy configs to user directory
    tryCatch({
      packageStartupMessage("epicR: Setting up user configuration files...")
      copy_configs_to_user()
      packageStartupMessage(paste("epicR: Config files copied to:", user_dir))
      packageStartupMessage("You can modify these files to customize model parameters for your region.")
    }, error = function(e) {
      packageStartupMessage("epicR: Could not set up user config files. Using package defaults.")
    })
  }

  # Initialize model_input cache as NULL - will be lazily loaded on first access
  .epicR_env$model_input <- NULL

  # Create active binding for model_input in package namespace
  # This provides backward compatibility - accessing model_input will lazily load it
  ns <- asNamespace(pkgname)
  if (!exists("model_input", envir = ns, inherits = FALSE)) {
    makeActiveBinding(
      "model_input",
      function() get_default_model_input(),
      env = ns
    )
  }

  invisible()
}

.onAttach <- function(libname, pkgname) {
  user_dir <- file.path(Sys.getenv("HOME"), ".epicR", "config")

  if (dir.exists(user_dir)) {
    packageStartupMessage(paste("epicR: Using config files from:", user_dir))
    packageStartupMessage("To reset configs to defaults, use: reset_user_configs()")
  }
}

.onUnload <- function (libpath) {
  library.dynam.unload("epicR", libpath)
}

