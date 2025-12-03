# Runs the model. Auto-initializes if no session is active.

Runs the model. Auto-initializes if no session is active.

## Usage

``` r
run(
  max_n_agents = NULL,
  input = NULL,
  settings = NULL,
  auto_terminate = FALSE,
  seed = NULL
)
```

## Arguments

- max_n_agents:

  maximum number of agents

- input:

  customized input criteria

- settings:

  customized settings (only used if auto-initializing)

- auto_terminate:

  whether to automatically terminate session after run (default: FALSE)

- seed:

  Random seed for reproducibility (optional). If provided, ensures
  identical results across runs

## Value

simulation results if successful

## Examples

``` r
if (FALSE) { # \dontrun{
# Simple usage - everything handled automatically
results <- run()

# Or with custom input
input <- get_input(jurisdiction = "us", time_horizon = 10)
results <- run(input = input$values)

# Advanced: manual session management for multiple runs
init_session()
run()
run()  # run again with same session
terminate_session()

# With reproducible results
run(seed = 123)
} # }
```
