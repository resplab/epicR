# Returns results of validation tests for diagnosis

This function returns a table showing the proportion of COPD patients
diagnosed over the model's runtime. It also provides a second table that
breaks down the proportion of diagnosed patients by COPD severity.
Additionally, the function generates a plot to visualize the
distribution of diagnoses over time.

## Usage

``` r
validate_diagnosis(n_sim = 10000)
```

## Arguments

- n_sim:

  number of agents

## Value

validation test results
