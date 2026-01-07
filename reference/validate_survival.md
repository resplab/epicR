# Returns the Kaplan Meier curve comparing COPD and non-COPD

Returns the Kaplan Meier curve comparing COPD and non-COPD

## Usage

``` r
validate_survival(
  savePlots = FALSE,
  base_agents = 10000,
  jurisdiction = "canada"
)
```

## Arguments

- savePlots:

  TRUE or FALSE (default), exports 300 DPI population growth and pyramid
  plots comparing simulated vs. predicted population

- base_agents:

  Number of agents in the simulation. Default is 1e4.

- jurisdiction:

  character string specifying the jurisdiction ("canada" or "us").
  Default is "canada"

## Value

validation test results
