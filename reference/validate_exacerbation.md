# Returns results of validation tests for exacerbation rates

This function runs validation tests for COPD exacerbation rates by GOLD
stage and compares them with reference values from studies such as
CanCOLD, CIHI, and Hoogendoorn. It simulates exacerbation events, and
returns key metrics, including overall exacerbation rates, rates by GOLD
stage, and rates in diagnosed vs. undiagnosed patients.

## Usage

``` r
validate_exacerbation(
  base_agents = 10000,
  input = NULL,
  jurisdiction = "canada"
)
```

## Arguments

- base_agents:

  Number of agents in the simulation. Default is 1e4.

- input:

  EPIC inputs

- jurisdiction:

  character string specifying the jurisdiction for validation ("canada"
  or "us"). Default is "canada".

## Value

For Canada: validation test results (invisible). For US: invisible NULL
(results displayed via messages and plots).
