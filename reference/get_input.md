# Returns a list of default model input values

Returns a list of default model input values

## Usage

``` r
get_input(
  age0 = 40,
  time_horizon = 20,
  discount_cost = 0,
  discount_qaly = 0.03,
  closed_cohort = 0,
  jurisdiction = "canada"
)
```

## Arguments

- age0:

  Starting age in the model

- time_horizon:

  Model time horizon

- discount_cost:

  Discounting for cost outcomes

- discount_qaly:

  Discounting for QALY outcomes

- closed_cohort:

  Whether the model should run as closed_cohort, open-population by
  default.

- jurisdiction:

  Jurisdiction for model parameters ("canada" or "us")

## Value

A list with four components:

- values:

  A nested list of model input parameter values

- help:

  A nested list of help text descriptions for each parameter

- ref:

  A nested list of reference information for each parameter

- config:

  The raw configuration object loaded from the JSON file
