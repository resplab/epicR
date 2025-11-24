#' @title epicR Configuration Management
#'
#' @description
#' The epicR package now supports user-customizable configuration files. When the
#' package is loaded for the first time, configuration files are automatically
#' copied to your home directory at `~/.epicR/config/`. You can modify these
#' files to customize model parameters for your specific region or research needs.
#'
#' @section Configuration Directory:
#' User configuration files are stored in: `~/.epicR/config/`
#'
#' @section Available Functions:
#' \itemize{
#'   \item \code{\link{get_user_config_dir}}: Get the path to user config directory
#'   \item \code{\link{user_config_exists}}: Check if a user config exists
#'   \item \code{\link{copy_configs_to_user}}: Copy default configs to user directory
#'   \item \code{\link{reset_user_configs}}: Reset configs to package defaults
#'   \item \code{\link{open_user_config_dir}}: Open config directory in file explorer
#'   \item \code{\link{list_available_jurisdictions}}: List available config jurisdictions
#'   \item \code{\link{validate_config}}: Validate a configuration file
#' }
#'
#' @section Usage:
#' The package automatically uses user configs if they exist. When you call
#' \code{get_input()}, it will:
#' \enumerate{
#'   \item First check for user config files in `~/.epicR/config/`
#'   \item If found, use the user's customized configuration
#'   \item If not found, fall back to package default configurations
#' }
#'
#' @section Customizing Configurations:
#' To customize configurations for your region:
#' \enumerate{
#'   \item The config files are automatically copied on first package load
#'   \item Navigate to `~/.epicR/config/` or use \code{open_user_config_dir()}
#'   \item Edit the JSON files (e.g., `config_canada.json`, `config_us.json`)
#'   \item Save your changes
#'   \item The next time you use \code{get_input()}, your changes will be used
#' }
#'
#' @section Adding New Jurisdictions:
#' To add a new jurisdiction:
#' \enumerate{
#'   \item Copy an existing config file (e.g., `config_canada.json`)
#'   \item Rename it to `config_yourcountry.json`
#'   \item Update the "jurisdiction" field in the JSON to match
#'   \item Modify all parameters as needed for your region
#'   \item Use with: \code{get_input(jurisdiction = "yourcountry")}
#' }
#'
#' @section Resetting to Defaults:
#' If you need to reset your configurations:
#' \itemize{
#'   \item Reset all configs: \code{reset_user_configs()}
#'   \item Reset specific jurisdiction: \code{reset_user_configs("canada")}
#' }
#'
#' @examples
#' \dontrun{
#' # Check where user configs are stored
#' get_user_config_dir()
#'
#' # Open the config directory in file explorer
#' open_user_config_dir()
#'
#' # List available jurisdictions
#' list_available_jurisdictions()
#'
#' # Validate your custom config
#' validate_config("canada", user = TRUE)
#'
#' # Reset to package defaults if needed
#' reset_user_configs("canada")
#'
#' # Use your custom config
#' input <- get_input(jurisdiction = "canada")
#' }
#'
#' @name epicR-config
#' @aliases configuration config
NULL