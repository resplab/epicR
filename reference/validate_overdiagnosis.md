# Returns results of validation tests for overdiagnosis

This function returns the proportion of non-COPD subjects overdiagnosed
over model time.

## Usage

``` r
validate_overdiagnosis(n_sim = 10000, jurisdiction = "canada")
```

## Arguments

- n_sim:

  number of agents

- jurisdiction:

  character string specifying the jurisdiction ("canada" or "us").
  Default is "canada"

## Value

validation test results
