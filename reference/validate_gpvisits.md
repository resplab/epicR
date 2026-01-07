# Returns results of validation tests for GP visits

This function returns Average number of GP visits by sex, COPD severity
and COPD diagnosis status along with their plots.

## Usage

``` r
validate_gpvisits(n_sim = 10000, jurisdiction = "canada")
```

## Arguments

- n_sim:

  number of agents

- jurisdiction:

  character string specifying the jurisdiction ("canada" or "us").
  Default is "canada"

## Value

validation test results
