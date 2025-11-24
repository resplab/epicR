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

## Choosing a Jurisdiction: Canada vs US

EPIC supports both Canadian and US populations with
jurisdiction-specific parameters:

``` r
# For Canadian population (default)
results_canada <- simulate(jurisdiction = "canada")

# For US population
results_us <- simulate(jurisdiction = "us")
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

The [`simulate()`](../reference/simulate.md) function provides
convenient parameters for common customizations:

``` r
# Change time horizon
results <- simulate(time_horizon = 20)

# Change jurisdiction and time horizon
results <- simulate(jurisdiction = "us", time_horizon = 15)

# For quick testing
results <- simulate(n_agents = 10000, time_horizon = 5)
```

For more advanced input modifications, you can use
[`get_input()`](../reference/get_input.md) to explore and modify
parameters:

``` r
# Explore available inputs
input <- get_input()
names(input$values)  # See categories

# View specific parameters
input$values$cost$exac_dcost  # Exacerbation costs by severity
input$values$global_parameters$time_horizon
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
# Quick test run (10,000 agents)
results <- simulate(n_agents = 1e4)

# Standard run (60,000 agents - default)
results <- simulate()

# Production run (1,000,000 agents)
results <- simulate(n_agents = 1e6)

# Check memory requirements before running large simulations
estimate_memory_required(n_agents = 1e6, record_mode = 0, time_horizon = 20)
```

## Getting Detailed Results

### Extended Output

For more detailed results by year and demographics:

``` r
# Get both basic and extended results
results <- simulate(return_extended = TRUE)

# Access basic results
print(results$basic)

# Access detailed output tables
names(results$extended)
```

### Individual Patient Data

To collect event-level data for each agent, use `return_events = TRUE`:

``` r
# Get event history (automatically sets record_mode = 2)
# Keep n_agents small due to memory requirements
results <- simulate(
  n_agents = 1e4,
  time_horizon = 5,
  return_events = TRUE
)

# Access events data frame
head(results$events)

# Can also get basic and extended results together
results <- simulate(
  n_agents = 1e4,
  return_extended = TRUE,
  return_events = TRUE
)
# Returns: results$basic, results$extended, results$events
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
# Run closed cohort analysis
results <- simulate(closed_cohort = TRUE)

# Combine with other parameters
results <- simulate(
  closed_cohort = TRUE,
  jurisdiction = "us",
  time_horizon = 10,
  n_agents = 50000
)
```

## Comparing Scenarios

A common use case is comparing interventions. The
[`simulate()`](../reference/simulate.md) function makes this
straightforward:

``` r
# Baseline scenario
results_baseline <- simulate(
  jurisdiction = "canada",
  time_horizon = 20,
  n_agents = 100000
)

# Intervention scenario (e.g., different time horizon or jurisdiction)
results_intervention <- simulate(
  jurisdiction = "us",
  time_horizon = 20,
  n_agents = 100000
)

# Compare outcomes
cost_diff <- results_intervention$basic$total_cost -
  results_baseline$basic$total_cost
qaly_diff <- results_intervention$basic$total_qaly -
  results_baseline$basic$total_qaly
icer <- cost_diff / qaly_diff
```

For more complex scenarios requiring custom input modifications, see the
“Advanced Usage” section below.

## Advanced Usage

For advanced users who need fine-grained control (e.g., running multiple
simulations in one session or modifying complex input parameters), you
can manage sessions manually:

### Manual Session Management

``` r
# Initialize session once
init_session()

# Run multiple simulations with same session
run()
results1 <- Cget_output()

run()  # run again with same session
results2 <- Cget_output()

# Clean up when done
terminate_session()
```

### Custom Input Modifications

For complex input modifications not covered by
[`simulate()`](../reference/simulate.md) parameters:

``` r
# Get and modify inputs
input <- get_input()

# Modify specific parameters
input$values$global_parameters$time_horizon <- 5
input$values$agent$p_female <- 0.55

# Run with custom inputs
init_session()
run(input = input$values)
results <- Cget_output()
terminate_session()
```

### Error Handling

Always wrap manual session management in error handling:

``` r
tryCatch({
  init_session()
  run()
  results <- Cget_output()
}, finally = {
  terminate_session()
})
```

## Troubleshooting

### Memory Errors

If you get memory allocation errors: 1. Reduce the number of agents:
`simulate(n_agents = 10000)` 2. Don’t request event history unless
needed (omit `return_events`) 3. Check available memory with
[`estimate_memory_required()`](../reference/estimate_memory_required.md)

### Session Issues

The [`simulate()`](../reference/simulate.md) function handles session
management automatically and includes error handling. If you’re using
manual session management (see Advanced Usage), always use
[`tryCatch()`](https://rdrr.io/r/base/conditions.html) to ensure
[`terminate_session()`](../reference/terminate_session.md) is called
even if errors occur.

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
