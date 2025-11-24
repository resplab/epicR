# Getting Started with EPIC

## Introduction

This guide will help you get started with the Evaluation Platform in
COPD (EPIC) using the epicR package. By the end of this vignette, you
will be able to:

- Run a basic COPD simulation
- Understand and interpret the model outputs
- Customize inputs and settings for your analysis
- Choose between Canadian and US populations

## What is EPIC?

EPIC is a discrete-event simulation (DES) model for Chronic Obstructive
Pulmonary Disease (COPD). It models the entire pathway of care
including:

- Disease incidence and progression
- Diagnosis and case detection
- Exacerbations (mild, moderate, severe)
- Treatment and medication
- Healthcare resource utilization
- Mortality

The model simulates individual patients (called “agents”) with
demographic and clinical characteristics. Each agent progresses through
time, experiencing events like birthdays, disease onset, exacerbations,
and treatment changes.

## Installation

If you haven’t already installed epicR:

``` r
# Install from GitHub
pak::pkg_install("resplab/epicR")
```

## Quick Start: Your First Simulation

### Simple Approach (Recommended)

The easiest way to run a simulation is using the
[`simulate()`](../reference/simulate.md) function, which handles all
session management automatically and provides progress information
(configuration summary, real-time progress bar, elapsed time, and status
messages):

``` r
library(epicR)
```

``` r
# Run with defaults - that's it!
results <- simulate()

# Access basic results
print(results$basic)

# Custom parameters
results <- simulate(
  jurisdiction = "us",
  time_horizon = 10,
  n_agents = 100000
)

# Quick test with fewer agents (faster for testing)
results <- simulate(n_agents = 10000)

# Get extended results (includes both basic and extended)
results <- simulate(return_extended = TRUE)
print(results$extended)

# Get event history (automatically sets record_mode)
results <- simulate(return_events = TRUE)
head(results$events)
```

### Step-by-Step Approach

For more control, you can manage the session manually:

#### Step 1: Initialize a Session

``` r
# Initialize with default settings
init_session()
```

The function returns `0` if successful.

#### Step 2: Run the Model

``` r
# Run with default inputs
run()
```

#### Step 3: Get Results

``` r
results <- Cget_output()
print(results)
```

#### Step 4: Clean Up

``` r
terminate_session()
```

The basic output includes:

| Output       | Description                         |
|--------------|-------------------------------------|
| `n_agents`   | Total number of agents simulated    |
| `cumul_time` | Total person-years of follow-up     |
| `n_deaths`   | Number of deaths                    |
| `n_COPD`     | Number of agents who developed COPD |
| `n_exac_*`   | Exacerbation counts by severity     |
| `total_cost` | Total healthcare costs              |
| `total_qaly` | Total quality-adjusted life years   |

### Step 4: Terminate the Session

Always terminate the session when done to free memory:

``` r
terminate_session()
```

## Choosing a Jurisdiction: Canada vs US

EPIC supports both Canadian and US populations with
jurisdiction-specific parameters:

``` r
# For Canadian population (default)
input_canada <- get_input(jurisdiction = "ca")

# For US population
input_us <- get_input(jurisdiction = "us")
```

The jurisdictions differ in: - Population demographics - Smoking
prevalence and trends - Healthcare costs - Disease incidence rates

## Customizing Your Simulation

### Understanding Inputs

Inputs control the model’s parameters. Explore them:

``` r
inputs <- get_input()

# Top-level structure
names(inputs)
# [1] "values" "help" "references"

# Value categories
names(inputs$values)

# Example: global parameters
names(inputs$values$global_parameters)
inputs$values$global_parameters$time_horizon  # Simulation duration in years
```

### Common Input Modifications

``` r
input <- get_input()

# Change time horizon (years)
input$values$global_parameters$time_horizon <- 20

# Modify COPD-related costs
input$values$cost$exac_dcost  # Exacerbation costs by severity

# Run with modified inputs
init_session()
run(input = input$values)
results <- Cget_output()
terminate_session()
```

### Understanding Settings

Settings control how the model runs (not what it simulates):

``` r
settings <- get_default_settings()
names(settings)
```

Key settings:

| Setting         | Description                                        | Default |
|-----------------|----------------------------------------------------|---------|
| `n_base_agents` | Number of agents to simulate                       | 60,000  |
| `record_mode`   | Level of output detail (0=aggregate, 2=individual) | 0       |

### Choosing the Number of Agents

More agents = more precision but longer runtime and more memory:

``` r
settings <- get_default_settings()

# Quick test run
settings$n_base_agents <- 1e4  # 10,000 agents

# Production run
settings$n_base_agents <- 1e6  # 1,000,000 agents

# Check memory requirements before running large simulations
estimate_memory_required(n_agents = 1e6, record_mode = 0, time_horizon = 20)
```

## Getting Detailed Results

### Extended Output

For more detailed results by year and demographics:

``` r
init_session()
run()

# Detailed output tables
results_ex <- Cget_output_ex()
names(results_ex)

terminate_session()
```

### Individual Patient Data

To collect event-level data for each agent, use `record_mode = 2`:

``` r
settings <- get_default_settings()
settings$record_mode <- 2
settings$n_base_agents <- 1e4  # Keep small due to memory requirements

init_session(settings = settings)

input <- get_input()
input$values$global_parameters$time_horizon <- 5
run(input = input$values)

# Get all events as a data frame
events <- as.data.frame(Cget_all_events_matrix())
head(events)

terminate_session()
```

**Warning:** Recording individual events requires substantial memory.
Start with a small number of agents.

### Event Types

Each event in the individual data has a numeric code:

| Event                 | Code |
|-----------------------|------|
| Start                 | 0    |
| Annual                | 1    |
| Birthday              | 2    |
| Smoking change        | 3    |
| COPD incidence        | 4    |
| Exacerbation          | 5    |
| Exacerbation end      | 6    |
| Death by exacerbation | 7    |
| Doctor visit          | 8    |
| Medication change     | 9    |
| Background death      | 13   |
| End                   | 14   |

## Open vs Closed Cohort

By default, EPIC is an **open population** model that captures
population dynamics (births, deaths, immigration, emigration). For a
**closed cohort** analysis (fixed initial population, no new entries):

``` r
# Get inputs configured for closed cohort
input <- get_input(closed_cohort = 1)

init_session()
run(input = input$values)
results <- Cget_output()
terminate_session()
```

## Comparing Scenarios

A common use case is comparing interventions. Here’s a template:

``` r
# Baseline scenario
init_session()
input_baseline <- get_input()
run(input = input_baseline$values)
results_baseline <- Cget_output()
terminate_session()

# Intervention scenario (e.g., improved case detection)
init_session()
input_intervention <- get_input()
# Modify relevant parameters for your intervention
# input_intervention$values$diagnosis$... <- new_value
run(input = input_intervention$values)
results_intervention <- Cget_output()
terminate_session()

# Compare outcomes
# cost_difference <- results_intervention$total_cost - results_baseline$total_cost
# qaly_difference <- results_intervention$total_qaly - results_baseline$total_qaly
# icer <- cost_difference / qaly_difference
```

## Troubleshooting

### Memory Errors

If you get memory allocation errors: 1. Reduce `n_base_agents` 2. Use
`record_mode = 0` (aggregate only) 3. Check available memory with
[`estimate_memory_required()`](../reference/estimate_memory_required.md)

### Session Not Terminated

Always wrap simulations in error handling:

``` r
tryCatch({
  init_session()
  run()
  results <- Cget_output()
}, finally = {
  terminate_session()
})
```

## Next Steps

- **Model Background**: See
  [`vignette("BackgroundEPIC")`](../articles/BackgroundEPIC.md) for
  model structure details
- **Calibration**: See
  [`vignette("Calibrate_COPD_Prevalence")`](../articles/Calibrate_COPD_Prevalence.md)
  for calibration methods
- **Validation**: Explore the `validate_*()` functions for model
  validation
- **US Model**: See
  [`vignette("Calibrate_Smoking")`](../articles/Calibrate_Smoking.md)
  for US-specific calibration

## References

Sadatsafavi M, et al. (2019). Development and Validation of the
Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of
COPD for Canada. Medical Decision Making. <doi:10.1177/0272989X18824098>
