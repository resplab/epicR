# Returns results of validation tests for smoking module.

It compares simulated smoking prevalence and trends against observed
data to assess the model's accuracy.

## Usage

``` r
validate_smoking(remove_COPD = 1, intercept_k = NULL)
```

## Arguments

- remove_COPD:

  0 or 1. whether to remove COPD-related mortality.

- intercept_k:

  a number

## Value

validation test results
