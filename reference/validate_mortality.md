# Returns results of validation tests for mortality rate

This function returns a table and a plot of the difference between
simulated and expected (life table) mortality, by sex and age.

## Usage

``` r
validate_mortality(
  n_sim = 5e+05,
  bgd = 1,
  bgd_h = 1,
  manual = 1,
  exacerbation = 1,
  jurisdiction = "canada"
)
```

## Arguments

- n_sim:

  number of simulated agents

- bgd:

  a number

- bgd_h:

  a number

- manual:

  a number

- exacerbation:

  a number

- jurisdiction:

  character string specifying the jurisdiction ("canada" or "us").
  Default is "canada"

## Value

validation test results
