# Returns results of validation tests for payoffs, costs and QALYs

Returns results of validation tests for payoffs, costs and QALYs

## Usage

``` r
validate_payoffs(
  nPatient = 1e+06,
  disableDiscounting = TRUE,
  disableExacMortality = TRUE
)
```

## Arguments

- nPatient:

  number of simulated patients. Default is 1e6.

- disableDiscounting:

  if TRUE, discounting will be disabled for cost and QALY calculations.
  Default: TRUE

- disableExacMortality:

  if TRUE, mortality due to exacerbations will be disabled for cost and
  QALY calculations. Default: TRUE

## Value

validation test results
