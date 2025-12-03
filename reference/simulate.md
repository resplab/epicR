# Convenience function: run simulation and return results

This is a simplified interface that handles session management
automatically and returns the results directly. Ideal for most users.
Progress information is displayed including: configuration summary, a
real-time progress bar showing percentage completion (10

## Usage

``` r
simulate(
  input = NULL,
  settings = NULL,
  jurisdiction = "canada",
  time_horizon = 20,
  n_agents = NULL,
  extended_results = TRUE,
  return_events = FALSE,
  seed = NULL
)
```

## Arguments

- input:

  customized input criteria (optional)

- settings:

  customized settings (optional)

- jurisdiction:

  Jurisdiction for model parameters ("canada" or "us")

- time_horizon:

  Model time horizon in years (default: 20)

- n_agents:

  Number of agents to simulate (default: 60,000)

- extended_results:

  whether to return extended results in addition to basic (default:
  TRUE)

- return_events:

  whether to return event matrix (default: FALSE). If TRUE,
  automatically sets record_mode=2

- seed:

  Random seed for reproducibility (optional). If provided, ensures
  identical results across runs

## Value

list with simulation results (always includes 'basic', includes
'extended' by default, optionally 'events')

## Examples

``` r
if (FALSE) { # \dontrun{
# Simplest usage - includes both basic and extended results
results <- simulate()
print(results$basic)
print(results$extended)

# With custom parameters
results <- simulate(jurisdiction = "us", time_horizon = 10, n_agents = 100000)

# Quick test with fewer agents
results <- simulate(n_agents = 10000)

# Basic output only (faster, less memory)
results <- simulate(extended_results = FALSE)
print(results$basic)

# With event history
results <- simulate(return_events = TRUE)
print(results$events)  # Event matrix

# With reproducible results
results1 <- simulate(seed = 123)
results2 <- simulate(seed = 123)
# results1 and results2 will be identical
} # }
```
