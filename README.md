<!-- badges: start -->
[![R-CMD-check.yaml](https://github.com/resplab/epicR/actions/workflows/R-CMD-check.yaml/badge.svg?branch=master)](https://github.com/resplab/epicR/actions/workflows/R-CMD-check.yaml)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

# epicR
R package for Evaluation Platform in COPD (EPIC). 

## Overview
epicR provides an interface to interact with the Evaluation Platform in COPD (EPIC), a discrete-event-simulation (DES) whole-disease model of Chronic Obstructive Pulmonary Disease.

## Installation

### Install from CRAN (Recommended)

The easiest way to install epicR is from CRAN:

```r
install.packages("epicR")
```

This works on all platforms (Windows, macOS, Linux) and handles dependencies automatically.

### Install Development Version from GitHub

To install the latest development version with new features and bug fixes:

```r
install.packages("pak")
pak::pkg_install("resplab/epicR")
```

**Note:** Installing from GitHub requires compilation tools:
- **Windows**: Install [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
- **macOS**: Install Xcode Command Line Tools (`xcode-select --install`) and [gfortran](https://cran.r-project.org/bin/macosx/tools/)
- **Linux**: Install `r-base-dev` and build essentials (`sudo apt-get install r-base-dev` on Ubuntu/Debian)

# Quick Guide

## Simple Usage (Recommended)

The easiest way to run EPIC is with the `simulate()` function, which handles all session management automatically and provides progress information including a real-time progress bar:

```r
library(epicR)

# Run with defaults (Canada, 20 year horizon, 60,000 agents)
results <- simulate()
print(results$basic)
# Shows configuration, progress bar (10% 20% ... 100%), and elapsed time

# Run for US with custom parameters
results <- simulate(jurisdiction = "us", time_horizon = 10, n_agents = 100000)

# Quick test with fewer agents (faster)
results <- simulate(n_agents = 10000)

# By default, you get both basic and extended results
results <- simulate()
print(results$basic)
print(results$extended)  # Included by default

# Get basic output only (faster, less memory)
results <- simulate(extended_results = FALSE)
print(results$basic)

# Get event history (automatically enables event recording)
results <- simulate(return_events = TRUE)
print(head(results$events))

# Get everything with custom settings
results <- simulate(
  jurisdiction = "us",
  time_horizon = 15,
  n_agents = 50000,
  extended_results = TRUE,  # TRUE by default
  return_events = TRUE
)
# Returns: results$basic, results$extended, results$events
```

## Setting Seeds for Reproducibility

EPIC uses a custom seed mechanism (different from R's native `set.seed()`) to ensure reproducible results. Use the `seed` parameter in the `simulate()` function:

```r
# Run with a specific seed for reproducible results
results1 <- simulate(seed = 123)
results2 <- simulate(seed = 123)
# Results will be identical!

# Different seeds give different results
results_a <- simulate(seed = 42)
results_b <- simulate(seed = 99)
# These will differ due to different random sequences

# Combine seed with other parameters
results <- simulate(
  jurisdiction = "us",
  time_horizon = 10,
  n_agents = 50000,
  seed = 12345
)

# Use seeds for comparing interventions
baseline <- simulate(seed = 42)

input <- get_input()
# Modify input parameters here...
intervention <- simulate(input = input, seed = 42)
# Compare with identical random variation removed
```

**Important**: Do NOT use R's native `set.seed()` function before calling `simulate()`. The `seed` parameter handles reproducibility correctly within EPIC's simulation framework.

For detailed information on seed usage, best practices, and technical details, see [SEED_REPRODUCIBILITY.md](SEED_REPRODUCIBILITY.md).

## Advanced Usage

For advanced customization of input parameters:

```r
library(epicR)

# Get and modify inputs
input <- get_input()
input$values$global_parameters$time_horizon <- 5

# Run with custom inputs
results <- simulate(input = input$values)
```

## Jurisdiction-Specific Configuration

EPIC now supports jurisdiction-specific parameter sets to enable modeling for different countries/regions. Currently, Canadian parameters are fully configured, with US parameters available as a template.

### Using Canadian Parameters (Default)
```r
# Canadian parameters are used by default
input <- get_input()
# or explicitly specify:
input <- get_input(jurisdiction = "canada")
```

### Using US Parameters
```r
# Note: US parameters must be configured first (see Configuration section)
input <- get_input(jurisdiction = "us")
```

### Parameter Override
Function parameters still override jurisdiction defaults:
```r
# Use Canadian defaults but change time horizon
input <- get_input(jurisdiction = "canada", time_horizon = 10)
```

## Configuration

### User-Customizable Configuration Files

epicR now supports user-customizable configuration files. When you load the package for the first time, configuration files are automatically copied to your home directory at `~/.epicR/config/`, allowing you to modify model parameters without changing the package code.

#### Key Features:
- **Automatic Setup**: Config files are copied to your home directory on first load
- **Easy Customization**: Edit JSON files in `~/.epicR/config/` to adjust parameters
- **Automatic Detection**: The package automatically uses your custom configs
- **Simple Reset**: Return to defaults anytime with `reset_user_configs()`

#### Configuration Management Functions:
```r
# View config directory location
get_user_config_dir()

# Open config directory in file explorer
open_user_config_dir()

# List available jurisdictions
list_available_jurisdictions()

# Validate your configuration
validate_config("canada", user = TRUE)

# Reset to package defaults
reset_user_configs()  # All configs
reset_user_configs("canada")  # Specific jurisdiction
```

#### Customizing Parameters:
```r
# 1. Open config directory
open_user_config_dir()

# 2. Edit config_canada.json or config_us.json with your parameters

# 3. Your changes are automatically used
input <- get_input(jurisdiction = "canada")
```

For detailed instructions, see the [User Configuration Guide](USER_CONFIG_GUIDE.md).

### Package Configuration Files

Default configurations are stored in the package at `inst/config/`:

- `config_canada.json` - Canadian parameter set (fully configured)
- `config_us.json` - US parameter template (requires configuration)

### Configuring US Parameters

To use EPIC for US populations, replace placeholder values in `config_us.json` with appropriate US-specific data:

1. Demographics (age pyramid, mortality tables)
2. Smoking patterns and prevalence
3. Healthcare costs and utilization
4. Disease epidemiology parameters

Example placeholder format:
```json
{
  "agent": {
    "p_female": "PLACEHOLDER_US_P_FEMALE"
  }
}
```

Replace with actual values:
```json
{
  "agent": {
    "p_female": 0.51
  }
}
```

### Test Values

Configuration files also include jurisdiction-specific test values used for package validation:

```json
{
  "test_values": {
    "population_over_40_2015": 18600000,
    "expected_severe_exacerbations_per_year": 100000,
    "expected_severe_exac_tolerance": 5000
  }
}
```

These values represent:
- `population_over_40_2015`: Population over 40 years of age (used for scaling test results)
- `expected_severe_exacerbations_per_year`: Expected number of severe exacerbations per year for validation
- `expected_severe_exac_tolerance`: Tolerance level for test assertions

For US parameters, replace with appropriate US values:
```json
{
  "test_values": {
    "population_over_40_2015": 130000000,
    "expected_severe_exacerbations_per_year": 700000,
    "expected_severe_exac_tolerance": 35000
  }
}
```

For some studies, having access to the entire event history of the simulated population might be beneficial. Capturing event history is possible by using the `return_events` parameter in `simulate()`:

```r
# Get events along with other results
results <- simulate(
  n_agents = 10000,
  return_events = TRUE
)

# Access the events
events <- results$events
head(events)
```

Alternatively, you can set `record_mode` as a `setting`: 

```r
settings <- get_default_settings()
settings$record_mode <- 2
settings$n_base_agents <- 1e4
results <- simulate(settings = settings, return_events = TRUE)
events <- results$events
```
Note that you might need a large amount of memory available, if you want to collect event history for a large number of patients. 

In the events data frame, each type of event has a code corresponding to the table below:

|Event|No.|
|-----|---|
|start |0 |
|annual|1 |
|birthday| 2 |
|smoking change | 3|
|COPD incidence | 4|
|Exacerbation | 5 |
|Exacerbation end| 6|
|Death by Exacerbation | 7|
|Doctor visit | 8|
|Medication change | 9|
|Background death | 13|
|End | 14|

  
## Closed-cohort analysis

Closed-cohort analysis can be specified by changing the appropriate input parameters. 

```r
library(epicR)

# Simple closed-cohort analysis
input <- get_input(closed_cohort = 1)$values
results <- simulate(input = input)

# You can also combine jurisdiction and closed-cohort parameters:
# Canadian closed-cohort analysis
input <- get_input(jurisdiction = "canada", closed_cohort = 1)$values
results <- simulate(input = input)

# US closed-cohort analysis
input <- get_input(jurisdiction = "us", closed_cohort = 1)$values
results <- simulate(input = input)
```

## Publications with epicR

The following publications have used epicR for their analyses:

Yan, K., Duan, K. and Johnson, K.M., 2025. Development and Validation of EPIC-USA: A COPD Policy Model for the United States. American Journal of Respiratory and Critical Care Medicine, 211(Abstracts), pp.A7130-A7130.

Mountain, R., Duan, K.I. and Johnson, K.M., 2024. Benefit–harm analysis of earlier initiation of triple therapy for prevention of acute exacerbation in patients with chronic obstructive pulmonary disease. Annals of the American Thoracic Society, 21(8), pp.1139-1146.

Mountain, R., Kim, D. and Johnson, K.M., 2023. Budget impact analysis of adopting primary care–based case detection of chronic obstructive pulmonary disease in the Canadian general population. Canadian Medical Association Open Access Journal, 11(6), pp.E1048-E1058.

Ahmadian, S., Johnson, K.M., Ho, J.K., Sin, D.D., Lynd, L.D., Harrison, M. and Sadatsafavi, M., 2023. A cost-effectiveness analysis of azithromycin for the prevention of acute exacerbations of chronic obstructive pulmonary disease. Annals of the American Thoracic Society, 20(12), pp.1735-1742.

Johnson KM, Sadatsafavi M, Adibi A, Lynd L, Harrison M, Tavakoli H, Sin DD, Bryan S. Cost effectiveness of case detection strategies for the early detection of COPD. Applied Health Economics and Health Policy. 2021 Mar;19(2):203-15. [https://doi.org/10.1007/s40258-020-00616-2](https://doi.org/10.1007/s40258-020-00616-2)


## Citation

Please cite:

Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. [https://doi.org/10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)

