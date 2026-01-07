# Returns results of validation tests for smoking module.

It compares simulated smoking prevalence and trends against observed
data to assess the model's accuracy.

## Usage

``` r
validate_smoking(remove_COPD = 1, intercept_k = NULL, jurisdiction = "canada")
```

## Arguments

- remove_COPD:

  0 or 1. whether to remove COPD-related mortality.

- intercept_k:

  a number

- jurisdiction:

  character string specifying the jurisdiction for validation ("canada"
  or "us"). Default is "canada".

## Value

For Canada: validation test results (invisible). For US: data frame with
smoking status rates by year.
