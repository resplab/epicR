# Returns simulated vs. predicted population table and a plot

Returns simulated vs. predicted population table and a plot

## Usage

``` r
validate_population(
  remove_COPD = 0,
  incidence_k = 1,
  savePlots = 0,
  jurisdiction = "canada"
)
```

## Arguments

- remove_COPD:

  0 or 1, indicating whether COPD-caused mortality should be removed

- incidence_k:

  a number (default=1) by which the incidence rate of population will be
  multiplied.

- savePlots:

  0 or 1, exports 300 DPI population growth and pyramid plots comparing
  simulated vs. predicted population

- jurisdiction:

  character string specifying the jurisdiction for validation ("canada"
  or "us"). Default is "canada".

## Value

For Canada: returns a table showing predicted (StatsCan) and simulated
population values. For US: returns a data frame with population
comparisons by age group and year.
