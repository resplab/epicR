# Returns simulated vs. predicted population table and a plot

Returns simulated vs. predicted population table and a plot

## Usage

``` r
validate_population(remove_COPD = 0, incidence_k = 1, savePlots = 0)
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

## Value

returns a table showing predicted (StatsCan) and simulated population
values
