# epicR Configuration Management

The epicR package now supports user-customizable configuration files.
When the package is loaded for the first time, configuration files are
automatically copied to your home directory at \`~/.epicR/config/\`. You
can modify these files to customize model parameters for your specific
region or research needs.

## Configuration Directory

User configuration files are stored in: \`~/.epicR/config/\`

## Available Functions

- [`get_user_config_dir`](get_user_config_dir.md): Get the path to user
  config directory

- [`user_config_exists`](user_config_exists.md): Check if a user config
  exists

- [`copy_configs_to_user`](copy_configs_to_user.md): Copy default
  configs to user directory

- [`reset_user_configs`](reset_user_configs.md): Reset configs to
  package defaults

- [`open_user_config_dir`](open_user_config_dir.md): Open config
  directory in file explorer

- [`list_available_jurisdictions`](list_available_jurisdictions.md):
  List available config jurisdictions

- [`validate_config`](validate_config.md): Validate a configuration file

## Usage

The package automatically uses user configs if they exist. When you call
[`get_input()`](get_input.md), it will:

1.  First check for user config files in \`~/.epicR/config/\`

2.  If found, use the user's customized configuration

3.  If not found, fall back to package default configurations

## Customizing Configurations

To customize configurations for your region:

1.  The config files are automatically copied on first package load

2.  Navigate to \`~/.epicR/config/\` or use
    [`open_user_config_dir()`](open_user_config_dir.md)

3.  Edit the JSON files (e.g., \`config_canada.json\`,
    \`config_us.json\`)

4.  Save your changes

5.  The next time you use [`get_input()`](get_input.md), your changes
    will be used

## Adding New Jurisdictions

To add a new jurisdiction:

1.  Copy an existing config file (e.g., \`config_canada.json\`)

2.  Rename it to \`config_yourcountry.json\`

3.  Update the "jurisdiction" field in the JSON to match

4.  Modify all parameters as needed for your region

5.  Use with: `get_input(jurisdiction = "yourcountry")`

## Resetting to Defaults

If you need to reset your configurations:

- Reset all configs: [`reset_user_configs()`](reset_user_configs.md)

- Reset specific jurisdiction: `reset_user_configs("canada")`

## Examples

``` r
if (FALSE) { # \dontrun{
# Check where user configs are stored
get_user_config_dir()

# Open the config directory in file explorer
open_user_config_dir()

# List available jurisdictions
list_available_jurisdictions()

# Validate your custom config
validate_config("canada", user = TRUE)

# Reset to package defaults if needed
reset_user_configs("canada")

# Use your custom config
input <- get_input(jurisdiction = "canada")
} # }
```
